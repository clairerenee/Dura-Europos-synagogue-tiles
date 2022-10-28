import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomMenu({this.selectedIndex, required this.onClicked});
  static const List<Color> colors = [Colors.blue, Colors.red, Colors.green];
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.globe,
              //color: Colors.pink,
              // size: 24.0,
              // semanticLabel: 'Text to announce in accessibility modes',
            ),
            label: 'Global Saves',

          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.pencil_circle),
            label: 'Create',
          ),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle_fill,),
            label: 'My Saves',
          ),
          
        ],
        currentIndex: selectedIndex,
        onTap: onClicked,
        selectedItemColor: colors[selectedIndex],
      );
  }
}
//https://stackoverflow.com/questions/66739156/how-to-use-bottomnavigationbar-in-a-separate-file