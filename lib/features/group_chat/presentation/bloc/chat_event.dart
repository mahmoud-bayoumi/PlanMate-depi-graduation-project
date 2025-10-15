import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {}


class SendMessage extends ChatEvent {
  final String content;

  const SendMessage(this.content);

  @override
  List<Object?> get props => [content];
}

class MessagesUpdated extends ChatEvent {
  final List<Map<String, dynamic>> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}


class MessagesUpdatedError extends ChatEvent {
  final String errorMessage;

  const MessagesUpdatedError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
