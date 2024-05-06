import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:with_database/users/fragments/user_profile.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/activity_information.dart';
import 'package:with_database/users/fragments/favorite_activity.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Future<dynamic> getActivity()async{
    var url = Uri.parse(API.timeActivity);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        //print(decodedData.length);
        //print(decodedData[0]);
        //print(decodedData.runtimeType);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }

  Future<dynamic> getJoinedActivity()async{
    var url = Uri.parse(API.timeActivity);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        print(decodedData.length);
        print(decodedData);
        print(decodedData.runtimeType);
        return cool(decodedData);
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }

  cool(List nice)async{
    var url1=Uri.parse(API.joinedActivity);

    try{
      var res=await http.post(
        url1,
        body: {
          "user_id":myID.toString(),
        },
      );
      if(res.statusCode==200){
        var resBodyOfLogin= jsonDecode(res.body);
        List fuck=resBodyOfLogin;
          print(resBodyOfLogin[0]['activity_id']);
          //print(fuck[6]['activity_name']);
          for(int i =0;i<resBodyOfLogin.length;i++){
            for(int j=0;j<nice.length;j++){
              if(resBodyOfLogin[i]['activity_id']==nice[j]['activity_id']) {
                fuck[i] = nice[j];
              }
            }
          }
          print (fuck);
          return fuck;

      }
    }
    catch(e){
      print(e.toString());
    }
  }
  List<MaterialColor> colorizeColors = [
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 40.0,
    fontFamily: 'SF',
  );


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('作伙來出遊'),
          backgroundColor: Colors.orange[100],
          centerTitle: true,
          actions: [
            IconButton(
                onPressed:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage())
                  );

                },
                icon: Icon(
                  Icons.person,
                  size: 50,
                )
            )
          ],
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        '最近活動',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        '最近活動',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        '最近活動',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 200,
                child:FutureBuilder(
                    future: getActivity(),
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        List list = snapshot.data;

                        return GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ActivityInformationPage(
                                            data: list[index],
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                    elevation: 10,
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.orange[50],
                                    child:Column(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 108,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20)
                                              )
                                          ),
                                          child: Image.asset(
                                            'assets/play_store_512.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  list[index]["activity_place"],
                                                  style:TextStyle(fontSize: 20),
                                                ),

                                                subtitle: Text(
                                                  list[index]["activity_name"],
                                                  style:TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                      ],
                                    )
                                )
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Center(
                            child:CircularProgressIndicator()
                        );
                      }
                    }
                )
              ),


            SizedBox(
              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      '參加的團',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      '參加的團',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                    ColorizeAnimatedText(
                      '參加的團',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
            ),



        SizedBox(
                height: 200,
                child:FutureBuilder(
                    future: getJoinedActivity(),
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        List list = snapshot.data;
                        //print(snapshot.runtimeType);
                        //print(list.runtimeType);
                        return GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ActivityInformationPage(
                                            data: list[index],
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    elevation: 10,
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.orange[50],
                                    child:Column(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 108,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)
                                            )
                                          ),
                                          child: Image.asset(
                                            'assets/play_store_512.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  list[index]["activity_place"],
                                                  style:TextStyle(fontSize: 20),
                                                ),

                                                subtitle: Text(
                                                  list[index]["activity_name"],
                                                  style:TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                      ],
                                    )
                                )
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Center(
                            child:SizedBox(height: 10,)
                        );
                      }
                    }
                )
            ),
            SizedBox(height: 30,),
            Image.asset("assets/長輩扁.jpg")

          ],
        ),
      ),
    );
  }
}