import 'package:flutter/material.dart';

class Commons {
  Future<bool> confirmCancel(context, title, content, accept, cancel) async {
    var response;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(
                accept,
              ),
              onPressed: () {
                response = true;
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(cancel),
              onPressed: () {
                response = false;
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
    return response;
  }
}
