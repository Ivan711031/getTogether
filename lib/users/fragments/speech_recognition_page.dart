import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:with_database/api/STT.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/users/model/activity.dart';
import 'package:with_database/api_connection/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:with_database/users/fragments/home_page.dart';
class SpeechRecognitionPage extends StatefulWidget {
  const SpeechRecognitionPage({Key? key}) : super(key: key);

  @override
  State<SpeechRecognitionPage> createState() => _SpeechRecognitionPageState();
}
class TextFieldAndCheckPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TextFieldAndCheckPageState();
}

class TextFieldAndCheckPageState extends State<TextFieldAndCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text('输入和选择'),
    ),body:TextField(),
    );
  }
}

class _SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  bool isLoadedModelList = false;
  List<String> modelList = [];
  bool isRecord = false;
  String speechRecognitionAudioPath = "";
  String nersentence ="";
  bool isNeedSendSpeechRecognition = false;
  String base64String = "";
  var formKey=GlobalKey<FormState>();
  var placeController =TextEditingController();
  var timeController = TextEditingController();
  var activityController =TextEditingController();
  var totalPeopleController =TextEditingController();
  var actualPlaceController =TextEditingController();
  var attentionController=TextEditingController();
  var nerInformation ='';
  DateTime dateTime = DateTime.now();
  createActivity()async{
    Activity activityModel=Activity(
        1,
        activityController.text.trim(),
        placeController.text.trim(),
        dateTime.toString().substring(0,10),
        myName,
        totalPeopleController.text.trim(),
        actualPlaceController.text.trim(),
        attentionController.text.trim()
    );
    try{
      var res=await http.post(
        Uri.parse(API.createActivity),
        body: activityModel.toJson(),
      );
      if(res.statusCode==200){
        var resBodyOfSignUp= jsonDecode(res.body);
        if(resBodyOfSignUp['success']==true){
          Fluttertoast.showToast(msg: '發起成功!');
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

  Future<String> getNer(String body) {
    return _getNer(
      Uri.parse('http://140.116.245.157:2001'),
      body,
    );
  }

  Future<String> _getNer(
      Uri url,
      String body,
      ) async {
    try {
      final response = await http.post(
        url,
        body: {"data":body, "token":'XXX'},
      );
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        print(decodedData);
        nerInformation='';
        for(int i=0;i<decodedData['ner'][0].length;i++){
          if(decodedData['ner'][0][i][2]=='LOC'){
            print('地點:'+decodedData['ner'][0][i][3]);
            nerInformation='地點 :'+'${decodedData['ner'][0][i][3]}\n';
          }
        }
        for(int i=0;i<decodedData['ner'][0].length;i++) {
          if (decodedData['ner'][0][i][2] == 'DATE') {
            print('時間:' + decodedData['ner'][0][i][3]);
            nerInformation+='時間 :'+'${decodedData['ner'][0][i][3]}';
          }
        }
        return decodedData;
      } else {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }



  List<String> items = [
    "華語",
    "台語",
    "華台雙語",
    "客語",
    "英語",
    "印尼語",
    "粵語"
  ];
  String selectedLanguage = "華語";
  AudioEncoder encoder = AudioEncoder.wav;

  Future<String> askForService(String base64String, String model) {
    return STTClient().askForService(base64String, model);
  }

  @override
  void initState() {
    super.initState();
    //********* 根據設備決定錄音的encoder *********//
    if (Platform.isIOS) {
      encoder = AudioEncoder.pcm16bit;
    } else {
      encoder = AudioEncoder.wav;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "逗陣來揪團",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.orange[100],
          centerTitle: true,
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30,30,30,8),
                child: Column(
                  children: [
                    Form(
                      key:formKey,
                      child: Column(
                        children: [
                          Row(
                            children:[
                              SizedBox(
                                width: 175,
                                child:TextFormField(
                                  controller: placeController,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.place
                                      ),
                                      hintText:"  地點",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true
                                  ),

                                ),
                              ),
                              SizedBox(
                                width: 175,
                                child:TextFormField(
                                  controller: activityController,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.directions_walk
                                      ),
                                      hintText:"  活動(例如:爬山、賞雪)",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.white60
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true
                                  ),

                                ),
                              ),
                            ]
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              SizedBox(
                                width: 175,
                                child:TextFormField(
                                  controller: totalPeopleController,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.directions_walk
                                      ),
                                      hintText:"  預計人數",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 175,
                                child:TextFormField(
                                  controller: actualPlaceController,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.directions_walk
                                      ),
                                      hintText:"  集合地址",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.black12
                                          )
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true
                                  ),

                                ),
                              ),
                            ]
                          ),
                          const SizedBox(height:30),
                          TextFormField(
                            controller: attentionController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                    Icons.directions_walk
                                ),
                                hintText:"  備註",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12
                                    )
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12
                                    )
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6
                                ),
                                fillColor: Colors.white,
                                filled: true
                            ),
                          ),
                          SizedBox(height: 30,),
                          SizedBox(
                              height: 50,
                              width:1000,
                              child:ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white
                                ),
                                onPressed: () {
                                  DatePicker.showDatePicker(context, showTitleActions: true, onConfirm: (date) {
                                    setState(() {
                                      dateTime = date;
                                    });
                                  }, currentTime: dateTime, locale:LocaleType.zh);
                                  print(dateTime.toString());
                                },
                                icon:const Icon(Icons.calendar_month,),
                                label:Text(DateFormat("yyyy-MM-dd").format(dateTime)),
                              )
                          ),
                          const SizedBox(height:30),
                          Material(
                            color: Colors.orange[200],
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: (){
                                createActivity();
                                setState(() {
                                  placeController.clear();
                                  timeController.clear();
                                  activityController.clear();
                                });

                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 10
                                ),
                                child: Text(
                                  '送出',
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),

                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],

                ),
              ),
            ),
            // 上半部
            Expanded(
            child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: (isNeedSendSpeechRecognition)
                      ? FutureBuilder(
                      future: askForService(base64String, selectedLanguage),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          // 請求失敗，顯示錯誤
                          print('askForService() 請求失敗');
                          isNeedSendSpeechRecognition = false;
                          return const Center(
                            child: Text(
                              '辨識失敗',
                              style: TextStyle(fontSize: 40),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // 請求成功，顯示資料
                          print('請求成功');
                          String sentence = snapshot.data.toString();
                          print(sentence);
                          //nersentence = sentence;
                          //getNer(nersentence);
                          isNeedSendSpeechRecognition = false;
                            return Text(
                              sentence,
                              style: const TextStyle(fontSize: 32),
                            );
                          } else {
                            // 請求未結束，顯示loading
                            print('辨識中...');
                            isNeedSendSpeechRecognition = false;
                            return const Center(
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator()),
                            );
                          }

                      })
                      :  SizedBox(height: 100,)
                ),
              ),
            ),

            // 下半部
            Center(
              child: Column(
                children: [
                  // 語音辨識
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        side: (isRecord == false)
                            ? const BorderSide(width: 5.0, color: Colors.orange)
                            : const BorderSide(width: 5.0, color: Colors.red),
                      ),
                      child: (isRecord == false)
                          ? const Icon(
                        Icons.mic,
                        size: 75,
                        color: Colors.orange,
                      )
                          : const Icon(
                        Icons.stop,
                        size: 75,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        debugPrint('Received click');
                        final record = Record();
                        if (isRecord == false) {
                          if (await record.hasPermission()) {
                            Directory tempDir = await getTemporaryDirectory();
                            speechRecognitionAudioPath =
                            '${tempDir.path}/record.wav';

                            await record.start(
                              numChannels: 1,
                              path: speechRecognitionAudioPath,
                              encoder: encoder,
                              bitRate: 128000,
                              samplingRate: 16000,
                            );
                            setState(() {
                              isRecord = true;
                              isNeedSendSpeechRecognition = false;
                            });
                          }
                        } else {
                          await record.stop();
                          var fileBytes = await File(speechRecognitionAudioPath)
                              .readAsBytes();

                          setState(() {
                            base64String = base64Encode(fileBytes);
                            isRecord = false;
                            isNeedSendSpeechRecognition = true;
                          });
                        }
                      },
                    ),
                  ),
                  DropdownButton(
                    value: selectedLanguage,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                    items: items.map((String item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}