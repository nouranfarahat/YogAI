import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/Round_specs.dart';
import '../models/Rounds_model.dart';
import '../models/pose.dart';

class roundsRepository{


  final _firestore=FirebaseFirestore.instance;
  final _fireStorage=FirebaseStorage.instance;
   List<Round>?program_rounds;
  late final List<dynamic> program_focused_area_rounds;
  List<Round>?program_recommended_flow_rounds;



  var snaps;
  Future<void> get_program_Rounds(List<Pose>poses)async
  {
try{      snaps =
      await _firestore.collection('round').where("focused_area",isEqualTo:true ).get();
       this.program_focused_area_rounds=snaps.docs.map((doc)=>Round(round_specs:Round_specs.fromSnapshot(doc) )).toList();
          setRoundsImgsUrl(this.program_focused_area_rounds);
          for(int i=0;i<this.program_focused_area_rounds.length;i++)
            {
              this.program_focused_area_rounds[i].get_round_poses(poses);
            }
         // this.program_focused_area_rounds.map((round1)=>round1.get_round_poses(poses));
}
    catch(e)
    {
      throw Exception(e.toString());
    }
  }

  void setRoundsImgsUrl(List<dynamic>? round)//set the downloadUrl for each round image
  {
for(int i=0;i<round!.length;i++)
      {round[i].round_specs.round_storage_url= loadImage(round[i].round_specs.round_img_url);}

  }
  Future<Round_specs> getRound(String round_id)async
  {
    try {
      final documentSnapshot = await _firestore.collection('round').doc(
          round_id).get();
      return Round_specs.fromSnapshot(documentSnapshot);
    }
    catch(e)
    {
      throw Exception(e.toString());
    }


  }
  Future<void> addRound(Round_specs round_specs)async
  {
  try {

    await  _firestore.collection('round') .add(round_specs.toDocument());

  }
  catch(e)
  {
    throw Exception(e.toString());
  }
  }

  Future<void> delete_Round(String round_id)async
  {
    try {
      await  _firestore.collection('round') .doc(round_id).delete();
    }
    catch(e)
    {
      throw Exception(e.toString());
    }
  }

  static Future<String> loadImage(var img_url1)async {

    try{
      final String url= await FirebaseStorage.instance.ref("/rounds_imgs").child(img_url1).getDownloadURL();
      return url;
    }
    catch(e){
      throw Exception(e.toString());
    }

  }



















}