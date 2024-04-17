
import 'package:flutter/material.dart';

// MessageTile widget

class MessageTile extends StatelessWidget {
  final String sender;
  final String message;
  final String time;

  const MessageTile({
    Key? key,
    required this.sender,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ 
        ListTile(
          title: Text(
            sender,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          trailing: Container(
            width: 50,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
          ),
          ),
        ),
        const Divider(
          color: Colors.black,
          thickness: 1,
        ),
      ],
    );
  }
}