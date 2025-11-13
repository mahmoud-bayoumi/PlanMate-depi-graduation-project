import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_firestore_service.dart';

class AuthService {
  final UserService _userService;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  // Constructor for dependency injection and easier testing
  AuthService({
    UserService? userService,
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  }) : _userService = userService ?? UserService(),
       _auth = auth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Stream of auth changes
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (caughtError) {
      // For user-friendly messages
      if (caughtError.code == 'user-not-found') {
        throw Exception('No account found with this email');
      } else if (caughtError.code == 'wrong-password') {
        throw Exception('Incorrect password. Please try again');
      } else if (caughtError.code == 'invalid-email') {
        throw Exception('Please enter a valid email address');
      } else if (caughtError.code == 'invalid-credential') {
        throw Exception('Invalid email or password');
      } else {
        throw Exception(
          caughtError.message ?? 'Login failed. Please try again',
        );
      }
    } catch (caughtError) {
      throw Exception('Connection error. Please check your internet');
    }
  }

  // Sign up with email and password
  Future<User?> signUpWithEmail(
    String email,
    String password,
    String firstName,
    String lastName,
    String birthDate,
  ) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;
      if (user != null) {
        // Store additional user details in Firestore
        await _userService.createUser(user.uid, firstName, lastName, birthDate);

        // Update display name
        final fullName = "$firstName $lastName";
        await user.updateDisplayName(fullName);
        await user.reload();

        // Return the updated user
        return _auth.currentUser;
      }
      return null;
    } on FirebaseAuthException catch (caughtError) {
      // For user-friendly messages
      if (caughtError.code == 'weak-password') {
        throw Exception('Password must be at least 6 characters long');
      } else if (caughtError.code == 'email-already-in-use') {
        throw Exception(
          'This email is already registered. Please login instead',
        );
      } else if (caughtError.code == 'invalid-email') {
        throw Exception('Please enter a valid email address');
      } else {
        throw Exception(
          caughtError.message ?? 'Registration failed. Please try again',
        );
      }
    } catch (caughtError) {
      throw Exception('Connection error. Please check your internet');
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();

      // User cancelled the sign-in
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Get authentication tokens
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (caughtError) {
      throw Exception(
        caughtError.message ?? 'Google sign-in failed. Please try again',
      );
    } catch (caughtError) {
      throw Exception('Google sign-in failed. Please try again');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (caughtError) {
      // For user-friendly messages
      if (caughtError.code == 'user-not-found') {
        throw Exception('No user found with this email.');
      } else if (caughtError.code == 'invalid-email') {
        throw Exception('Invalid email format.');
      } else {
        throw Exception(caughtError.message ?? 'Password reset failed.');
      }
    } catch (caughtError) {
      throw Exception('An unexpected error occurred.');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // From Google
      await _auth.signOut(); // From Firebase
    } catch (caughtError) {
      throw Exception('Sign out failed.');
    }
  }
}
