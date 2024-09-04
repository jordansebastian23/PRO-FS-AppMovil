import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //cambiar color icon del drawer
      surfaceTintColor: Colors.blue[900],
      child: ListView(
        //cambiar color al icon del drawer
        children: [
          ListTile(
            title: Text("Home"),
            onTap: () {
            }  
          ),
          ListTile(
            title: Text("About"),
            onTap: () {
            }
          )
        ]  
      )
    );
  }

}