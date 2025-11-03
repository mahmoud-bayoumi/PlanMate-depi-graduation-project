// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/event.dart';
import '../../../data/models/task.dart';
import 'favourite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  /// Start listening to user's favorites in realtime
  Future<void> fetchFavorites() async {
    final user = _auth.currentUser;
    if (user == null) {
      //print('[FavoriteCubit] fetchFavorites: user == null');
      emit(const FavoriteSuccess([]));
      return;
    }

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    //print('[FavoriteCubit] Listening to: ${ref.path}');

    // cancel previous subscription if exists
    await _subscription?.cancel();

    _subscription = ref.snapshots().listen(
      (snapshot) {
        try {
          final favorites = snapshot.docs.map((doc) {
            final data = doc.data();
            final rawTasks = (data['tasks'] as List<dynamic>?) ?? <dynamic>[];
            final tasks = rawTasks.map((t) {
              if (t is Map<String, dynamic>) return Task.fromMap(t);
              if (t is Map) return Task.fromMap(Map<String, dynamic>.from(t));
              return Task(title: '', description: '', done: false);
            }).toList();

            // build EventModel (assumes constructor with these fields)
            return EventModel(
              title: (data['title'] as String?) ?? '',
              image: (data['image'] as String?) ?? '',
              date: (data['date'] as String?) ?? '',
              time: (data['time'] as String?) ?? '',
              address: (data['address'] as String?) ?? '',
              phone: (data['phone'] as String?) ?? '',
              tasks: tasks,
            );
          }).toList();

          //print('[FavoriteCubit] snapshot received: ${favorites.length} items');
          emit(FavoriteSuccess(favorites));
        } catch (e) {
          //print('[FavoriteCubit] snapshot processing error: $e');
          //print(st);
          emit(FavoriteError(e.toString()));
        }
      },
      onError: (err) {
        //print('[FavoriteCubit] snapshots listen error: $err');
        emit(FavoriteError(err.toString()));
      },
    );
  }

  /// add: uses .add() so Firestore generates a docId (avoids collisions)
  Future<void> addToFavorite(EventModel event) async {
    final user = _auth.currentUser;
    if (user == null) {
      //print('[FavoriteCubit] addToFavorite: user == null');
      emit(const FavoriteSuccess([]));
      return;
    }

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    final map = {
      'title': event.title,
      'image': event.image,
      'date': event.date,
      'time': event.time,
      'address': event.address,
      'phone': event.phone,
      'tasks': event.tasks.map((t) => t.toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'owner': user.uid,
    };

    //print('[FavoriteCubit] addToFavorite => path: ${ref.path}');
    try {
      final docRef = await ref.add(map);
      //print('[FavoriteCubit] addToFavorite success docId=${docRef.id}');
      // no need to call fetchFavorites() because snapshots listener will fire
    } catch (e) {
      //print('[FavoriteCubit] addToFavorite error: $e');
      //print(st);
      emit(FavoriteError(e.toString()));
    }
  }

  /// remove: find documents with matching title and delete them
  Future<void> removeFromFavorite(String title) async {
    final user = _auth.currentUser;
    if (user == null) {
      //print('[FavoriteCubit] removeFromFavorite: user == null');
      emit(const FavoriteSuccess([]));
      return;
    }

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
    //print(
    //'[FavoriteCubit] removeFromFavorite: querying title="$title" at ${ref.path}',
    //);

    try {
      final querySnap = await ref.where('title', isEqualTo: title).get();
      if (querySnap.docs.isEmpty) {
        // print('[FavoriteCubit] No doc found to delete for title="$title"');
        return;
      }

      for (final doc in querySnap.docs) {
        await ref.doc(doc.id).delete();
        //print('[FavoriteCubit] Deleted doc id=${doc.id}');
      }
      // snapshots listener will update the state automatically
    } catch (e) {
      // print('[FavoriteCubit] removeFromFavorite error: $e');
      //print(st);
      emit(FavoriteError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}