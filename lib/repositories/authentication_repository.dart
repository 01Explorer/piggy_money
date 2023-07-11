import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piggy_money/core/exceptions/authentication_exceptions.dart';
import 'package:piggy_money/models/user_model.dart' as user_model;

class AuthenticationRepository {
  // final CacheClient _cache;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  user_model.User get currentUser {
    return _firebaseAuth.currentUser?.toModel ?? user_model.User.empty;
  }

  Stream<user_model.User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user_model.User user =
          firebaseUser?.toModel ?? user_model.User.empty;
      return user;
    });
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  // AuthenticationRepository({
  //   // CacheClient? cache,
  //   // GoogleSignIn? googleSignIn,
  // }) :
  //       // _cache = cache ?? CacheClient(),

  // // _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
  // ;
}

extension on User {
  user_model.User get toModel {
    return user_model.User(
        id: uid, email: email, name: displayName, avatar: photoURL);
  }
}
