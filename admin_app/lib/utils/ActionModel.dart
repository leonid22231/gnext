import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionModel{
  String name;
  String description;
  IconData icon;
  StatefulWidget child;
  var secondChild;

  ActionModel(
      {required this.name,
      required this.description,
      this.secondChild,
      required this.icon,
      required this.child});
}