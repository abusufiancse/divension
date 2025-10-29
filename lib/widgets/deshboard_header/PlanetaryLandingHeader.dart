// lib/src/widgets/planetary_landing_header.dart
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Use inside SliverAppBar → FlexibleSpaceBar(background: PlanetaryLandingHeader())
class PlanetaryLandingHeader extends StatefulWidget {
  const PlanetaryLandingHeader({super.key, this.loop = true});
  final bool loop;

  @override
  State<PlanetaryLandingHeader> createState() => _PlanetaryLandingHeaderState();
}

class _PlanetaryLandingHeaderState extends State<PlanetaryLandingHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 18000));
    _t = CurvedAnimation(parent: _ctrl, curve: Curves.linear);
    widget.loop ? _ctrl.repeat() : _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _t,
      builder: (context, _) {
        return LayoutBuilder(builder: (_, c) {
          final size = Size(c.maxWidth, c.maxHeight);
          final t = _t.value;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1) Deep star background
              _Starfield(phase: t),

              // 2) Subtle grid overlay
              CustomPaint(size: size, painter: _GridPainter(cs)),

              // 3) Rotating wireframe sphere + orbits + sweep
              CustomPaint(
                size: size,
                painter: _HudPainter(
                  t: t,
                  cs: cs,
                ),
                willChange: true,
              ),

              // 4) Bottom-left caption (as requested)
              Positioned(
                left: 16,
                bottom: 14,
                child: _Caption(t: t, cs: cs),
              ),
            ],
          );
        });
      },
    );
  }
}

/// ------------------------------ STARFIELD ------------------------------
class _Starfield extends StatelessWidget {
  final double phase;
  const _Starfield({required this.phase});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF050510), Color(0xFF0A0A1A), Color(0xFF090922)],
        ),
      ),
      child: CustomPaint(
        painter: _StarfieldPainter(phase),
        willChange: true,
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final double t;
  _StarfieldPainter(this.t);

  Color _starColor(double temp) {
    // simple color temp mapping (reddish → bluish)
    final r = (220 - 60 * temp).clamp(150, 230).toInt();
    final g = (200 + 20 * temp).clamp(140, 230).toInt();
    final b = (180 + 70 * temp).clamp(180, 255).toInt();
    return Color.fromARGB(255, r, g, b);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(2026);

    // Parallax layers
    void layer(int count, double twinkleMul, double parallax, double alphaBase) {
      for (int i = 0; i < count; i++) {
        final x0 = rnd.nextDouble() * size.width;
        final y0 = rnd.nextDouble() * size.height;
        final temp = rnd.nextDouble();
        // simple parallax drift
        final dx = math.sin((t * 2 * math.pi) + i * .07) * parallax;
        final dy = math.cos((t * 2 * math.pi) + i * .11) * parallax * .5;
        final tw = (math.sin(t * 2 * math.pi * (1.0 + (i % 5) * .1) + i) + 1) * .5;

        canvas.drawCircle(
          Offset(x0 + dx, y0 + dy),
          0.5 + rnd.nextDouble() * 1.2,
          Paint()..color = _starColor(temp).withOpacity(alphaBase + tw * twinkleMul),
        );
      }
    }

    layer(450, .35, 3.0, .15);
    layer(250, .45, 6.0, .18);
    layer(120, .55, 10.0, .22);

    // vignetting
    final vignette = RadialGradient(
      colors: [Colors.transparent, Colors.black.withOpacity(.4)],
      stops: const [.65, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Offset.zero & size, Paint()..shader = vignette);
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => oldDelegate.t != t;
}

/// ------------------------------ GRID OVERLAY ------------------------------
class _GridPainter extends CustomPainter {
  final ColorScheme cs;
  _GridPainter(this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withOpacity(.06)
      ..strokeWidth = 1;

    const step = 40.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // subtle center crosshair
    final center = Offset(size.width * .55, size.height * .55);
    canvas.drawLine(center + const Offset(-10, 0), center + const Offset(10, 0), grid);
    canvas.drawLine(center + const Offset(0, -10), center + const Offset(0, 10), grid);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ------------------------------ HUD PAINTER ------------------------------
class _HudPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _HudPainter({required this.t, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .55, size.height * .55);

    // Wireframe sphere (rotating latitude/longitude lines)
    final sphereR = size.shortestSide * .22;
    _drawWireSphere(canvas, center, sphereR, t, cs);

    // Concentric orbits with moving satellites
    final orbitBase = sphereR * 1.1;
    for (int i = 0; i < 4; i++) {
      final r = orbitBase + i * (sphereR * .25);
      _drawOrbit(canvas, center, r, tilt: .18 * (i.isEven ? 1 : -1), phase: t * (1.2 - i * 0.15));
      _drawSatellite(canvas, center, r, speed: .6 + i * .17, size: 3.0 + i, color: cs.primary);
    }

    // Radar sweep arc
    _drawRadarSweep(canvas, center, sphereR * 1.6, t, cs);

    // Data ticks ring
    _drawDataTicks(canvas, center, sphereR * 1.85, t, cs);
  }

  void _drawWireSphere(Canvas canvas, Offset c, double r, double t, ColorScheme cs) {
    final line = Paint()
      ..color = Colors.white.withOpacity(.18)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // latitude lines
    for (int i = -3; i <= 3; i++) {
      final k = i / 3.0;
      final ry = r * math.cos(k * math.pi / 2);
      final rx = r;
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(t * 2 * math.pi * .15);
      final rect = Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry.abs() * 2);
      canvas.drawOval(rect, line);
      canvas.restore();
    }

    // longitude lines
    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(i * (math.pi / 8) + t * 2 * math.pi * .15);
      canvas.drawCircle(Offset.zero, r, line);
      canvas.restore();
    }

    // glowing equator
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [cs.primary.withOpacity(.25), Colors.transparent],
      ).createShader(Rect.fromCircle(center: c, radius: r * 1.2));
    canvas.drawCircle(c, r * 1.2, glow);
  }

  void _drawOrbit(Canvas canvas, Offset c, double r, {required double tilt, required double phase}) {
    final p = Paint()
      ..color = Colors.white.withOpacity(.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(tilt);
    final rx = r;
    final ry = r * (0.6 + 0.1 * math.sin(phase * 2 * math.pi));
    final path = Path();
    for (int i = 0; i <= 160; i++) {
      final ang = (i / 160) * 2 * math.pi;
      final x = math.cos(ang) * rx;
      final y = math.sin(ang) * ry;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, p);
    canvas.restore();
  }

  void _drawSatellite(Canvas canvas, Offset c, double r, {required double speed, required double size, required Color color}) {
    // elliptical path with tilt
    final tilt = .35;
    final a = r;
    final b = r * .72;
    final ang = t * 2 * math.pi * speed;

    final x = c.dx + math.cos(ang) * a * math.cos(tilt) - math.sin(ang) * b * math.sin(tilt);
    final y = c.dy + math.cos(ang) * a * math.sin(tilt) + math.sin(ang) * b * math.cos(tilt);

    final body = Paint()..color = color.withOpacity(.95);
    canvas.drawCircle(Offset(x, y), size.toDouble(), body);

    // small trailing glow
    final trail = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(.35), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: size * 3));
    canvas.drawCircle(Offset(x, y), size * 3.0, trail);
  }

  void _drawRadarSweep(Canvas canvas, Offset c, double r, double t, ColorScheme cs) {
    final sweepAng = (t * 2 * math.pi) % (2 * math.pi);
    final path = Path()..moveTo(c.dx, c.dy);
    path.arcTo(Rect.fromCircle(center: c, radius: r), sweepAng, math.pi / 6, false);
    path.close();

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          cs.primary.withOpacity(.25),
          cs.primary.withOpacity(.05),
          Colors.transparent
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawPath(path, paint);
  }

  void _drawDataTicks(Canvas canvas, Offset c, double r, double t, ColorScheme cs) {
    final tick = Paint()
      ..color = Colors.white.withOpacity(.28)
      ..strokeWidth = 1.4;

    final count = 64;
    for (int i = 0; i < count; i++) {
      final a = i * (2 * math.pi / count) + t * .8;
      final inner = Offset(c.dx + math.cos(a) * (r - 6), c.dy + math.sin(a) * (r - 6));
      final outer = Offset(c.dx + math.cos(a) * (r + 6), c.dy + math.sin(a) * (r + 6));
      canvas.drawLine(inner, outer, tick);
    }

    // ring glow
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(.10), Colors.transparent],
      ).createShader(Rect.fromCircle(center: c, radius: r + 10));
    canvas.drawCircle(c, r + 10, glow);
  }

  @override
  bool shouldRepaint(covariant _HudPainter old) => old.t != t || old.cs != cs;
}

/// ------------------------------ CAPTION ------------------------------
class _Caption extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const _Caption({required this.t, required this.cs});

  String get _stage {
    // subtle stage text that cycles
    final p = (t % 1.0);
    if (p < .33) return 'Orbital Radar';
    if (p < .66) return 'Telemetry Sweep';
    return 'Deep Space HUD';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mission Console',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
                shadows: [Shadow(blurRadius: 10, color: Colors.black87)],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _stage,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
