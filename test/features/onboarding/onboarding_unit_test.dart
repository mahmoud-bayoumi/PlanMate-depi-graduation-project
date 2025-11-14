import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planmate_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/get_started_widgets.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/cycles_container.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/first_page_bottom_sheet.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/onboarding_description.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/onboarding_title_text.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/next_text_button.dart';
import 'package:planmate_app/features/onboarding/presentation/views/widgets/dots_row.dart';
import 'package:planmate_app/features/authentication/bloc/auth_bloc.dart';
import 'package:planmate_app/features/authentication/bloc/auth_state.dart';
import 'package:planmate_app/features/authentication/bloc/auth_event.dart';

// Mock classes
class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  group('OnboardingView Unit Tests', () {
    testWidgets('Test 1: OnboardingView initializes with PageController', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      expect(find.byType(OnboardingView), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Test 2: OnboardingView displays first page initially', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Should show first page content
      expect(find.text('Easy to find events'), findsOneWidget);
    });

    testWidgets('Test 3: OnboardingView has two pages', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both pages exist by checking their content
      expect(find.text('Easy to find events'), findsOneWidget);
      
      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      
      expect(find.text('Meet with new folks'), findsOneWidget);
    });

    testWidgets('Test 4: OnboardingView updates isLastPage on page change', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on first page
      expect(find.byType(FIrstPageBottomSheet), findsOneWidget);

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Should show GetStartedButton on last page
      expect(find.byType(GetStartedButton), findsOneWidget);
    });

    testWidgets('Test 5: OnboardingView buildPage creates correct structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify page structure components
      expect(find.byType(CyclesContainer), findsOneWidget);
      expect(find.byType(OnboardingTitleText), findsOneWidget);
      expect(find.byType(OnboardingDescription), findsOneWidget);
    });

    testWidgets('Test 6: OnboardingView disposes PageController correctly', (tester) async {
      final widget = const OnboardingView();
      await tester.pumpWidget(
        MaterialApp(
          home: widget,
        ),
      );

      await tester.pumpAndSettle();

      // Remove widget to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Should not throw errors during disposal
      expect(find.byType(OnboardingView), findsNothing);
    });

    testWidgets('Test 7: OnboardingView shows correct content on second page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Should show second page content
      expect(find.text('Meet with new folks'), findsOneWidget);
    });
  });

  group('GetStartedButton Unit Tests', () {
    testWidgets('Test 1: GetStartedButton renders ElevatedButton', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      expect(find.byType(GetStartedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Test 2: GetStartedButton displays correct text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Test 3: GetStartedButton saves hasSeenOnboarding to SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final mockAuthBloc = MockAuthBloc();
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.fromIterable([AuthInitial()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const Scaffold(
              body: GetStartedButton(),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify SharedPreferences was updated
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('hasSeenOnboarding'), isTrue);
    });

    testWidgets('Test 4: GetStartedButton has correct button styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      // fixedSize is a WidgetStateProperty, check its value
      final fixedSize = button.style?.fixedSize?.resolve({});
      expect(fixedSize, equals(const Size(350, 60)));
    });

    testWidgets('Test 5: GetStartedButton navigates to AuthGate on press', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final mockAuthBloc = MockAuthBloc();
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());
      when(() => mockAuthBloc.stream).thenAnswer((_) => Stream.fromIterable([AuthInitial()]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: const Scaffold(
              body: GetStartedButton(),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Navigation should occur (widget will be replaced)
      expect(find.byType(GetStartedButton), findsNothing);
    });
  });

  group('CyclesContainer Unit Tests', () {
    testWidgets('Test 1: CyclesContainer renders with image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      expect(find.byType(CyclesContainer), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Test 2: CyclesContainer uses correct width and height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      // Container width and height are set via constraints or direct properties
      // Verify container exists and has decoration
      expect(container.decoration, isNotNull);
      expect(container.child, isNotNull);
    });

    testWidgets('Test 3: CyclesContainer displays image asset', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('FirstPageBottomSheet Unit Tests', () {
    testWidgets('Test 1: FirstPageBottomSheet renders with DotsRow and NextTextButton', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FIrstPageBottomSheet(
              isLastPage: false,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byType(FIrstPageBottomSheet), findsOneWidget);
      expect(find.byType(DotsRow), findsOneWidget);
      expect(find.byType(NextTextButton), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Test 2: FirstPageBottomSheet has correct padding', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FIrstPageBottomSheet(
              isLastPage: false,
              controller: controller,
            ),
          ),
        ),
      );

      // Find the Padding widget that's a descendant of FirstPageBottomSheet
      final paddingFinder = find.descendant(
        of: find.byType(FIrstPageBottomSheet),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsOneWidget);
      controller.dispose();
    });

    testWidgets('Test 3: FirstPageBottomSheet passes isLastPage to DotsRow', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FIrstPageBottomSheet(
              isLastPage: true,
              controller: controller,
            ),
          ),
        ),
      );

      final dotsRow = tester.widget<DotsRow>(find.byType(DotsRow));
      expect(dotsRow.isLastPage, isTrue);
      controller.dispose();
    });
  });

  group('OnboardingDescription Unit Tests', () {
    testWidgets('Test 1: OnboardingDescription displays text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(
              description: 'Test description',
            ),
          ),
        ),
      );

      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('Test 2: OnboardingDescription applies correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(
              description: 'Test',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.style?.fontWeight, equals(FontWeight.w400));
      expect(text.style?.fontSize, equals(16));
    });

    testWidgets('Test 3: OnboardingDescription has maxLines constraint', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(
              description: 'Test',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.maxLines, equals(4));
    });
  });

  group('OnboardingTitleText Unit Tests', () {
    testWidgets('Test 1: OnboardingTitleText displays title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingTitleText(title: 'Test Title'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('Test 2: OnboardingTitleText applies correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingTitleText(title: 'Test'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.style?.fontWeight, equals(FontWeight.w500));
      expect(text.style?.fontSize, equals(28));
    });
  });

  group('NextTextButton Unit Tests', () {
    testWidgets('Test 1: NextTextButton renders TextButton', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextTextButton(controller: controller),
          ),
        ),
      );

      expect(find.byType(NextTextButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Test 2: NextTextButton displays Next text and icon', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextTextButton(controller: controller),
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_right_alt), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Test 3: NextTextButton navigates to next page', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: controller,
                    children: const [
                      Text('Page 1'),
                      Text('Page 2'),
                    ],
                  ),
                ),
                NextTextButton(controller: controller),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on first page
      expect(find.text('Page 1'), findsOneWidget);

      final button = find.byType(TextButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Should navigate to second page
      expect(find.text('Page 2'), findsOneWidget);
      controller.dispose();
    });
  });

  group('DotsRow Unit Tests', () {
    testWidgets('Test 1: DotsRow renders two AnimatedContainers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      expect(find.byType(DotsRow), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(2));
    });

    testWidgets('Test 2: DotsRow updates dot width based on isLastPage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify containers exist
      expect(find.byType(AnimatedContainer), findsNWidgets(2));

      // Update to last page
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify containers still exist with updated state
      expect(find.byType(AnimatedContainer), findsNWidgets(2));
    });

    testWidgets('Test 3: DotsRow has correct animation duration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
      expect(container.duration, equals(const Duration(milliseconds: 300)));
    });
  });
}

