import 'dart:math';

import 'package:engine_3d/3d/vec3d.dart';

class Mat4x4 {
  static get identity {
    Mat4x4 m = Mat4x4();
    m[0][0] = 1.0;
    m[1][1] = 1.0;
    m[2][2] = 1.0;
    m[3][3] = 1.0;
    return m;
  } 

  static rotateX(rad) {
    final m = Mat4x4();
    m[0][0] = 1;
    m[1][1] = cos(rad * 0.5);
    m[1][2] = sin(rad * 0.5);
    m[2][1] = -sin(rad * 0.5);
    m[2][2] = cos(rad * 0.5);
    m[3][3] = 1;
    return m;
  }

  static rotateY(rad) {
    final m = Mat4x4();
    m[0][0] = cos(rad);
    m[1][1] = 1;
    m[0][2] = sin(rad);
    m[2][0] = -sin(rad);
    m[2][2] = cos(rad);
    m[3][3] = 1;
    return m;
  }

  static rotateZ(rad) {
    final m = Mat4x4();
    m[0][0] = cos(rad);
    m[0][1] = sin(rad);
    m[1][0] = -sin(rad);
    m[1][1] = cos(rad);
    m[2][2] = 1;
    m[3][3] = 1;
    return m;
  }

  static translate(double x, double y, double z) {
    final m = Mat4x4();
    m[0][0] = 1.0;
    m[1][1] = 1.0;
    m[2][2] = 1.0;
    m[3][3] = 1.0;
    m[3][0] = x;
    m[3][1] = y;
    m[3][2] = z;
    return m;
  }

  static projection(double fovDeg, double aRatio, double near, double far) {
    final fov = 1.0 / tan( 0.5 * pi * fovDeg / 180.0);
    final m = Mat4x4();
    m[0][0] = aRatio * fov;
    m[1][1] = fov;
    m[2][2] = far / (far - near);
    m[3][2] = -far * near / (far - near);
    m[2][3] = 1.0;
    m[3][3] = 0.0;
    return m;
  }

  List<List> _m;
  Mat4x4({
    List<List>? m,
  }) :
    _m = m ?? [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0],];
  List<List> get m => _m;
  Vec3d multipy(Vec3d vec) {
    final double w = vec.x * _m[0][3] + vec.y * _m[1][3] + vec.z * _m[2][3] + _m[3][3];
    if (w != 0.0) {
      return Vec3d(
        x: (vec.x * _m[0][0] + vec.y * _m[1][0] + vec.z * _m[2][0] + _m[3][0]) / w,
        y: (vec.x * _m[0][1] + vec.y * _m[1][1] + vec.z * _m[2][1] + _m[3][1]) / w,
        z: (vec.x * _m[0][2] + vec.y * _m[1][2] + vec.z * _m[2][2] + _m[3][2]) / w,
      );
    }
    return Vec3d(
      x: vec.x * _m[0][0] + vec.y * _m[1][0] + vec.z * _m[2][0] + _m[3][0],
      y: vec.x * _m[0][1] + vec.y * _m[1][1] + vec.z * _m[2][1] + _m[3][1],
      z: vec.x * _m[0][2] + vec.y * _m[1][2] + vec.z * _m[2][2] + _m[3][2],
    );
  }
  List operator [](index) {
    return _m[index];
  }
}
