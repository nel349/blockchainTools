import 'package:flutter/material.dart';
import 'views/imagePickerHome.dart';
import 'views/webview_screen.dart';

void main() {
  runApp(PickerHomeApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Contract',
      debugShowCheckedModeBanner: false,
      home: WebViewExample(),
    );
  }
}