import 'dart:math';

class Vec3d {
  double x, y, z;
  double pitch = 0;
  double yaw = 0;
  double roll = 0;
  List<double> n = [0.0, 0.0, 0.0];
  ///
  Vec3d({
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });
  ///
  double get length => sqrt(x * x + y * y + z * z);
  ///
  Vec3d get normal => this / length;
  ///
  double dot(Vec3d rhs) => x * rhs.x + y * rhs.y + z * rhs.z;
  ///
  Vec3d cross(Vec3d rhs) => Vec3d(
    x: y * rhs.z - z * rhs.y,
    y: z * rhs.x - x * rhs.z,
    z: x * rhs.y - y * rhs.x,
  );
  ///
  Vec3d operator +(Vec3d rhs) {
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
    return this;
  }
  ///
  Vec3d operator -(Vec3d rhs) {
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
    return this;
  }
  ///
  Vec3d operator *(double rhs) {
    x *= rhs;
    y *= rhs;
    z *= rhs;
    return this;
  }
  ///
  Vec3d operator /(double rhs) {
    x /= rhs;
    y /= rhs;
    z /= rhs;
    return this;
  }
  ///
  @override
  String toString() {
    return 'Vec3d(x: $x, y: $y, z: $z)';
  }
}
