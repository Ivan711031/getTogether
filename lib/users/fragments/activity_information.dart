import 'package:flutter/material.dart';

class ActivityInformationPage extends StatelessWidget {
  const ActivityInformationPage(
      {Key? key, required this.data})
      : super(key: key);

  final Map<String, dynamic> data;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[200],
        foregroundColor: Colors.black,
        title: Text("活動資訊"),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("活動", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_name"],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("地點", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_place"],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("時間", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["activity_time"],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text("發起人", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(data["activity_holder"], style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),

                  ],
                )),
          ),
        ],
      ),
    );
  }
}