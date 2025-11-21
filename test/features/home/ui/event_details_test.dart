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

    testWidgets('tapping Add To List button triggers bloc event and shows success snackbar', 
        (tester) async {
      // Arrange: mock service responses
      when(() => mockService.addEventToUserList(any()))
          .thenAnswer((_) async {});
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);

      // Build the widget
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      // Scroll if needed
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Add To List - wrap in runAsync to handle async operations
      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        
        // Wait a bit for async operations
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      // Pump to process UI updates
      await tester.pumpAndSettle();

      // Verify service was called
      verify(() => mockService.addEventToUserList(any())).called(1);
      verify(() => mockService.getUserEvents()).called(1);

      // Verify success snackbar appears
      expect(find.text('Event added to your list!'), findsOneWidget);
    });

    testWidgets('shows only error snackbar when event already exists', (tester) async {
      // Mock the service to throw "already in list" error
      when(() => mockService.addEventToUserList(any()))
          .thenThrow(Exception('already in your list'));
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);

      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Add To List - wrap in runAsync
      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        
        // Wait for async operations
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      await tester.pumpAndSettle();

      // Verify service was called
      verify(() => mockService.addEventToUserList(any())).called(1);

      // The bloc should emit Error then Loaded (to restore state)
      // But only error snackbar should show due to errorOccurred flag
      expect(find.text('Event already in your list!'), findsOneWidget);
      expect(find.text('Event added to your list!'), findsNothing);
    });

    testWidgets('shows only error snackbar when generic error occurs with previous state', 
        (tester) async {
      // Set up previous loaded state
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);
      
      // Load initial state
      await tester.runAsync(() async {
        bloc.add(LoadUserEvents());
        await Future.delayed(const Duration(milliseconds: 100));
      });
      
      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      // Now mock failure for add event
      when(() => mockService.addEventToUserList(any()))
          .thenThrow(Exception('Network error'));

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap Add To List
      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      await tester.pumpAndSettle();

      // Verify error snackbar shows but not success
      expect(find.text('Exception: Network error'), findsOneWidget);
      expect(find.text('Event added to your list!'), findsNothing);
    });

    testWidgets('bloc emits correct final state when add event fails', (tester) async {
      when(() => mockService.addEventToUserList(any()))
          .thenThrow(Exception('already in your list'));
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);

      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Tap and wait for async completion
      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      await tester.pumpAndSettle();

      verify(() => mockService.addEventToUserList(any())).called(1);

      // After the error, the bloc restores the state to UserEventsLoaded
      // So the final state should be UserEventsLoaded, not UserEventsError
      expect(bloc.state, isA<UserEventsLoaded>());
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

  group('EventDetailsScreen Snackbar Behavior', () {
    late MockUserEventService mockService;
    late UserEventsBloc bloc;

    setUp(() {
      mockService = MockUserEventService();
      bloc = UserEventsBloc(mockService);
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets('does not show success snackbar after error snackbar', (tester) async {
      // This test verifies the errorOccurred flag works correctly
      when(() => mockService.addEventToUserList(any()))
          .thenThrow(Exception('already in your list'));
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);

      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      await tester.pumpAndSettle();

      // Only error snackbar should be present
      expect(find.text('Event already in your list!'), findsOneWidget);
      expect(find.text('Event added to your list!'), findsNothing);

      // Even after waiting for state restoration
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Event added to your list!'), findsNothing);
    });

    testWidgets('shows success snackbar only on first successful add', (tester) async {
      when(() => mockService.addEventToUserList(any()))
          .thenAnswer((_) async {});
      when(() => mockService.getUserEvents())
          .thenAnswer((_) async => [testEvent]);

      await tester.pumpWidget(createWidgetUnderTest(testEvent, bloc));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.text('Add To List'));
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      
      await tester.pumpAndSettle();

      // Success snackbar should appear
      expect(find.text('Event added to your list!'), findsOneWidget);
      expect(find.text('Event already in your list!'), findsNothing);
    });
  });
}
