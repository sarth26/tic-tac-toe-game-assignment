import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/game_board.dart';

class GameHomepage extends StatefulWidget {
  const GameHomepage({super.key});

  @override
  State<GameHomepage> createState() => _GameHomepageState();
}

class _GameHomepageState extends State<GameHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tic-Tac-Toe"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: GameBoard(),
        )
      ),
    );
  }
}