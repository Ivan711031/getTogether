import 'package:flutter/material.dart';
import 'package:with_database/users/fragments/speech_recognition_page.dart';
import 'activity_page.dart';
import 'home_page.dart';
int _selectedIndex=0;

class DashboardOfFragments extends StatefulWidget {
  const DashboardOfFragments({ super.key });
  @override
  State<DashboardOfFragments> createState() => _DashboardOfFragmentsState();
}
class _DashboardOfFragmentsState extends State<DashboardOfFragments> {
  @override
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    ActivityPage(),
    SpeechRecognitionPage(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主畫面',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: '活動',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_outlined),
            label: '開團',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        backgroundColor: Colors.brown[100],
      ),


    );
  }
}
