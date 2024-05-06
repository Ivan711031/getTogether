import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/users/model/order.dart';
import '../../api_connection/api_connection.dart';

class ActivityInformationPage extends StatelessWidget {
  const ActivityInformationPage(
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
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("活動", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_name"],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("地點", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_place"],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("時間", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_time"],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("發起人", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(data["activity_holder"], style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("人數", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_current_people"]+"/"+data["activity_total_people"],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("集合地址", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_actual_place"],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("備註", style: TextStyle(fontSize: 30))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_attention"],
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child:Material(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(

                          onTap: (){
                            print(myID.runtimeType);
                            print(data["activity_id"].runtimeType);
                            currentPlus1();
                            joinActivity();
                          },
                          child: const Padding(

                            padding: EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 10
                            ),
                            child: Text(
                              '參團',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25
                              ),
                            ),

                          ),
                        ),
                      )
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}