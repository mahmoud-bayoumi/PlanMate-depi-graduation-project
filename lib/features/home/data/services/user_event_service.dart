import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event.dart';
import '../models/task.dart';

class UserEventService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Fixed collection path and included tasks
  Future<void> addEventToUserList(EventModel event) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No logged in user.");

    final userEventsRef = _firestore
        .collection('usersData')      // Correct top-level collection
        .doc(user.uid)
        .collection('userEvents');   // Matches getUserEvents()

    // Check if event already exists
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
      'tasks': event.tasks.map((t) => t.toMap()).toList(), // ✅ include tasks
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

      return EventModel.fromMap(data, tasks);
    }).toList();
  }

  Future<void> markTaskAsDone(String eventTitle, String taskTitle) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No logged-in user found.");

    final eventRef = _firestore
        .collection('usersData')
        .doc(user.uid)
        .collection('userEvents');

    // Find the event doc by title
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
