import 'dart:convert';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'dart:io';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'files.dart';


class PoseAngles
{
  files ?file ;
  var joints_map = {"left_shoulder": 0,"right_shoulder": 1,"left_elbow": 2,"right_elbow": 3,"left_wrist": 4,"right_wrist": 5,"left_hip": 6,"right_hip": 7,"left_knee": 8,"right_knee": 9,"left_ankle": 10,"right_ankle": 11,"thorax": 12,"pelvis": 13};
  var angles_calculation = new Map();///= {"tree_pose-l": {"a": [1,2]}};
  fill_angles_calculation_map() {
    /*angles_calculation["tree_pose-l"] = {"left_knee" : [joints_map["left_ankle"] , joints_map["left_knee"] , joints_map["left_hip"]] ,
                                          "right_knee":[joints_map["right_ankle"] , joints_map["right_knee"] , joints_map["right_hip"]],
                                          "split" : [joints_map["left_knee"] , joints_map["pelvis"] , joints_map["right_knee"]],
                                          "spine" : [joints_map["thorax"] , joints_map["pelvis"] , joints_map["right_knee"]]};*/
    angles_calculation["tree"] = {//-l
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "split": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["left_knee"]
      ],
      "spine": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["thorax"]
      ]
    };

    angles_calculation["downward dog"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "split": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["left_knee"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };

    angles_calculation["warrior 1"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "split": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["left_knee"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };


    angles_calculation["bridge"] = {//-r
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
      "spine": [
        joints_map["thorax"],
        joints_map["pelvis"],
        joints_map["right_knee"]
      ],
    };

    angles_calculation["bow"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "spine": [
        joints_map["thorax"],
        joints_map["pelvis"],
        joints_map["right_knee"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };

    angles_calculation["cobra"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "spine": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["thorax"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };


    angles_calculation["upward plank"] = {//-r
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "spine": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["thorax"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };

    angles_calculation["warrior 2"] = {//-r
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "split": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["left_knee"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };

    angles_calculation["triangle"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "split": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["left_knee"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
      "outer_hip": [
        joints_map["left_shoulder"],
        joints_map["left_hip"],
        joints_map["left_knee"]
      ]
    };

    angles_calculation["boat"] = {//-r
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
      "spine": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["thorax"]
      ],
    };
    angles_calculation["chair"] = {//-r
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
    };

    angles_calculation["plank"] = {//-l
      "right_knee": [
        joints_map["right_hip"],
        joints_map["right_knee"],
        joints_map["right_ankle"]
      ],
      "left_knee": [
        joints_map["left_hip"],
        joints_map["left_knee"],
        joints_map["left_ankle"]
      ],
      "left_shoulder": [
        joints_map["left_hip"],
        joints_map["left_shoulder"],
        joints_map["left_elbow"]
      ],
      "right_shoulder": [
        joints_map["right_hip"],
        joints_map["right_shoulder"],
        joints_map["right_elbow"]
      ],
      "right_elbow": [
        joints_map["right_wrist"],
        joints_map["right_elbow"],
        joints_map["right_shoulder"]
      ],
      "left_elbow": [
        joints_map["left_wrist"],
        joints_map["left_elbow"],
        joints_map["left_shoulder"]
      ],
      "spine": [
        joints_map["right_knee"],
        joints_map["pelvis"],
        joints_map["thorax"]
      ],
    };
  }
  Map  calculate_pose_angles(String pose_name , var user_vector)
  {
    fill_angles_calculation_map();
    Map angle_value_map = new Map();

    var pose_map = angles_calculation[pose_name];
    int num_of_angles = pose_map.length;
    pose_map.entries.forEach((joint_name) {
        //String joint_name= pose_map.entries[0].key;//left_knee
        var p1 = pose_map[joint_name.key][0];//left_ankle index
        double p1_x = user_vector[p1 * 2] ;
        double p1_y = user_vector[p1 * 2 + 1];
        var p2 = pose_map[joint_name.key][1];//left_knee index
        double p2_y = user_vector[p2 * 2 + 1];
        double p2_x = user_vector[p2 * 2] ;
        var p3 = pose_map[joint_name.key][2];//left_hip index
        double p3_x = user_vector[p3 * 2] ;
        double p3_y = user_vector[p3 * 2 + 1];

       // double result = atan2(p3_y - p1_y, p3_x - p1_x) - atan2(p2_y - p1_y, p2_x - p1_x);
        double result = atan2(p3_y - p2_y, p3_x - p2_x) - atan2(p1_y - p2_y, p1_x - p2_x);
        result = degrees(result);
        if (result < 0)
        {
          result = result + 360;
        }
        print(joint_name.key +"            user angle        " +result.toString());
        //print(joint_name.key + " : ");
        //print(result);
        angle_value_map[joint_name.key] = result;
      });
      return angle_value_map;
  }




  Map getRanges(String pose_name) {

    Map angleRanges_map = new Map();
    var data = files.get_rangesFile(pose_name);
    //LineSplitter ls = new LineSplitter();
    var lines = data.split('|');

    int file_sz = lines.length;

    for (int i = 0; i < file_sz; i++) {
      final splitted = lines[i].split(', ');
      angleRanges_map[splitted[0]] = Tuple2<double, double>(
          double.parse(splitted[1]), double.parse(splitted[2]));
    }

    return angleRanges_map;
  }
  List<dynamic> check_ranges(String pose_name , var user_vector)
  {
      dynamic  angle_value_map= calculate_pose_angles(pose_name, user_vector); //user angles
      var angleRanges_map = getRanges(pose_name); //right ranges
      int dummy =2;

      List<dynamic> wrong_joints =[];
      int cnt=0;
      for (var key in angleRanges_map.keys)
      {
        var user_angle = angle_value_map[key];
        var min = angleRanges_map[key].item1;
        var max = angleRanges_map[key].item2;
        if(!(user_angle              >= min && user_angle <= max))
          {
            cnt++;

            if((angles_calculation[pose_name][key][1] <12))
              {
                var wrong_joints_num = angles_calculation[pose_name][key][1];
                if(wrong_joints_num < 12)
                  wrong_joints.add(wrong_joints_num + 5);
              }
            //print("wrong joint :   " + wrong_joints.toString() +"      " /*+ wrong_joints_str*/);
          }

         /* if (joints_map.containsKey(key))
          {
            wrong_joints.add(joints_map[key]);
          }
          else
          {
            List<dynamic> sub_joints = angles_calculation[pose_name][key];
            for(int i=0;i<sub_joints.length;i++)
            {
              wrong_joints.add(sub_joints[i]);
            }

          }*/

        }


      return wrong_joints;
  }

}

