import 'package:flutter/foundation.dart';

class Activity{
  int activity_id;
  String activity_name;
  String activity_place;
  String activity_time;
  String activity_holder;
  String activity_total_people;
  String activity_actual_place;
  String activity_attention;

  Activity(
      this.activity_id,
      this.activity_name,
      this.activity_place,
      this.activity_time,
      this.activity_holder,
      this.activity_total_people,
      this.activity_actual_place,
      this.activity_attention
      );

  Map<String,dynamic> toJson()=>{
    'activity_id':activity_id.toString(),
    'activity_name':activity_name,
    'activity_place':activity_place,
    'activity_time':activity_time,
    'activity_holder':activity_holder,
    'activity_total_people':activity_total_people.toString(),
    'activity_actual_place':activity_actual_place,
    'activity_attention':activity_attention,
  };

  factory Activity.fromJson(Map<String,dynamic> json)=>Activity(
    int.parse(json["activity_id"]),
    json["activity_name"],
    json["activity_place"],
    json["activity_time"],
    json["activity_holder"],
    json["activity_total_people"],
    json["activity_actual_place"],
    json["activity_attention"]
  );
}