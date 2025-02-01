import 'dart:async';
import 'dart:math';
import 'package:excerbuys/store/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';

class AnimatedBalance extends StatefulWidget {
  final int balance;
  const AnimatedBalance({super.key, required this.balance});

  @override
  State<AnimatedBalance> createState() => _AnimatedBalanceState();
}

class _AnimatedBalanceState extends State<AnimatedBalance> {
  // numbers in the new balance
  List<String> _newBalanceChars = [];
  // a list of differences between each number in changed balance
  List<int?> _charDifferences = [];
  // flag to disable animation during calculations
  bool _isStopAnimating = true;
  // animation timeout
  Timer? timeouutId;
  // styles
  Color _textColor = Colors.white;
  double centerBalance = 0;
  double letterHeight = 77;
  double letterWidth = 34;

  // splits a string into chars
  List<String> getTextChars(int value, int length) {
    return value.toString().padLeft(length, '0').split("");
  }

  // generates a list filled with values in a given range
  List<String> generateRange(int start, int end) {
    return List<String>.generate(
        end - start + 1, (index) => (start + index).toString());
  }

  // generates pairs of characters on each place in a string
  List<List<String?>> getCharsPairs(int oldValue, int newValue) {
    int maxLength = max(oldValue.toString().length, newValue.toString().length);
    List<String> oldChars = getTextChars(oldValue, maxLength);
    List<String> newChars = getTextChars(newValue, maxLength);

    // trim leading zeroes
    newChars = int.parse(newChars.join('')).toString().split("");
    oldChars = oldChars.sublist(oldChars.length - newChars.length);

    setState(() {
      _newBalanceChars = newChars;
    });

    List<String> oldCharsReversed = oldChars.reversed.toList();
    List<String> newCharsReversed = newChars.reversed.toList();

    // generate pairs from the last place in a string to avoid length issues
    final List<List<String?>> charPairs = oldCharsReversed
        .asMap()
        .map((idx, item) {
          final String? newChar =
              idx >= newCharsReversed.length ? null : newCharsReversed[idx];
          return MapEntry(idx, [item, newChar]);
        })
        .values
        .toList();

    return charPairs;
  }

  // calculates differences in each char pair
  List<int?> getCharDifferencess(List<List<String?>> charPairs) {
    final List<int?> differences = charPairs.reversed.map((element) {
      if (element[0] == null || element[1] == null) {
        return null;
      }
      return int.parse(element[1]!) - int.parse(element[0]!);
    }).toList();
    return differences;
  }

  @override
  void didUpdateWidget(covariant AnimatedBalance oldWidget) {
    setState(() {
      _isStopAnimating = true;
      if (oldWidget.balance < widget.balance) {
        _textColor = Theme.of(context).colorScheme.secondary;
      }

      if (oldWidget.balance > widget.balance) {
        _textColor = Color(0xFFFA6161);
      }
    });
    final List<List<String?>> charPairs =
        getCharsPairs(oldWidget.balance, widget.balance);

    final List<int?> differences = getCharDifferencess(charPairs);
    setState(() {
      _charDifferences = differences;
    });

    if (timeouutId != null) {
      timeouutId!.cancel();
    }

    // animation handler
    timeouutId = Timer(
        Duration(
            milliseconds:
                max(calculateMaxDuration(differences) * 120, 400) + 200), () {
      setState(() {
        _textColor = Colors.white;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Re-enable animation for the next transition
        _isStopAnimating = false;
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  int calculateMaxDuration(List<int?> differences) {
    return differences
        .where((item) => item != null)
        .map((item) => item!.abs())
        .fold(0, (acc, item) => max(acc, item));
  }

  @override
  void dispose() {
    if (timeouutId != null) {
      timeouutId!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    // initial char pairs generation
    getCharsPairs(widget.balance, widget.balance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _newBalanceChars.length * letterWidth,
      height: letterHeight,
      child: Stack(children: [
        ..._newBalanceChars
            .asMap()
            .map((idx, element) {
              int difference = 0;
              if (idx < _charDifferences.length &&
                  _charDifferences[idx] != null) {
                difference = _charDifferences[idx]!;
              }

              List<String> rangeList = generateRange(
                  min(int.parse(element), int.parse(element) - difference),
                  max(int.parse(element), int.parse(element) - difference));

              if (difference == 0) {
                rangeList = [element];
              }
              rangeList = rangeList.reversed.toList();

              double positionBottom = centerBalance;
              if (_isStopAnimating) {
                positionBottom = difference >= 0
                    ? centerBalance
                    : centerBalance - (difference.abs() * letterHeight);
              } else {
                positionBottom = difference <= 0
                    ? centerBalance
                    : centerBalance - (difference.abs() * letterHeight);
              }

              return MapEntry(
                  idx,
                  AnimatedPositioned(
                    curve: Curves.decelerate,
                    duration: Duration(
                        milliseconds: _isStopAnimating
                            ? 0
                            : max(400, (difference.abs() * 120))),
                    width: letterWidth,
                    left: idx * letterWidth,
                    bottom: positionBottom,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rangeList.map((item) {
                        return Text(
                          item,
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 54,
                              color:
                                  difference != 0 ? _textColor : Colors.white),
                        );
                      }).toList(),
                    ),
                  ));
            })
            .values
            .toList(),
      ]),
    );
  }
}
