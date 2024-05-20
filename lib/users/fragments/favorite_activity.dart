import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/activity_page.dart';

import 'new_activity_information.dart';
class FavoriteActivityPage extends StatefulWidget {
  const FavoriteActivityPage({Key? key}) : super(key: key);

  @override
  State<FavoriteActivityPage> createState() => _FavoriteActivityPageState();
}

class _FavoriteActivityPageState extends State<FavoriteActivityPage> {
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
            leading: new IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back)
            ),
            title: Text('有興趣的活動'),
            backgroundColor: Colors.orange[100],
            centerTitle: true,
          ),
          body:FutureBuilder(
            future: getActivity(),
            builder: (context,snapshot){
              if (snapshot.hasError){
                print("snapshot.error");
              }

              return snapshot.hasData? GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: favoriteActivity.length,
                itemBuilder: (context,index){
                  List list =snapshot.data;
                  List cool =[];
                  for(int i=0;i<favoriteActivity.length;i++){
                    for(int j=0;j<list.length;j++) {
                      if (favoriteActivity[i] == list[j]["activity_id"]){
                        cool.add(snapshot.data[j]);
                      }
                    }
                  }
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewActivityInformationPage(data: cool[index],),
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
                                              cool[index]['activity_id'])) {
                                            favoriteActivity.remove(
                                                cool[index]['activity_id']);
                                          } else {
                                            favoriteActivity
                                                .add(
                                                cool[index]['activity_id']);
                                          }
                                          debugPrint(
                                              favoriteActivity.toString());
                                        });
                                      },
                                      icon: (favoriteActivity.contains(
                                          cool[index]['activity_id']) ==
                                          true)
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border)),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        cool[index]["activity_place"],
                                        style:TextStyle(fontSize: 20),
                                      ),

                                      subtitle: Text(
                                        cool[index]["activity_name"],
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
              ) :const Center(child: CircularProgressIndicator(),);
            } ,
          )
      ),
    );
  }
}