import 'package:flutter/material.dart';

import 'package:flutter_todo_api/styles/styles.dart';

class StyledFlatButton extends StatelessWidget {
  final String text;
  final onPressed;
  final double? radius;

  const StyledFlatButton(this.text, {this.onPressed, Key? key, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
      ),
    );
  }
}
