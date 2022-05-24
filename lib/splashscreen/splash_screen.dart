import 'dart:async';
import 'dart:ui';

import 'package:canvas_tictoctoe/game/games.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Game())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            Text("Welcome to TIC TAc TOE",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
            SizedBox(height: 40),
            Image.asset(
              "assets/images/icon.png",
              height: 250,
              width: 250,
            ),
          ],
        ),
        // child: Image.asset(
        //   "assets/images/icon.png",
        //   height: 250,
        //   width: 250,
        // ),
      ),
    );
  }
}
