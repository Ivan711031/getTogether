import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/activity_information.dart';
import 'package:with_database/users/fragments/favorite_activity.dart';
import 'package:with_database/users/fragments/home_page.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:with_database/users/fragments/small_speech.dart';

import 'new_activity_information.dart';
List<String> favoriteActivity=[];
class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String keyWord="";
  Future<dynamic> getActivity()async{
    var url = Uri.parse(API.timeActivity);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        print(decodedData);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }

  getJoinedActivity()async{
    var url1=Uri.parse(API.joinedActivity);
    var url2=Uri.parse(API.showActivity);
    try{
      var res=await http.post(
        url1,
        body: {
          "user_id":myID.toString(),
        },
      );
      if(res.statusCode==200){
        var resBodyOfLogin= jsonDecode(res.body);
        if(resBodyOfLogin['success']==true){
          print(resBodyOfLogin);
        }
        else{
        }
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('活動列表'),
          backgroundColor: Colors.orange[100],
          centerTitle: true,
          actions: [
            IconButton(
                onPressed:(){
                  getJoinedActivity();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoriteActivityPage())
                  );
                },
                icon: Icon(Icons.favorite)
            )
          ],
        ),
        body:Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      keyWord = value;
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        // 刷新
                      });
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child:FutureBuilder(
              future: getActivity(),
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  List list = snapshot.data;

                  // 判斷是否有點擊搜尋
                  List<dynamic> newData = [];
                  if (keyWord != "") {
                    for (int i = 0; i < list.length; i++) {
                      if (list[i]['activity_name'].contains(keyWord)) {
                        newData.add(list[i]);
                      }
                      if (list[i]['activity_place'].contains(keyWord)) {
                        newData.add(list[i]);
                      }
                    }
                    list = newData;
                  }

                  return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewActivityInformationPage(data: list[index],),
                                //SpeechSynthesisPage(yoyo:'我超酷')
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
                                    'assets/風景2.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (favoriteActivity.contains(
                                                list[index]['activity_id'])) {
                                              favoriteActivity.remove(
                                                  list[index]['activity_id']);
                                            } else {
                                              favoriteActivity
                                                  .add(
                                                  list[index]['activity_id']);
                                            }
                                            debugPrint(
                                                favoriteActivity.toString());
                                          });
                                        },
                                        icon: (favoriteActivity.contains(
                                            list[index]['activity_id']) ==
                                            true)
                                            ? Icon(Icons.favorite)
                                            : Icon(Icons.favorite_border)),
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
            )
          ]
        )
      ),
    );
  }
}


