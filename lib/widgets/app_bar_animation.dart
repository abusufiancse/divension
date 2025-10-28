// lib/src/widgets/space_launch_header.dart
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Use inside SliverAppBar → FlexibleSpaceBar(background: SpaceLaunchHeader())
class SpaceLaunchHeader extends StatefulWidget {
  const SpaceLaunchHeader({super.key, this.loop = true});
  final bool loop;

  @override
  State<SpaceLaunchHeader> createState() => _SpaceLaunchHeaderState();
}

class _SpaceLaunchHeaderState extends State<SpaceLaunchHeader>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _phase;
  late final Animation<double> _rocketY;
  late final Animation<double> _thrust;
  late final Animation<double> _skyMix;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    );

    widget.loop ? _ctrl.repeat() : _ctrl.forward();
    _phase = CurvedAnimation(parent: _ctrl, curve: Curves.linear);

    // Earth → Liftoff → Ascent → Space
    _rocketY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.84, end: 0.82)
            .chain(CurveTween(curve: const Interval(0.00, 0.16, curve: Curves.easeOut))),
        weight: 16,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.82, end: 0.56)
            .chain(CurveTween(curve: const Interval(0.16, 0.46, curve: Curves.easeInOutCubic))),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.56, end: 0.06)
            .chain(CurveTween(curve: const Interval(0.46, 1.00, curve: Curves.easeIn))),
        weight: 54,
      ),
    ]).animate(_ctrl);

    // Thrust profile
    _thrust = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: 0.95)
            .chain(CurveTween(curve: const Interval(0.00, 0.22, curve: Curves.easeIn))),
        weight: 22,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: const Interval(0.22, 0.38, curve: Curves.easeOut))),
        weight: 16,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.7)
            .chain(CurveTween(curve: const Interval(0.38, 1.00, curve: Curves.easeOutCubic))),
        weight: 62,
      ),
    ]).animate(_ctrl);

    // Sky → Space blend
    _skyMix = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.30, 0.95, curve: Curves.easeIn),
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

          final double skyBlend = _skyMix.value.clamp(0.0, 1.0).toDouble();
          final double thrust = _thrust.value.clamp(0.0, 1.0).toDouble();
          final double topY = (h * _rocketY.value);

          return Stack(
            fit: StackFit.expand,
            children: [
              _SkyToSpaceBackground(mix: skyBlend),

              // distant planet/moon (parallax, shows in space)
              if (skyBlend > 0.4)
                Positioned(
                  right: lerpDouble(-40, 20, skyBlend)!,
                  top: lerpDouble(30, 12, skyBlend)!,
                  child: Opacity(
                    opacity: (skyBlend - 0.35).clamp(0.0, 1.0),
                    child: _CelestialBody(radius: 28 + 18 * skyBlend),
                  ),
                ),

              // stars (two parallax layers)
              IgnorePointer(
                child: Stack(
                  children: [
                    Opacity(
                      opacity: (skyBlend * .9).clamp(0.0, 1.0),
                      child: CustomPaint(
                        painter: _StarsPainter(
                          seed: 11,
                          density: lerpDouble(0.2, 0.8, skyBlend)!.clamp(0.0, 1.0),
                          twinkleT: _ctrl.value,
                          parallax: 0.2,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (skyBlend).clamp(0.0, 1.0),
                      child: CustomPaint(
                        painter: _StarsPainter(
                          seed: 99,
                          density: lerpDouble(0.2, 1.0, skyBlend)!.clamp(0.0, 1.0),
                          twinkleT: (_ctrl.value + .35) % 1.0,
                          parallax: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ground horizon & launch pad (fade away as we ascend)
              Positioned.fill(
                child: Opacity(
                  opacity: (1 - skyBlend).clamp(0.0, 1.0),
                  child: const _GroundHorizon(),
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: (1 - skyBlend).clamp(0.0, 1.0),
                  child: const _LaunchPadAndTower(),
                ),
              ),

              // thick smoke near ground
              Positioned(
                left: 0, right: 0, bottom: h * 0.10,
                child: Opacity(
                  opacity: (1 - skyBlend).clamp(0.0, 1.0) * (0.55 + 0.45 * thrust),
                  child: _SmokeBand(width: w, height: 140, t: _ctrl.value),
                ),
              ),

              // ROCKET (realistic painter + exhaust)
              Positioned(
                left: w * 0.42,
                top: topY,
                child: _RocketAssembly(thrust: thrust, skyMix: skyBlend),
              ),

              // upper cloud wisps (early phase only)
              Positioned(
                left: 0, right: 0,
                top: h * (0.50 - _rocketY.value * 0.18),
                child: Opacity(
                  opacity: (1 - skyBlend).clamp(0.0, 1.0) * 0.5,
                  child: _CloudWisps(width: w, height: 120, t: _ctrl.value),
                ),
              ),

              // -------- Center Title --------
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to Divention Science Club',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: .3,
                            shadows: [
                              Shadow(blurRadius: 12, color: Colors.black54, offset: Offset(0, 2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // -------- Animated Material Badges near bottom (usable) --------
              Positioned(
                left: 0,
                right: 0,
                bottom: 56, // bottom theke ektu opor
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BadgeWrapper(
                      tooltip: 'Chemistry',
                      onTap: () => Navigator.pushNamed(context, '/chemistry'),
                      child: ChemistryBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 12),
                    _BadgeWrapper(
                      tooltip: 'Physics',
                      onTap: () => Navigator.pushNamed(context, '/physics'),
                      child: PhysicsBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 12),
                    _BadgeWrapper(
                      tooltip: 'Research News',
                      onTap: () => Navigator.pushNamed(context, '/news'),
                      child: NewsBadge(t: _ctrl.value, cs: cs),
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

////================= BADGE WRAPPER =================
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

////================= CHEMISTRY BADGE =================
class ChemistryBadge extends StatelessWidget {
  final double t; // 0..1 loop
  final ColorScheme cs;
  const ChemistryBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlaskPainter(t, cs),
      willChange: true,
    );
  }
}

class _FlaskPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _FlaskPainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final center = Offset(w * .5, h * .6);

    // flask body
    final glass = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final body = Path()
      ..moveTo(w * .30, h * .55)
      ..quadraticBezierTo(w * .30, h * .90, w * .50, h * .90)
      ..quadraticBezierTo(w * .70, h * .90, w * .70, h * .55)
      ..quadraticBezierTo(w * .60, h * .55, w * .60, h * .42)
      ..lineTo(w * .60, h * .28)
      ..lineTo(w * .40, h * .28)
      ..lineTo(w * .40, h * .42)
      ..quadraticBezierTo(w * .40, h * .55, w * .30, h * .55);
    canvas.drawPath(body, glass);

    // liquid level wave
    final lvl = h * (.70 + .02 * math.sin(t * 2 * math.pi));
    final liquid = Path()
      ..moveTo(w * .32, lvl)
      ..quadraticBezierTo(w * .45, lvl - 6 * math.sin(t * 2 * math.pi),
          w * .68, lvl)
      ..lineTo(w * .68, h * .86)
      ..quadraticBezierTo(w * .50, h * .92, w * .32, h * .86)
      ..close();
    final liqPaint = Paint()
      ..shader = LinearGradient(
        colors: [cs.primary.withOpacity(.65), cs.primary.withOpacity(.35)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, lvl, w, h - lvl));
    canvas.drawPath(liquid, liqPaint);

    // bubbles
    final rnd = math.Random(8);
    for (int i = 0; i < 7; i++) {
      final bx = w * (.36 + rnd.nextDouble() * .28);
      final by = lvl - (i * 8 + 10) - 8 * math.sin((t + i * .12) * 2 * math.pi);
      final r = 2.0 + rnd.nextDouble() * 1.5;
      canvas.drawCircle(Offset(bx, by), r, Paint()..color = Colors.white70);
    }

    // neck highlight
    canvas.drawLine(Offset(w * .45, h * .30), Offset(w * .55, h * .30),
        Paint()..color = Colors.white.withOpacity(.6)..strokeWidth = 2);

    // sparkles
    canvas.drawCircle(center.translate(-18, -10), 1.2, Paint()..color = Colors.white.withOpacity(.9));
    canvas.drawCircle(center.translate(16, -4), 1.0, Paint()..color = Colors.white70);
  }

  @override
  bool shouldRepaint(covariant _FlaskPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

////================= PHYSICS BADGE =================
class PhysicsBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const PhysicsBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PendulumPainter(t, cs),
      willChange: true,
    );
  }
}

class _PendulumPainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _PendulumPainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // rod pivot
    final pivot = Offset(w * .5, h * .10);
    canvas.drawCircle(pivot, 2, Paint()..color = Colors.white70);

    // angle oscillation
    final ang = .6 * math.sin(t * 2 * math.pi); // -0.6..0.6 rad
    final len = h * .42;

    // bob position
    final bob = Offset(
      pivot.dx + len * math.sin(ang),
      pivot.dy + len * math.cos(ang),
    );

    // rod
    canvas.drawLine(
      pivot, bob,
      Paint()
        ..color = Colors.white70
        ..strokeWidth = 2,
    );

    // bob
    final bobPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, cs.primary.withOpacity(.7)],
      ).createShader(Rect.fromCircle(center: bob, radius: 8));
    canvas.drawCircle(bob, 8, bobPaint);

    // tick marks for scale
    for (int i = -3; i <= 3; i++) {
      final a = i * .2;
      final p = Offset(
        pivot.dx + (len + 8) * math.sin(a),
        pivot.dy + (len + 8) * math.cos(a),
      );
      canvas.drawCircle(p, 1, Paint()..color = Colors.white24);
    }
  }

  @override
  bool shouldRepaint(covariant _PendulumPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

////================= NEWS BADGE =================
class NewsBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;
  const NewsBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GlobePainter(t, cs),
      willChange: true,
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double t;
  final ColorScheme cs;
  _GlobePainter(this.t, this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w * .5, h * .56);
    final r = 16.0;

    // globe body
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [cs.primary.withOpacity(.85), cs.primary.withOpacity(.35)],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawCircle(c, r, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = Colors.white54);

    // latitude lines
    for (int i = -2; i <= 2; i++) {
      final yy = i * 4.0;
      canvas.drawOval(
        Rect.fromCenter(center: c.translate(0, yy), width: r * 2, height: (r - i.abs() * 2) * 2),
        Paint()..color = Colors.white24..style = PaintingStyle.stroke,
      );
    }

    // longitude sweep (spin)
    final sweep = (t * 2 * math.pi);
    for (int i = 0; i < 3; i++) {
      final a = sweep + i * .7;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        a - .9, 1.8,
        false,
        Paint()..color = Colors.white38..style = PaintingStyle.stroke,
      );
      // slightly brighter front band
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        a + .1, .3,
        false,
        Paint()..color = Colors.white70..strokeWidth = 1.4..style = PaintingStyle.stroke,
      );
    }

    // ping notification dot
    final pingR = 3.0 + 2.0 * (0.5 + 0.5 * math.sin(t * 2 * math.pi));
    final pingPos = c.translate(r * .6, -r * .2);
    canvas.drawCircle(pingPos, pingR, Paint()..color = Colors.amberAccent.withOpacity(.9));
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.cs != cs;
}

////================= BACKGROUND =================
class _SkyToSpaceBackground extends StatelessWidget {
  final double mix;
  const _SkyToSpaceBackground({required this.mix});
  @override
  Widget build(BuildContext context) {
    const skyTop = Color(0xFFAEDBFF);
    const skyBottom = Color(0xFF1B86C9);
    const spaceTop = Color(0xFF0A0F24);
    const spaceBottom = Color(0xFF071428);

    final c1 = Color.lerp(skyTop, spaceTop, mix)!;
    final c2 = Color.lerp(skyBottom, spaceBottom, mix)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [c1, c2],
        ),
      ),
    );
  }
}

class _CelestialBody extends StatelessWidget {
  final double radius;
  const _CelestialBody({required this.radius});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2, height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFBFD4FF), Color(0xFF6F86B8), Color(0x00384C7A)],
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [BoxShadow(color: Color(0x44224488), blurRadius: 20)],
      ),
    );
  }
}

////================= GROUND & PAD =================
class _GroundHorizon extends StatelessWidget {
  const _GroundHorizon();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GroundPainter());
}

class _GroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final groundH = h * 0.22;

    final rect = Rect.fromLTWH(0, h - groundH, size.width, groundH);
    final groundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2A3F3D), Color(0xFF1A2927)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, groundPaint);

    // distant line
    final p = Path()..moveTo(0, h - groundH + 16);
    for (double x = 0; x <= size.width; x += 18) {
      p.lineTo(x, h - groundH + 16 + math.sin(x * .05) * 3);
    }
    p
      ..lineTo(size.width, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(p, Paint()..color = const Color(0xFF172321));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LaunchPadAndTower extends StatelessWidget {
  const _LaunchPadAndTower();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _PadPainter());
}

class _PadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final baseY = h * 0.82;

    // pad deck
    final padRect = Rect.fromLTWH(size.width * 0.36, baseY, size.width * 0.28, 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(padRect, const Radius.circular(3)),
      Paint()..color = const Color(0xFF404B51),
    );

    // tower body
    final towerLeft = size.width * 0.335;
    final towerTop = h * 0.44;
    final tower = RRect.fromRectAndRadius(
      Rect.fromLTWH(towerLeft, towerTop, 10, baseY - towerTop),
      const Radius.circular(3),
    );
    canvas.drawRRect(tower, Paint()..color = const Color(0xFF546870));

    // braces
    final bracePaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 2;
    for (double y = towerTop + 12; y < baseY; y += 18) {
      canvas.drawLine(Offset(towerLeft, y), Offset(towerLeft + 10, y + 10), bracePaint);
      canvas.drawLine(Offset(towerLeft + 10, y), Offset(towerLeft, y + 10), bracePaint);
    }

    // rail
    final railY = baseY - 6;
    canvas.drawLine(
      Offset(padRect.left, railY),
      Offset(padRect.right, railY),
      Paint()
        ..color = const Color(0xFFB0BEC5)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

////================= CLOUD / SMOKE =================
class _SmokeBand extends StatelessWidget {
  final double width, height, t;
  const _SmokeBand({required this.width, required this.height, required this.t});

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: width, height: height, child: CustomPaint(painter: _SmokePainter(t: t)));
}

class _SmokePainter extends CustomPainter {
  final double t;
  _SmokePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(12);
    for (int i = 0; i < 30; i++) {
      final x = size.width * (0.34 + rnd.nextDouble() * 0.32);
      final y = size.height * (0.25 + rnd.nextDouble() * 0.55);
      final r = (26 + rnd.nextDouble() * 30) * (1 + 0.08 * math.sin(t * 2 * math.pi + i));
      final p = Paint()
        ..color = const Color(0x99B0BEC5).withOpacity(0.5 + 0.3 * rnd.nextDouble())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(x, y), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _SmokePainter oldDelegate) => oldDelegate.t != t;
}

class _CloudWisps extends StatelessWidget {
  final double width, height, t;
  const _CloudWisps({required this.width, required this.height, required this.t});
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: width, height: height, child: CustomPaint(painter: _CloudWispPainter(t: t)));
}

class _CloudWispPainter extends CustomPainter {
  final double t;
  _CloudWispPainter({required this.t});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * .58)
      ..cubicTo(size.width * .20, size.height * .36, size.width * .45, size.height * .72,
          size.width * .66, size.height * .46)
      ..quadraticBezierTo(size.width * .82, size.height * .36, size.width, size.height * .50)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final stop = (0.38 + 0.18 * math.sin(t * 2 * math.pi)).clamp(0.18, .9).toDouble();
    final g = LinearGradient(
      colors: [const Color(0x33FFFFFF), const Color(0x11FFFFFF)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      stops: [0.0, stop],
    ).createShader(Offset.zero & size);

    canvas.drawPath(path, Paint()..shader = g);
  }

  @override
  bool shouldRepaint(covariant _CloudWispPainter oldDelegate) => oldDelegate.t != t;
}

////================= STARS =================
class _StarsPainter extends CustomPainter {
  final int seed;
  final double density; // 0..1
  final double twinkleT;
  final double parallax; // 0..1
  _StarsPainter({required this.seed, required this.density, required this.twinkleT, required this.parallax});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final total = (180 * density).toInt().clamp(0, 280);
    for (int i = 0; i < total; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final shift = math.sin((twinkleT + i * 0.01) * 2 * math.pi) * (2.0 * parallax);
      final x = baseX + shift;
      final y = baseY + shift * 0.4;
      final base = rnd.nextDouble() * 0.6 + 0.25;
      final tw = (math.sin((twinkleT * 2 * math.pi) + i) + 1) * 0.25;
      final r = rnd.nextDouble() * 1.6 + 0.3;
      final c = Colors.white.withOpacity((base + tw).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), r, Paint()..color = c);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) =>
      oldDelegate.density != density || oldDelegate.twinkleT != twinkleT || oldDelegate.seed != seed;
}

////================= ROCKET (Painter-based realistic) =================
class _RocketAssembly extends StatelessWidget {
  final double thrust; // 0..1
  final double skyMix; // 0..1
  const _RocketAssembly({required this.thrust, required this.skyMix});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // exhaust trail (ground only)
        Positioned(
          top: 64,
          child: Opacity(
            opacity: (1 - skyMix * 0.85).clamp(0.0, 1.0),
            child: _ExhaustTrail(length: 170 + 90 * thrust),
          ),
        ),
        // flame & embers
        Positioned(top: 80, child: _EngineFlame(intensity: thrust, skyMix: skyMix)),
        // rocket body (custom painter)
        const _RocketBodyPainterWidget(),
      ],
    );
  }
}

class _RocketBodyPainterWidget extends StatelessWidget {
  const _RocketBodyPainterWidget();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(52, 110),
      painter: _RocketPainter(Theme.of(context).colorScheme),
    );
  }
}

class _RocketPainter extends CustomPainter {
  final ColorScheme cs;
  _RocketPainter(this.cs);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // BODY PATH (rounded capsule)
    final body = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.80, h * 0.10, w * 0.80, h * 0.22)
      ..lineTo(w * 0.80, h * 0.78)
      ..quadraticBezierTo(w * 0.80, h * 0.92, w * 0.50, h * 0.92)
      ..quadraticBezierTo(w * 0.20, h * 0.92, w * 0.20, h * 0.78)
      ..lineTo(w * 0.20, h * 0.22)
      ..quadraticBezierTo(w * 0.20, h * 0.10, w * 0.50, 0)
      ..close();

    // Metallic gradient + soft specular
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFFFDFEFF), Color(0xFFE7F1FF), Color(0xFFD6E7F8)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    canvas.drawPath(body, bodyPaint);

    // Specular highlight stripe
    final spec = Path()
      ..moveTo(w * 0.30, h * 0.08)
      ..quadraticBezierTo(w * 0.38, h * 0.40, w * 0.32, h * 0.84)
      ..quadraticBezierTo(w * 0.34, h * 0.40, w * 0.30, h * 0.08)
      ..close();
    canvas.drawPath(spec, Paint()..color = Colors.white.withOpacity(0.22));

    // Window (porthole)
    final winCenter = Offset(w * 0.5, h * 0.40);
    final winR = w * 0.12;
    final winGrad = RadialGradient(
      colors: [cs.primary, cs.primaryContainer.withOpacity(.85)],
      center: Alignment.topLeft,
      radius: 1.0,
    ).createShader(Rect.fromCircle(center: winCenter, radius: winR));
    canvas.drawCircle(winCenter, winR + 3, Paint()..color = Colors.white);
    canvas.drawCircle(winCenter, winR, Paint()..shader = winGrad);
    canvas.drawCircle(winCenter, winR, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white);

    // Mid stripe (wrap)
    final stripe = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.60), width: w * 0.64, height: 10),
      const Radius.circular(6),
    );
    canvas.drawRRect(stripe, Paint()..color = cs.primary.withOpacity(.16));

    // FINS
    final finPaint = Paint()..color = cs.primary.withOpacity(.95);
    final leftFin = Path()
      ..moveTo(w * 0.22, h * 0.66)
      ..quadraticBezierTo(w * 0.02, h * 0.80, w * 0.08, h * 0.90)
      ..lineTo(w * 0.22, h * 0.82)
      ..close();
    final rightFin = Path()
      ..moveTo(w * 0.78, h * 0.66)
      ..quadraticBezierTo(w * 0.98, h * 0.80, w * 0.92, h * 0.90)
      ..lineTo(w * 0.78, h * 0.82)
      ..close();
    canvas.drawPath(leftFin, finPaint);
    canvas.drawPath(rightFin, finPaint);

    // Nozzle (shadowed)
    final noz = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.96), width: w * 0.26, height: h * 0.10),
      const Radius.circular(6),
    );
    canvas.drawRRect(noz, Paint()..color = const Color(0xFF8A9AA8));

    // Rivets (tiny)
    final rivetPaint = Paint()..color = Colors.white.withOpacity(.7);
    for (double x = w * 0.28; x <= w * 0.72; x += w * 0.11) {
      canvas.drawCircle(Offset(x, h * 0.24), 1.1, rivetPaint);
      canvas.drawCircle(Offset(x, h * 0.74), 1.1, rivetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

////================= EXHAUST & FLAME =================
class _ExhaustTrail extends StatelessWidget {
  final double length;
  const _ExhaustTrail({required this.length});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(26, length), painter: _TrailPainter());
}

class _TrailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.4, size.width * 0.5, size.height)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.4, size.width * 0.5, 0);

    final grad = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xBBFFFFFF), Color(0x66FFA726), Color(0x00FF7043)],
      stops: [0.0, .28, 1.0],
    ).createShader(Offset.zero & size);

    final paint = Paint()
      ..shader = grad
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(path, paint);

    // turbulence dots
    final rnd = math.Random(4);
    for (int i = 0; i < 14; i++) {
      final x = size.width * (0.3 + rnd.nextDouble() * 0.4);
      final y = size.height * (0.25 + rnd.nextDouble() * 0.7);
      final r = rnd.nextDouble() * 1.8 + 0.6;
      canvas.drawCircle(Offset(x, y), r, Paint()..color = const Color(0x66FFC46B));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EngineFlame extends StatelessWidget {
  final double intensity; // 0..1
  final double skyMix;    // 0..1
  const _EngineFlame({required this.intensity, required this.skyMix});

  @override
  Widget build(BuildContext context) {
    final double i = intensity.clamp(0.0, 1.0).toDouble();
    final double fade = (1 - skyMix * 0.55).clamp(0.0, 1.0).toDouble();

    return Column(
      children: [
        // core flame
        Opacity(
          opacity: fade,
          child: Container(
            width: 20,
            height: 24.0 + 20.0 * i,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFFFD180), Color(0xFFFF6A3D)],
                stops: [0.0, .46, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.orangeAccent.withOpacity(.35 * i), blurRadius: 22, spreadRadius: 2),
                BoxShadow(color: Colors.amber.withOpacity(.25 * i), blurRadius: 30, spreadRadius: 3),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // embers row
        Opacity(
          opacity: fade * 0.9,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(7, (k) {
              final scale = 1 - k * 0.13;
              return Container(
                width: 3.8 * scale,
                height: 3.8 * scale,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.75 * scale),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
