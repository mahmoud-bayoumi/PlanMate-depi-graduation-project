import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/category.dart';
import '../../../data/models/event.dart';
import '../../../data/models/task.dart';
import 'get_category_state.dart';

class GetCategoryCubit extends Cubit<GetCategoryState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GetCategoryCubit() : super(GetCategoryInitial());

  Future<void> getCategories() async {
    emit(GetCategoryLoading());

    try {
      final List<Category> categoryList = [];

      // Fetch all categories
      final categorySnapshot = await firestore.collection('categories').get();

      for (var categoryDoc in categorySnapshot.docs) {
        final categoryId = categoryDoc.id;
        final categoryData = categoryDoc.data();

        final List<Event> eventList = [];

        // Fetch all events in the category
        final eventSnapshot = await firestore
            .collection('categories')
            .doc(categoryId)
            .collection('events')
            .get();

        for (var eventDoc in eventSnapshot.docs) {
          final eventId = eventDoc.id;
          final eventData = eventDoc.data();

          final List<Task> taskList = [];

          // Fetch all tasks in the event
          final taskSnapshot = await firestore
              .collection('categories')
              .doc(categoryId)
              .collection('events')
              .doc(eventId)
              .collection('tasks')
              .get();

          for (var taskDoc in taskSnapshot.docs) {
            taskList.add(Task.fromMap(taskDoc.data()));
          }

          eventList.add(Event.fromMap(eventId, eventData, taskList));
        }

        categoryList.add(Category.fromMap(categoryId, categoryData, eventList));
      }

      emit(GetCategorySuccess());
    } catch (e) {
      emit(GetCategoryFailure(error: e.toString()));
    }
  }
}
