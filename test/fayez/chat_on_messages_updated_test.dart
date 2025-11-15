import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:planmate_app/features/group_chat/presentation/bloc/chat_bloc.dart';
import 'package:planmate_app/features/group_chat/presentation/bloc/chat_event.dart';
import 'package:planmate_app/features/group_chat/presentation/bloc/chat_state.dart';

class DummyFirestore extends Mock implements FirebaseFirestore {}
class DummyAuth extends Mock implements FirebaseAuth {}

void main() {
  late ChatBloc bloc;

  setUp(() {
    bloc = ChatBloc(
      firestore: DummyFirestore(),
      auth: DummyAuth(),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test(
    'MessagesUpdated emits ChatLoaded with the same messages',
    () async {
      final messages = [
        {'id': '1', 'text': 'hello'},
        {'id': '2', 'text': 'welcome'},
      ];

      bloc.add(MessagesUpdated(messages));

      await expectLater(
        bloc.stream,
        emits(
          predicate<ChatState>((state) {
            if (state is ChatLoaded) {
              return state.messages.length == 2 &&
                  state.messages[0]['text'] == 'hello' &&
                  state.messages[1]['id'] == '2';
            }
            return false;
          }),
        ),
      );
    },
  );
}
