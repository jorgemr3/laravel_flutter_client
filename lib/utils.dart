
  import 'package:flutter/material.dart';

Future<void> showResponseDialog(String title, String content, BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

Center homeScreen(responseData) {
    return Center(
        child: Text(
      responseData,
      style: TextStyle(color: Colors.blueGrey, fontSize: 10.0),
    ));
  }

 