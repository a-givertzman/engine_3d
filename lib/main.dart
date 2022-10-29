import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
///
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
///
class MyHomePage extends StatefulWidget {
  final String title;
  ///
  const MyHomePage({super.key, required this.title});
  ///
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
///
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animation;
  final Mesh _meshCube = Mesh(tris: [
    // south
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 0.0), Vec3d(x: 0.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 0.0),]),
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 0.0, z: 0.0),]),
    // east
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 1.0),]),
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 1.0), Vec3d(x: 1.0, y: 0.0, z: 1.0),]),
    // north
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 1.0), Vec3d(x: 1.0, y: 1.0, z: 1.0), Vec3d(x: 0.0, y: 1.0, z: 1.0),]),
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 1.0, z: 1.0), Vec3d(x: 0.0, y: 0.0, z: 1.0),]),
    // west
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 1.0, z: 1.0), Vec3d(x: 0.0, y: 1.0, z: 0.0),]),
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 1.0, z: 0.0), Vec3d(x: 0.0, y: 0.0, z: 0.0),]),
    // top
    Triangle(p: [Vec3d(x: 0.0, y: 1.0, z: 0.0), Vec3d(x: 0.0, y: 1.0, z: 1.0), Vec3d(x: 1.0, y: 1.0, z: 1.0),]),
    Triangle(p: [Vec3d(x: 0.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 1.0), Vec3d(x: 1.0, y: 1.0, z: 0.0),]),
    // button
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 0.0), Vec3d(x: 0.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 0.0),]),
    Triangle(p: [Vec3d(x: 0.0, y: 0.0, z: 0.0), Vec3d(x: 1.0, y: 1.0, z: 0.0), Vec3d(x: 1.0, y: 0.0, z: 0.0),]),
  ]);
  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      lowerBound: 0.0,
      upperBound: 360.0 + 360,
      duration: const Duration(milliseconds: 12000),
      vsync: this,
    );
    _animation.addListener(() {
      // if (_animation.isCompleted) {
      //   _animation.re
      // }
      // if (mounted) setState(() {});
    });
    _animation.repeat();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            Text(
              '${_animation.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 200,),
            AnimatedBuilder(
              animation: _animation, 
              builder:(context, child) {
                return CustomPaint(
                  painter: Custom3DPainter(
                    mesh: _meshCube,
                    vCanera: Vec3d(x: 0.0, y: 0.0, z: 0.0),
                    width: 400.0,
                    height: 400.0,
                    fTheta: _animation.value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              _animation.reverse();
            },
            tooltip: 'Animate reverse',
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: () {
              _animation.forward();
            },
            tooltip: 'Animate forward',
            child: const Icon(Icons.replay_circle_filled),
          ),
        ],
      )
    );
  }
  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}


class Custom3DPainter extends CustomPainter {
  final Mesh mesh;
  final double width;
  final double height;
  final Mat4x4 matProj = Mat4x4();
  final Vec3d _vCanera;
  final Vec3d _vLightDirection;
  double aRatio;
  double fNear;
  double fFar;
  final double _fFov; // radian
  final double _fTheta; // radian
  ///
  Custom3DPainter({
    required this.mesh,
    required this.width,
    required this.height,
    Vec3d? vCanera,
    Vec3d? vLightDirection,
    this.fNear = 0.1,
    this.fFar = 1000.0,
    fFov = 90.0,  // degree
    fTheta = 0.0, // degree
  }) :
    aRatio = height / width,
    _fFov = 1.0 / tan( 0.5 * pi * fFov / 180.0),
    _fTheta = pi * fTheta / 180.0,
    _vCanera = vCanera ?? Vec3d(x: 0.0, y: 0.0, z: 0.0),
    _vLightDirection = vLightDirection ?? Vec3d(x: 0.0, y: 0.0, z: -1.0),
    super() {
      matProj.m[0][0] = aRatio * _fFov;
      matProj.m[1][1] = _fFov;
      matProj.m[2][2] = fFar / (fFar - fNear);
      matProj.m[3][2] = -fFar * fNear / (fFar - fNear);
      matProj.m[2][3] = 1.0;
      matProj.m[3][3] = 0.0;
    }
  ///
  ///
  _drawTriangles(Canvas canvas, Size size, List<Triangle> tris) {
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;
    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blueGrey;

    final matRotZ = Mat4x4();
    matRotZ.m[0][0] = cos(_fTheta);
    matRotZ.m[0][1] = sin(_fTheta);
    matRotZ.m[1][0] = -sin(_fTheta);
    matRotZ.m[1][1] = cos(_fTheta);
    matRotZ.m[2][2] = 1;
    matRotZ.m[3][3] = 1;

    final matRotX = Mat4x4();
    matRotX.m[0][0] = 1;
    matRotX.m[1][1] = cos(_fTheta * 0.5);
    matRotX.m[1][2] = sin(_fTheta * 0.5);
    matRotX.m[2][1] = -sin(_fTheta * 0.5);
    matRotX.m[2][2] = cos(_fTheta * 0.5);
    matRotX.m[3][3] = 1;

    for (final tri in tris) {

      final triRotatedZ = Triangle(p: [
        matRotZ.multipy(tri.p[0]),
        matRotZ.multipy(tri.p[1]),
        matRotZ.multipy(tri.p[2]),
      ]);

      final triRotatedZX = Triangle(p: [
        matRotX.multipy(triRotatedZ.p[0]),
        matRotX.multipy(triRotatedZ.p[1]),
        matRotX.multipy(triRotatedZ.p[2]),
      ]);

      final triTranslated = Triangle(p: [
        Vec3d(x: triRotatedZX.p[0].x, y: triRotatedZX.p[0].y, z: triRotatedZX.p[0].z + 3.0),
        Vec3d(x: triRotatedZX.p[1].x, y: triRotatedZX.p[1].y, z: triRotatedZX.p[1].z + 3.0),
        Vec3d(x: triRotatedZX.p[2].x, y: triRotatedZX.p[2].y, z: triRotatedZX.p[2].z + 3.0),
      ]);

      final line1 = Vec3d(
        x: triTranslated.p[1].x - triTranslated.p[0].x,
        y: triTranslated.p[1].y - triTranslated.p[0].y,
        z: triTranslated.p[1].z - triTranslated.p[0].z,
      );
      final line2 = Vec3d(
        x: triTranslated.p[2].x - triTranslated.p[0].x,
        y: triTranslated.p[2].y - triTranslated.p[0].y,
        z: triTranslated.p[2].z - triTranslated.p[0].z,
      );
      final normal = Vec3d(
        x: line1.y * line2.z - line1.z * line2.y,
        y: line1.z * line2.x - line1.x * line2.z,
        z: line1.x * line2.y - line1.y * line2.x,
      );
      final l = sqrt(normal.x*normal.x + normal.y*normal.y + normal.z*normal.z);
      normal.x /= l; 
      normal.y /= l; 
      normal.z /= l;

      if (normal.x * (triTranslated.p[0].x - _vCanera.x) +
          normal.y * (triTranslated.p[0].y - _vCanera.y) +
          normal.z * (triTranslated.p[0].z - _vCanera.z) < 0.0) {
        
        final ll = sqrt(_vLightDirection.x*_vLightDirection.x + _vLightDirection.y*_vLightDirection.y + _vLightDirection.z*_vLightDirection.z);
        _vLightDirection.x /= ll; 
        _vLightDirection.y /= ll; 
        _vLightDirection.z /= ll;

        final dp = normal.x * _vLightDirection.x + normal.y * _vLightDirection.y + normal.z * _vLightDirection.z;

        final triProjected = Triangle(p: [
          matProj.multipy(triTranslated.p[0]),
          matProj.multipy(triTranslated.p[1]),
          matProj.multipy(triTranslated.p[2]),
        ]);
        
        triProjected.p[0].x += 0.0; triProjected.p[0].y += 0.0;
        triProjected.p[1].x += 0.0; triProjected.p[1].y += 0.0;
        triProjected.p[2].x += 0.0; triProjected.p[2].y += 0.0;
        
        triProjected.p[0].x *= 0.5 * width; triProjected.p[0].y *= 0.5 * height;
        triProjected.p[1].x *= 0.5 * width; triProjected.p[1].y *= 0.5 * height;
        triProjected.p[2].x *= 0.5 * width; triProjected.p[2].y *= 0.5 * height;
        canvas.drawPath(
          _getTrianglePath(triProjected),
          Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.blueGrey.withAlpha((255 * (0.7- dp * 0.5)).round())
        );
        canvas.drawPath(
          _getTrianglePath(triProjected),
          paintStroke
        );
      }
    }
  }
  ///
  _getTrianglePath(Triangle triangle) {
    return Path()
      ..moveTo(triangle.p[0].x, triangle.p[0].y)
      ..lineTo(triangle.p[1].x, triangle.p[1].y)
      ..lineTo(triangle.p[2].x, triangle.p[2].y)
      ..lineTo(triangle.p[0].x, triangle.p[0].y);
  }
  ///
  @override
  void paint(Canvas canvas, Size size) {
    final radius = 50.0;
    // canvas.translate(size.width / 2, size.height / 2);
    // canvas.drawCircle(Offset.zero, radius, Paint()..style=PaintingStyle.stroke);
    // canvas.translate(0, -radius);
    _drawTriangles(canvas, size, mesh.tris);
  }
  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Vec3d {
  double x, y, z;
  Vec3d({
    required this.x,
    required this.y,
    required this.z,
  });
}

class Triangle {
  final List<Vec3d> p;
  Triangle({
    required this.p,
  });
}

class Mesh {
  final List<Triangle> tris;
  Mesh({
    required this.tris,
  });
}

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