import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planmate_app/features/home/data/models/event.dart';
import 'package:planmate_app/features/home/data/models/task.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_state.dart';
import 'package:planmate_app/your_event_list_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

//Mock the Bloc
class MockUserEventsBloc extends MockBloc<UserEventsEvent, UserEventsState>
    implements UserEventsBloc {}

//Fake event for mocktail
class FakeUserEventsEvent extends Fake implements UserEventsEvent {}

//Fake state for mocktail
class FakeUserEventsState extends Fake implements UserEventsState {}

void main() {
  setUpAll(() {
    //Register fallback values for mocktail
    registerFallbackValue(FakeUserEventsEvent());
    registerFallbackValue(FakeUserEventsState());
  });

  testWidgets('EventsListScreen displays and updates tasks correctly',
      (WidgetTester tester) async {
    final event = EventModel(
      title: 'Test Event',
      image: '',
      date: '2025-11-08',
      time: '5:00 PM',
      address: 'Alexandria',
      phone: '0100000000',
      tasks: [Task(title: 'Task 1', description: 'Do it', done: false)],
    );

    final mockBloc = MockUserEventsBloc();

    //Set up the mock bloc to return the loaded state
    whenListen(
      mockBloc,
      Stream.fromIterable([UserEventsLoaded([event])]),
      initialState: UserEventsLoaded([event]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserEventsBloc>.value(
          value: mockBloc,
          child: const EventsListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    //Step 1:Verify event exists
    expect(find.text('Test Event'), findsOneWidget);

    //Step 2:Expand tile
    await tester.tap(find.text('Test Event'));
    await tester.pumpAndSettle();

    //Step 3:Verify initial button
    expect(find.text('Join Now'), findsOneWidget);

    //Step 4:Tap "Join Now" -> expect "Uncompleted"
    await tester.tap(find.text('Join Now'));
    await tester.pumpAndSettle();
    
    expect(find.text('Uncompleted'), findsOneWidget);
    expect(find.text('Join Now'), findsNothing);

    //Step 5:Tap "Uncompleted" -> should become "Completed"
    await tester.tap(find.text('Uncompleted'));
    await tester.pumpAndSettle();

    //Step 6:Expect "Completed"
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Uncompleted'), findsNothing);

    //Step 7:Task still visible
    expect(find.text('Task 1'), findsOneWidget);
    
    //Step 8:Verify the bloc event was called
    verify(() => mockBloc.add(any(that: isA<MarkTaskDone>()))).called(1);
  });
}