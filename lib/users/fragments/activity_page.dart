import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/activity_information.dart';
import 'package:with_database/users/fragments/favorite_activity.dart';
List<String> favoriteActivity=[];
class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String keyWord="";
  Future<dynamic> getActivity()async{
    var url = Uri.parse(API.showActivity);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
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

                  return ListView.builder(
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
                            color: Colors.blue[50],
                            child: Row(
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
                                    title: Text(list[index]["activity_place"]),
                                    subtitle: Text(
                                        list[index]["activity_name"]),
                                  ),
                                )
                              ],
                            ),
                          )
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
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


