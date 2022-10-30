import 'dart:math';

import 'package:engine_3d/3d/mat4x4.dart';
import 'package:engine_3d/3d/mesh.dart';
import 'package:engine_3d/3d/triangle.dart';
import 'package:engine_3d/3d/vec3d.dart';
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
  late Mesh _meshModel;
  final Mesh _meshShip = Mesh.fromObjFile('assets/models/ship.obj');
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
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 0.0, z: 0.0),]),
    Triangle(p: [Vec3d(x: 1.0, y: 0.0, z: 1.0), Vec3d(x: 0.0, y: 0.0, z: 0.0), Vec3d(x: 1.0, y: 0.0, z: 0.0),]),
  ]);
  //
  @override
  void initState() {
    super.initState();
    // _meshModel = _meshCube;
    _meshModel = _meshShip;
    _meshModel.load()
    .then((value) {
      // setState(() {});
      print(_meshModel);
    });
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
    _animation.forward();
    // _animation.repeat();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    const  size = Size(600.0, 600.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.green[200],
        child: AnimatedBuilder(
          animation: _animation, 
          builder:(context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // const Text(
                //   'You have pushed the button this many times:',
                // ),
                Text(
                  '${_animation.value.round()}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // const SizedBox(height: 200,),
                CustomPaint(
                  size: size,
                  painter: Custom3DPainter(
                    mesh: _meshModel,
                    vCanera: Vec3d(x: 0.0, y: 0.0, z: 0.0),
                    size: size,
                    fTheta: _animation.value,
                  ),
                ),
              ],
            );
          },
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
  late Mat4x4 matProj;
  final Vec3d _vCanera;
  final Vec3d _vLightDirection;
  final Size size;
  double aRatio;
  double fNear;
  double fFar;
  final double _fFov; // radian
  final double _fTheta; // radian
  ///
  Custom3DPainter({
    required this.mesh,
    required this.size,
    Vec3d? vCanera,
    Vec3d? vLightDirection,
    this.fNear = 0.1,
    this.fFar = 1000.0,
    fFov = 90.0,  // degree
    fTheta = 0.0, // degree
  }) :
    width = size.width,
    height = size.height,
    aRatio = size.height / size.width,
    matProj = Mat4x4.projection(fFov, size.height / size.width, fNear, fFar),
    _fFov = 1.0 / tan( 0.5 * pi * fFov / 180.0),
    _fTheta = pi * fTheta / 180.0,
    _vCanera = vCanera ?? Vec3d(x: 0.0, y: 0.0, z: 0.0),
    _vLightDirection = vLightDirection ?? Vec3d(x: 0.0, y: 0.0, z: -1.0),
    super();
  ///
  ///
  _drawTriangles(Canvas canvas, Size size, List<Triangle> tris) {

    final matRotZ = Mat4x4.rotateZ(_fTheta);
    final matRotX = Mat4x4.rotateX(_fTheta);
    final List<Triangle> vTrisToRaster = [];
    
    // print('tris count: ${tris.length}');
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

      /// Offset into the deepth of the screen
      final triTranslated = Triangle(p: [
        Vec3d(x: triRotatedZX.p[0].x, y: triRotatedZX.p[0].y, z: triRotatedZX.p[0].z + 8.0),
        Vec3d(x: triRotatedZX.p[1].x, y: triRotatedZX.p[1].y, z: triRotatedZX.p[1].z + 8.0),
        Vec3d(x: triRotatedZX.p[2].x, y: triRotatedZX.p[2].y, z: triRotatedZX.p[2].z + 8.0),
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
      // print('line1 : $line1');
      // print('line2 : $line2');
      // print('normal : $normal');
      final l = sqrt(normal.x*normal.x + normal.y*normal.y + normal.z*normal.z);
      normal.x /= l; 
      normal.y /= l; 
      normal.z /= l;

      // CROSS PRODUCR
      final cp = normal.x * (triTranslated.p[0].x - _vCanera.x) +
                  normal.y * (triTranslated.p[0].y - _vCanera.y) +
                  normal.z * (triTranslated.p[0].z - _vCanera.z);

      if (cp < 0.0) {
        
        final ll = sqrt(_vLightDirection.x*_vLightDirection.x + _vLightDirection.y*_vLightDirection.y + _vLightDirection.z*_vLightDirection.z);
        _vLightDirection.x /= ll; 
        _vLightDirection.y /= ll; 
        _vLightDirection.z /= ll;

        final dp = normal.x * _vLightDirection.x + normal.y * _vLightDirection.y + normal.z * _vLightDirection.z;
        final triProjected = Triangle(
          color: colorShiftLightness(Colors.blueGrey, 0.5 + dp * 0.5),
          p: [
            matProj.multipy(triTranslated.p[0]),
            matProj.multipy(triTranslated.p[1]),
            matProj.multipy(triTranslated.p[2]),
          ], 
        );
        
        triProjected.p[0].x += 1.0; triProjected.p[0].y += 1.0;
        triProjected.p[1].x += 1.0; triProjected.p[1].y += 1.0;
        triProjected.p[2].x += 1.0; triProjected.p[2].y += 1.0;
        
        triProjected.p[0].x *= 0.5 * width; triProjected.p[0].y *= 0.5 * height;
        triProjected.p[1].x *= 0.5 * width; triProjected.p[1].y *= 0.5 * height;
        triProjected.p[2].x *= 0.5 * width; triProjected.p[2].y *= 0.5 * height;

        vTrisToRaster.add(triProjected);
      }
      vTrisToRaster.sort((t1, t2) {
        final z1 = (t1.p[0].z + t1.p[1].z + t1.p[2].z) / 3;
        final z2 = (t2.p[0].z + t2.p[1].z + t2.p[2].z) / 3;
        return z2.compareTo(z1);
      });
      _drawRaster(
        canvas, 
        size, 
        vTrisToRaster,
      );
    }
  }
  ///
  _drawRaster(Canvas canvas, Size size, List<Triangle> tris) {
    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black;
    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blueGrey;
    for (final tri in tris) {
      canvas.drawPath(
        _getTrianglePath(tri),
        Paint()
        ..style = PaintingStyle.fill
        ..color = tri.color
      );
      // print('tri : $tri');
      // canvas.drawPath(
      //   _getTrianglePath(tri),
      //   paintStroke
      // );
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
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(width, height)), Paint()..style = PaintingStyle.stroke..color = Colors.orange);
    // canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(width, height)), Paint()..color = Colors.white54);
    _drawTriangles(canvas, size, mesh.tris);
  }
  ///
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Color colorShiftLightness(Color color, double factor) {
  assert(factor >= 0);
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness * factor;
  if (lightness < 0) return hslColor.withLightness(0).toColor();
  if (lightness > 1) return hslColor.withLightness(1).toColor();
  return hslColor.withLightness(lightness).toColor();
}
