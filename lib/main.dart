import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/game_homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tic-Tac-Toe",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true
      ),
      home: GameHomepage()
    );
  }
}
