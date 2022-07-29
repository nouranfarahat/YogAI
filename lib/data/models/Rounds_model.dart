import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoga_ai/data/models/pose.dart';
import 'package:yoga_ai/data/repositories/poses_repository.dart';

import 'Round_specs.dart';
class Round {

  late final List<Pose> round_poses=[];
final Round_specs round_specs;
  Round(
      {required this.round_specs, });

void get_round_poses(List<Pose> p){
  for(int j=0;j<this.round_specs.round_poses_id.length;j++)
  {
  for(int i=0;i<p.length;i++)
  {
if(p[i].pose_id==this.round_specs.round_poses_id[j])
  {
    this.round_poses.add(p[i]);
  }
  }


  }
}

}

