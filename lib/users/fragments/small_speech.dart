import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../api/TTS.dart';

class SpeechSynthesisPage extends StatefulWidget {
  SpeechSynthesisPage({Key? key,required this.data}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<SpeechSynthesisPage> createState() => _SpeechSynthesisPageState(data:this.data);
}

class _SpeechSynthesisPageState extends State<SpeechSynthesisPage> {
  final Map<String, dynamic> data;
  _SpeechSynthesisPageState({required this.data});
  @override

  String sentence='安安你好';
  String language = "台語";
  List<String> items = ["國語", "台語", "客語", "英語", "印尼語"];
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    player.init();
  }

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      print("Playing");
      player.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.volume_up, size: 30),
        onPressed: () async {
          if (sentence.isEmpty) return;

          // 連接到文字轉語音服務器
          TTSClient client = TTSClient();
          await client.connect();

          // 發送語音合成請求，傳遞語言和句子內容
          client.send(language, '活動名稱 '+data['activity_name']+'活動地點 '+data['activity_place']+'集合地點 '+data['activity_actual_place']);

          // 等待接收服務器的回應
          String result = await client.receive();

          if (result.isEmpty) {
            debugPrint('合成失敗');
          } else {
            // 解析服務器回傳的 JSON 格式數據
            Map<String, dynamic> responseData = json.decode(result);

            // 檢查狀態是否正確且有合成的語音文件數據
            if (responseData['status'] != null &&
                responseData['status']) {
              List<int> resultBytes = base64.decode(responseData['bytes']);
              Directory tempDir = await getTemporaryDirectory();
              String speechSynthesisAudioPath = '${tempDir.path}/synthesis.wav';
              File outputFile = File(speechSynthesisAudioPath);

              // 將語音數據寫入文件
              await outputFile.writeAsBytes(resultBytes);
              debugPrint('File received complete');

              // 播放合成的語音文件
              play(speechSynthesisAudioPath);

            } else {
              debugPrint('合成失敗');
            }
          }
          client.close();
        });
  }
}