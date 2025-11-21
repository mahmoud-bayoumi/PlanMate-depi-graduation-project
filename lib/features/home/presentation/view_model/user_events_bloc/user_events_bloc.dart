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
    // Store current state before attempting to add
    final previousState = state;
    
    try {
      await _service.addEventToUserList(event.event);

      final updatedEvents = await _service.getUserEvents();
      emit(UserEventsLoaded(updatedEvents));
    } catch (e) {
      final errorMessage = e.toString();
      
      // If event already exists, emit error but keep the current loaded state
      if (errorMessage.contains("already in your list")) {
        emit(UserEventsError("Event already in your list!"));
        
        // Immediately restore the previous state if it was loaded
        if (previousState is UserEventsLoaded) {
          emit(UserEventsLoaded(previousState.events));
        } else {
          // If previous state wasn't loaded, fetch current events
          try {
            final currentEvents = await _service.getUserEvents();
            emit(UserEventsLoaded(currentEvents));
          } catch (_) {
            // If fetching fails, just keep the error state
          }
        }
      } else {
        emit(UserEventsError(errorMessage));
        
        // For other errors, also try to restore previous state
        if (previousState is UserEventsLoaded) {
          emit(UserEventsLoaded(previousState.events));
        }
      }
    }
  }
}
