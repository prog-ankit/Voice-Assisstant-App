import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeatureBox extends StatelessWidget {
  String title;
  String description;
  Color color;
  FeatureBox(
      {super.key,
      required this.color,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20.0))),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding:
          EdgeInsets.symmetric(vertical: 20).copyWith(left: 15.0, right: 10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18.0),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
