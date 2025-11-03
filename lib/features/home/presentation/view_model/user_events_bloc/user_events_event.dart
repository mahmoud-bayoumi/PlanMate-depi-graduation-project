import 'package:equatable/equatable.dart';
import '../../../data/models/event.dart';

abstract class UserEventsEvent extends Equatable {
  const UserEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvents extends UserEventsEvent {}

class MarkTaskDone extends UserEventsEvent {
  final String eventTitle;
  final String taskTitle;

  const MarkTaskDone(this.eventTitle, this.taskTitle);

  @override
  List<Object?> get props => [eventTitle, taskTitle];

  
}

class AddUserEvent extends UserEventsEvent {
  final EventModel event;

  const AddUserEvent(this.event);

  @override
  List<Object?> get props => [event];
}

