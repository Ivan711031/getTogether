import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/users/fragments/map_page.dart';
import 'package:with_database/users/model/order.dart';
import '../../api/TTS.dart';
import '../../api_connection/api_connection.dart';
import 'package:with_database/users/fragments/small_speech.dart';

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
      height: 180,
      fit: BoxFit.cover,
    );
  }
}


int a =1;



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
//
class NewActivityInformationPage extends StatefulWidget {
  const NewActivityInformationPage({Key? key,required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<NewActivityInformationPage> createState() => _NewActivityInformationPageState(data:this.data);
}
//
class _NewActivityInformationPageState extends State<NewActivityInformationPage> {

  final Map<String, dynamic> data;
  _NewActivityInformationPageState({required this.data});

  gotoMap()async{
    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address='+data['activity_place']+'&key=AIzaSyC_G7mh74MvW-NwaAFBb-l3Qrx3m5f8R-w');
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        print(decodedData);
        print(decodedData['results'][0]['geometry']['location']['lat']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MapPage(
                    lat:decodedData['results'][0]['geometry']['location']['lat'],
                    lng:decodedData['results'][0]['geometry']['location']['lng']
                ),
          ),
        );

      } else {
        Fluttertoast.showToast(msg: '發生錯誤，再試一次!');
      }
    } catch (e) {
      print(e.toString());
    }

  }

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
          print('');
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

          //ImageSection(image: 'assets/陽明山.jpg'),
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
                          onPressed: () {
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
                            fontSize: 14,
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
                      SpeechSynthesisPage(data:data),
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
                ),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            gotoMap();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         MapPage(),
                            //   ),
                            // );
                          },
                          icon: const Icon(Icons.map)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '地圖',
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
          SizedBox(height: 10,),
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