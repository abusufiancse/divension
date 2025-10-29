// lib/src/widgets/cosmic_zoom_header.dart
// A different take: cinematic fly-through with parallax and side-pan
// Deep Field → Gravitational Lens → Emission Nebula → Comet Flyby → Kuiper Belt → Earth Sunrise → Reverse
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 1) Put this helper near the top of the file (after imports is fine).
double _dot(Offset a, Offset b) => a.dx * b.dx + a.dy * b.dy;


class CosmicZoomHeaderTwo extends StatefulWidget {
  const CosmicZoomHeaderTwo({super.key, this.loop = true});
  final bool loop;

  @override
  State<CosmicZoomHeaderTwo> createState() => _CosmicZoomHeaderTwoState();
}

class _CosmicZoomHeaderTwoState extends State<CosmicZoomHeaderTwo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 26000));
    _t = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    widget.loop ? _ctrl.repeat(reverse: true) : _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, __) {
        final t = _t.value;

        // Segments
        // 0.00–0.18 Deep field + parallax star drift
        // 0.18–0.35 Gravitational lens cluster appears
        // 0.35–0.52 Emission nebula fly-through
        // 0.52–0.66 Comet flyby (fast lateral pan)
        // 0.66–0.82 Kuiper belt particles + distant Sun
        // 0.82–1.00 Earth sunrise close-up
        double seg(double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);
        final deep = seg(0.00, 0.18);
        final lens = seg(0.18, 0.35);
        final neb  = seg(0.35, 0.52);
        final com  = seg(0.52, 0.66);
        final kui  = seg(0.66, 0.82);
        final ear  = seg(0.82, 1.00);

        // Lateral pan mixes across the whole journey for a different feel
        final panX = lerpDouble(0, 140, math.sin(t * math.pi) * 0.5 + 0.5)!;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF030311),
                    Color.lerp(const Color(0xFF030311), const Color(0xFF001327), t * 0.6)!,
                  ],
                ),
              ),
            ),

            // Deep field starfield (persistent)
            CustomPaint(
              painter: _DeepFieldPainter(
                time: t,
                panX: panX,
                density: 900,
                seed: 20251029,
              ),
              willChange: true,
            ),

            // Gravitational lens arcs (Einstein rings) — fades in/out
            if (lens > 0)
              CustomPaint(
                painter: _GravLensPainter(progress: lens, time: t, panX: panX * .6),
                willChange: true,
              ),

            // Emission nebula clouds (HII) with dark dust filaments
            if (neb > 0)
              CustomPaint(
                painter: _NebulaFlyPainter(progress: neb, time: t, panX: panX),
                willChange: true,
              ),

            // Comet nucleus + glowing tail (quick pass left→right)
            if (com > 0)
              CustomPaint(
                painter: _CometFlybyPainter(progress: com, time: t),
                willChange: true,
              ),

            // Kuiper belt: icy particles + distant Sun halo
            if (kui > 0)
              CustomPaint(
                painter: _KuiperBeltPainter(progress: kui, time: t, panX: panX * .3),
                willChange: true,
              ),

            // Earth: limb, aurora, city lights, ISS silhouette pass
            if (ear > 0)
              CustomPaint(
                painter: _EarthSunrisePainter(progress: ear, time: t),
                willChange: true,
              ),

            // Bottom-left caption
            Positioned(
              left: 14,
              bottom: 14,
              child: _Caption(stage: _stageLabel(t)),
            ),
          ],
        );
      },
    );
  }

  String _stageLabel(double t) {
    if (t < .18) return 'DEEP FIELD';
    if (t < .35) return 'GRAVITATIONAL LENS';
    if (t < .52) return 'EMISSION NEBULA';
    if (t < .66) return 'COMET FLYBY';
    if (t < .82) return 'KUIPER BELT';
    return 'EARTH SUNRISE';
  }
}

class _Caption extends StatelessWidget {
  final String stage;
  const _Caption({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        stage,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.6,
          fontSize: 13.sp,
          shadows: const [Shadow(blurRadius: 12, color: Colors.black87)],
        ),
      ),
    );
  }
}

/// ========================= STARFIELD =========================

class _DeepFieldPainter extends CustomPainter {
  final double time;
  final double panX;
  final int density;
  final int seed;

  _DeepFieldPainter({
    required this.time,
    required this.panX,
    required this.density,
    required this.seed,
  });

  Color _starColor(double t) {
    // rough black-body palette: cool→warm→hot
    final r = (180 + (t * 75)).clamp(170, 255).toInt();
    final g = (160 + (t * 65)).clamp(150, 235).toInt();
    final b = (200 + (t * 40)).clamp(190, 255).toInt();
    return Color.fromARGB(255, r, g, b);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final count = density;

    // parallax layers (far, mid, near)
    for (int layer = 0; layer < 3; layer++) {
      final factor = [.25, .55, 1.0][layer];
      for (int i = 0; i < count ~/ 3; i++) {
        final baseX = rnd.nextDouble() * size.width;
        final baseY = rnd.nextDouble() * size.height;

        final x = (baseX + panX * factor) % size.width;
        final y = (baseY + time * 12 * factor) % size.height;

        final temp = rnd.nextDouble();
        final radius = .4 + rnd.nextDouble() * (layer == 2 ? 1.6 : 1.0);
        final twinkle = .35 + .65 * (0.5 + 0.5 * math.sin(time * 10 + i * .13 + layer));

        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = _starColor(temp).withOpacity((.25 + temp * .7) * twinkle),
        );
      }
    }

    // faint vignette
    final vignette = RadialGradient(
      colors: [Colors.transparent, Colors.black.withOpacity(.35)],
      stops: const [.65, 1.0],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = vignette);
  }

  @override
  bool shouldRepaint(covariant _DeepFieldPainter old) =>
      old.time != time || old.panX != panX;
}

/// ========================= GRAVITATIONAL LENS =========================

class _GravLensPainter extends CustomPainter {
  final double progress;
  final double time;
  final double panX;
  _GravLensPainter({required this.progress, required this.time, required this.panX});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width * .5 + panX * .2, size.height * .55);
    final r = lerpDouble(40, size.shortestSide * .38, progress)!;

    // Cluster core glow
    final core = RadialGradient(
      colors: [
        Colors.white.withOpacity(.15 * progress),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(center: c, radius: r * 1.3));
    canvas.drawCircle(c, r * 1.3, Paint()..shader = core);

    // Einstein rings (arcs)
    for (int i = 0; i < 3; i++) {
      final sweep = lerpDouble(.9, 1.8, progress)!;
      final start = i * (2 * math.pi / 3) + time * .2;
      final ringR = r * (1 + i * .18);
      final p = Paint()
        ..color = Colors.white.withOpacity(.28 - i * .07)
        ..style = PaintingStyle.stroke
        ..strokeWidth = lerpDouble(1.2, 2.6, progress)!;
      canvas.drawArc(Rect.fromCircle(center: c, radius: ringR), start, sweep, false, p);
    }

    // Lensed arclets (background galaxies)
    final rnd = math.Random(77);
    for (int i = 0; i < 60; i++) {
      final ang = rnd.nextDouble() * 2 * math.pi;
      final rr = r * (1.05 + rnd.nextDouble() * .6);
      final start = ang - .08;
      final sweep = .16 + rnd.nextDouble() * .22;
      final opacity = (.18 + rnd.nextDouble() * .25) * progress;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: rr),
        start,
        sweep,
        false,
        Paint()
          ..color = const Color(0xFFBFD6FF).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GravLensPainter old) =>
      old.progress != progress || old.time != time || old.panX != panX;
}

/// ========================= NEBULA FLY-THROUGH =========================

class _NebulaFlyPainter extends CustomPainter {
  final double progress;
  final double time;
  final double panX;
  _NebulaFlyPainter({required this.progress, required this.time, required this.panX});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(9);
    // Large emission clumps
    for (int i = 0; i < 7; i++) {
      final cx = size.width * (.15 + i * .12) + panX * .8;
      final cy = size.height * (.3 + math.sin(time * .7 + i) * .15);
      final r = lerpDouble(60, 140, progress)! * (1 + i * .05);

      final grad = RadialGradient(
        colors: [
          const Color(0xFFFF7BAC).withOpacity(.22),
          const Color(0xFF8EC5FF).withOpacity(.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx % size.width, cy), radius: r));

      canvas.drawCircle(Offset(cx % size.width, cy), r, Paint()..shader = grad);
    }

    // Dark dust filaments
    for (int i = 0; i < 10; i++) {
      final y = size.height * (.25 + i * .06);
      final rect = Rect.fromLTWH(-size.width * .2 + panX, y, size.width * 1.4, 10 + i.toDouble());
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(40)),
        Paint()..color = Colors.black.withOpacity(.12 + i * .02),
      );
    }

    // Hot stars embedded
    for (int i = 0; i < 120; i++) {
      final x = (rnd.nextDouble() * size.width + panX) % size.width;
      final y = rnd.nextDouble() * size.height;
      final o = (.4 + rnd.nextDouble() * .6) * progress;
      canvas.drawCircle(Offset(x, y), 1 + rnd.nextDouble() * 1.8, Paint()..color = Colors.white.withOpacity(o));
    }
  }

  @override
  bool shouldRepaint(covariant _NebulaFlyPainter old) =>
      old.progress != progress || old.time != time || old.panX != panX;
}

/// ========================= COMET FLYBY =========================

class _CometFlybyPainter extends CustomPainter {
  final double progress;
  final double time;
  _CometFlybyPainter({required this.progress, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    // Path left → right with slight curve
    final px = lerpDouble(-100, size.width + 100, Curves.easeInOut.transform(progress))!;
    final py = size.height * (.35 + math.sin(progress * math.pi) * .1);

    final nucleus = Offset(px, py);

    // Ion tail (blue)
    final tailLen = 240.0;
    final tailPath = Path()
      ..moveTo(nucleus.dx, nucleus.dy)
      ..quadraticBezierTo(
        nucleus.dx - tailLen * .4,
        nucleus.dy - 30,
        nucleus.dx - tailLen,
        nucleus.dy - 80,
      );
    canvas.drawPath(
      tailPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFF7FB6FF).withOpacity(.75),
            Colors.transparent,
          ],
        ).createShader(Offset.zero & size)
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
        ..style = PaintingStyle.stroke,
    );

    // Dust tail (yellowish, broader)
    final dustPath = Path()
      ..moveTo(nucleus.dx, nucleus.dy)
      ..quadraticBezierTo(
        nucleus.dx - tailLen * .35,
        nucleus.dy + 10,
        nucleus.dx - tailLen * .9,
        nucleus.dy + 50,
      );
    canvas.drawPath(
      dustPath,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFFFE08A).withOpacity(.55), Colors.transparent],
        ).createShader(Offset.zero & size)
        ..strokeWidth = 18
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
        ..style = PaintingStyle.stroke,
    );

    // Nucleus
    canvas.drawCircle(
      nucleus,
      6,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white, const Color(0xFFE1E1E1)],
          center: const Alignment(-.4, -.4),
        ).createShader(Rect.fromCircle(center: nucleus, radius: 6)),
    );
  }

  @override
  bool shouldRepaint(covariant _CometFlybyPainter old) => old.progress != progress || old.time != time;
}

/// ========================= KUIPER BELT (Improved Sun) =========================

class _KuiperBeltPainter extends CustomPainter {
  final double progress;
  final double time;
  final double panX;
  _KuiperBeltPainter({required this.progress, required this.time, required this.panX});

  @override
  void paint(Canvas canvas, Size size) {
    final sunCenter = Offset(size.width * (.52 + .05 * progress) + panX * .2, size.height * (.56 + .02 * progress));
    final coreR = lerpDouble(34, 62, progress)!;

    // 1) Solar core (photosphere)
    final core = RadialGradient(
      colors: [
        const Color(0xFFFFE6A3),
        const Color(0xFFFFC857),
        const Color(0xFFFF9A3C),
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromCircle(center: sunCenter, radius: coreR));
    canvas.drawCircle(sunCenter, coreR, Paint()..shader = core);

    // 2) HDR corona/bloom layers (Rayleigh-ish falloff)
    void corona(double radiusMul, double alpha) {
      canvas.drawCircle(
        sunCenter,
        coreR * radiusMul,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFF0C2).withOpacity(alpha),
              Colors.transparent,
            ],
          ).createShader(Rect.fromCircle(center: sunCenter, radius: coreR * radiusMul))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      );
    }
    corona(1.6, .75);
    corona(2.3, .45);
    corona(3.0, .25);

    // 3) Diffraction spikes (subtle, non-intrusive)
    final spikePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.white.withOpacity(.55), Colors.transparent],
      ).createShader(Offset.zero & size)
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..style = PaintingStyle.stroke;

    void spike(double angle, double len) {
      final dir = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        sunCenter - dir * (len * .2),
        sunCenter + dir * len,
        spikePaint,
      );
    }

    // Four main spikes + four minor
    final baseLen = coreR * 2.6;
    for (final a in [0.0, math.pi / 2, math.pi, 3 * math.pi / 2]) {
      spike(a, baseLen);
    }
    for (final a in [.25, .75, 1.25, 1.75].map((e) => e * math.pi)) {
      spike(a, baseLen * .6);
    }

    // 4) Kuiper belt particles (icy rocks with anisotropy)
    final rnd = math.Random(321);
    for (int i = 0; i < 300; i++) {
      final ang = rnd.nextDouble() * 2 * math.pi + time * .18;
      final dist = lerpDouble(130, size.shortestSide * .58, progress)! * (0.85 + rnd.nextDouble() * .55);
      final pos = Offset(sunCenter.dx + dist * math.cos(ang), sunCenter.dy + dist * math.sin(ang) * .65);
      final r = rnd.nextDouble() * 1.8 + .4;

      // Forward scattering brightening towards the Sun
      final lightDir = (sunCenter - pos);
      final nd = lightDir.distance;
      final fwd = (1.0 - (nd / (coreR * 3.5)).clamp(0.0, 1.0)); // brighter if closer to Sun
      final alpha = (.28 + fwd * .35) * (0.8 + .2 * math.sin(time * 3 + i));

      canvas.drawCircle(pos, r, Paint()..color = Colors.white.withOpacity(alpha));
    }
  }

  @override
  bool shouldRepaint(covariant _KuiperBeltPainter old) =>
      old.progress != progress || old.time != time || old.panX != panX;
}

/// ========================= EARTH SUNRISE (Vector World Map) =========================

class _EarthSunrisePainter extends CustomPainter {
  final double progress;
  final double time;
  _EarthSunrisePainter({required this.progress, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    // Cinematic framing like before
    final R = lerpDouble(62, size.shortestSide * .5, progress)!;
    final center = Offset(
      lerpDouble(size.width * .88, size.width * .60, progress)!,
      lerpDouble(size.height * 1.12, size.height * .72, progress)!,
    );

    // Light direction (Sun to the right-top), slight drift
    final sunDir = Offset(0.75, -0.55).direction + 0.08 * math.sin(time * 2 * math.pi);
    final lvec = Offset(math.cos(sunDir), math.sin(sunDir));

    // ---------------- Atmosphere (Rayleigh + Mie) ----------------
    _ring(canvas, center, R * 1.18, Colors.transparent, const Color(0xFF79C8FF).withOpacity(.38), 36);
    _ring(canvas, center, R * 1.06, Colors.transparent, const Color(0xFF4FA8FF).withOpacity(.20), 20);
    final sunriseAng = sunDir + math.pi; // limb opposite light vector
    _arcGlow(
      canvas, center, R * 1.02,
      startAngle: sunriseAng - .35, sweep: .70,
      color: const Color(0xFFFFC857).withOpacity(.55), width: 8, blur: 18,
    );

    // ---------------- Ocean body + limb darkening ----------------
    final ocean = RadialGradient(
      colors: [const Color(0xFF0B5EA8), const Color(0xFF063B6C)],
    ).createShader(Rect.fromCircle(center: center, radius: R));
    canvas.drawCircle(center, R, Paint()..shader = ocean);
    canvas.drawCircle(
      center, R,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(.18)],
          stops: const [.75, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: R)),
    );

    // ---------------- Vector world map on a sphere ----------------
    // Rotation of Earth around its axis
    final lon0 = time * .7 * 360.0; // degrees; rotate slowly eastward
    _drawWorldMapOnSphere(canvas, center, R, lon0, strokeWidth: 1.2);

    // ---------------- Clouds ----------------
    final rot = time * .8 * 2 * math.pi;
    final cloudBand = Paint()
      ..color = Colors.white.withOpacity(.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    _ellipseArc(canvas, center, R * .86, R * .36, rot * 1.2, math.pi * .95, cloudBand);
    _ellipseArc(canvas, center, R * .66, R * .28, rot * 1.2 + .6, math.pi * .75, cloudBand);
    _ellipseArc(canvas, center, R * .54, R * .22, rot * 1.2 + 1.4, math.pi * .62, cloudBand);

    // Random cloud tufts (bias to day side)
    final rnd = math.Random(905);
    final tuft = Paint()
      ..color = Colors.white.withOpacity(.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    for (int i = 0; i < 60; i++) {
      final a = rnd.nextDouble() * 2 * math.pi;
      final d = R * (.30 + rnd.nextDouble() * .65);
      final p = Offset(center.dx + math.cos(a) * d, center.dy + math.sin(a) * d);
      final n = _dot(Offset.fromDirection(a), lvec);
      if (n > -0.2) canvas.drawCircle(p, 2.0 + rnd.nextDouble() * 3.5, tuft);
    }

    // ---------------- Day/Night terminator + city lights ----------------
    _nightMask(canvas, size, center, R * 1.02, lvec, softness: .55, darkness: .46);

    final lights = Paint()..color = const Color(0xFFFFE6A3).withOpacity(.62);
    for (int i = 0; i < 140; i++) {
      final a = rnd.nextDouble() * 2 * math.pi;
      final d = R * (.18 + rnd.nextDouble() * .82);
      final p = Offset(center.dx + math.cos(a) * d, center.dy + math.sin(a) * d);
      final n = _dot(Offset.fromDirection(a), lvec); // day if positive
      if (n < -0.05) canvas.drawCircle(p, rnd.nextDouble() * 1.4, lights);
    }

    // ---------------- Specular sun glint + aurora + ISS ----------------
    final glintCenter = center + lvec * (R * .25);
    canvas.drawCircle(
      glintCenter, R * .18,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withOpacity(.52), Colors.transparent],
        ).createShader(Rect.fromCircle(center: glintCenter, radius: R * .18)),
    );

    final auroraPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF00FFB2).withOpacity(.55), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: R))
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    _auroraArc(canvas, center, R, pole: 1, offset: .38, paint: auroraPaint);
    _auroraArc(canvas, center, R, pole: -1, offset: 2.38, paint: auroraPaint);

    final issT = Curves.easeInOut.transform(progress);
    final issAng = lerpDouble(1.08 * math.pi, .68 * math.pi, issT)!;
    final issR = R * 1.02;
    final issPos = Offset(center.dx + math.cos(issAng) * issR, center.dy + math.sin(issAng) * issR);
    canvas.drawRect(
      Rect.fromCenter(center: issPos, width: 9, height: 2.2),
      Paint()..color = Colors.black.withOpacity(.9),
    );
  }

  // ==== World map rendering on sphere (orthographic projection) ====

  void _drawWorldMapOnSphere(Canvas canvas, Offset c, double R, double lonCenterDeg,
      {double strokeWidth = 1.0}) {
    // Small, low-poly continent outlines (lat/lon in degrees).
    // Each polygon is a polyline; visibility is culled by projection (z>0).
    final List<List<Offset>> outlines = _worldOutlines();

    // Convert lon0 (center) to radians
    final lon0 = _deg2rad(lonCenterDeg);
    final lat0 = 0.0; // looking at equator (can tilt later)

    final outlinePaint = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0);

    for (final poly in outlines) {
      final path = Path();
      bool started = false;
      for (final ll in poly) {
        final lat = _deg2rad(ll.dy);
        final lon = _deg2rad(ll.dx);
        final p = _orthographicProject(lat, lon, lat0, lon0);
        if (p == null) {
          started = false;
          continue;
        }
        final pt = Offset(c.dx + p.dx * R, c.dy - p.dy * R); // y up
        if (!started) {
          path.moveTo(pt.dx, pt.dy);
          started = true;
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      canvas.drawPath(path, outlinePaint);
    }

    // Optional: faint graticule (latitude/longitude lines)
    // final gratPaint = Paint()
    //   ..color = Colors.white.withOpacity(.12)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 0.8;
    // // Meridians
    // for (int lon = -120; lon <= 120; lon += 30) {
    //   _drawMeridian(canvas, c, R, lat0, lon0, _deg2rad(lon.toDouble()), gratPaint);
    // }
    // // Parallels
    // for (int lat = -60; lat <= 60; lat += 30) {
    //   _drawParallel(canvas, c, R, lat0, lon0, _deg2rad(lat.toDouble()), gratPaint);
    // }
  }

  // Orthographic projection from lat/lon to unit disc (x,y), with visibility
  // Returns null if the point is on the far side (z <= 0).
  Offset? _orthographicProject(double lat, double lon, double lat0, double lon0) {
    // Rotate sphere so that (lat0, lon0) is at center
    final cosLat = math.cos(lat);
    final sinLat = math.sin(lat);
    final cosLat0 = math.cos(lat0);
    final sinLat0 = math.sin(lat0);
    final dLon = lon - lon0;

    final x = cosLat * math.sin(dLon);
    final y = cosLat0 * sinLat - sinLat0 * cosLat * math.cos(dLon);
    final z = sinLat0 * sinLat + cosLat0 * cosLat * math.cos(dLon); // toward viewer

    if (z <= 0) return null; // backface culling
    return Offset(x, y);
  }

  // Draw a meridian (constant longitude) visible arc
  void _drawMeridian(Canvas canvas, Offset c, double R, double lat0, double lon0, double lon, Paint p) {
    final path = Path();
    bool started = false;
    for (int dlat = -90; dlat <= 90; dlat += 2) {
      final lat = _deg2rad(dlat.toDouble());
      final pt = _orthographicProject(lat, lon, lat0, lon0);
      if (pt == null) {
        started = false;
        continue;
      }
      final xy = Offset(c.dx + pt.dx * R, c.dy - pt.dy * R);
      if (!started) {
        path.moveTo(xy.dx, xy.dy);
        started = true;
      } else {
        path.lineTo(xy.dx, xy.dy);
      }
    }
    canvas.drawPath(path, p);
  }

  // Draw a parallel (constant latitude) visible arc
  void _drawParallel(Canvas canvas, Offset c, double R, double lat0, double lon0, double lat, Paint p) {
    final path = Path();
    bool started = false;
    for (int dlon = -180; dlon <= 180; dlon += 2) {
      final lon = _deg2rad(dlon.toDouble());
      final pt = _orthographicProject(lat, lon, lat0, lon0);
      if (pt == null) {
        started = false;
        continue;
      }
      final xy = Offset(c.dx + pt.dx * R, c.dy - pt.dy * R);
      if (!started) {
        path.moveTo(xy.dx, xy.dy);
        started = true;
      } else {
        path.lineTo(xy.dx, xy.dy);
      }
    }
    canvas.drawPath(path, p);
  }

  // Low-poly outlines (very simplified; enough to feel “real” without assets).
  // Each Offset is (lon, lat) in degrees. Polylines are closed visually by data.
  List<List<Offset>> _worldOutlines() {
    return [
      // North America (outline simplified)
      [
        const Offset(-168, 72), const Offset(-141, 70), const Offset(-126, 63), const Offset(-112, 59),
        const Offset(-100, 49), const Offset(-96, 45), const Offset(-84, 42), const Offset(-79, 25),
        const Offset(-97, 19), const Offset(-105, 23), const Offset(-114, 30), const Offset(-125, 34),
        const Offset(-130, 43), const Offset(-140, 56), const Offset(-150, 60), const Offset(-160, 66),
        const Offset(-168, 72),
      ],
      // South America
      [
        const Offset(-81, 12), const Offset(-79, 0), const Offset(-76, -7), const Offset(-74, -10),
        const Offset(-70, -15), const Offset(-66, -20), const Offset(-63, -25), const Offset(-60, -29),
        const Offset(-58, -34), const Offset(-55, -38), const Offset(-53, -43), const Offset(-50, -48),
        const Offset(-52, -33), const Offset(-54, -25), const Offset(-57, -15), const Offset(-61, -5),
        const Offset(-66, 1), const Offset(-70, 6), const Offset(-75, 9), const Offset(-81, 12),
      ],
      // Europe + North Africa + Middle East (very simplified)
      [
        const Offset(-10, 36), const Offset(0, 50), const Offset(10, 54), const Offset(20, 58),
        const Offset(32, 60), const Offset(40, 56), const Offset(52, 54), const Offset(56, 47),
        const Offset(45, 41), const Offset(36, 35), const Offset(28, 34), const Offset(20, 37),
        const Offset(10, 43), const Offset(2, 41), const Offset(-5, 38), const Offset(-10, 36),
        // North Africa
        const Offset(-10, 36), const Offset(0, 32), const Offset(10, 31), const Offset(20, 31),
        const Offset(30, 31), const Offset(35, 30), const Offset(10, 20), const Offset(0, 20),
        const Offset(-5, 25), const Offset(-10, 36),
      ],
      // Sub-Saharan Africa
      [
        const Offset(10, 10), const Offset(12, 5), const Offset(14, 0), const Offset(16, -5),
        const Offset(20, -10), const Offset(25, -15), const Offset(30, -20), const Offset(35, -25),
        const Offset(32, -30), const Offset(28, -35), const Offset(20, -35), const Offset(12, -30),
        const Offset(8, -20), const Offset(6, -10), const Offset(8, -2), const Offset(10, 10),
      ],
      // Arabian peninsula + Iran (sketch)
      [
        const Offset(38, 30), const Offset(44, 28), const Offset(50, 26), const Offset(56, 25),
        const Offset(58, 22), const Offset(54, 20), const Offset(50, 18), const Offset(46, 20),
        const Offset(42, 22), const Offset(40, 26), const Offset(38, 30),
      ],
      // India + SE Asia (very simplified)
      [
        const Offset(70, 28), const Offset(78, 22), const Offset(86, 20), const Offset(92, 18),
        const Offset(98, 15), const Offset(104, 12), const Offset(110, 14), const Offset(114, 18),
        const Offset(108, 22), const Offset(100, 24), const Offset(92, 26), const Offset(84, 28),
        const Offset(76, 30), const Offset(70, 28),
      ],
      // East Asia
      [
        const Offset(118, 40), const Offset(124, 42), const Offset(130, 44), const Offset(136, 46),
        const Offset(140, 44), const Offset(142, 40), const Offset(140, 36), const Offset(134, 34),
        const Offset(126, 32), const Offset(120, 34), const Offset(118, 40),
      ],
      // Australia
      [
        const Offset(132, -12), const Offset(138, -16), const Offset(146, -20), const Offset(152, -24),
        const Offset(150, -30), const Offset(144, -34), const Offset(136, -32), const Offset(130, -28),
        const Offset(128, -22), const Offset(132, -12),
      ],
      // Greenland (rough)
      [
        const Offset(-47, 83), const Offset(-42, 78), const Offset(-38, 72), const Offset(-44, 70),
        const Offset(-52, 72), const Offset(-54, 76), const Offset(-50, 81), const Offset(-47, 83),
      ],
      // Antarctica (just a rim near bottom)
      [
        const Offset(-160, -70), const Offset(-120, -72), const Offset(-80, -74), const Offset(-40, -72),
        const Offset(0, -74), const Offset(40, -72), const Offset(80, -74), const Offset(120, -72),
        const Offset(160, -70),
      ],
    ];
  }

  // Helpers for outlines
  double _deg2rad(double d) => d * math.pi / 180.0;

  // UI helpers from previous version (unchanged)
  void _ring(Canvas canvas, Offset c, double r, Color inner, Color outer, double blur) {
    canvas.drawCircle(
      c, r,
      Paint()
        ..shader = RadialGradient(colors: [outer, inner]).createShader(Rect.fromCircle(center: c, radius: r))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );
  }

  void _arcGlow(Canvas canvas, Offset c, double r,
      {required double startAngle, required double sweep, required Color color, required double width, required double blur}) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), startAngle, sweep, false, p);
  }

  void _ellipseArc(Canvas canvas, Offset c, double rx, double ry, double start, double sweep, Paint p) {
    final path = Path();
    for (int i = 0; i <= 64; i++) {
      final t = start + sweep * (i / 64);
      final x = c.dx + math.cos(t) * rx;
      final y = c.dy + math.sin(t) * ry;
      (i == 0) ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, p);
  }

  void _nightMask(Canvas canvas, Size size, Offset c, double r, Offset lvec,
      {double softness = .5, double darkness = .45}) {
    canvas.save();
    final ang = math.atan2(lvec.dy, lvec.dx);
    canvas.translate(c.dx, c.dy);
    canvas.rotate(ang + math.pi); // gradient toward night
    final rect = Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 2);
    final grad = LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight,
      colors: [Colors.black.withOpacity(darkness), Colors.black.withOpacity(darkness * (1 - softness)), Colors.transparent],
      stops: const [0.0, 0.45, 0.9],
    ).createShader(rect);
    canvas.drawCircle(Offset.zero, r, Paint()..shader = grad..blendMode = BlendMode.darken);
    canvas.restore();
  }

  void _auroraArc(Canvas canvas, Offset c, double R, {required int pole, required double offset, required Paint paint}) {
    final path = Path();
    for (int j = 0; j <= 60; j++) {
      final t = (j / 60.0) * math.pi * .95 + offset;
      final x = c.dx + math.cos(t) * R * .78;
      final y = c.dy + math.sin(t) * R * (.28 * pole);
      (j == 0) ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EarthSunrisePainter old) =>
      old.progress != progress || old.time != time;
}


