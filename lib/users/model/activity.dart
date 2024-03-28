import 'package:flutter/foundation.dart';

class Activity{
  int activity_id;
  String activity_name;
  String activity_place;
  String activity_time;
  String activity_holder;

  Activity(
      this.activity_id,
      this.activity_name,
      this.activity_place,
      this.activity_time,
      this.activity_holder,
      );

  Map<String,dynamic> toJson()=>{
    'activity_id':activity_id.toString(),
    'activity_name':activity_name,
    'activity_place':activity_place,
    'activity_time':activity_time,
    'activity_holder':activity_holder,
  };

  factory Activity.fromJson(Map<String,dynamic> json)=>Activity(
    int.parse(json["activity_id"]),
    json["activity_name"],
    json["activity_place"],
    json["activity_time"],
    json["activity_holder"]
  );
}