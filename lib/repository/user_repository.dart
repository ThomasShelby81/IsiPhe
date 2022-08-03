import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth;

  UserRepository()
    :_firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password){
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut(){
    return _firebaseAuth.signOut();
  }

  Future<bool> isSignIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getUser(){
    return _firebaseAuth.currentUser;
  }

}