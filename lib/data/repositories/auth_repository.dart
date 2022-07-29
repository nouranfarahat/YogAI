import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../enum/user_level_enum.dart';
import '../models/user.dart';
class AuthRepository{
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  late   user   current_user;
  bool checkUserNameexistence(String username)
  {
    try {
      final documentSnapshot =
       _firestore.collection('user').where(
          'user_name', isEqualTo: username).get();
      if(documentSnapshot!=null)
      {return true;
      }return false;
    }catch(e)
    {
      throw Exception(e.toString());
    }



  }

  Future<void> signUp({required String email, required String password,required String username,required DateTime age,}) async {
      if(true)
     { try {
        final result = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        user? new_user = user(user_name:username,level:Level.beginner.string,age:age,user_id:result.user?.uid);
        createUser(new_user);
        this.current_user=new_user;

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw Exception('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          throw Exception('The account already exists for that email.');
        }
      } catch (e) {
        throw Exception(e.toString());
      }}
    else{

      throw Exception("username is already used");
    }
  }
  //function to check if the username is unique or not
  Future<void> createUser(user new_user)async
  {
    try{

      await _firestore
          .collection("user")
          .doc(new_user.user_id)
          .set(new_user.toDocument());
    }
    catch(e){
      throw Exception(e.toString());
    }

  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await _firestore.collection('user').doc(result.user?.uid ?? '').get();


      if (documentSnapshot.exists) {

        this.current_user= user.fromSnapshot(documentSnapshot);
      }


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
      else{
        throw Exception(e.toString());
      }
    }
  }
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }


}