import 'package:flutter/material.dart';
import 'package:musix/theme/blue_theme.dart';
import 'package:musix/theme/green_theme.dart';
import 'package:musix/theme/purple_theme.dart';
import 'package:musix/theme/theme_provider.dart';
import 'package:provider/provider.dart';
class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title:
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Text('S E T T I N G', style: TextStyle(fontWeight: FontWeight.bold),),
          ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            padding: EdgeInsets.only(top:30),
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Center(child: Text('Change Theme', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),)),
                ListTile(
                  title: Text('G R E E N', style: TextStyle(color: Colors.green[900]),),
                  leading: Icon(Icons.circle, color: Colors.green,),
                  onTap: (){
                    Provider.of<ThemeProvider>(context, listen: false).themeData = greenTheme;                  },
                ),
                ListTile(
                  title: Text('B L U E', style: TextStyle(color: Colors.blue[900])),
                  leading: Icon(Icons.circle, color: Colors.blue[900],),
                  onTap: (){
                    Provider.of<ThemeProvider>(context, listen: false).themeData = blueTheme;                  },
                ),
                ListTile(
                  title: Text('P U R P L E', style: TextStyle(color: Colors.purple[900])),
                  leading: Icon(Icons.circle, color: Colors.purple[900],),
                  onTap: (){
                    Provider.of<ThemeProvider>(context, listen: false).themeData = purpleTheme;                  },
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
