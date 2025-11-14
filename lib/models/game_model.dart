import 'package:flutter/material.dart';

class GameModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  GameModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}
