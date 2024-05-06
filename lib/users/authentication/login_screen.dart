import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:with_database/users/authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/fragments/dashboard_of_fragments.dart';
import 'package:with_database/users/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:with_database/users/userPreferences/user_preferences.dart';
var myName='';
var myEmail='';
int myID=0;
List myInfo=[];
class  LoginScreen extends StatefulWidget
{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formkey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var isObsecure =true.obs;

  loginUserNow()async{
    try{
      var res=await http.post(
        Uri.parse(API.login),
        body: {
          "user_email":emailController.text.trim(),
          "user_password":passwordController.text.trim(),
        },
      );
      if(res.statusCode==200){
        var resBodyOfLogin= jsonDecode(res.body);
        if(resBodyOfLogin['success']==true){
          Fluttertoast.showToast(msg: '登入成功!');
          User userInfo=User.fromJson(resBodyOfLogin['userData']);
          await RememberUserPrefs.saveRememberUser(userInfo);
          myName=userInfo.user_name;
          myID=userInfo.user_id;

          //print(myName);
          Get.to(DashboardOfFragments());


        }
        else{
          Fluttertoast.showToast(msg: '請填寫正確的帳號或密碼');
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
      backgroundColor: Colors.orange[100],
      body: LayoutBuilder(
        builder: (context, cons){
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width:MediaQuery.of(context).size.width,
                    height: 275,
                    child: Image.asset("assets/login2.jpeg"),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,8),
                    child: Container(
                      decoration: BoxDecoration(
                        color:Colors.orange[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.white,
                            offset: Offset(0,0)
                          )
                        ],

                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30,30,30,8),
                        child: Column(
                          children: [
                            Form(
                              key:formkey,
                              child: Column(
                                children: [
                                  //email
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) =>val== ""?"請填寫信箱":null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email
                                      ),
                                      hintText:"  帳號",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60
                                        )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.white60
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.white60
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                              color: Colors.white60
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

                                  const SizedBox(height: 30),

                                  //password
                                  Obx(
                                      ()=>TextFormField(
                                        controller: passwordController,
                                        obscureText:isObsecure.value,
                                        validator: (val) =>val== ""?"請填寫密碼":null,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.vpn_key_sharp
                                            ),
                                            suffixIcon: Obx(
                                                    ()=>GestureDetector(
                                                  onTap: (){
                                                    isObsecure.value=!isObsecure.value;
                                                  },
                                                  child: Icon(
                                                      isObsecure.value? Icons.visibility_off :Icons.visibility
                                                  ),
                                                )
                                            ),
                                            hintText:"  密碼",
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.white60
                                                )
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 6
                                            ),
                                            fillColor: Colors.white,
                                            filled: true
                                        ),


                                      )
                                  ),
                                  const SizedBox(height: 30,),

                                  Material(
                                    color:Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formkey.currentState!.validate()) {
                                          loginUserNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 10
                                        ),
                                        child: Text("登入"),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("還沒有帳號?"),
                                TextButton(
                                    onPressed: (){
                                      Get.to(SignUpScreen());
                                    },
                                    child: const Text(
                                      "註冊",
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontSize: 16
                                      ),
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )

    );
  }
}
