import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/event.dart';
import '../../../data/services/user_event_service.dart';
import 'user_events_event.dart';
import 'user_events_state.dart';

class UserEventsBloc extends Bloc<UserEventsEvent, UserEventsState> {
  final UserEventService _service;
  UserEventsBloc(this._service) : super(UserEventsInitial()) {
    on<LoadUserEvents>(_onLoadUserEvents);
    on<MarkTaskDone>(_onMarkTaskDone);
    on<AddUserEvent>(_onAddUserEvent);
  }

  Future<void> _onLoadUserEvents(event, emit) async {
    emit(UserEventsLoading());
    try {
      final events = await _service.getUserEvents();
      emit(UserEventsLoaded(events));
    } catch (e) {
      emit(UserEventsError(e.toString()));
    }
  }

  Future<void> _onMarkTaskDone(event, emit) async {
    try {
      await _service.markTaskAsDone(event.eventTitle, event.taskTitle);
      final updatedEvents = await _service.getUserEvents();
      emit(UserEventsLoaded(updatedEvents));
    } catch (e) {
      emit(UserEventsError(e.toString()));
    }
  }

  Future<void> _onAddUserEvent(event, emit) async {
    try {
      await _service.addEventToUserList(event.event);

      final updatedEvents = await _service.getUserEvents();
      emit(UserEventsLoaded(updatedEvents));
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains("already in your list")) {
        emit(UserEventsError("Event already in your list!"));
      } else {
        emit(UserEventsError(errorMessage));
      }
    }
  }
}
