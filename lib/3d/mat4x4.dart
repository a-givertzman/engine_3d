import 'package:engine_3d/3d/vec3d.dart';

class Mat4x4 {
  List<List> _m;
  Mat4x4({
    List<List> ? m,
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
}
