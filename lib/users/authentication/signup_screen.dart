import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:with_database/api_connection/api_connection.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:http/http.dart'as http;
import 'package:with_database/users/model/user.dart';

class  SignUpScreen extends StatefulWidget
{

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey=GlobalKey<FormState>();
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var isObsecure =true.obs;

  validateUserEmail()async{
    try{
      var res=await http.post(
        Uri.parse(API.validateEmail),
        body:{
          'user_email':emailController.text.trim(),
        }
      );
      if(res.statusCode==200){
        var resBodyOfValidateEmail= jsonDecode(res.body);
        print(resBodyOfValidateEmail);
        if(resBodyOfValidateEmail['emailFound']){
          Fluttertoast.showToast(msg: '這個帳號有人用過了');
        }
        else{
          registerAndSaveUserRecord();


        }
      }
    }
    catch(e)
    {
      print(e.toString());

    }

  }
  registerAndSaveUserRecord()async{
    User userModel=User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim()
    );
    try{
      var res=await http.post(
        Uri.parse(API.signup),
        body: userModel.toJson(),
      );
      if(res.statusCode==200){
        var resBodyOfSignUp= jsonDecode(res.body);
        if(resBodyOfSignUp['success']==true){
          Fluttertoast.showToast(msg: '註冊成功!');
          Get.to(LoginScreen());
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
                      height: 248,
                      child: Image.asset("assets/signup.jpeg"),

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
                                key:formKey,
                                child: Column(
                                  children: [
                                    //name
                                    TextFormField(
                                      controller: nameController,
                                      validator: (val) =>val== ""?"請填寫姓名":null,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                              Icons.person
                                          ),
                                          hintText:"  姓名",
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
                                    const SizedBox(height: 30,),
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
                                          if(formKey.currentState!.validate()){
                                            validateUserEmail();
                                          }

                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 28,
                                              vertical: 10
                                          ),
                                          child: Text("註冊"),
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
                                  const Text("有帳號了?"),
                                  TextButton(
                                      onPressed: (){
                                        Get.to(LoginScreen());

                                      },
                                      child: const Text(
                                        "登入",
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
