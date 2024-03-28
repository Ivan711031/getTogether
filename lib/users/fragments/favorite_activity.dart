import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/activity_page.dart';
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

              return snapshot.hasData? ListView.builder(
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
                  return Card(
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        Expanded(
                          child:ListTile(
                            title: Text(cool[index]["activity_place"]),
                            subtitle: Text(cool[index]["activity_name"]),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ) :const Center(child: CircularProgressIndicator(),);
            } ,
          )
      ),
    );
  }
}