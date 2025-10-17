import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/result_dialog.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

enum Player{X, O}

class _GameBoardState extends State<GameBoard> with SingleTickerProviderStateMixin {

  final List<String?> _board = List<String?>.filled(9, null);
  Player _current = Player.X;
  bool _gameOver = false;
  List<int> _winningLine = [];

  late AnimationController _pluseController ;


    @override
    void initState(){
      super.initState();

      _pluseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
    lowerBound: 0.95,
    upperBound: 1.06,
    )..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _pluseController.reverse();
      }else if(status == AnimationStatus.dismissed){
        _pluseController.forward();
      }
    });

    _pluseController.forward();
    }

    @override
    void dispose(){
      _pluseController.dispose();
      super.dispose();
    }

    void _restart(){
      setState(() {
        for(var i=0; i<9; i++) _board[i]= null;
        _current = Player.X;
        _gameOver = false;
        _winningLine = [];
        _pluseController.stop();
      });
    }

    void _makeMove(int index){
      if(_board[index] != null || _gameOver) return;
      setState(() {
        _board[index] = _current == Player.X ? "X" : "O";
        final winnerLine = _checkWinner();
        if(winnerLine.isNotEmpty){
          _gameOver=true;
          _winningLine=winnerLine;
          _pluseController.forward();

          Future.delayed(const Duration(milliseconds: 250),(){
            showDialog(
              context: context, 
              builder: (_) => ResultDialog(
                title: "Player ${_board[winnerLine[0]]} Wins!", 
                onRestart: (){
                  Navigator.of(context).pop();
                  _restart();
                }),
            );
          });
          return;
        }

        if(!_board.contains(null)){
          _gameOver=true;
          Future.delayed(const Duration(milliseconds: 250),(){
            showDialog(
              context: context, 
              builder:  (_)=> ResultDialog(
                title: 'It\'s a Draw', 
                onRestart: (){
                  Navigator.of(context).pop();
                  _restart();
                })
            );
          });
          return;
        }

        _current = _current == Player.X ? Player.O : Player.X;
      });
    }

    List<int> _checkWinner(){
      const wins = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
      ];

      for(final combo in wins){
        final a = combo[0], b = combo[1], c = combo[2];
        if(_board[a] != null && _board[a] == _board[b] && _board[b] == _board[c]){
          return [a,b,c];
        }
      }
      return[];
    }

    Widget _buildCell(int index){
      final isWinningCell = _winningLine.contains(index);

        Widget content = GestureDetector(
          onTap: () =>_makeMove(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isWinningCell? Colors.deepPurple.shade100:Colors.white,
              border: Border.all(color: Colors.grey.shade300,width: 1.5),
              boxShadow: isWinningCell?[BoxShadow(color: Colors.deepPurple.withOpacity(0.12),blurRadius: 8, spreadRadius: 2)]:null,
            ),
            child: Center(
          child: AnimatedScale(
            scale: isWinningCell ? _pluseController.value:1.0, 
            duration: const Duration(milliseconds: 200),
            child: Text(
              _board[index]??'',
              style: TextStyle(
                fontSize: 44, 
                fontWeight: FontWeight.w700,
                color: _board[index] == 'X'? Colors.deepPurple : Colors.pinkAccent,
              ),
            ),
          ),
        ),
      )
        
      );

      if(isWinningCell && _pluseController.isAnimating){
        content = ScaleTransition(scale: _pluseController.drive(Tween(begin: 0.98,end: 1.06)),child: content);
      }
      return content;
    }

  @override
  Widget build(BuildContext context) {
   final statusText = _gameOver ? "Game Over" : "Current: ${_current == Player.X ? "X" : "O"}";

   return Padding(
     padding: const EdgeInsets.only(top: 60),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statusText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ElevatedButton.icon(
                onPressed: _restart,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
              ),
            ],
          ),
        ),
     
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12)
            ),
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8
                ),
                itemCount: 9, 
                itemBuilder: (context,index){
                  return _buildCell(index);
              },
            ),
          ),
        ),
     
        const SizedBox(height: 12,),
     
        _buildExtras(),
      ],
     ),
   );
  }

  Widget _buildExtras() {
// move history: show sequence of placed symbols
    final moves = <String>[];
    for (var i = 0; i < 9; i++) {
      if (_board[i] != null) moves.add('${i + 1}:${_board[i]}');
    }


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Moves: ${moves.join(' ')}', style: const TextStyle(fontSize: 18)),
        Text('Tip: Try to control center', style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
      ],
    );
  }
}


