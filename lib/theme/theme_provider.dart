import 'package:flutter/material.dart';
import 'package:musix/theme/blue_theme.dart';
import 'package:musix/theme/green_theme.dart';
import 'package:musix/theme/purple_theme.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData=greenTheme;

  ThemeData get themeData=> _themeData;

  set themeData(ThemeData themeData){
    _themeData=themeData;
    notifyListeners();
  }

}