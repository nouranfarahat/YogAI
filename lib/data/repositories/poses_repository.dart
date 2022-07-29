import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/pose.dart';
class poses_repository{
  final _firestore=FirebaseFirestore.instance;
  final _fireStorage=FirebaseStorage.instance;
    late final List<Pose> poses;
     //method to get poses data from firestore
  void setPosesUrl()//set the downloadUrl for each pose
  {
    for(int i=0;i<poses.length;i++)
    {
      this.poses[i].pose_Storage_url= loadImage(poses[i].pose_img_url);
    }
  }
  Future<void> getPose_by_id(String pose_id,Pose p)async
  {
    final documentSnapshot =
    await _firestore.collection('poses').doc(pose_id).get();


    if (documentSnapshot.exists) {

       p= Pose.fromSnapshot(documentSnapshot);

      p.pose_Storage_url=loadImage(p.pose_img_url);


      // return poses;
    }
    else{
      throw Exception('failed load poses');
    }







  }
  Future<void> getPoses()async
  {
    final documentSnapshot =
    await _firestore.collection('poses').get();


    if (documentSnapshot.size>=0) {

      this.poses=await documentSnapshot.docs.map((doc)=>Pose.fromSnapshot(doc)).toList();

      setPosesUrl();

     // return poses;
    }
    else{
      throw Exception('failed load poses');
    }

  }
  Future<void> setPose(Pose pose)async
  {
  try {

    await  _firestore.collection('poses') .add(pose.toDocument());

  }
  catch(e)
    {
    throw Exception('failed upload poses');
    }
  }
Future<void> addPoses(List<Pose> poses )async
{
  try {
for(int i=0;i<poses.length;i++)
  {
    await setPose(poses[i]);
  }

}
catch(e)
  {
    throw Exception(e.toString());
  }
}

  static Future<String> loadImage(String img_url1)async {

    try{
      final String url= await FirebaseStorage.instance.ref("/poses_imgs").child(img_url1).getDownloadURL();
      return url;
    }
    catch(e){
      throw Exception(e.toString());
    }

  }


















}