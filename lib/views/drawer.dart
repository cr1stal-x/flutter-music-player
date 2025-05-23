import 'package:flutter/material.dart';
import 'package:musix/views/contactUs_view.dart';
import 'package:musix/views/setting_view.dart';
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          DrawerHeader(child: Center(
            child: Icon(Icons.music_note, size: 50),
          )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: ListTile(
              title: Text('S E T T I N G'),
              leading: Icon(Icons.settings),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 20),
            child: ListTile(
              title: Text('C O N T A C T    U S'),
              leading: Icon(Icons.accessibility),
              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));},
            ),
          )
        ],
      )
      ,
    );
  }
}
