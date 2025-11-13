import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:planmate_app/features/authentication/services/auth_service.dart';
import 'package:planmate_app/features/authentication/services/user_firestore_service.dart';

// Mock classes for Firebase and Google dependencies
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserService extends Mock implements UserService {}

class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserService mockUserService;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService authService;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  // Set up mocktail and StreamController before each test (isolation)
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserService = MockUserService();
    mockGoogleSignIn = MockGoogleSignIn();

    authService = AuthService(
      auth: mockFirebaseAuth,
      userService: mockUserService,
      googleSignIn: mockGoogleSignIn,
    );
  });

  group('AuthService Essential Tests', () {
    group('signInWithEmail', () {
      test('Test: Successful Email/Password Sign-In', () async {
        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInWithEmail(
          'test@example.com',
          'password123',
        );

        expect(result, equals(mockUser));
      });

      test('Test: Failed Sign-In with Invalid Credentials', () async {
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

        expect(
          () => authService.signInWithEmail('test@example.com', 'wrong'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signUpWithEmail', () {
      test('Test: Successful User Registration', () async {
        const userId = 'user123';
        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        when(() => mockUser.uid).thenReturn(userId);
        when(
          () => mockUser.updateDisplayName(any()),
        ).thenAnswer((_) async => {});
        when(() => mockUser.reload()).thenAnswer((_) async => {});
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(
          () => mockUserService.createUser(any(), any(), any(), any()),
        ).thenAnswer((_) async => {});

        final result = await authService.signUpWithEmail(
          'new@example.com',
          'password123',
          'John',
          'Doe',
          '1990-01-01',
        );

        expect(result, equals(mockUser));
        verify(
          () => mockUserService.createUser(userId, 'John', 'Doe', '1990-01-01'),
        ).called(1);
      });

      test('Test: Registration with Existing Email', () async {
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => authService.signUpWithEmail(
            'existing@example.com',
            'password123',
            'John',
            'Doe',
            '1990-01-01',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signInWithGoogle', () {
      test('Test: Successful Google Auth Sign-In', () async {
        final mockGoogleAccount = MockGoogleSignInAccount();
        final mockGoogleAuth = MockGoogleSignInAuthentication();
        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        when(
          () => mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          () => mockGoogleAccount.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(() => mockGoogleAuth.accessToken).thenReturn('token');
        when(() => mockGoogleAuth.idToken).thenReturn('id_token');
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(
          () => mockFirebaseAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInWithGoogle();

        expect(result, equals(mockUser));
      });
    });

    group('resetPassword', () {
      test('Test: Password Reset Email Sent Successfully', () async {
        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => {});

        await authService.resetPassword('test@example.com');

        verify(
          () => mockFirebaseAuth.sendPasswordResetEmail(
            email: 'test@example.com',
          ),
        ).called(1);
      });
    });

    group('signOut', () {
      test('Test: Complete Sign-Out from All Providers', () async {
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

        await authService.signOut();

        verify(() => mockGoogleSignIn.signOut()).called(1);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });
    });
  });
}
