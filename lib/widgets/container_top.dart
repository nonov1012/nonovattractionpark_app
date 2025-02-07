import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContainerTop extends StatelessWidget {
  const ContainerTop({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: Center(child: Text(text == null ? '-' : text!)),
      ),
    );
  }
}
