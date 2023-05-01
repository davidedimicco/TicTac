import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ultimate Tic Tac Toe'),
        ),
        body: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<int>> _bigBoard = List.generate(9, (_) => List.generate(9, (_) => 0));
  List<int> _smallBoardWinners = List.generate(9, (_) => 0);
  int _currentPlayer = 1;
  int? _activeSmallBoard;
  int _winner = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildBigBoard(constraints),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Container(
                width: constraints.maxWidth * 0.5,
                child: ResetButton(onReset: _resetGame),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBigBoard(BoxConstraints constraints) {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int bigIndex) {
        return Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: _smallBoardWinners[bigIndex] == 1
                  ? Colors.blue.withOpacity(0.3)
                  : _smallBoardWinners[bigIndex] == 2
                      ? Colors.red.withOpacity(0.3)
                      : Colors.transparent,
            ),
            child: _buildSmallBoard(bigIndex, constraints),
          ),
        );
      },
      physics: NeverScrollableScrollPhysics(),
    );
  }

  bool _isGameStarted() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (_bigBoard[i][j] != 0) {
          return true;
        }
      }
    }
    return false;
  }

  bool _isSmallBoardFull(List<int> board) {
    for (int i = 0; i < 9; i++) {
      if (board[i] == 0) {
        return false;
      }
    }
    return true;
  }

Widget _buildSmallBoard(int bigIndex, BoxConstraints constraints) {
  bool isGameStarted = _isGameStarted();
    return GridView.builder(
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int smallIndex) {
        bool isClickable = (_winner == 0) && (_bigBoard[bigIndex][smallIndex] == 0) && ((_activeSmallBoard == null ? true : _isSmallBoardFull(_bigBoard[_activeSmallBoard!])) || _activeSmallBoard == bigIndex);
        return GestureDetector(
          onTap: isClickable ? () => _handleTap(context, bigIndex, smallIndex) : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                _bigBoard[bigIndex][smallIndex] == 1
                    ? 'X'
                    : _bigBoard[bigIndex][smallIndex] == 2
                        ? 'O'
                        : isClickable && isGameStarted
                            ? '?'
                            : '',
                style: TextStyle(
                  fontSize: constraints.maxWidth / 27,
                  fontWeight: FontWeight.bold,
                  color: _bigBoard[bigIndex][smallIndex] == 1
                      ? Colors.blue
                      : _bigBoard[bigIndex][smallIndex] == 2
                          ? Colors.red
                          : isClickable && isGameStarted
                              ? Colors.grey
                              : Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
      physics: NeverScrollableScrollPhysics(),
    );
  }


  void _handleTap(BuildContext context, int bigIndex, int smallIndex) {
    if (_winner == 0 &&
        _bigBoard[bigIndex][smallIndex] == 0 &&
        ((_activeSmallBoard == null ? true : _isSmallBoardFull(_bigBoard[_activeSmallBoard!])) || _activeSmallBoard == bigIndex)) {
      setState(() {
        _bigBoard[bigIndex][smallIndex] = _currentPlayer;
        _activeSmallBoard = smallIndex;

        if (_smallBoardWinners[bigIndex] == 0) {
          _smallBoardWinners[bigIndex] = _checkWin(_bigBoard[bigIndex], _currentPlayer);
          _winner = _checkWin(_smallBoardWinners, _currentPlayer);
          if (_winner != 0) {
            Text dialog_text = (_winner == 1) ? Text('Player X wins!') : ((_winner == 2) ? Text('Player O wins!') : Text('This is a draw!'));
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Game Over'),
                  content: dialog_text,
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }

        _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      });
    }
  }

  int _checkWin(List<int> board, int player) {
    for (int i = 0; i < 3; i++) {
      if (board[i * 3] == player &&
          board[i * 3 + 1] == player &&
          board[i * 3 + 2] == player) {
        return player;
      }
      if (board[i] == player &&
          board[i + 3] == player &&
          board[i + 6] == player) {
        return player;
      }
    }

    if (board[0] == player &&
        board[4] == player &&
        board[8] == player) {
      return player;
    }

    if (board[2] == player &&
        board[4] == player &&
        board[6] == player) {
      return player;
    }
    if (_isSmallBoardFull(board)){
      return 8;
    }
    return 0;
  }

  void _resetGame() {
    setState(() {
      _bigBoard = List.generate(9, (_) => List.generate(9, (_) => 0));
      _smallBoardWinners = List.generate(9, (_) => 0);
      _currentPlayer = 1;
      _activeSmallBoard = null;
      _winner = 0;
    });
  }
}

class ResetButton extends StatelessWidget {
  final VoidCallback onReset;

  ResetButton({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onReset,
      child: Text('Reset'),
    );
  }
}