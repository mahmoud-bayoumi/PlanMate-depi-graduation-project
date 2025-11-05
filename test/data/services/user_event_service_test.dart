import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planmate_app/features/home/data/models/event.dart';
import 'package:planmate_app/features/home/data/models/task.dart';

class TestableUserEventService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  TestableUserEventService({
    required this.auth,
    required this.firestore,
  });

  Future<void> addEventToUserList(EventModel event) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("No logged in user.");

    final userEventsRef = firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents');

    final existingEvent = await userEventsRef
        .where('title', isEqualTo: event.title)
        .limit(1)
        .get();

    if (existingEvent.docs.isNotEmpty) {
      throw Exception("Event already in your list!");
    }

    await userEventsRef.add({
      'title': event.title,
      'image': event.image,
      'date': event.date,
      'time': event.time,
      'address': event.address,
      'phone': event.phone,
      'tasks': event.tasks.map((t) => t.toMap()).toList(),
    });
  }

  Future<List<EventModel>> getUserEvents() async {
    final user = auth.currentUser;
    if (user == null) throw Exception("No logged-in user found.");

    final snapshot = await firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final List<Task> tasks = (data['tasks'] as List<dynamic>? ?? [])
          .map((t) => Task.fromMap(Map<String, dynamic>.from(t)))
          .toList();

      return EventModel.fromMap(data, tasks);
    }).toList();
  }

  Future<void> markTaskAsDone(String eventTitle, String taskTitle) async {
    final user = auth.currentUser;
    if (user == null) throw Exception("No logged-in user found.");

    final eventRef = firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents');

    final query = await eventRef.where('title', isEqualTo: eventTitle).limit(1).get();
    if (query.docs.isEmpty) return;

    final docRef = query.docs.first.reference;
    final data = query.docs.first.data();

    final tasks = (data['tasks'] as List<dynamic>).map((t) {
      final taskMap = Map<String, dynamic>.from(t);
      if (taskMap['title'] == taskTitle) {
        taskMap['done'] = !(taskMap['done'] ?? false);
      }
      return taskMap;
    }).toList();

    await docRef.update({'tasks': tasks});
  }
}

void main() {
  group('UserEventService', () {
    late TestableUserEventService service;
    late MockFirebaseAuth mockAuth;
    late FakeFirebaseFirestore fakeFirestore;
    late MockUser mockUser;

    setUp(() {
      // Create mock user
      mockUser = MockUser(
        uid: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      //Step1:Create mock auth with signed-in user
      mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      
      //Step2:Create fake firestore
      fakeFirestore = FakeFirebaseFirestore();

      //Step3:Create service with mocks
      service = TestableUserEventService(
        auth: mockAuth,
        firestore: fakeFirestore,
      );
    });

    test('Add event successfully when user is logged in', () async {
      final event = EventModel(
        title: 'Test Event',
        image: 'image_url',
        date: '2025-11-08',
        time: '10:00 AM',
        address: 'Cairo',
        phone: '12345',
        tasks: [Task(title: 'Task 1', description: 'Test', done: false)],
      );

      await service.addEventToUserList(event);

      //Verify event was added
      final events = await service.getUserEvents();
      expect(events.length, 1);
      expect(events.first.title, 'Test Event');
      expect(events.first.tasks.length, 1);
      expect(events.first.tasks.first.title, 'Task 1');
    });

    test('Add event throws when no user is logged in', () async {
      //Create service with no signed-in user
      final noUserAuth = MockFirebaseAuth(signedIn: false);
      final noUserService = TestableUserEventService(
        auth: noUserAuth,
        firestore: fakeFirestore,
      );

      final event = EventModel(
        title: 'Test Event',
        image: '',
        date: '2025-11-08',
        time: '10:00 AM',
        address: 'Cairo',
        phone: '12345',
        tasks: [Task(title: 'Task 1', description: 'Test', done: false)],
      );

      expect(
        () => noUserService.addEventToUserList(event),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No logged in user'),
        )),
      );
    });

    test('Add duplicate event throws exception', () async {
      final event = EventModel(
        title: 'Test Event',
        image: '',
        date: '2025-11-08',
        time: '10:00 AM',
        address: 'Cairo',
        phone: '12345',
        tasks: [Task(title: 'Task 1', description: 'Test', done: false)],
      );

      //Add event first time
      await service.addEventToUserList(event);

      //Try to add same event again
      expect(
        () => service.addEventToUserList(event),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Event already in your list'),
        )),
      );
    });

    test('Get user events returns empty list when no events', () async {
      final events = await service.getUserEvents();
      expect(events, isEmpty);
    });

    test('Mark task as done updates task status', () async {
      final event = EventModel(
        title: 'Test Event',
        image: '',
        date: '2025-11-08',
        time: '10:00 AM',
        address: 'Cairo',
        phone: '12345',
        tasks: [Task(title: 'Task 1', description: 'Test', done: false)],
      );

      await service.addEventToUserList(event);

      //Mark task as done
      await service.markTaskAsDone('Test Event', 'Task 1');

      //Verify task is marked as done
      final events = await service.getUserEvents();
      expect(events.first.tasks.first.done, true);

      //Mark task as not done (toggle)
      await service.markTaskAsDone('Test Event', 'Task 1');

      //Verify task is marked as not done
      final updatedEvents = await service.getUserEvents();
      expect(updatedEvents.first.tasks.first.done, false);
    });

    test('Mark task as done does nothing for non-existent event', () async {
      //Should not throw error
      await service.markTaskAsDone('Non-existent Event', 'Task 1');
      
      final events = await service.getUserEvents();
      expect(events, isEmpty);
    });
  });
}