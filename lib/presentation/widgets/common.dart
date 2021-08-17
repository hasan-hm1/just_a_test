import 'package:flutter/material.dart';

class CeneteredCircualrProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('An Error Occured'),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(errorMessage),
    );
  }
}
