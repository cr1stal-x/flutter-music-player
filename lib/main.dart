import 'package:flutter/material.dart';
import 'package:musix/theme/theme_provider.dart';
import 'package:musix/view_models/library_view_model.dart';
import 'package:musix/testClient.dart';
import 'package:musix/views/downloaded_songs.dart';
import 'package:musix/views/main_page_view.dart';
import 'package:musix/views/server_view.dart';
import 'package:provider/provider.dart';
import 'Auth.dart';
import 'view_models/song_view_model.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider<CommandClient>(create: (_) => CommandClient()..connect()),
        ChangeNotifierProvider(create: (_) => SongViewModel()..init()),
        ChangeNotifierProvider(create: (_)=>ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
        ChangeNotifierProvider(create:(_) => SongProvider()),
        ChangeNotifierProvider(create:(_) => DownloadedSongProvider())

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
