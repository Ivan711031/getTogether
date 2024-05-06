import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/users/model/order.dart';
import '../../api_connection/api_connection.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.current,
    required this.total
  });

  final String name;
  final String location;
  final String current;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32,right: 32,top: 32,bottom: 32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 25
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Text(
            "人數: "+current+'/'+total,
            style: TextStyle(fontSize: 20),
          ),

        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}






class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32,right: 32,top: 20,bottom: 2),
      child: Text(
        description,
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class NewActivityInformationPage extends StatelessWidget {
  const NewActivityInformationPage(
      {Key? key, required this.data})
      : super(key: key);

  final Map<String, dynamic> data;

  joinActivity()async{
    Order orderModel=Order(
        myID,
        data["activity_id"]
    );
    try{
      var res=await http.post(
        Uri.parse(API.order),
        body: orderModel.toJson(),
      );
      if(res.statusCode==200){
        var resBodyOfSignUp= jsonDecode(res.body);
        if(resBodyOfSignUp['success']==true){
          Fluttertoast.showToast(msg: '參加成功');
          print(myName);

        }
        else{
          Fluttertoast.showToast(msg: '發生錯誤，再試一次!');
        }
      }
    }
    catch(e){
      print(e.toString());

    }

  }
  currentPlus1()async{
    Order orderModel=Order(
        myID,
        data["activity_id"]
    );
    try{
      var res=await http.post(
        Uri.parse(API.currentPlus),
        body: orderModel.toJson(),
      );
      if(res.statusCode==200){
        var resBodyOfSignUp= jsonDecode(res.body);
        if(resBodyOfSignUp['success']==true){
          Fluttertoast.showToast(msg: '挖草!');
          print(myName);

        }
        else{
          Fluttertoast.showToast(msg: '發生錯誤，再試一次!');
        }
      }
    }
    catch(e){
      print(e.toString());
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[200],
          foregroundColor: Colors.black,
          title: Text("活動資訊"),
          centerTitle: true,
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //ImageSection(image: 'assets/login2.jpeg'),
          TitleSection(name: data['activity_place'],location: data['activity_name'],current:data['activity_current_people'],total: data['activity_total_people'],),

          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){
                            currentPlus1();
                            joinActivity();
                          },
                          icon: const Icon(Icons.add_box_rounded)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '參加活動',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]
                ),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){

                          },
                          icon: const Icon(Icons.volume_up_rounded)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '活動內容',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ]
                )
              ],
            )
          ),
          TextSection(description:
          data["activity_time"]
          ),
          TextSection(description:
          "主辦人:"+data["activity_holder"]
          ),
          TextSection(description:
          '集合地址: '+data["activity_actual_place"]
          ),
          TextSection(description:
          '備註: '+data["activity_attention"]
          ),

        ],
      )
    );
  }
}