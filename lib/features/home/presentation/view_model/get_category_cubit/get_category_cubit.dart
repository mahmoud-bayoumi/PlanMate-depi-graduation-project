// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/category.dart';
import '../../../data/models/event.dart';
import '../../../data/models/task.dart';
import 'get_category_state.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int selectedCategoryIndex = 1000;
  List<CategoryModel> categoryList = [];
  List<Task> taskList = [];
  List<EventModel> eventList = [];
  String nameCategory = 'General';
  GetCategoryCubit() : super(GetCategoryInitial());

  Future<void> getCategories() async {
    emit(GetCategoryLoading());
    nameCategory = 'General';
    categoryList.clear();
    eventList.clear();
    taskList.clear();
    try {
      final categorySnapshot = await firestore.collection('category').get();

      for (var categoryDoc in categorySnapshot.docs) {
        final categoryId = categoryDoc.id;
        final categoryData = categoryDoc.data() as Map<String, dynamic>? ?? {};

        final eventSnapshot = await firestore
            .collection('category')
            .doc(categoryId)
            .collection('event')
            .get();

        for (var eventDoc in eventSnapshot.docs) {
          final eventId = eventDoc.id;
          final eventData = eventDoc.data() as Map<String, dynamic>? ?? {};

          final taskSnapshot = await firestore
              .collection('category')
              .doc(categoryId)
              .collection('event')
              .doc(eventId)
              .collection('task')
              .get();

          for (var taskDoc in taskSnapshot.docs) {
            final raw = taskDoc.data();
            final taskData = raw as Map<String, dynamic>? ?? {};

            // لطباعة الداتا لو محتاج تعرف أي مستند مكسور:
            // print('task ${taskDoc.id} => $taskData');

            try {
              // استدعاء الفاكتوري الجديد اللي ياخد Map
              final task = Task.fromMap(taskData);
              taskList.add(task);
            } catch (err) {
              //print('Failed to parse task ${taskDoc.id}: $err');
              continue; // نكمل الباقي
            }
          } // end tasks loop

          try {
            final event = EventModel.fromMap(eventData, taskList);
            //print('--- event ${eventDoc.id} raw data: $eventData');
            eventList.add(event);
          } catch (err) {
            //print('Failed to parse event ${eventDoc.id}: $err');
            continue;
          }
        } // end events loop

        try {
          final category = CategoryModel.fromMap(categoryData, eventList);
          categoryList.add(category);
        } catch (err) {
          //print('Failed to parse category ${categoryDoc.id}: $err');
          continue;
        }
      } // end categories loop

      //print('categories: ${categoryList.length}');
      final totalEvents = categoryList.fold<int>(
        0,
        (p, c) => p + c.events.length,
      );
      final totalTasks = categoryList.fold<int>(
        0,
        (p, c) => p + c.events.fold<int>(0, (pp, e) => pp + e.tasks.length),
      );
      //print('events: $totalEvents, tasks: $totalTasks');

      emit(GetCategorySuccess(/*categories: categoryList*/));
    } on FirebaseException catch (fe) {
      //print('FirebaseException: ${fe.code} ${fe.message}');
      emit(GetCategoryFailure(error: '${fe.code}: ${fe.message}'));
    } catch (e) {
      //print('Error: $e');
      //print(st);
      emit(GetCategoryFailure(error: e.toString()));
    }
  }

  /// جلب events (ومهامهم) حسب قيمة الحقل 'name' في مستندات category
  Future<List<EventModel>> getEventsByCategory(String categoryName) async {
    emit(GetCategoryLoading());
    nameCategory = categoryName;
    try {
      final List<EventModel> localEventList = [];

      // نبحث عن الكاتيجوري حسب الحقل 'name'
      final q = await firestore
          .collection('category')
          .where('name', isEqualTo: categoryName)
          .get();

      if (q.docs.isEmpty) {
        emit(GetEventsByCategorySuccess([]));
        return [];
      }

      // لكل مستند category اللي رجعناه
      for (final catDoc in q.docs) {
        final categoryDocId = catDoc.id;

        final eventSnapshot = await firestore
            .collection('category')
            .doc(categoryDocId)
            .collection('event')
            .get();

        for (var eventDoc in eventSnapshot.docs) {
          final eventData = eventDoc.data() as Map<String, dynamic>? ?? {};

          // قائمة مهام جديدة لكل حدث
          final List<Task> localTaskList = [];

          final taskSnapshot = await firestore
              .collection('category')
              .doc(categoryDocId)
              .collection('event')
              .doc(eventDoc.id)
              .collection('task')
              .get();

          for (var taskDoc in taskSnapshot.docs) {
            final taskData = taskDoc.data() as Map<String, dynamic>? ?? {};
            try {
              // نفترض Task.fromMap موجود ويأخذ Map<String,dynamic>
              final task = Task.fromMap(taskData);
              localTaskList.add(task);
            } catch (err) {
              //print('Failed to parse task ${taskDoc.id}: $err');
              continue;
            }
          } // end tasks loop

          try {
            // EventModel.fromMap يأخذ (Map, List<Task>)
            final event = EventModel.fromMap(eventData, localTaskList);
            localEventList.add(event);
          } catch (err) {
            //print('Failed to parse event ${eventDoc.id}: $err');
            continue;
          }
        } // end events loop
      } // end categories loop

      // خزن محليًا في حال احتجت تستخدمه من خارج
      eventList = localEventList;

      // print(
      // 'Loaded ${localEventList.length} events for categoryName="$categoryName"',
      //);
      emit(GetCategorySuccess());
      return localEventList;
    } on FirebaseException catch (fe) {
      // print('FirebaseException: ${fe.code} ${fe.message}');
      emit(GetCategoryFailure(error: '${fe.code}: ${fe.message}'));
      return [];
    } catch (e) {
      //print('Error: $e');
      //print(st);
      emit(GetCategoryFailure(error: e.toString()));
      return [];
    }
  }
}
