import 'package:cloud_firestore/cloud_firestore.dart';

import '../../enum/user_level_enum.dart';

class user{
 final  String user_name;
 String? level;
  final DateTime age;
  String? user_id;
  List<String>? rounds;


  user({required this.user_name,required this.level,required this.age, this.user_id,this.rounds});

 Map<String, dynamic> toDocument() {
  return {
   "age":this.age,
   "user_name":this.user_name,
   "level":level,
   "user_id":this.user_id,
   "my_rounds":rounds,
  };
 }

 factory user.fromSnapshot( DocumentSnapshot<Map<String, dynamic>> snap) {

  return user(
  age: DateTime.parse(snap[ "age"].toDate().toString()),
   user_name: snap["user_name"],
   level:snap["level"],
   user_id:snap["user_id"],
  // rounds:List<String>.from(snap["my_rounds"]),
  );
 }










}