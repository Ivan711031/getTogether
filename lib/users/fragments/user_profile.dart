import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:with_database/users/userPreferences/current_user.dart';

class UserProfilePage extends StatelessWidget {

  final CurrentUser _currentUser=Get.put(CurrentUser());
  Widget userInformation(IconData iconData,String userData){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange[100],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color:Colors.black,
          ),
          const SizedBox(width: 16,),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
            ),

          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[200],
          foregroundColor: Colors.black,
          title: Text("使用者資訊"),
      ),
        body:ListView(
          children: [
            SizedBox(height: 30,),
            userInformation(Icons.person, _currentUser.user.user_name),
            SizedBox(height: 30,),
            userInformation(Icons.mail, _currentUser.user.user_email)

          ],
        )
    );

  }
}