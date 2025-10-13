import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (caughtError) {
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

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (caughtError) {
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

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (caughtError) {
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

  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await _auth.signOut();
    } catch (caughtError) {
      throw Exception('Sign out failed.');
    }
  }
}
