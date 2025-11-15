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
    bloc = ChatBloc(firestore: DummyFirestore(), auth: DummyAuth());
  });

  tearDown(() async {
    await bloc.close();
  });

  test('MessagesUpdatedError emits ChatError with correct message', () async {
    const errorMsg = "Something went wrong";

    bloc.add(const MessagesUpdatedError(errorMsg));

    await expectLater(
      bloc.stream,
      emits(
        predicate<ChatState>((state) {
          if (state is ChatError) {
            return state.message == errorMsg;
          }
          return false;
        }),
      ),
    );
  });
}
