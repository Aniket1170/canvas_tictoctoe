import 'package:flutter/material.dart';

enum Mark { X, O, NONE }

const STROKE_WIDTH = 6.0;
const HALF_STROKE_WIDTH = STROKE_WIDTH / 2.0;
const DOUBLE_STROKE_WIDTH = STROKE_WIDTH * 2.0;

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Map<int, Mark> _gameMark = Map();
  Mark _currentMark = Mark.O;

  List<int>? _winningLine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Tic tAc toE"),
      ),
      body: Center(
        child: Column(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Note:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff484848),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "1.O will play first",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "2.If you wan to play again click on game grid to start again",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            GestureDetector(
              onTapUp: (TapUpDetails details) {
                setState(() {
                  if (_gameMark.length >= 9 || _winningLine != null) {
                    _gameMark = Map<int, Mark>();
                    _currentMark = Mark.O;
                    // _winningLine = null;
                    _winningLine = null;
                  } else {
                    _addMark(
                        details.localPosition.dx, details.localPosition.dy);
                    _winningLine = getWinningLine();
                  }
                });
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  child: CustomPaint(
                    painter: GamePainter(_gameMark, _winningLine),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addMark(double x, double y) {
    double? _dividedSize = GamePainter.getDividedSize();
    // bool isAbsent = false;
    // _gameMark.putIfAbsent(
    //     (x ~/ _dividedSize! + (y ~/ _dividedSize) * 3).toInt(), () {
    //   isAbsent = true;
    //   return _currentMark;
    // });
    _gameMark.putIfAbsent(
        (x ~/ _dividedSize! + (y ~/ _dividedSize) * 3).toInt(),
        () => _currentMark);
    // if (isAbsent) _currentMark = _currentMark == Mark.O ? Mark.X : Mark.O;
    _currentMark = _currentMark == Mark.O ? Mark.X : Mark.O;
  }

  List<int>? getWinningLine() {
    final winningLines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    List<int>? winningLineFound;

    winningLines.forEach((winningLine) {
      int countNoughts = 0;
      int countCrosses = 0;

      winningLine.forEach((index) {
        if (_gameMark[index] == Mark.O) {
          ++countNoughts;
        } else if (_gameMark[index] == Mark.X) {
          ++countCrosses;
        }
      });
      if (countNoughts >= 3 || countCrosses >= 3) {
        winningLineFound = winningLine;
      }
    });

    return winningLineFound;
  }
}

class GamePainter extends CustomPainter {
  static double? _dividedSize;
  Map<int, Mark> _gameMark;

  List<int>? _winningLine;

  // GamePainter(this._gameMark, this._winningLine);
  GamePainter(this._gameMark, this._winningLine);
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = STROKE_WIDTH
      ..color = Colors.black;

    final blackThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.black;

    final redThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.red;

    final orangeThickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = DOUBLE_STROKE_WIDTH
      ..color = Colors.orange;

    _dividedSize = size.width / 3.0;

    //1sr horizontal lie
    canvas.drawLine(
        Offset(STROKE_WIDTH, _dividedSize! - HALF_STROKE_WIDTH),
        Offset(size.width - STROKE_WIDTH, _dividedSize! - HALF_STROKE_WIDTH),
        blackPaint);

    //2sr horizontal lie
    canvas.drawLine(
        Offset(STROKE_WIDTH, _dividedSize! * 2 - HALF_STROKE_WIDTH),
        Offset(
            size.width - STROKE_WIDTH, _dividedSize! * 2 - HALF_STROKE_WIDTH),
        blackPaint);

    //1sr vertictal lie
    canvas.drawLine(
        Offset(_dividedSize! - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(_dividedSize! - HALF_STROKE_WIDTH, size.height - STROKE_WIDTH),
        blackPaint);

    //2sr vertictal lie
    canvas.drawLine(
        Offset(_dividedSize! * 2 - HALF_STROKE_WIDTH, STROKE_WIDTH),
        Offset(
            _dividedSize! * 2 - HALF_STROKE_WIDTH, size.height - STROKE_WIDTH),
        blackPaint);

    _gameMark.forEach((index, mark) {
      switch (mark) {
        case Mark.O:
          drawNought(canvas, index, redThickPaint);
          break;
        case Mark.X:
          drawCross(canvas, index, blackThickPaint);
          break;
        default:
          break;
      }
    });

    drawWinningLine(canvas, _winningLine!, orangeThickPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  static double? getDividedSize() => _dividedSize;

  void drawNought(Canvas canvas, int index, Paint paint) {
    double left = (index % 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;
    double top = (index ~/ 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;
    double noughSize = _dividedSize! - DOUBLE_STROKE_WIDTH * 4;

    canvas.drawOval(Rect.fromLTWH(left, top, noughSize, noughSize), paint);
  }

  void drawCross(Canvas canvas, int index, Paint paint) {
    double x1, y1;
    double x2, y2;
    x1 = (index % 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;
    y1 = (index ~/ 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;

    x2 = (index % 3 + 1) * _dividedSize! - DOUBLE_STROKE_WIDTH * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize! - DOUBLE_STROKE_WIDTH * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

    x1 = (index % 3 + 1) * _dividedSize! - DOUBLE_STROKE_WIDTH * 2;
    y1 = (index ~/ 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;

    x2 = (index % 3) * _dividedSize! + DOUBLE_STROKE_WIDTH * 2;
    y2 = (index ~/ 3 + 1) * _dividedSize! - DOUBLE_STROKE_WIDTH * 2;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  void drawWinningLine(Canvas canvas, List<int> winningLine, Paint paint) {
    if (winningLine == null) return;

    double x1 = 0, y1 = 0;
    double x2 = 0, y2 = 0;

    int firstIndex = winningLine.first;
    int lastIndex = winningLine.last;
    //
    if (firstIndex % 3 == lastIndex % 3) {
      x1 = x2 = firstIndex % 3 * _dividedSize! + _dividedSize! / 2;
      y1 = STROKE_WIDTH;
      y2 = _dividedSize! * 3 - STROKE_WIDTH;
    } else if (firstIndex ~/ 3 == lastIndex ~/ 3) {
      x1 = STROKE_WIDTH;
      x2 = _dividedSize! * 3 - STROKE_WIDTH;
      y1 = y2 = firstIndex ~/ 3 * _dividedSize! + _dividedSize! / 2;
    } else {
      if (firstIndex == 0) {
        x1 = y1 = DOUBLE_STROKE_WIDTH;
        x2 = y2 = _dividedSize! * 3 - DOUBLE_STROKE_WIDTH;
      } else {
        x1 = _dividedSize! * 3 - DOUBLE_STROKE_WIDTH;
        y1 = DOUBLE_STROKE_WIDTH;
        x2 = DOUBLE_STROKE_WIDTH;
        y2 = _dividedSize! * 3 - DOUBLE_STROKE_WIDTH;
      }
    }
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }
}
