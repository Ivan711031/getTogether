import 'package:flutter/material.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:with_database/users/fragments/user_profile.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ilovetogether'),
          backgroundColor: Colors.orange[100],
          centerTitle: true,
          actions: [
            IconButton(
                onPressed:(){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage())
                  );

                },
                icon: Icon(Icons.person)
            )
          ],
        ),
      ),
    );
  }
}