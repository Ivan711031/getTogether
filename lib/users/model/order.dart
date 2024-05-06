class Order{
  int user_id;
  String activity_id;

  Order(
      this.user_id,
      this.activity_id
      );

  Map<String,dynamic> toJson()=>{
    'user_id':user_id.toString(),
    'activity_id':activity_id,
  };

  factory Order.fromJson(Map<String,dynamic> json)=>Order(
    int.parse(json["user_id"]),
    json["activity_id"],
  );
}