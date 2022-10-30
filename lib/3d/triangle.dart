import 'package:engine_3d/3d/vec3d.dart';
import 'package:flutter/material.dart';

class Triangle {
  final List<Vec3d> p;
  final Color color;
  Triangle({
    required this.p,
    this.color = Colors.black,
  });
  @override
  String toString() {
    String res = 'Triangle(';
    for (int i = 0; i < 3; i++) {
      res += '\n\tpoint $i: ${p[i]}';
    }
    res += ')';
    return res;
  }
}
