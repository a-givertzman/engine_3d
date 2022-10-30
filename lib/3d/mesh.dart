import 'dart:convert';

import 'package:engine_3d/3d/triangle.dart';
import 'package:engine_3d/3d/vec3d.dart';
import 'package:flutter/services.dart';

class Mesh {
  late List<Triangle> tris = [];
  late String? _path;
  ///
  Mesh({
    required this.tris,
  });
  ///
  Mesh.fromObjFile(String path) :
    _path = path;
  ///
  Future<bool> load() {
    final path = _path;
    if (path != null) {
      return rootBundle.loadString(path)
      .then((value) {
        final lines = LineSplitter.split(value);
        final List<Vec3d> verts = [];
        for (final line in lines) {
          final lineParts = line.split(' ');
          if (lineParts[0] == 'v') {
            verts.add(
              Vec3d(
                x: double.tryParse(lineParts[1]) ?? 0.0, 
                y: double.tryParse(lineParts[2]) ?? 0.0, 
                z: double.tryParse(lineParts[3]) ?? 0.0,
              ),
            );
          }
        }
        for (final line in lines) {
          final lineParts = line.split(' ');
          if (lineParts[0] == 'f') {
            tris.add(
              Triangle(p: [
                verts[int.parse(lineParts[1]) - 1],
                verts[int.parse(lineParts[2]) - 1], 
                verts[int.parse(lineParts[3]) - 1],
              ]),
            );
          }
        }

        return true;
      });
    }
    return Future.value(false);
  }
  ///
  @override
  String toString() {
    String res = 'Mesh(';
    for (int i = 0; i < tris.length; i++) {
      res += '\n\t$i: ${tris[i]}';
    }
    res += ')';
    return res;
  }
}

