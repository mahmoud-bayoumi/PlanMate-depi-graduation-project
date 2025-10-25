import 'package:equatable/equatable.dart';
import '../../../data/models/event.dart';

abstract class UserEventsState extends Equatable {
  const UserEventsState();

  @override
  List<Object?> get props => [];
}

class UserEventsInitial extends UserEventsState {}

class UserEventsLoading extends UserEventsState {}

class UserEventsLoaded extends UserEventsState {
  final List<EventModel> events;

  const UserEventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}



class UserEventsError extends UserEventsState {
  final String message;

  const UserEventsError(this.message);

  @override
  List<Object?> get props => [message];
}
