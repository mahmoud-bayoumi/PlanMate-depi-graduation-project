import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planmate_app/features/group_chat/presentation/bloc/chat_bloc.dart';
import 'package:planmate_app/features/group_chat/presentation/bloc/chat_event.dart';
import 'package:planmate_app/features/group_chat/presentation/bloc/chat_state.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionRef extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirestore mockFirestore;
  late MockCollectionRef mockMessagesCollection;
  late StreamController<QuerySnapshot<Map<String, dynamic>>> snapshotController;
  late ChatBloc bloc;

  setUp(() {
    mockFirestore = MockFirestore();
    mockMessagesCollection = MockCollectionRef();
    snapshotController =
        StreamController<QuerySnapshot<Map<String, dynamic>>>();

    when(() => mockFirestore.collection('messages'))
        .thenReturn(mockMessagesCollection);

    when(() => mockMessagesCollection.where(
          any(),
          isEqualTo: any(named: 'isEqualTo'),
        )).thenReturn(mockMessagesCollection);

    when(() => mockMessagesCollection.orderBy(
          any(),
          descending: any(named: 'descending'),
        )).thenReturn(mockMessagesCollection);

    when(() => mockMessagesCollection.snapshots())
        .thenAnswer((_) => snapshotController.stream);

    bloc = ChatBloc(firestore: mockFirestore, auth: MockAuth());
  });

  tearDown(() async {
    await snapshotController.close();
    await bloc.close();
  });

  test(
    'LoadMessages emits ChatLoaded when snapshot arrives',
    () async {
      final mockDoc = MockQueryDocSnapshot();
      when(() => mockDoc.id).thenReturn('m1');
      when(() => mockDoc.data()).thenReturn({
        'chatId': 'general_chat',
        'text': 'hello',
        'timestamp': DateTime.now(),
      });

      final mockSnapshot = MockQuerySnapshot();
      when(() => mockSnapshot.docs).thenReturn([mockDoc]);

      // Trigger load
      bloc.add(LoadMessages());

      // Allow Bloc to attach listener
      await Future.delayed(const Duration(milliseconds: 20));

      // Send fake Firestore snapshot
      snapshotController.add(mockSnapshot);

      // Expect ChatLoaded only
      await expectLater(
        bloc.stream,
        emits(isA<ChatLoaded>()),
      );
    },
  );
}
