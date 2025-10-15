abstract class ChatEvent {}


class LoadMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String content;
  SendMessage(this.content);
}

class MessagesUpdated extends ChatEvent {
  final List<Map<String, dynamic>> messages;
  MessagesUpdated(this.messages);
}