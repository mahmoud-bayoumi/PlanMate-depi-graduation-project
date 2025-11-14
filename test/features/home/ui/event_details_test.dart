import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/event_details.dart';
import 'package:planmate_app/features/home/data/models/event.dart';
import 'package:planmate_app/features/home/data/models/task.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_bloc.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_event.dart';
import 'package:planmate_app/features/home/presentation/view_model/user_events_bloc/user_events_state.dart';
import 'package:planmate_app/features/home/data/services/user_event_service.dart';

class MockUserEventService extends Mock implements UserEventService {}
class FakeEventModel extends Fake implements EventModel {}


void main() {
  final testEvent = EventModel(
    title: 'Test Event',
    image: 'https://example.com/image.jpg',
    date: '2025-11-08',
    time: '12:00 PM',
    address: 'Cairo',
    phone: '12345',
    tasks: [Task(title: 'Task 1', description: 'Test', done: false)],
  );

  setUpAll(() {
  registerFallbackValue(FakeEventModel());

  registerFallbackValue(EventModel(
    title: '',
    image: '',
    date: '',
    time: '',
    address: '',
    phone: '',
    tasks: const [],
  ));
});


  Widget createWidgetUnderTest(EventModel event, UserEventsBloc bloc) {
    return MaterialApp(
      home: BlocProvider<UserEventsBloc>.value(
        value: bloc,
        child: EventDetailsScreen(eventModel: event),
      ),
    );
  }

  group('EventDetailsScreen UI Tests', () {
    late MockUserEventService mockService;
    late UserEventsBloc bloc;

    setUp(() {
      mockService = MockUserEventService();
      bloc = UserEventsBloc(mockService);
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('displays event title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      expect(find.text('Test Event'), findsOneWidget);
    });

    testWidgets('displays all event details', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      expect(find.text('Date: 2025-11-08'), findsOneWidget);
      expect(find.text('Address: Cairo'), findsOneWidget);
      expect(find.text('Time: 12:00 PM'), findsOneWidget);
      expect(find.text('Phone: 12345'), findsOneWidget);
      expect(find.text('Free'), findsOneWidget);
    });

    testWidgets('displays Add To List button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();
      expect(find.text('Add To List'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays back button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('displays share button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('displays note section', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('Note :-'), findsOneWidget);
      expect(find.text("You can access each event's tasks from the Events List screen."), findsOneWidget);
    });
  });

  group('EventDetailsScreen Interaction Tests', () {
    late MockUserEventService mockService;
    late UserEventsBloc bloc;

    setUp(() {
      mockService = MockUserEventService();
      bloc = UserEventsBloc(mockService);
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('back button pops the screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<UserEventsBloc>.value(
                      value: bloc,
                      child: EventDetailsScreen(eventModel: testEvent),
                    ),
                  ),
                );
              },
              child: const Text('Go to Details'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();
      expect(find.text('Test Event'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Go to Details'), findsOneWidget);
      expect(find.text('Test Event'), findsNothing);
    });

testWidgets('tapping Add To List button triggers bloc event', (tester) async {
  //Arrange: mock service responses
  when(() => mockService.addEventToUserList(testEvent))
      .thenAnswer((_) async {});
  when(() => mockService.getUserEvents())
      .thenAnswer((_) async => [testEvent]);

  //Build the widget
  await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
  await tester.pumpAndSettle();

  //Scroll if needed
  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
  await tester.pumpAndSettle();

  //Tap Add To List
  await tester.tap(find.text('Add To List'));

  //Simulate timer in widget
  await tester.pump(const Duration(seconds: 2));

  //Wait for async call to complete
  await untilCalled(() => mockService.addEventToUserList(testEvent));

  //Assert
  verify(() => mockService.addEventToUserList(testEvent)).called(1);
});



    testWidgets('bloc emits error state when add event fails', (tester) async {
  when(() => mockService.addEventToUserList(testEvent))
      .thenThrow(Exception('already in your list'));

  await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
  await tester.pumpAndSettle();

  await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Add To List'));
  await tester.pump(); 
  await tester.pump(const Duration(seconds: 2)); 

  await untilCalled(() => mockService.addEventToUserList(testEvent));

  verify(() => mockService.addEventToUserList(testEvent)).called(1);

  expect(bloc.state, isA<UserEventsError>());
  expect((bloc.state as UserEventsError).message, 'Event already in your list!');
});


    testWidgets('share button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();
    });
  });

  group('EventDetailsScreen Edge Cases', () {
    late MockUserEventService mockService;
    late UserEventsBloc bloc;

    setUp(() {
      mockService = MockUserEventService();
      bloc = UserEventsBloc(mockService);
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('handles event with empty image', (WidgetTester tester) async {
      final eventWithoutImage = EventModel(
        title: 'Event No Image',
        image: '',
        date: '2025-11-08',
        time: '12:00 PM',
        address: 'Cairo',
        phone: '12345',
        tasks: [],
      );

      await tester.pumpWidget(createWidgetUnderTest(eventWithoutImage, bloc));
      expect(find.text('Event No Image'), findsOneWidget);
    });

    testWidgets('handles event with no tasks', (WidgetTester tester) async {
      final eventWithNoTasks = EventModel(
        title: 'Event No Tasks',
        image: 'https://example.com/image.jpg',
        date: '2025-11-08',
        time: '12:00 PM',
        address: 'Cairo',
        phone: '12345',
        tasks: [],
      );

      await tester.pumpWidget(createWidgetUnderTest(eventWithNoTasks, bloc));
      expect(find.text('Event No Tasks'), findsOneWidget);
    });
  });
}





