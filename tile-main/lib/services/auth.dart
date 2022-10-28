import 'package:tile/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on Firebaser User

  MyUser? _userFromFirebaseUser(User? user){
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
        //.map( _userFromFirebaseUser);
  }

  //anonymous
  Future signInAnonymous () async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      //result represents user
      User? user = result.user as User;
      //return _userFromFirebaseUser(user);
      return user;
       
    } catch (e){
      print(e.toString());
      return null;
    }

  }


  //sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }

  }


  //register with email and password
  Future registerWithEmailandPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  //sign out
  Future signOut () async {
    try {
      return await _auth.signOut();
       
    } catch (e){
      print(e.toString());
      print("he");
      return null;
    }

  }


}
