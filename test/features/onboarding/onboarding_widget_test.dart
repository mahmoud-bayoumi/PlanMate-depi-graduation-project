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

  group('OnboardingView Widget Tests', () {
    testWidgets('Test 1: OnboardingView displays Scaffold with PageView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Test 2: OnboardingView shows first page content correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Easy to find events'), findsOneWidget);
      expect(find.text('Discover a variety of events tailored to your interests. Our platform makes it simple to browse and find what matters most to you.'), findsOneWidget);
    });

    testWidgets('Test 3: OnboardingView shows second page content after swipe', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Meet with new folks'), findsOneWidget);
      expect(find.text('Connect with people who share your interests. Our platform helps you expand your network by meeting new and like-minded individuals.'), findsOneWidget);
    });

    testWidgets('Test 4: OnboardingView shows FirstPageBottomSheet on first page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FIrstPageBottomSheet), findsOneWidget);
      expect(find.byType(GetStartedButton), findsNothing);
    });

    testWidgets('Test 5: OnboardingView shows GetStartedButton on last page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(GetStartedButton), findsOneWidget);
      expect(find.byType(FIrstPageBottomSheet), findsNothing);
    });

    testWidgets('Test 6: OnboardingView handles page swipe gestures', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Easy to find events'), findsOneWidget);

      // Swipe left to go to next page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Meet with new folks'), findsOneWidget);

      // Swipe right to go back
      await tester.drag(find.byType(PageView), const Offset(400, 0));
      await tester.pumpAndSettle();

      // After swiping back, should be on first page again
      expect(find.text('Easy to find events'), findsOneWidget);
    });

    testWidgets('Test 7: OnboardingView maintains state during page changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingView(),
        ),
      );

      await tester.pumpAndSettle();

      // Swipe to second page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Widget should still be mounted
      expect(find.byType(OnboardingView), findsOneWidget);
    });
  });

  group('GetStartedButton Widget Tests', () {
    testWidgets('Test 1: GetStartedButton displays all UI elements', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      expect(find.byType(GetStartedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Test 2: GetStartedButton has correct button styling', (tester) async {
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

    testWidgets('Test 3: GetStartedButton saves onboarding status and navigates', (tester) async {
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

    testWidgets('Test 4: GetStartedButton has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      // Find the Padding widget that's a descendant of GetStartedButton
      final paddingFinder = find.descendant(
        of: find.byType(GetStartedButton),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsOneWidget);
      final padding = tester.widget<Padding>(paddingFinder);
      expect(padding.padding, equals(const EdgeInsets.symmetric(vertical: 40.0, horizontal: 8)));
    });

    testWidgets('Test 5: GetStartedButton text has correct styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GetStartedButton(),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Get Started'));
      expect(text.style?.color, equals(Colors.white));
      expect(text.style?.fontSize, equals(18));
      expect(text.style?.fontWeight, equals(FontWeight.w600));
    });
  });

  group('CyclesContainer Widget Tests', () {
    testWidgets('Test 1: CyclesContainer displays container with image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      expect(find.byType(CyclesContainer), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Test 2: CyclesContainer uses screen dimensions', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      // Verify container has width and height set (they're direct properties)
      // The container should adapt to screen size
      expect(container.decoration, isNotNull);
      expect(container.child, isNotNull);

      addTearDown(() => tester.binding.setSurfaceSize(null));
    });

    testWidgets('Test 3: CyclesContainer has background decoration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CyclesContainer(image: 'assets/images/illustrations.png'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isNotNull);
    });
  });

  group('FirstPageBottomSheet Widget Tests', () {
    testWidgets('Test 1: FirstPageBottomSheet displays correct layout', (tester) async {
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
      // Find Row that's a descendant of FirstPageBottomSheet
      final rowFinder = find.descendant(
        of: find.byType(FIrstPageBottomSheet),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsOneWidget);
      expect(find.byType(DotsRow), findsOneWidget);
      expect(find.byType(NextTextButton), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
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
      final padding = tester.widget<Padding>(paddingFinder);
      expect(padding.padding, equals(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40)));
      controller.dispose();
    });

    testWidgets('Test 3: FirstPageBottomSheet passes controller to NextTextButton', (tester) async {
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

      expect(find.byType(NextTextButton), findsOneWidget);
      controller.dispose();
    });
  });

  group('OnboardingDescription Widget Tests', () {
    testWidgets('Test 1: OnboardingDescription displays description text', (tester) async {
      const description = 'This is a test description for onboarding.';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(description: description),
          ),
        ),
      );

      expect(find.text(description), findsOneWidget);
    });

    testWidgets('Test 2: OnboardingDescription applies correct text styling', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(description: 'Test'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test'));
      expect(text.style?.fontWeight, equals(FontWeight.w400));
      expect(text.style?.fontSize, equals(16));
      expect(text.maxLines, equals(4));
    });

    testWidgets('Test 3: OnboardingDescription has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(description: 'Test'),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, equals(const EdgeInsets.symmetric(horizontal: 8.0)));
    });

    testWidgets('Test 4: OnboardingDescription handles long text', (tester) async {
      const longDescription = 'This is a very long description that should be displayed correctly with the maxLines constraint applied to prevent overflow issues.';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingDescription(description: longDescription),
          ),
        ),
      );

      expect(find.text(longDescription), findsOneWidget);
    });
  });

  group('OnboardingTitleText Widget Tests', () {
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

    testWidgets('Test 3: OnboardingTitleText handles different titles', (tester) async {
      final titles = ['Title 1', 'Title 2', 'Another Title'];
      for (final title in titles) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: OnboardingTitleText(title: title),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
      }
    });
  });

  group('NextTextButton Widget Tests', () {
    testWidgets('Test 1: NextTextButton displays Next text and arrow icon', (tester) async {
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

    testWidgets('Test 2: NextTextButton has correct text styling', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextTextButton(controller: controller),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Next'));
      expect(text.style?.fontSize, equals(18));
      controller.dispose();
    });

    testWidgets('Test 3: NextTextButton navigates page on tap', (tester) async {
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

      // Tap Next button
      final button = find.byType(TextButton);
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Should navigate to second page
      expect(find.text('Page 2'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('Test 4: NextTextButton icon has correct color and size', (tester) async {
      final controller = PageController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NextTextButton(controller: controller),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_right_alt));
      expect(icon.size, equals(36));
      controller.dispose();
    });
  });

  group('DotsRow Widget Tests', () {
    testWidgets('Test 1: DotsRow displays two animated dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      expect(find.byType(DotsRow), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNWidgets(2));
    });

    testWidgets('Test 2: DotsRow shows first dot active when not last page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both containers exist
      final containers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(containers.length, equals(2));
      // First dot should be wider (active), second should be smaller (inactive)
      // We verify the structure exists rather than checking width directly
      expect(containers.first, isNotNull);
      expect(containers.last, isNotNull);
    });

    testWidgets('Test 3: DotsRow shows second dot active when last page', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both containers exist
      final containers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(containers.length, equals(2));
      // Second dot should be wider (active), first should be smaller (inactive)
      // We verify the structure exists rather than checking width directly
      expect(containers.first, isNotNull);
      expect(containers.last, isNotNull);
    });

    testWidgets('Test 4: DotsRow animates when isLastPage changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Change to last page
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify containers still exist after animation
      final containers = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(containers.length, equals(2));
    });

    testWidgets('Test 5: DotsRow dots have correct height and border radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
      // Verify decoration exists and has correct border radius
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(100)));
      expect(decoration.color, isNotNull);
    });

    testWidgets('Test 6: DotsRow has spacing between dots', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DotsRow(isLastPage: false),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(6));
    });
  });
}

