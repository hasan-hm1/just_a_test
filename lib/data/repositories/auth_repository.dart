import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:interview_test/data/models/auth/user.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/enums/user_type.dart';
import 'package:interview_test/res/app_res.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserType? userType;

  Future<void> signup(User user) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      // set Type
      await _firebaseFirestore
          .collection(AppContants.usersColllectionName)
          .doc(userCredential.user?.uid)
          .set({'type': user.type});
      this.userType = _getUserTypeFromString(user.type);
    } on FirebaseAuthException catch (e) {
      throw AppError(errorMessage: e.message);
    } on Error catch (_) {
      throw AppError();
    }
  }

  Future<void> signin(User user) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      if (userCredential.user != null) {
        // get type
        final doc = await _firebaseFirestore
            .collection(AppContants.usersColllectionName)
            .doc(userCredential.user!.uid)
            .get();

        this.userType = _getUserTypeFromString(doc.get('type'));
      }
    } on FirebaseAuthException catch (e) {
      throw AppError(errorMessage: e.message);
    } on Error catch (_) {
      throw AppError();
    }
  }

  Future<void> signout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppError(errorMessage: e.message);
    } on Error catch (_) {
      throw AppError();
    }
  }

  Future<void> fetchUserType(String userId) async {
    try {
      final type = await _firebaseFirestore
          .collection(AppContants.usersColllectionName)
          .doc(userId)
          .get();

      this.userType = _getUserTypeFromString(type.data()?['type']);
    } on FirebaseAuthException catch (e) {
      throw AppError(errorMessage: e.message);
    } on Error catch (_) {
      throw AppError();
    }
  }

  UserType _getUserTypeFromString(String userString) {
    if (userString == 'student') {
      return UserType.student;
    }
    return UserType.teacher;
  }
}
