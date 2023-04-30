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

  Widget _buildSmallBoard(int bigIndex, BoxConstraints constraints) {
    return GridView.builder(
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int smallIndex) {
        return GestureDetector(
          onTap: _activeSmallBoard == null || _activeSmallBoard == bigIndex
              ? () => _handleTap(bigIndex, smallIndex)
              : null,
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
                        : '',
                style: TextStyle(
                  fontSize: constraints.maxWidth / 27,
                  fontWeight: FontWeight.bold,
                  color: _bigBoard[bigIndex][smallIndex] == 1
                      ? Colors.blue
                      : _bigBoard[bigIndex][smallIndex] == 2
                          ? Colors.red
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

  void _handleTap(int bigIndex, int smallIndex) {
    if (_bigBoard[bigIndex][smallIndex] == 0 && _smallBoardWinners[bigIndex] == 0) {
      setState(() {
        _bigBoard[bigIndex][smallIndex] = _currentPlayer;
        _activeSmallBoard = smallIndex;
        if (_checkSmallBoardWin(bigIndex, _currentPlayer)) {
          _smallBoardWinners[bigIndex] = _currentPlayer;
        }
        _currentPlayer = _currentPlayer == 1 ? 2 : 1;
      });
    }
  }

  bool _checkSmallBoardWin(int bigIndex, int player) {
    for (int i = 0; i < 3; i++) {
      if (_bigBoard[bigIndex][i * 3] == player &&
          _bigBoard[bigIndex][i * 3 + 1] == player &&
          _bigBoard[bigIndex][i * 3 + 2] == player) {
        return true;
      }
      if (_bigBoard[bigIndex][i] == player &&
          _bigBoard[bigIndex][i + 3] == player &&
          _bigBoard[bigIndex][i + 6] == player) {
        return true;
      }
    }

    if (_bigBoard[bigIndex][0] == player &&
        _bigBoard[bigIndex][4] == player &&
        _bigBoard[bigIndex][8] == player) {
      return true;
    }

    if (_bigBoard[bigIndex][2] == player &&
        _bigBoard[bigIndex][4] == player &&
        _bigBoard[bigIndex][6] == player) {
      return true;
    }

    return false;
  }

  void _resetGame() {
    setState(() {
      _bigBoard = List.generate(9, (_) => List.generate(9, (_) => 0));
      _smallBoardWinners = List.generate(9, (_) => 0);
      _currentPlayer = 1;
      _activeSmallBoard = null;
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

