// lib/src/widgets/cosmic_zoom_header.dart
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cosmic zoom: Milky Way → Galaxy → Solar System → Earth → Reverse
/// Use inside SliverAppBar → FlexibleSpaceBar(background: CosmicZoomHeader())
class CosmicZoomHeader extends StatefulWidget {
  const CosmicZoomHeader({super.key, this.loop = true});
  final bool loop;

  @override
  State<CosmicZoomHeader> createState() => _CosmicZoomHeaderState();
}

class _CosmicZoomHeaderState extends State<CosmicZoomHeader>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _zoomPhase;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 24000),
    );

    widget.loop ? _ctrl.repeat() : _ctrl.forward();

    _zoomPhase = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _zoomPhase,
      builder: (context, _) {
        // Phase breakdown:
        // 0.00 - 0.20: Milky Way (wide view)
        // 0.20 - 0.35: Zoom to our galaxy region
        // 0.35 - 0.50: Solar system view
        // 0.50 - 0.65: Earth close-up
        // 0.65 - 0.80: Hold on Earth
        // 0.80 - 1.00: Reverse zoom back to Milky Way

        final t = _zoomPhase.value;
        final CosmicPhase phase;
        final double phaseProgress;

        if (t < 0.20) {
          phase = CosmicPhase.milkyWay;
          phaseProgress = t / 0.20;
        } else if (t < 0.35) {
          phase = CosmicPhase.galaxyZoom;
          phaseProgress = (t - 0.20) / 0.15;
        } else if (t < 0.50) {
          phase = CosmicPhase.solarSystem;
          phaseProgress = (t - 0.35) / 0.15;
        } else if (t < 0.65) {
          phase = CosmicPhase.earthZoom;
          phaseProgress = (t - 0.50) / 0.15;
        } else if (t < 0.80) {
          phase = CosmicPhase.earthHold;
          phaseProgress = (t - 0.65) / 0.15;
        } else {
          phase = CosmicPhase.reverseZoom;
          phaseProgress = (t - 0.80) / 0.20;
        }

        return LayoutBuilder(builder: (_, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Dynamic cosmic background
              _CosmicBackground(phase: phase, progress: phaseProgress),

              // Main cosmic layers
              _CosmicZoomLayers(
                phase: phase,
                progress: phaseProgress,
                globalTime: t,
              ),

              // Title overlay
              Positioned(
                left: 16,
                bottom: 16,
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getPhaseTitle(phase),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.sp,
                              letterSpacing: 2.0,
                              shadows: [
                                 Shadow(
                                  blurRadius: 20.r,
                                  color: Colors.black87,
                                  offset: Offset(0, 4),
                                ),
                                Shadow(
                                  blurRadius: 40.r,
                                  color: Colors.blue.withOpacity(0.5),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _getPhaseSubtitle(phase),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              fontSize: 10.sp,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  blurRadius: 12,
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  String _getPhaseTitle(CosmicPhase phase) {
    switch (phase) {
      case CosmicPhase.milkyWay:
        return 'THE MILKY WAY';
      case CosmicPhase.galaxyZoom:
        return 'APPROACHING OUR GALAXY';
      case CosmicPhase.solarSystem:
        return 'THE SOLAR SYSTEM';
      case CosmicPhase.earthZoom:
        return 'PLANET EARTH';
      case CosmicPhase.earthHold:
        return 'HOME';
      case CosmicPhase.reverseZoom:
        return 'COSMIC PERSPECTIVE';
    }
  }

  String _getPhaseSubtitle(CosmicPhase phase) {
    switch (phase) {
      case CosmicPhase.milkyWay:
        return '100,000 light-years across';
      case CosmicPhase.galaxyZoom:
        return 'Orion Arm - Solar Neighborhood';
      case CosmicPhase.solarSystem:
        return '4.6 billion years old';
      case CosmicPhase.earthZoom:
        return 'The Blue Marble';
      case CosmicPhase.earthHold:
        return 'Our Pale Blue Dot';
      case CosmicPhase.reverseZoom:
        return 'Journey Through Space';
    }
  }
}

enum CosmicPhase {
  milkyWay,
  galaxyZoom,
  solarSystem,
  earthZoom,
  earthHold,
  reverseZoom,
}

//═══════════════════════════════════════════════════════════
// COSMIC BACKGROUND
//═══════════════════════════════════════════════════════════

class _CosmicBackground extends StatelessWidget {
  final CosmicPhase phase;
  final double progress;

  const _CosmicBackground({
    required this.phase,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    Color topColor, bottomColor;

    switch (phase) {
      case CosmicPhase.milkyWay:
      case CosmicPhase.reverseZoom:
        topColor = const Color(0xFF000308);
        bottomColor = const Color(0xFF0A0520);
        break;
      case CosmicPhase.galaxyZoom:
        topColor = const Color(0xFF050212);
        bottomColor = const Color(0xFF0F0628);
        break;
      case CosmicPhase.solarSystem:
        topColor = const Color(0xFF000000);
        bottomColor = const Color(0xFF0A0F1E);
        break;
      case CosmicPhase.earthZoom:
      case CosmicPhase.earthHold:
        topColor = const Color(0xFF000C1A);
        bottomColor = const Color(0xFF001A33);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
      ),
    );
  }
}

//═══════════════════════════════════════════════════════════
// COSMIC ZOOM LAYERS
//═══════════════════════════════════════════════════════════

class _CosmicZoomLayers extends StatelessWidget {
  final CosmicPhase phase;
  final double progress;
  final double globalTime;

  const _CosmicZoomLayers({
    required this.phase,
    required this.progress,
    required this.globalTime,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Star field (always visible, different densities)
        _StarField(
          phase: phase,
          progress: progress,
          time: globalTime,
        ),

        // Phase-specific cosmic objects
        if (phase == CosmicPhase.milkyWay || phase == CosmicPhase.reverseZoom)
          _MilkyWayView(progress: progress, time: globalTime),

        if (phase == CosmicPhase.galaxyZoom)
          _GalaxyZoomView(progress: progress, time: globalTime),

        if (phase == CosmicPhase.solarSystem)
          _SolarSystemView(progress: progress, time: globalTime),

        if (phase == CosmicPhase.earthZoom || phase == CosmicPhase.earthHold)
          _EarthView(
            progress: progress,
            time: globalTime,
            isHolding: phase == CosmicPhase.earthHold,
          ),

        if (phase == CosmicPhase.reverseZoom && progress > 0.5)
          _SolarSystemView(
            progress: 1 - ((progress - 0.5) * 2),
            time: globalTime,
          ),
      ],
    );
  }
}

//═══════════════════════════════════════════════════════════
// STAR FIELD
//═══════════════════════════════════════════════════════════

class _StarField extends StatelessWidget {
  final CosmicPhase phase;
  final double progress;
  final double time;

  const _StarField({
    required this.phase,
    required this.progress,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    double density;
    double speed;

    switch (phase) {
      case CosmicPhase.milkyWay:
        density = 0.8;
        speed = 0.05;
        break;
      case CosmicPhase.galaxyZoom:
        density = lerpDouble(0.8, 1.2, progress)!;
        speed = 0.1 + progress * 0.2;
        break;
      case CosmicPhase.solarSystem:
        density = 1.5;
        speed = 0.3;
        break;
      case CosmicPhase.earthZoom:
        density = lerpDouble(1.5, 0.4, progress)!;
        speed = 0.2;
        break;
      case CosmicPhase.earthHold:
        density = 0.3;
        speed = 0.1;
        break;
      case CosmicPhase.reverseZoom:
        density = lerpDouble(0.3, 0.8, progress)!;
        speed = 0.15;
        break;
    }

    return CustomPaint(
      painter: _StarFieldPainter(
        density: density,
        speed: speed,
        time: time,
        seed: 123,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final double density;
  final double speed;
  final double time;
  final int seed;

  _StarFieldPainter({
    required this.density,
    required this.speed,
    required this.time,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final count = (300 * density).toInt().clamp(50, 600);

    for (int i = 0; i < count; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;

      // Parallax motion
      final parallaxFactor = rnd.nextDouble();
      final x = baseX + (time * speed * 20 * parallaxFactor);
      final y = baseY + (time * speed * 10 * parallaxFactor);

      // Wrap around
      final px = x % size.width;
      final py = y % size.height;

      // Twinkle
      final twinkle = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(time * 10 + i * 0.1));
      final radius = 0.5 + rnd.nextDouble() * 1.8;
      final opacity = (0.4 + rnd.nextDouble() * 0.6) * twinkle;

      canvas.drawCircle(
        Offset(px, py),
        radius,
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) =>
      oldDelegate.time != time ||
          oldDelegate.density != density ||
          oldDelegate.speed != speed;
}

//═══════════════════════════════════════════════════════════
// MILKY WAY VIEW
//═══════════════════════════════════════════════════════════

class _MilkyWayView extends StatelessWidget {
  final double progress;
  final double time;

  const _MilkyWayView({required this.progress, required this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MilkyWayPainter(time: time),
    );
  }
}

class _MilkyWayPainter extends CustomPainter {
  final double time;

  _MilkyWayPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Galactic core (bright center)
    final coreRadius = size.width * 0.08;
    canvas.drawCircle(
      center,
      coreRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE5B4).withOpacity(0.9),
            const Color(0xFFFFB347).withOpacity(0.6),
            const Color(0xFF8B4513).withOpacity(0.2),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: coreRadius)),
    );

    // Spiral arms
    final armPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    for (int arm = 0; arm < 4; arm++) {
      final armPath = Path();
      final armAngleOffset = (arm * math.pi / 2) + (time * 0.5);

      for (double t = 0; t <= 1.0; t += 0.01) {
        final angle = armAngleOffset + t * 4 * math.pi;
        final radius = (size.width * 0.15) + (t * size.width * 0.35);
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        if (t == 0) {
          armPath.moveTo(x, y);
        } else {
          armPath.lineTo(x, y);
        }
      }

      canvas.drawPath(
        armPath,
        armPaint
          ..shader = LinearGradient(
            colors: [
              const Color(0xFF9370DB).withOpacity(0.6),
              const Color(0xFF4169E1).withOpacity(0.3),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }

    // Star clusters in arms
    final rnd = math.Random(456);
    for (int i = 0; i < 150; i++) {
      final angle = rnd.nextDouble() * 2 * math.pi + time * 0.5;
      final radius = (size.width * 0.15) + (rnd.nextDouble() * size.width * 0.35);
      final spread = (rnd.nextDouble() - 0.5) * 40;

      final x = center.dx + radius * math.cos(angle) + spread;
      final y = center.dy + radius * math.sin(angle) + spread;

      canvas.drawCircle(
        Offset(x, y),
        rnd.nextDouble() * 2.5 + 0.5,
        Paint()..color = Colors.white.withOpacity(0.5 + rnd.nextDouble() * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MilkyWayPainter oldDelegate) =>
      oldDelegate.time != time;
}

//═══════════════════════════════════════════════════════════
// GALAXY ZOOM VIEW
//═══════════════════════════════════════════════════════════

class _GalaxyZoomView extends StatelessWidget {
  final double progress;
  final double time;

  const _GalaxyZoomView({required this.progress, required this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GalaxyZoomPainter(progress: progress, time: time),
    );
  }
}

class _GalaxyZoomPainter extends CustomPainter {
  final double progress;
  final double time;

  _GalaxyZoomPainter({required this.progress, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Zooming into a section of the galaxy
    final scale = 1.0 + progress * 3.0;
    final nebulaeCount = 8;

    // Nebula clouds
    final rnd = math.Random(789);
    for (int i = 0; i < nebulaeCount; i++) {
      final angle = (i / nebulaeCount) * 2 * math.pi;
      final dist = (size.width * 0.2) / scale;
      final x = center.dx + dist * math.cos(angle + time * 0.3);
      final y = center.dy + dist * math.sin(angle + time * 0.3);

      final nebulaRadius = (60 + rnd.nextDouble() * 80) / scale;

      canvas.drawCircle(
        Offset(x, y),
        nebulaRadius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Color.lerp(const Color(0xFFFF6B9D), const Color(0xFF4A90E2), i / nebulaeCount)!
                  .withOpacity(0.3),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: Offset(x, y), radius: nebulaRadius))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      );
    }

    // Star clusters getting closer
    for (int i = 0; i < 80; i++) {
      final baseAngle = rnd.nextDouble() * 2 * math.pi;
      final baseDist = rnd.nextDouble() * size.width * 0.4;
      final x = center.dx + (baseDist / scale) * math.cos(baseAngle);
      final y = center.dy + (baseDist / scale) * math.sin(baseAngle);

      final starSize = (1.5 + rnd.nextDouble() * 2.5) * scale.clamp(1.0, 2.0);

      canvas.drawCircle(
        Offset(x, y),
        starSize,
        Paint()..color = Colors.white.withOpacity(0.7 + rnd.nextDouble() * 0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyZoomPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
}

//═══════════════════════════════════════════════════════════
// SOLAR SYSTEM VIEW
//═══════════════════════════════════════════════════════════

class _SolarSystemView extends StatelessWidget {
  final double progress;
  final double time;

  const _SolarSystemView({required this.progress, required this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SolarSystemPainter(progress: progress, time: time),
    );
  }
}

class _SolarSystemPainter extends CustomPainter {
  final double progress;
  final double time;

  _SolarSystemPainter({required this.progress, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Sun
    final sunRadius = 35.0 + progress * 15;
    canvas.drawCircle(
      center,
      sunRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF4E6),
            const Color(0xFFFFD700),
            const Color(0xFFFF8C00).withOpacity(0.8),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: sunRadius)),
    );

    // Sun glow
    canvas.drawCircle(
      center,
      sunRadius * 1.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: sunRadius * 1.5))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Planets
    final planets = [
      {'name': 'Mercury', 'orbit': 70.0, 'size': 4.0, 'color': const Color(0xFF8C7853), 'speed': 4.0},
      {'name': 'Venus', 'orbit': 95.0, 'size': 9.0, 'color': const Color(0xFFFFC649), 'speed': 3.2},
      {'name': 'Earth', 'orbit': 125.0, 'size': 10.0, 'color': const Color(0xFF4A90E2), 'speed': 2.5},
      {'name': 'Mars', 'orbit': 155.0, 'size': 6.0, 'color': const Color(0xFFCD5C5C), 'speed': 2.0},
      {'name': 'Jupiter', 'orbit': 210.0, 'size': 22.0, 'color': const Color(0xFFD4A574), 'speed': 1.2},
      {'name': 'Saturn', 'orbit': 270.0, 'size': 19.0, 'color': const Color(0xFFFAD5A5), 'speed': 0.9},
    ];

    for (final planet in planets) {
      final orbit = planet['orbit'] as double;
      final planetSize = planet['size'] as double;
      final color = planet['color'] as Color;
      final speed = planet['speed'] as double;

      // Orbit line
      canvas.drawCircle(
        center,
        orbit,
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      // Planet position
      final angle = time * speed * 2 * math.pi;
      final planetPos = Offset(
        center.dx + orbit * math.cos(angle),
        center.dy + orbit * math.sin(angle),
      );

      // Planet
      canvas.drawCircle(
        planetPos,
        planetSize,
        Paint()
          ..shader = RadialGradient(
            colors: [color, color.withOpacity(0.7)],
            center: const Alignment(-0.3, -0.3),
          ).createShader(Rect.fromCircle(center: planetPos, radius: planetSize)),
      );

      // Earth special: show as we zoom in
      if (planet['name'] == 'Earth' && progress > 0.5) {
        final earthGlow = lerpDouble(0, 15, (progress - 0.5) * 2)!;
        canvas.drawCircle(
          planetPos,
          planetSize + earthGlow,
          Paint()
            ..shader = RadialGradient(
              colors: [
                const Color(0xFF4A90E2).withOpacity(0.5),
                Colors.transparent,
              ],
            ).createShader(
                Rect.fromCircle(center: planetPos, radius: planetSize + earthGlow))
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        );
      }
    }

    // Asteroid belt
    final rnd = math.Random(321);
    for (int i = 0; i < 100; i++) {
      final orbit = 175 + rnd.nextDouble() * 25;
      final angle = rnd.nextDouble() * 2 * math.pi + time * 0.5;
      final x = center.dx + orbit * math.cos(angle);
      final y = center.dy + orbit * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        0.8 + rnd.nextDouble() * 1.2,
        Paint()..color = Colors.grey.withOpacity(0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SolarSystemPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.time != time;
}

//═══════════════════════════════════════════════════════════
// EARTH VIEW
//═══════════════════════════════════════════════════════════

class _EarthView extends StatelessWidget {
  final double progress;
  final double time;
  final bool isHolding;

  const _EarthView({
    required this.progress,
    required this.time,
    required this.isHolding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EarthPainter(
        progress: progress,
        time: time,
        isHolding: isHolding,
      ),
    );
  }
}

class _EarthPainter extends CustomPainter {
  final double progress;
  final double time;
  final bool isHolding;

  _EarthPainter({
    required this.progress,
    required this.time,
    required this.isHolding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final baseRadius = 80.0;
    final earthRadius = isHolding
        ? baseRadius
        : lerpDouble(0, baseRadius, progress)!;

    if (earthRadius < 5) return;

    // Space glow
    canvas.drawCircle(
      center,
      earthRadius * 1.3,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF1E3A8A).withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: earthRadius * 1.3))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // Earth body
    canvas.drawCircle(
      center,
      earthRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF4A90E2),
            const Color(0xFF2563EB),
            const Color(0xFF1E3A8A),
          ],
          stops: const [0.0, 0.6, 1.0],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: center, radius: earthRadius)),
    );

    // Continents (simplified)
    final continentPaint = Paint()
      ..color = const Color(0xFF2D5016).withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final rotation = time * 0.5 * 2 * math.pi;

    // Africa-like shape
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final africa = Path()
      ..moveTo(-15, -25)
      ..quadraticBezierTo(-20, -10, -15, 5)
      ..quadraticBezierTo(-10, 20, 0, 30)
      ..quadraticBezierTo(10, 25, 15, 10)
      ..quadraticBezierTo(18, -5, 12, -20)
      ..quadraticBezierTo(5, -28, -15, -25);
    canvas.drawPath(africa, continentPaint);

    // Europe-Asia-like shape
    final eurasia = Path()
      ..moveTo(25, -30)
      ..quadraticBezierTo(40, -25, 45, -15)
      ..quadraticBezierTo(48, 0, 42, 15)
      ..quadraticBezierTo(35, 25, 20, 20)
      ..quadraticBezierTo(10, 10, 15, -10)
      ..quadraticBezierTo(20, -25, 25, -30);
    canvas.drawPath(eurasia, continentPaint);

    canvas.restore();

    // Clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final rnd = math.Random(654);
    for (int i = 0; i < 15; i++) {
      final angle = (i / 15) * 2 * math.pi + rotation * 1.5;
      final dist = earthRadius * (0.88 + rnd.nextDouble() * 0.1);
      final x = center.dx + dist * math.cos(angle);
      final y = center.dy + dist * math.sin(angle);
      final cloudSize = earthRadius * (0.12 + rnd.nextDouble() * 0.08);

      canvas.drawCircle(Offset(x, y), cloudSize, cloudPaint);
    }

    // Atmosphere rim light
    canvas.drawCircle(
      center,
      earthRadius,
      Paint()
        ..color = const Color(0xFF7DD3FC).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Terminator (day/night shadow)
    final terminatorPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: earthRadius));

    canvas.drawPath(
      terminatorPath,
      Paint()
        ..shader = LinearGradient(
          begin: const Alignment(-0.5, -0.5),
          end: const Alignment(0.8, 0.8),
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
          ],
          stops: const [0.45, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: earthRadius)),
    );

    // City lights on night side (if holding)
    if (isHolding) {
      final cityPaint = Paint()..color = const Color(0xFFFFD700).withOpacity(0.6);

      for (int i = 0; i < 30; i++) {
        final angle = (i / 30) * 2 * math.pi + rotation;

        // Only on night side
        final normalizedAngle = (angle + math.pi) % (2 * math.pi);
        if (normalizedAngle > math.pi * 0.7 && normalizedAngle < math.pi * 1.3) {
          final dist = earthRadius * (0.75 + rnd.nextDouble() * 0.15);
          final x = center.dx + dist * math.cos(angle);
          final y = center.dy + dist * math.sin(angle);

          canvas.drawCircle(
            Offset(x, y),
            0.8 + rnd.nextDouble() * 1.2,
            cityPaint,
          );
        }
      }
    }

    // Moon (small, orbiting)
    final moonOrbit = earthRadius * 2.2;
    final moonAngle = time * 1.5 * 2 * math.pi;
    final moonPos = Offset(
      center.dx + moonOrbit * math.cos(moonAngle),
      center.dy + moonOrbit * math.sin(moonAngle),
    );
    final moonRadius = earthRadius * 0.27;

    canvas.drawCircle(
      moonPos,
      moonRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE5E5E5),
            const Color(0xFFA0A0A0),
          ],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: moonPos, radius: moonRadius)),
    );

    // Moon craters
    canvas.drawCircle(
      moonPos.translate(moonRadius * 0.3, -moonRadius * 0.2),
      moonRadius * 0.15,
      Paint()..color = const Color(0xFF808080).withOpacity(0.3),
    );
    canvas.drawCircle(
      moonPos.translate(-moonRadius * 0.25, moonRadius * 0.3),
      moonRadius * 0.2,
      Paint()..color = const Color(0xFF808080).withOpacity(0.3),
    );
  }

  @override
  bool shouldRepaint(covariant _EarthPainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.time != time ||
          oldDelegate.isHolding != isHolding;
}