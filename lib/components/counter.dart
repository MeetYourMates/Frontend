library counter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef void CounterChangeCallback(num value);

class Counter extends StatefulWidget {
  final CounterChangeCallback onChanged;
  final textStyle;
  final color;
  Counter({
    Key key,
    @required num initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    @required this.decimalPlaces,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 25,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  final double buttonSize;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  /// indicates the color of fab used for increment and decrement
  Color color;

  /// text syle
  TextStyle textStyle;
  void _incrementCounter() {
    if (widget.selectedValue + widget.step <= widget.maxValue) {
      widget.onChanged((widget.selectedValue + widget.step));
    }
  }

  void _decrementCounter() {
    if (widget.selectedValue - widget.step >= widget.minValue) {
      widget.onChanged((widget.selectedValue - widget.step));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    color = widget.color ?? themeData.accentColor;
    textStyle = widget.textStyle ??
        new TextStyle(
          fontSize: 20.0,
        );

    return new Container(
      padding: new EdgeInsets.all(4.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              onPressed: _decrementCounter,
              elevation: 2,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
              backgroundColor: widget.color,
            ),
          ),
          new Container(
            padding: EdgeInsets.all(4.0),
            child: new Text('${num.parse((widget.selectedValue).toStringAsFixed(widget.decimalPlaces))}', style: widget.textStyle),
          ),
          new SizedBox(
            width: widget.buttonSize,
            height: widget.buttonSize,
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              elevation: 2,
              tooltip: 'Increment',
              child: Icon(Icons.add),
              backgroundColor: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
