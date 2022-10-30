class Vec3d {
  double x, y, z;
  Vec3d({
    required this.x,
    required this.y,
    required this.z,
  });
  @override
  String toString() {
    return 'Vec3d(x: $x, y: $y, z: $z)';
  }
}
