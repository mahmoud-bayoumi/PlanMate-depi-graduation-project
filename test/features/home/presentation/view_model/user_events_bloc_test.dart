import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_state.dart';
import 'package:planmate_app/features/home/data/models/event.dart';
import 'package:planmate_app/features/home/data/models/task.dart';
import 'package:planmate_app/features/home/data/services/user_event_service.dart';

class MockUserEventService extends Mock implements UserEventService {
  @override
  Future<List<EventModel>> getUserEvents() {
    return super.noSuchMethod(
      Invocation.method(#getUserEvents, []),
      returnValue: Future.value(<EventModel>[]),
      returnValueForMissingStub: Future.value(<EventModel>[]),
    );
  }

  @override
  Future<void> addEventToUserList(EventModel event) {
    return super.noSuchMethod(
      Invocation.method(#addEventToUserList, [event]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }

  @override
  Future<void> markTaskAsDone(String eventTitle, String taskTitle) {
    return super.noSuchMethod(
      Invocation.method(#markTaskAsDone, [eventTitle, taskTitle]),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    );
  }
}

void main() {
  group('UserEventsBloc', () {
    late MockUserEventService mockService;

    final mockEvent = EventModel(
      title: 'Test Event',
      image: '',
      date: '2025-11-08',
      time: '8:00 PM',
      address: 'Alexandria',
      phone: '0100000000',
      tasks: [Task(title: 'Task 1', description: 'Desc', done: false)],
    );

    setUp(() {
      mockService = MockUserEventService();
    });

    blocTest<UserEventsBloc, UserEventsState>(
      'emits [Loading, Loaded] when LoadUserEvents succeeds',
      build: () {
        when(mockService.getUserEvents())
            .thenAnswer((_) async => [mockEvent]);
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(LoadUserEvents()),
      expect: () => [isA<UserEventsLoading>(), isA<UserEventsLoaded>()],
      verify: (_) {
        verify(mockService.getUserEvents()).called(1);
      },
    );

    blocTest<UserEventsBloc, UserEventsState>(
      'emits [Error] when addEvent throws',
      build: () {
        when(mockService.addEventToUserList(mockEvent))
            .thenThrow(Exception('Failed'));
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(AddUserEvent(mockEvent)),
      expect: () => [isA<UserEventsError>()],
      verify: (_) {
        verify(mockService.addEventToUserList(mockEvent)).called(1);
      },
    );

    blocTest<UserEventsBloc, UserEventsState>(
      'emits [Loaded] when AddUserEvent succeeds',
      build: () {
        when(mockService.addEventToUserList(mockEvent))
            .thenAnswer((_) async => Future.value());
        when(mockService.getUserEvents())
            .thenAnswer((_) async => [mockEvent]);
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(AddUserEvent(mockEvent)),
      expect: () => [isA<UserEventsLoaded>()],
      verify: (_) {
        verify(mockService.addEventToUserList(mockEvent)).called(1);
        verify(mockService.getUserEvents()).called(1);
      },
    );

    blocTest<UserEventsBloc, UserEventsState>(
      'emits error with custom message when event already exists',
      build: () {
        when(mockService.addEventToUserList(mockEvent))
            .thenThrow(Exception('already in your list'));
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(AddUserEvent(mockEvent)),
      expect: () => [
        isA<UserEventsError>().having(
          (state) => state.message,
          'message',
          'Event already in your list!',
        ),
      ],
    );

    blocTest<UserEventsBloc, UserEventsState>(
      'emits [Loading, Error] when LoadUserEvents fails',
      build: () {
        when(mockService.getUserEvents())
            .thenThrow(Exception('Failed to load'));
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(LoadUserEvents()),
      expect: () => [
        isA<UserEventsLoading>(),
        isA<UserEventsError>().having(
          (state) => state.message,
          'message',
          contains('Failed to load'),
        ),
      ],
    );

    blocTest<UserEventsBloc, UserEventsState>(
      'emits [Loaded] when MarkTaskDone succeeds',
      build: () {
        when(mockService.markTaskAsDone('Test Event', 'Task 1'))
            .thenAnswer((_) async => Future.value());
        when(mockService.getUserEvents())
            .thenAnswer((_) async => [mockEvent]);
        return UserEventsBloc(mockService);
      },
      act: (bloc) => bloc.add(const MarkTaskDone('Test Event', 'Task 1')),
      expect: () => [isA<UserEventsLoaded>()],
      verify: (_) {
        verify(mockService.markTaskAsDone('Test Event', 'Task 1')).called(1);
        verify(mockService.getUserEvents()).called(1);
      },
    );
  });
}