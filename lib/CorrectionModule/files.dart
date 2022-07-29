class files
{
  Map ranges_files = new Map();
  static get_rangesFile(String pose_name)
  {
    String ranges="";
    //string1.toLowerCase().contains(string2.toLowerCase())
    if("tree-l".toLowerCase().contains(pose_name.toLowerCase()))
    //if("tree-l" == pose_name)
    {
    //|left_knee, 313.34, 344.5, 31.16
      ranges = """right_knee, 172, 186
|left_knee, 34, 50
|spine, 190, 207
|split, 77, 95
""";
    }
    else if(pose_name == "warrior 1")
    {
      ranges ="""right_knee, 91.15, 127.04
|left_knee, 154.03, 180.31
|left_shoulder, 151.03, 189.8
|right_shoulder, 148.28, 200.78
|split, 211.61, 265.74, 54.13
|right_elbow, 130.27, 171.49
|left_elbow, 148.54, 167.58
""";

    }
    else if("warrior 2" == pose_name)
    {
      //|left_knee, 313.34, 344.5, 31.16
      ranges = """right_knee, 230, 250 
|left_knee, 170, 180 
|left_shoulder, 70, 85
|right_shoulder, 255, 265
|split, 100, 120
|right_elbow, 180, 200
|left_elbow, 165, 185 
""";
    }
    else if(pose_name == "chair")
    {
      //|left_knee, 313.34, 344.5, 31.16
      ranges = """right_knee, 254, 297 
|left_knee, 260, 297 
|left_shoulder, 176, 195
|right_shoulder, 176, 190
|right_elbow, 181, 200
|left_elbow, 181, 197 
""";
    }
    else if(pose_name == "triangle")
    {
      ranges ="""right_knee, 166, 183
|left_knee, 158, 180
|left_shoulder, 239, 276
|right_shoulder, 89, 113
|split, 264, 290
|right_elbow, 165, 177
|left_elbow, 184, 200
|outer_hip, 50, 61
""";

    }
    else if(pose_name == "boat")
    {
      ranges = """right_knee, 254, 297 
|left_knee, 166, 185
|left_shoulder, 159, 180
|right_shoulder, 53, 90
|right_elbow, 142, 184
|left_elbow, 150, 183 
|spine, 42, 79
""";

    }//1
    else if(pose_name == "bridge")
    {
      ranges = """right_knee, 273, 295 
|left_knee, 274, 298
|left_shoulder, 30, 45
|right_shoulder, 32, 47
|right_elbow, 169, 186
|left_elbow, 166, 183 
|spine, 196, 220
""";

    }//2
    else if(pose_name == "bow")
    {
      ranges = """right_knee, 64, 102
|left_knee, 67, 104
|left_shoulder, 288, 311
|right_shoulder, 289, 313
|right_elbow, 179, 211
|left_elbow, 178, 203 
|spine, 90, 131
""";

    }//3
    else if(pose_name == "downward dog")
    {
      ranges ="""right_knee, 166, 193
|left_knee, 165, 195
|left_shoulder, 160, 186
|right_shoulder, 159, 187
|split, 350, 359
|right_elbow, 152, 181
|left_elbow, 157, 174
""";

    }//4
    else if(pose_name == "plank")
    {
      ranges = """right_knee, 156, 183
|left_knee, 173, 185
|left_shoulder, 67, 97
|right_shoulder, 67, 91
|right_elbow, 174, 183
|left_elbow, 171, 180
|spine, 145, 172
""";

    }//5
    else if(pose_name == "cobra")
    {
      ranges = """right_knee, 177, 190
|left_knee, 177, 193
|left_shoulder, 300, 333
|right_shoulder, 313, 342
|right_elbow, 173, 193
|left_elbow, 163, 190
|spine, 163, 190
""";

    }//6
    else if(pose_name == "upward plank")
    {
      ranges = """right_knee, 177, 188
|left_knee, 176, 18
|left_shoulder, 61, 85
|right_shoulder, 59, 82
|right_elbow, 165, 186
|left_elbow, 164, 190
|spine, 162, 190
""";

    }//7
    return ranges;
  }
}