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
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _phase;
  late final Animation<double> _descent;
  late final Animation<double> _retroThrusters;
  late final Animation<double> _atmosphericEntry;
  late final Animation<double> _landingGear;
  late final Animation<double> _dustPlume;
  late final Animation<double> _astronautDeploy;
  late final Animation<double> _planetRotation;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 15000),
    );

    widget.loop ? _ctrl.repeat() : _ctrl.forward();
    _phase = CurvedAnimation(parent: _ctrl, curve: Curves.linear);

    // Orbital descent trajectory
    _descent = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.1, end: 0.15)
            .chain(CurveTween(curve: const Interval(0.00, 0.15, curve: Curves.easeOut))),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.15, end: 0.45)
            .chain(CurveTween(curve: const Interval(0.15, 0.40, curve: Curves.easeInOutCubic))),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.45, end: 0.70)
            .chain(CurveTween(curve: const Interval(0.40, 0.65, curve: Curves.easeInCubic))),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.70, end: 0.75)
            .chain(CurveTween(curve: const Interval(0.65, 0.75, curve: Curves.easeOut))),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 0.75)
            .chain(CurveTween(curve: const Interval(0.75, 1.00, curve: Curves.linear))),
        weight: 25,
      ),
    ]).animate(_ctrl);

    // Retro-thruster firing sequence
    _retroThrusters = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.00, 0.20, curve: Curves.linear))),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: const Interval(0.20, 0.35, curve: Curves.easeIn))),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8)
            .chain(CurveTween(curve: const Interval(0.35, 0.60, curve: Curves.easeInOut))),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.60, 0.75, curve: Curves.easeOut))),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.75, 1.00, curve: Curves.linear))),
        weight: 25,
      ),
    ]).animate(_ctrl);

    // Atmospheric entry effects
    _atmosphericEntry = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.00, 0.25, curve: Curves.linear))),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: const Interval(0.25, 0.40, curve: Curves.easeIn))),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.40, 0.60, curve: Curves.easeOut))),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.60, 1.00, curve: Curves.linear))),
        weight: 40,
      ),
    ]).animate(_ctrl);

    // Landing gear deployment
    _landingGear = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.50, 0.70, curve: Curves.easeInOut),
    );

    // Dust plume on touchdown
    _dustPlume = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.00, 0.70, curve: Curves.linear))),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: const Interval(0.70, 0.75, curve: Curves.easeOut))),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.3)
            .chain(CurveTween(curve: const Interval(0.75, 0.90, curve: Curves.easeOut))),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 0.0)
            .chain(CurveTween(curve: const Interval(0.90, 1.00, curve: Curves.easeOut))),
        weight: 10,
      ),
    ]).animate(_ctrl);

    // Astronaut deployment
    _astronautDeploy = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.80, 1.00, curve: Curves.easeInOut),
    );

    // Planet rotation for parallax
    _planetRotation = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    );
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
      animation: _phase,
      builder: (context, _) {
        return LayoutBuilder(builder: (_, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;

          final double descentY = h * _descent.value;
          final double thrusterIntensity = _retroThrusters.value;
          final double atmosphericGlow = _atmosphericEntry.value;
          final double landingGearProgress = _landingGear.value;
          final double dustOpacity = _dustPlume.value;
          final double astronautProgress = _astronautDeploy.value;
          final double planetRot = _planetRotation.value * 2 * math.pi;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Deep space background
              _DeepSpaceBackground(phase: _phase.value),

              // Nebula effects
              Positioned.fill(
                child: CustomPaint(
                  painter: _NebulaPainter(phase: _phase.value),
                  willChange: true,
                ),
              ),

              // Planet with atmosphere
              Positioned(
                bottom: -h * 0.3,
                left: 0,
                right: 0,
                child: _Exoplanet(
                  rotation: planetRot,
                  atmosphereDensity: atmosphericGlow,
                ),
              ),

              // Ring system
              Positioned.fill(
                child: CustomPaint(
                  painter: _RingSystemPainter(rotation: planetRot * 0.3),
                  willChange: true,
                ),
              ),

              // Moons
              Positioned(
                right: w * 0.1 + math.sin(planetRot) * 20,
                top: h * 0.15 + math.cos(planetRot) * 10,
                child: _Moon(radius: 25, phase: planetRot * 2),
              ),

              // Landing module with heat shield
              Positioned(
                left: w * 0.42,
                top: descentY,
                child: _LandingModule(
                  thrusterIntensity: thrusterIntensity,
                  atmosphericGlow: atmosphericGlow,
                  landingGearProgress: landingGearProgress,
                ),
              ),

              // Dust plume
              if (dustOpacity > 0.01)
                Positioned(
                  left: w * 0.35,
                  right: w * 0.35,
                  bottom: h * 0.18,
                  height: 120,
                  child: Opacity(
                    opacity: dustOpacity,
                    child: _LandingDust(phase: _phase.value),
                  ),
                ),

              // Astronaut with rover
              if (astronautProgress > 0.01)
                Positioned(
                  left: w * 0.43 + astronautProgress * 50,
                  bottom: h * 0.18,
                  child: Opacity(
                    opacity: astronautProgress,
                    child: _AstronautWithRover(walkCycle: _phase.value),
                  ),
                ),

              // Mission title
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Exoplanet Exploration Program',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            letterSpacing: .5,
                            shadows: [
                              Shadow(blurRadius: 20, color: Colors.black87, offset: Offset(0, 3)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mars-2035 Mission',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: .3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Scientific instruments badges
              Positioned(
                left: 0,
                right: 0,
                bottom: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BadgeWrapper(
                      tooltip: 'Spectrometer',
                      onTap: () => Navigator.pushNamed(context, '/spectrometer'),
                      child: SpectrometerBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 12),
                    _BadgeWrapper(
                      tooltip: 'Drill Core',
                      onTap: () => Navigator.pushNamed(context, '/drill'),
                      child: DrillBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 12),
                    _BadgeWrapper(
                      tooltip: 'Weather Station',
                      onTap: () => Navigator.pushNamed(context, '/weather'),
                      child: WeatherBadge(t: _ctrl.value, cs: cs),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

// Badge wrapper
class _BadgeWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String tooltip;
  const _BadgeWrapper({required this.child, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        color: Colors.white.withOpacity(.10),
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            width: 94,
            height: 62,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 1),
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26, offset: Offset(0, 2))],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Spectrometer Badge
class SpectrometerBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const SpectrometerBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpectrometerPainter(t, cs),
      willChange: true,
    );
  }
}

class _SpectrometerPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _SpectrometerPainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Prism
    final prismPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          cs.primary.withOpacity(0.3),
          cs.primary.withOpacity(0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final prism = Path()
      ..moveTo(w * 0.3, h * 0.3)
      ..lineTo(w * 0.7, h * 0.3)
      ..lineTo(w * 0.5, h * 0.8)
      ..close();

    canvas.drawPath(prism, prismPaint);

    // Light beam
    final beamPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, h * 0.4),
      Offset(w * 0.3, h * 0.4),
      beamPaint,
    );

    // Spectrum
    final spectrumColors = [
      Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple
    ];

    for (int i = 0; i < spectrumColors.length; i++) {
      final x = w * 0.7 + i * w * 0.04;
      final intensity = (math.sin((t * 2 * math.pi) + i * 0.5) + 1) * 0.5;

      canvas.drawLine(
        Offset(x, h * 0.3),
        Offset(x + w * 0.02, h * 0.8),
        Paint()
          ..color = spectrumColors[i].withOpacity(0.3 + intensity * 0.7)
          ..strokeWidth = 3,
      );
    }

    // Data points
    final dataPaint = Paint()..color = cs.primary.withOpacity(0.9);
    for (int i = 0; i < 5; i++) {
      final x = w * (0.15 + i * 0.15);
      final y = h * (0.6 + math.sin((t * 2 * math.pi) + i * 0.8) * 0.1);
      canvas.drawCircle(Offset(x, y), 2, dataPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpectrometerPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

// Drill Badge
class DrillBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const DrillBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DrillPainter(t, cs),
      willChange: true,
    );
  }
}

class _DrillPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _DrillPainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Drill body
    final drillPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade600],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final drillBody = Path()
      ..moveTo(w * 0.45, 0)
      ..lineTo(w * 0.55, 0)
      ..lineTo(w * 0.55, h * 0.6)
      ..lineTo(w * 0.52, h * 0.7)
      ..lineTo(w * 0.48, h * 0.7)
      ..lineTo(w * 0.45, h * 0.6)
      ..close();

    canvas.drawPath(drillBody, drillPaint);

    // Drill bit (rotating)
    final rotation = t * 2 * math.pi;
    canvas.save();
    canvas.translate(w * 0.5, h * 0.7);
    canvas.rotate(rotation);

    final bitPaint = Paint()..color = Colors.grey.shade800;
    for (int i = 0; i < 3; i++) {
      final angle = i * 2 * math.pi / 3;
      canvas.drawLine(
        Offset(0, 0),
        Offset(math.cos(angle) * w * 0.15, math.sin(angle) * w * 0.15),
        bitPaint,
      );
    }
    canvas.restore();

    // Core sample
    final coreY = h * 0.7 + (1 - math.cos(t * 2 * math.pi)) * h * 0.2;
    final corePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.brown.shade400, Colors.brown.shade600],
      ).createShader(Rect.fromLTWH(w * 0.42, coreY, w * 0.16, h * 0.1));

    canvas.drawRect(
      Rect.fromLTWH(w * 0.42, coreY, w * 0.16, h * 0.1),
      corePaint,
    );

    // Layers indicator
    final layerPaint = Paint()
      ..color = cs.primary.withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final y = h * (0.75 + i * 0.08);
      canvas.drawLine(
        Offset(w * 0.3, y),
        Offset(w * 0.7, y),
        layerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DrillPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

// Weather Station Badge
class WeatherBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const WeatherBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WeatherStationPainter(t, cs),
      willChange: true,
    );
  }
}

class _WeatherStationPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _WeatherStationPainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Station base
    final basePaint = Paint()
      ..color = Colors.grey.shade700;

    canvas.drawRect(
      Rect.fromLTWH(w * 0.4, h * 0.7, w * 0.2, h * 0.25),
      basePaint,
    );

    // Solar panel
    final panelPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.shade800, Colors.blue.shade600],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, h * 0.2, w * 0.25, h * 0.15),
      panelPaint,
    );

    // Panel lines
    final linePaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(w * 0.15, h * (0.2 + i * 0.05)),
        Offset(w * 0.4, h * (0.2 + i * 0.05)),
        linePaint,
      );
    }

    // Antenna
    final antennaPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.5, h * 0.7),
      Offset(w * 0.5, h * 0.3),
      antennaPaint,
    );

    // Signal waves
    final wavePaint = Paint()
      ..color = cs.primary.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final radius = 5.0 + i * 5.0 + (math.sin(t * 2 * math.pi) + 1) * 2.0;
      canvas.drawCircle(
        Offset(w * 0.5, h * 0.3),
        radius,
        wavePaint,
      );
    }

    // Wind vane
    final windAngle = t * 2 * math.pi;
    canvas.save();
    canvas.translate(w * 0.65, h * 0.4);
    canvas.rotate(windAngle);

    final vanePaint = Paint()..color = Colors.red;
    canvas.drawPath(
      Path()
        ..moveTo(0, -w * 0.08)
        ..lineTo(w * 0.04, 0)
        ..lineTo(0, w * 0.08)
        ..lineTo(-w * 0.04, 0)
        ..close(),
      vanePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WeatherStationPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

// Deep Space Background
class _DeepSpaceBackground extends StatelessWidget {
  final double phase;
  const _DeepSpaceBackground({required this.phase});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000),
            Color(0xFF0A0A1A),
            Color(0xFF0F0F2A),
            Color(0xFF000000),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _StarFieldPainter(phase: phase),
        willChange: true,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final double phase;
  _StarFieldPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(123);

    // Background stars
    for (int i = 0; i < 200; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final brightness = rnd.nextDouble();
      final twinkle = (math.sin((phase * 2 * math.pi) + i * 0.1) + 1) * 0.5;

      canvas.drawCircle(
        Offset(x, y),
        0.5 + brightness * 1.5,
        Paint()..color = Colors.white.withOpacity(0.3 + brightness * 0.7 * twinkle),
      );
    }

    // Bright stars
    for (int i = 0; i < 20; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final twinkle = (math.sin((phase * 2 * math.pi) + i * 0.3) + 1) * 0.5;

      final gradient = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.9 + twinkle * 0.1),
          Colors.white.withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 10));

      canvas.drawCircle(
        Offset(x, y),
        2 + twinkle * 2,
        Paint()..shader = gradient,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => oldDelegate.phase != phase;
}

// Nebula effects
class _NebulaPainter extends CustomPainter {
  final double phase;
  _NebulaPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.purple.withOpacity(0.1),
          Colors.blue.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.7, size.height * 0.3),
        radius: 150,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      150 + math.sin(phase * 2 * math.pi) * 10,
      nebulaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NebulaPainter oldDelegate) => oldDelegate.phase != phase;
}

// Exoplanet with atmosphere
class _Exoplanet extends StatelessWidget {
  final double rotation;
  final double atmosphereDensity;
  const _Exoplanet({required this.rotation, required this.atmosphereDensity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ExoplanetPainter(rotation: rotation, atmosphereDensity: atmosphereDensity),
      willChange: true,
    );
  }
}

class _ExoplanetPainter extends CustomPainter {
  final double rotation;
  final double atmosphereDensity;
  _ExoplanetPainter({required this.rotation, required this.atmosphereDensity});

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final planetRadius = h * 0.6;
    final center = Offset(size.width * 0.5, h - planetRadius);

    // Planet surface
    final surfacePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF8B7355),
          const Color(0xFF6B5D54),
          const Color(0xFF4A3C28),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: planetRadius));

    canvas.drawCircle(center, planetRadius, surfacePaint);

    // Surface features (craters, mountains)
    final featurePaint = Paint()
      ..color = Colors.black.withOpacity(0.2);

    final rnd = math.Random(456);
    for (int i = 0; i < 15; i++) {
      final angle = rotation + i * 0.5;
      final distance = planetRadius * (0.3 + rnd.nextDouble() * 0.5);
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle) * 0.5; // Elliptical for perspective
      final radius = 5 + rnd.nextDouble() * 15;

      canvas.drawCircle(Offset(x, y), radius, featurePaint);
    }

    // Atmosphere glow
    if (atmosphereDensity > 0.01) {
      final atmospherePaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.orange.withOpacity(atmosphereDensity * 0.6),
            Colors.red.withOpacity(atmosphereDensity * 0.3),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: center, radius: planetRadius * 1.2));

      canvas.drawCircle(center, planetRadius * 1.2, atmospherePaint);
    }

    // Atmospheric entry flames
    if (atmosphereDensity > 0.5) {
      final flamePaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(atmosphereDensity),
            Colors.yellow.withOpacity(atmosphereDensity * 0.8),
            Colors.orange.withOpacity(atmosphereDensity * 0.6),
            Colors.red.withOpacity(atmosphereDensity * 0.4),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      final flamePath = Path()
        ..moveTo(size.width * 0.3, 0)
        ..quadraticBezierTo(
          size.width * 0.5,
          h * 0.3,
          size.width * 0.7,
          0,
        )
        ..lineTo(size.width * 0.7, h * 0.4)
        ..quadraticBezierTo(
          size.width * 0.5,
          h * 0.2,
          size.width * 0.3,
          h * 0.4,
        )
        ..close();

      canvas.drawPath(flamePath, flamePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ExoplanetPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.atmosphereDensity != atmosphereDensity;
}

// Ring System
class _RingSystemPainter extends CustomPainter {
  final double rotation;
  _RingSystemPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.85);
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width * 0.6),
      rotation - 0.3,
      0.6,
      false,
      ringPaint,
    );

    // Ring particles
    final particlePaint = Paint()..color = Colors.white.withOpacity(0.6);
    final rnd = math.Random(789);

    for (int i = 0; i < 50; i++) {
      final angle = rotation + i * 0.1;
      final radius = size.width * (0.55 + rnd.nextDouble() * 0.1);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle) * 0.3;

      canvas.drawCircle(Offset(x, y), 1, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingSystemPainter oldDelegate) => oldDelegate.rotation != rotation;
}

// Moon
class _Moon extends StatelessWidget {
  final double radius;
  final double phase;
  const _Moon({required this.radius, required this.phase});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade500,
            Colors.grey.shade700,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _MoonCratersPainter(phase: phase),
        willChange: true,
      ),
    );
  }
}

class _MoonCratersPainter extends CustomPainter {
  final double phase;
  _MoonCratersPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final craterPaint = Paint()..color = Colors.black.withOpacity(0.2);
    final rnd = math.Random(321);

    for (int i = 0; i < 8; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final radius = 2 + rnd.nextDouble() * 5;

      canvas.drawCircle(Offset(x, y), radius, craterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoonCratersPainter oldDelegate) => false;
}

// Landing Module
class _LandingModule extends StatelessWidget {
  final double thrusterIntensity;
  final double atmosphericGlow;
  final double landingGearProgress;
  const _LandingModule({
    required this.thrusterIntensity,
    required this.atmosphericGlow,
    required this.landingGearProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Retro thrusters
        if (thrusterIntensity > 0.01)
          Positioned(
            bottom: -40,
            child: _RetroThrusters(intensity: thrusterIntensity),
          ),

        // Heat shield glow
        if (atmosphericGlow > 0.01)
          Positioned.fill(
            child: _HeatShield(glowIntensity: atmosphericGlow),
          ),

        // Main module
        const _LanderBody(),

        // Landing gear
        _LandingGear(deployment: landingGearProgress),
      ],
    );
  }
}

class _LanderBody extends StatelessWidget {
  const _LanderBody();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 70),
      painter: _LanderBodyPainter(),
    );
  }
}

class _LanderBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Main body (hexagonal)
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF0F0F0), Color(0xFFC0C0C0), Color(0xFFA0A0A0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final body = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.85, h * 0.2)
      ..lineTo(w * 0.85, h * 0.6)
      ..lineTo(w * 0.5, h * 0.9)
      ..lineTo(w * 0.15, h * 0.6)
      ..lineTo(w * 0.15, h * 0.2)
      ..close();

    canvas.drawPath(body, bodyPaint);

    // Window
    final windowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    canvas.drawCircle(Offset(w * 0.5, h * 0.3), w * 0.2, windowPaint);

    // Window frame
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.3),
      w * 0.2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Solar panels
    final panelPaint = Paint()
      ..color = Colors.blue.shade800;

    canvas.drawRect(
      Rect.fromLTWH(-w * 0.3, h * 0.4, w * 0.25, h * 0.3),
      panelPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(w * 1.05, h * 0.4, w * 0.25, h * 0.3),
      panelPaint,
    );

    // Panel details
    final panelLinePaint = Paint()
      ..color = Colors.blue.shade600
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(-w * 0.3, h * (0.45 + i * 0.1)),
        Offset(-w * 0.05, h * (0.45 + i * 0.1)),
        panelLinePaint,
      );

      canvas.drawLine(
        Offset(w * 1.05, h * (0.45 + i * 0.1)),
        Offset(w * 1.3, h * (0.45 + i * 0.1)),
        panelLinePaint,
      );
    }

    // Antenna
    final antennaPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.5, 0),
      Offset(w * 0.5, -h * 0.15),
      antennaPaint,
    );

    canvas.drawCircle(Offset(w * 0.5, -h * 0.15), 3, antennaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RetroThrusters extends StatelessWidget {
  final double intensity;
  const _RetroThrusters({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ThrusterFlame(intensity: intensity, angle: -0.3),
        const SizedBox(width: 10),
        _ThrusterFlame(intensity: intensity, angle: 0),
        const SizedBox(width: 10),
        _ThrusterFlame(intensity: intensity, angle: 0.3),
      ],
    );
  }
}

class _ThrusterFlame extends StatelessWidget {
  final double intensity;
  final double angle;
  const _ThrusterFlame({required this.intensity, required this.angle});

  @override
  Widget build(BuildContext context) {
    final height = 20.0 + intensity * 40.0;
    final width = 8.0 + intensity * 12.0;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.9 * intensity),
              Colors.cyan.withOpacity(0.8 * intensity),
              Colors.blue.withOpacity(0.7 * intensity),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withOpacity(0.6 * intensity),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatShield extends StatelessWidget {
  final double glowIntensity;
  const _HeatShield({required this.glowIntensity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeatShieldPainter(intensity: glowIntensity),
      willChange: true,
    );
  }
}

class _HeatShieldPainter extends CustomPainter {
  final double intensity;
  _HeatShieldPainter({required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final shieldPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(intensity),
          Colors.orange.withOpacity(intensity * 0.8),
          Colors.red.withOpacity(intensity * 0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5),
        radius: size.width * 0.8,
      ));

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.8,
      shieldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HeatShieldPainter oldDelegate) =>
      oldDelegate.intensity != intensity;
}

class _LandingGear extends StatelessWidget {
  final double deployment;
  const _LandingGear({required this.deployment});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LandingGearPainter(deployment: deployment),
      willChange: true,
    );
  }
}

class _LandingGearPainter extends CustomPainter {
  final double deployment;
  _LandingGearPainter({required this.deployment});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final gearPaint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Left gear
    final leftGearAngle = deployment * math.pi / 4;
    final leftGearEnd = Offset(
      w * 0.1 - math.sin(leftGearAngle) * w * 0.2,
      h + math.cos(leftGearAngle) * w * 0.2,
    );

    canvas.drawLine(
      Offset(w * 0.2, h * 0.8),
      leftGearEnd,
      gearPaint,
    );

    // Right gear
    final rightGearAngle = deployment * math.pi / 4;
    final rightGearEnd = Offset(
      w * 0.9 + math.sin(rightGearAngle) * w * 0.2,
      h + math.cos(rightGearAngle) * w * 0.2,
    );

    canvas.drawLine(
      Offset(w * 0.8, h * 0.8),
      rightGearEnd,
      gearPaint,
    );

    // Foot pads
    if (deployment > 0.5) {
      final padPaint = Paint()..color = Colors.grey.shade600;

      canvas.drawCircle(leftGearEnd, 5, padPaint);
      canvas.drawCircle(rightGearEnd, 5, padPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LandingGearPainter oldDelegate) =>
      oldDelegate.deployment != deployment;
}

// Landing Dust
class _LandingDust extends StatelessWidget {
  final double phase;
  const _LandingDust({required this.phase});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LandingDustPainter(phase: phase),
      willChange: true,
    );
  }
}

class _LandingDustPainter extends CustomPainter {
  final double phase;
  _LandingDustPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(654);

    for (int i = 0; i < 30; i++) {
      final baseX = size.width * (0.2 + rnd.nextDouble() * 0.6);
      final baseY = size.height * (0.3 + rnd.nextDouble() * 0.5);
      final velocity = 20 + rnd.nextDouble() * 30;
      final x = baseX + math.sin(phase * 2 * math.pi + i) * velocity;
      final y = baseY - phase * 50;
      final radius = 3 + rnd.nextDouble() * 8;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.brown.withOpacity(0.4 + rnd.nextDouble() * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LandingDustPainter oldDelegate) => oldDelegate.phase != phase;
}

// Astronaut with Rover
class _AstronautWithRover extends StatelessWidget {
  final double walkCycle;
  const _AstronautWithRover({required this.walkCycle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Astronaut(walkCycle: walkCycle),
        const SizedBox(width: 10),
        _MarsRover(walkCycle: walkCycle),
      ],
    );
  }
}

class _Astronaut extends StatelessWidget {
  final double walkCycle;
  const _Astronaut({required this.walkCycle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 50),
      painter: _AstronautPainter(walkCycle: walkCycle),
      willChange: true,
    );
  }
}

class _AstronautPainter extends CustomPainter {
  final double walkCycle;
  _AstronautPainter({required this.walkCycle});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Body
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final body = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.7, h * 0.25)
      ..lineTo(w * 0.7, h * 0.6)
      ..lineTo(w * 0.5, h * 0.75)
      ..lineTo(w * 0.3, h * 0.6)
      ..lineTo(w * 0.3, h * 0.25)
      ..close();

    canvas.drawPath(body, bodyPaint);

    // Helmet
    final helmetPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

    canvas.drawCircle(Offset(w * 0.5, h * 0.15), w * 0.25, helmetPaint);

    // Visor with reflection
    final visorPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withOpacity(0.8),
          Colors.blue.withOpacity(0.4),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(w * 0.5, h * 0.15),
        radius: w * 0.2,
      ));

    canvas.drawCircle(Offset(w * 0.5, h * 0.15), w * 0.2, visorPaint);

    // Visor reflection
    final reflectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.7);

    canvas.drawPath(
      Path()
        ..moveTo(w * 0.35, h * 0.1)
        ..quadraticBezierTo(w * 0.4, h * 0.05, w * 0.45, h * 0.1)
        ..lineTo(w * 0.4, h * 0.15)
        ..close(),
      reflectionPaint,
    );

    // Arms (animated)
    final armPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    final armSwing = math.sin(walkCycle * 2 * math.pi) * 0.3;

    // Left arm
    canvas.drawLine(
      Offset(w * 0.25, h * 0.35),
      Offset(w * 0.15 + armSwing * w, h * 0.5),
      armPaint,
    );

    // Right arm
    canvas.drawLine(
      Offset(w * 0.75, h * 0.35),
      Offset(w * 0.85 - armSwing * w, h * 0.5),
      armPaint,
    );

    // Legs (animated walking)
    final legPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.1
      ..strokeCap = StrokeCap.round;

    final legSwing = math.sin(walkCycle * 2 * math.pi) * 0.4;

    // Left leg
    canvas.drawLine(
      Offset(w * 0.4, h * 0.65),
      Offset(w * 0.35 + legSwing * w, h * 0.85),
      legPaint,
    );

    // Right leg
    canvas.drawLine(
      Offset(w * 0.6, h * 0.65),
      Offset(w * 0.65 - legSwing * w, h * 0.85),
      legPaint,
    );

    // PLSS (Portable Life Support System)
    final plssPaint = Paint()
      ..color = Colors.grey.withOpacity(0.8);

    canvas.drawRect(
      Rect.fromLTWH(w * 0.75, h * 0.35, w * 0.15, h * 0.2),
      plssPaint,
    );

    // Helmet antenna
    final antennaPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.5, h * 0.05),
      Offset(w * 0.5, h * 0.12),
      antennaPaint,
    );

    canvas.drawCircle(Offset(w * 0.5, h * 0.05), 1.5, antennaPaint);
  }

  @override
  bool shouldRepaint(covariant _AstronautPainter oldDelegate) =>
      oldDelegate.walkCycle != walkCycle;
}

class _MarsRover extends StatelessWidget {
  final double walkCycle;
  const _MarsRover({required this.walkCycle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(40, 30),
      painter: _MarsRoverPainter(walkCycle: walkCycle),
      willChange: true,
    );
  }
}

class _MarsRoverPainter extends CustomPainter {
  final double walkCycle;
  _MarsRoverPainter({required this.walkCycle});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Rover body
    final bodyPaint = Paint()
      ..color = Colors.grey.shade700;

    final body = Path()
      ..moveTo(w * 0.1, h * 0.4)
      ..lineTo(w * 0.9, h * 0.4)
      ..lineTo(w * 0.85, h * 0.8)
      ..lineTo(w * 0.15, h * 0.8)
      ..close();

    canvas.drawPath(body, bodyPaint);

    // Solar panel
    final panelPaint = Paint()
      ..color = Colors.blue.shade800;

    canvas.drawRect(
      Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.2),
      panelPaint,
    );

    // Panel lines
    final panelLinePaint = Paint()
      ..color = Colors.blue.shade600
      ..strokeWidth = 1;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(w * 0.2, h * (0.2 + i * 0.1)),
        Offset(w * 0.8, h * (0.2 + i * 0.1)),
        panelLinePaint,
      );
    }

    // Wheels (animated rotation)
    final wheelPaint = Paint()..color = Colors.black;
    final wheelRotation = walkCycle * 2 * math.pi;

    for (int i = 0; i < 3; i++) {
      final x = w * (0.2 + i * 0.3);

      canvas.save();
      canvas.translate(x, h * 0.85);
      canvas.rotate(wheelRotation);

      // Wheel
      canvas.drawCircle(Offset.zero, w * 0.08, wheelPaint);

      // Wheel spokes
      final spokePaint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1;

      for (int j = 0; j < 4; j++) {
        final angle = j * math.pi / 2;
        canvas.drawLine(
          Offset.zero,
          Offset(math.cos(angle) * w * 0.06, math.sin(angle) * w * 0.06),
          spokePaint,
        );
      }

      canvas.restore();
    }

    // Camera mast
    final mastPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(w * 0.7, h * 0.2),
      Offset(w * 0.7, h * 0.05),
      mastPaint,
    );

    // Camera
    final cameraPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(w * 0.7, h * 0.05), w * 0.03, cameraPaint);

    // Antenna
    final antennaPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.3, h * 0.2),
      Offset(w * 0.3, h * 0.1),
      antennaPaint,
    );

    canvas.drawCircle(Offset(w * 0.3, h * 0.1), 2, antennaPaint);
  }

  @override
  bool shouldRepaint(covariant _MarsRoverPainter oldDelegate) =>
      oldDelegate.walkCycle != walkCycle;
}