import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  
  String screenMessage;
  SplashScreen(this.screenMessage);

  @override
  Widget build(BuildContext context) {
    print('In SplashScreen');
    return Scaffold(
      body: Center(
        child: Text(screenMessage),
      ),
    );
  }
}
