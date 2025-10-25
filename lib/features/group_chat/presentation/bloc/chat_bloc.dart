import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'chat_event.dart';
import 'chat_state.dart';

const String genralChatId = 'general_chat';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _messagesSubscription;
  User? get currentUser => _auth.currentUser;

  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<MessagesUpdatedError>(_onMessagesUpdatedError);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    emit(ChatLoading());

    _messagesSubscription?.cancel();

    _messagesSubscription = _firestore
        .collection('messages')
        .where('chatId', isEqualTo: genralChatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final messages = snapshot.docs.map((doc) => doc.data()).toList();
            add(MessagesUpdated(messages));
          },
          onError: (error) {
            add(MessagesUpdatedError('Failed to load messages: $error'));
          },
        );
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  void _onMessagesUpdatedError(
    MessagesUpdatedError event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatError(event.errorMessage));
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (_auth.currentUser == null) {
      emit(const ChatError("User not logged in."));
      return;
    }

    try {
      final currentUserId = _auth.currentUser!.uid;

      await _firestore.collection('messages').add({
        'chatId': genralChatId,
        'senderId': currentUserId,
        'text': event.content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(ChatError("Failed to send message: $e"));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}