import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event.dart';
import '../models/task.dart';

class UserEventService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEventToUserList(EventModel event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("No logged in user.");

    final userEventsRef = FirebaseFirestore.instance
        .collection('userEvents')
        .doc(user.uid)
        .collection('events');

    // Check if event already exists (based on title)
    final existingEvent = await userEventsRef
        .where('title', isEqualTo: event.title)
        .limit(1)
        .get();

    if (existingEvent.docs.isNotEmpty) {
      // Throw a specific exception that we can catch in Bloc
      throw Exception("Event already in your list!");
    }

    // Otherwise add it
    await userEventsRef.add({
      'title': event.title,
      'image': event.image,
      'date': event.date,
      'time': event.time,
      'address': event.address,
      'phone': event.phone,
    });
  }

  Future<List<EventModel>> getUserEvents() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No logged-in user found.");

    final snapshot = await _firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final List<Task> tasks = (data['tasks'] as List<dynamic>? ?? [])
          .map((t) => Task.fromMap(Map<String, dynamic>.from(t)))
          .toList();

      return EventModel(
        title: data['title'] ?? '',
        image: data['image'] ?? '',
        date: data['date'] ?? '',
        time: data['time'] ?? '',
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        tasks: tasks,
      );
    }).toList();
  }

  Future<void> markTaskAsDone(String eventTitle, String taskTitle) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No logged-in user found.");

    final eventRef = _firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents')
        .doc(eventTitle);

    final doc = await eventRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final tasks = (data['tasks'] as List<dynamic>).map((t) {
      final taskMap = Map<String, dynamic>.from(t);
      if (taskMap['title'] == taskTitle) {
        final currentDone = taskMap['done'] ?? false;

        if (currentDone == false && taskMap['joined'] != true) {
          taskMap['joined'] = true;
          taskMap['done'] = false;
        } else if (currentDone == false && taskMap['joined'] == true) {
          taskMap['done'] = true;
        }
      }
      return taskMap;
    }).toList();

    await eventRef.update({'tasks': tasks});
  }
}
