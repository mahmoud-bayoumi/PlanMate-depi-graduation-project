import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/category.dart';
import '../../../data/models/event.dart';
import '../../../data/models/task.dart';
import 'get_category_state.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<CategoryModel> categoryList = [];
  List<Task> taskList = [];
  List<EventModel> eventList = [];
  GetCategoryCubit() : super(GetCategoryInitial());

  Future<void> getCategories() async {
    emit(GetCategoryLoading());

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
              print('Failed to parse task ${taskDoc.id}: $err');
              continue; // نكمل الباقي
            }
          } // end tasks loop

          try {
            final event = EventModel.fromMap(eventData, taskList);
            print('--- event ${eventDoc.id} raw data: $eventData');
            eventList.add(event);
          } catch (err) {
            print('Failed to parse event ${eventDoc.id}: $err');
            continue;
          }
        } // end events loop

        try {
          final category = CategoryModel.fromMap(categoryData, eventList);
          categoryList.add(category);
        } catch (err) {
          print('Failed to parse category ${categoryDoc.id}: $err');
          continue;
        }
      } // end categories loop

      print('categories: ${categoryList.length}');
      final totalEvents = categoryList.fold<int>(
        0,
        (p, c) => p + c.events.length,
      );
      final totalTasks = categoryList.fold<int>(
        0,
        (p, c) => p + c.events.fold<int>(0, (pp, e) => pp + e.tasks.length),
      );
      print('events: $totalEvents, tasks: $totalTasks');

      emit(GetCategorySuccess(/*categories: categoryList*/));
    } on FirebaseException catch (fe) {
      print('FirebaseException: ${fe.code} ${fe.message}');
      emit(GetCategoryFailure(error: '${fe.code}: ${fe.message}'));
    } catch (e, st) {
      print('Error: $e');
      print(st);
      emit(GetCategoryFailure(error: e.toString()));
    }
  }
}
