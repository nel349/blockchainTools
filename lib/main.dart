import 'package:flutter/material.dart';
import 'screens/articles.dart';
import 'screens/components.dart';
import 'screens/getStarted.dart';
import 'screens/home.dart';
import 'screens/inquriry.dart';
import 'screens/onBoarding.dart';
import 'screens/pro.dart';
import 'screens/profile.dart';
import 'screens/register.dart';
import 'screens/services.dart';
import 'screens/settings.dart';
import 'views/image_picker_home.dart';
import 'views/webview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Smart Contract',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: "/image_picker",
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Home(),
          '/settings': (BuildContext context) => new Settings(),
          "/onBoarding": (BuildContext context) => new Intro(),
          "/pro": (BuildContext context) => new Pro(),
          "/profile": (BuildContext context) => new Profile(),
          "/articles": (BuildContext context) => new Articles(),
          "/components": (BuildContext context) => new Components(),
          "/account": (BuildContext context) => new Register(),
          "/ask": (BuildContext context) => new Inquiry(),
          "/start": (BuildContext context) => new Started(),
          "/services": (BuildContext context) => new Services(),
          "/webview": (BuildContext context) => new WebViewExample(),
          "/image_picker": (BuildContext context) => new PickerHomeApp(),
        });
  }
}