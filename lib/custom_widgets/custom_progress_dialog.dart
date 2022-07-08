import 'package:flutter/material.dart';

class CustomProgressDialog extends StatelessWidget {
  final String title;
  const CustomProgressDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(fontSize: 20),),
            SizedBox(height: 14,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
