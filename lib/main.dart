import 'package:flutter/material.dart';
import 'package:musix/theme/theme_provider.dart';
import 'package:musix/view_models/library_view_model.dart';
import 'package:musix/views/main_page_view.dart';
import 'package:provider/provider.dart';
import 'view_models/song_view_model.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongViewModel()..init()),
        ChangeNotifierProvider(create: (_)=>ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: MainPage(),
    );
  }
}
