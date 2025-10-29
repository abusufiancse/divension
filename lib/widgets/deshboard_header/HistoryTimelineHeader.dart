// lib/src/widgets/history_timeline_header.dart
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Animated journey through human history
/// Ancient Egypt → Roman Empire → Medieval → Renaissance → Industrial → Digital Age
class HistoryTimelineHeader extends StatefulWidget {
  const HistoryTimelineHeader({super.key, this.loop = true});
  final bool loop;

  @override
  State<HistoryTimelineHeader> createState() => _HistoryTimelineHeaderState();
}

class _HistoryTimelineHeaderState extends State<HistoryTimelineHeader>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _timelineProgress;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30000),
    );

    widget.loop ? _ctrl.repeat() : _ctrl.forward();

    _timelineProgress = CurvedAnimation(
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
      animation: _timelineProgress,
      builder: (context, _) {
        final t = _timelineProgress.value;

        // Timeline phases:
        // 0.00-0.16: Ancient Egypt
        // 0.16-0.32: Roman Empire
        // 0.32-0.48: Medieval Period
        // 0.48-0.64: Renaissance
        // 0.64-0.80: Industrial Revolution
        // 0.80-1.00: Digital Age

        final HistoricalEra era;
        final double eraProgress;

        if (t < 0.16) {
          era = HistoricalEra.ancientEgypt;
          eraProgress = t / 0.16;
        } else if (t < 0.32) {
          era = HistoricalEra.romanEmpire;
          eraProgress = (t - 0.16) / 0.16;
        } else if (t < 0.48) {
          era = HistoricalEra.medieval;
          eraProgress = (t - 0.32) / 0.16;
        } else if (t < 0.64) {
          era = HistoricalEra.renaissance;
          eraProgress = (t - 0.48) / 0.16;
        } else if (t < 0.80) {
          era = HistoricalEra.industrial;
          eraProgress = (t - 0.64) / 0.16;
        } else {
          era = HistoricalEra.digital;
          eraProgress = (t - 0.80) / 0.20;
        }

        return LayoutBuilder(builder: (_, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Era-specific background
              _EraBackground(era: era, progress: eraProgress),

              // Atmospheric particles
              _AtmosphericParticles(era: era, time: t),

              // Main era scene
              _EraScene(
                era: era,
                progress: eraProgress,
                globalTime: t,
              ),

              // Timeline bar at bottom
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: _TimelineBar(currentTime: t),
              ),

              // Era title and info
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getEraTitle(era),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 36,
                            letterSpacing: 2.5,
                            fontFamily: _getEraFont(era),
                            shadows: [
                              Shadow(
                                blurRadius: 24,
                                color: _getEraShadowColor(era),
                                offset: const Offset(0, 4),
                              ),
                              const Shadow(
                                blurRadius: 12,
                                color: Colors.black87,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getEraSubtitle(era),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 1.5,
                            shadows: const [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black54,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getEraDateRange(era),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
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

  String _getEraTitle(HistoricalEra era) {
    switch (era) {
      case HistoricalEra.ancientEgypt:
        return 'ANCIENT EGYPT';
      case HistoricalEra.romanEmpire:
        return 'ROMAN EMPIRE';
      case HistoricalEra.medieval:
        return 'MEDIEVAL AGE';
      case HistoricalEra.renaissance:
        return 'RENAISSANCE';
      case HistoricalEra.industrial:
        return 'INDUSTRIAL ERA';
      case HistoricalEra.digital:
        return 'DIGITAL AGE';
    }
  }

  String _getEraSubtitle(HistoricalEra era) {
    switch (era) {
      case HistoricalEra.ancientEgypt:
        return 'Land of Pharaohs and Pyramids';
      case HistoricalEra.romanEmpire:
        return 'Glory of Rome and its Legions';
      case HistoricalEra.medieval:
        return 'Knights, Castles and Kingdoms';
      case HistoricalEra.renaissance:
        return 'Rebirth of Art and Science';
      case HistoricalEra.industrial:
        return 'Steam Power and Innovation';
      case HistoricalEra.digital:
        return 'Information and Technology';
    }
  }

  String _getEraDateRange(HistoricalEra era) {
    switch (era) {
      case HistoricalEra.ancientEgypt:
        return '3100 BCE - 30 BCE';
      case HistoricalEra.romanEmpire:
        return '27 BCE - 476 CE';
      case HistoricalEra.medieval:
        return '476 CE - 1453 CE';
      case HistoricalEra.renaissance:
        return '1300 CE - 1600 CE';
      case HistoricalEra.industrial:
        return '1760 CE - 1840 CE';
      case HistoricalEra.digital:
        return '1970 CE - Present';
    }
  }

  String _getEraFont(HistoricalEra era) {
    // Return appropriate font family based on era
    return 'System'; // Replace with custom fonts if available
  }

  Color _getEraShadowColor(HistoricalEra era) {
    switch (era) {
      case HistoricalEra.ancientEgypt:
        return const Color(0xFFDAA520).withOpacity(0.6);
      case HistoricalEra.romanEmpire:
        return const Color(0xFF8B0000).withOpacity(0.6);
      case HistoricalEra.medieval:
        return const Color(0xFF4169E1).withOpacity(0.6);
      case HistoricalEra.renaissance:
        return const Color(0xFF8B4513).withOpacity(0.6);
      case HistoricalEra.industrial:
        return const Color(0xFF696969).withOpacity(0.6);
      case HistoricalEra.digital:
        return const Color(0xFF00CED1).withOpacity(0.6);
    }
  }
}

enum HistoricalEra {
  ancientEgypt,
  romanEmpire,
  medieval,
  renaissance,
  industrial,
  digital,
}

//═══════════════════════════════════════════════════════════
// ERA BACKGROUND
//═══════════════════════════════════════════════════════════

class _EraBackground extends StatelessWidget {
  final HistoricalEra era;
  final double progress;

  const _EraBackground({required this.era, required this.progress});

  @override
  Widget build(BuildContext context) {
    List<Color> colors;

    switch (era) {
      case HistoricalEra.ancientEgypt:
        colors = [
          const Color(0xFFDAA520), // Gold
          const Color(0xFFCD853F), // Peru
          const Color(0xFF8B4513), // Saddle brown
        ];
        break;
      case HistoricalEra.romanEmpire:
        colors = [
          const Color(0xFF8B0000), // Dark red
          const Color(0xFFB22222), // Fire brick
          const Color(0xFF2F4F4F), // Dark slate gray
        ];
        break;
      case HistoricalEra.medieval:
        colors = [
          const Color(0xFF191970), // Midnight blue
          const Color(0xFF483D8B), // Dark slate blue
          const Color(0xFF2F4F4F), // Dark slate gray
        ];
        break;
      case HistoricalEra.renaissance:
        colors = [
          const Color(0xFF8B4513), // Saddle brown
          const Color(0xFFCD853F), // Peru
          const Color(0xFF2F4F4F), // Dark slate gray
        ];
        break;
      case HistoricalEra.industrial:
        colors = [
          const Color(0xFF2F4F4F), // Dark slate gray
          const Color(0xFF696969), // Dim gray
          const Color(0xFF778899), // Light slate gray
        ];
        break;
      case HistoricalEra.digital:
        colors = [
          const Color(0xFF000428), // Dark blue
          const Color(0xFF004e92), // Medium blue
          const Color(0xFF1a1a2e), // Dark purple-blue
        ];
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }
}

//═══════════════════════════════════════════════════════════
// ATMOSPHERIC PARTICLES
//═══════════════════════════════════════════════════════════

class _AtmosphericParticles extends StatelessWidget {
  final HistoricalEra era;
  final double time;

  const _AtmosphericParticles({required this.era, required this.time});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlesPainter(era: era, time: time),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final HistoricalEra era;
  final double time;

  _ParticlesPainter({required this.era, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(42);

    // Different particle types for different eras
    switch (era) {
      case HistoricalEra.ancientEgypt:
        _drawSandParticles(canvas, size, rnd);
        break;
      case HistoricalEra.romanEmpire:
        _drawEmbers(canvas, size, rnd);
        break;
      case HistoricalEra.medieval:
        _drawSnowflakes(canvas, size, rnd);
        break;
      case HistoricalEra.renaissance:
        _drawPaintSplatters(canvas, size, rnd);
        break;
      case HistoricalEra.industrial:
        _drawSteamParticles(canvas, size, rnd);
        break;
      case HistoricalEra.digital:
        _drawDataBits(canvas, size, rnd);
        break;
    }
  }

  void _drawSandParticles(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 50; i++) {
      final x = (rnd.nextDouble() * size.width + time * 30 * (i % 3 + 1)) % size.width;
      final y = rnd.nextDouble() * size.height;
      final opacity = 0.2 + rnd.nextDouble() * 0.3;

      canvas.drawCircle(
        Offset(x, y),
        1.5 + rnd.nextDouble(),
        Paint()..color = const Color(0xFFDAA520).withOpacity(opacity),
      );
    }
  }

  void _drawEmbers(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 30; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (size.height - (time * 50 * (i % 4 + 1)) + i * 20) % size.height;
      final glow = (math.sin(time * 5 + i) + 1) / 2;

      canvas.drawCircle(
        Offset(x, y),
        2.0 + rnd.nextDouble() * 2,
        Paint()
          ..color = Color.lerp(
            const Color(0xFFFF4500),
            const Color(0xFFFFD700),
            glow,
          )!.withOpacity(0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  void _drawSnowflakes(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 40; i++) {
      final x = (rnd.nextDouble() * size.width + math.sin(time * 2 + i) * 20) % size.width;
      final y = (time * 40 * (i % 3 + 1) + i * 15) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        1.5 + rnd.nextDouble(),
        Paint()..color = Colors.white.withOpacity(0.4),
      );
    }
  }

  void _drawPaintSplatters(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 25; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final colors = [
        const Color(0xFFFF6B6B),
        const Color(0xFF4ECDC4),
        const Color(0xFFFFE66D),
        const Color(0xFF95E1D3),
      ];

      canvas.drawCircle(
        Offset(x, y),
        3.0 + rnd.nextDouble() * 4,
        Paint()
          ..color = colors[i % colors.length].withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
  }

  void _drawSteamParticles(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 35; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = (size.height - (time * 60 * (i % 3 + 1)) + i * 25) % size.height;
      final opacity = (1 - (y / size.height)) * 0.4;

      canvas.drawCircle(
        Offset(x, y),
        4.0 + rnd.nextDouble() * 6,
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  void _drawDataBits(Canvas canvas, Size size, math.Random rnd) {
    for (int i = 0; i < 60; i++) {
      final x = (time * 100 * (i % 5 + 1) + i * 20) % size.width;
      final y = rnd.nextDouble() * size.height;
      final bit = i % 2 == 0 ? '1' : '0';

      final textPainter = TextPainter(
        text: TextSpan(
          text: bit,
          style: TextStyle(
            color: const Color(0xFF00CED1).withOpacity(0.4),
            fontSize: 12 + rnd.nextDouble() * 8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.era != era;
}

//═══════════════════════════════════════════════════════════
// ERA SCENE
//═══════════════════════════════════════════════════════════

class _EraScene extends StatelessWidget {
  final HistoricalEra era;
  final double progress;
  final double globalTime;

  const _EraScene({
    required this.era,
    required this.progress,
    required this.globalTime,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EraScenePainter(
        era: era,
        progress: progress,
        time: globalTime,
      ),
    );
  }
}

class _EraScenePainter extends CustomPainter {
  final HistoricalEra era;
  final double progress;
  final double time;

  _EraScenePainter({
    required this.era,
    required this.progress,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (era) {
      case HistoricalEra.ancientEgypt:
        _paintEgypt(canvas, size);
        break;
      case HistoricalEra.romanEmpire:
        _paintRome(canvas, size);
        break;
      case HistoricalEra.medieval:
        _paintMedieval(canvas, size);
        break;
      case HistoricalEra.renaissance:
        _paintRenaissance(canvas, size);
        break;
      case HistoricalEra.industrial:
        _paintIndustrial(canvas, size);
        break;
      case HistoricalEra.digital:
        _paintDigital(canvas, size);
        break;
    }
  }

  void _paintEgypt(Canvas canvas, Size size) {
    // Sun (Ra)
    final sunY = size.height * 0.20;
    canvas.drawCircle(
      Offset(size.width * 0.75, sunY),
      45,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFD700),
            const Color(0xFFFF8C00).withOpacity(0.8),
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.75, sunY),
          radius: 45,
        )),
    );

    // Sun rays
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * math.pi + time * 0.5;
      final startR = 50.0;
      final endR = 75.0;

      canvas.drawLine(
        Offset(
          size.width * 0.75 + startR * math.cos(angle),
          sunY + startR * math.sin(angle),
        ),
        Offset(
          size.width * 0.75 + endR * math.cos(angle),
          sunY + endR * math.sin(angle),
        ),
        Paint()
          ..color = const Color(0xFFFFD700).withOpacity(0.6)
          ..strokeWidth = 3,
      );
    }

    // Pyramids
    final baseY = size.height * 0.70;

    // Great Pyramid
    final pyramid1 = Path()
      ..moveTo(size.width * 0.30, baseY)
      ..lineTo(size.width * 0.20, size.height * 0.88)
      ..lineTo(size.width * 0.40, size.height * 0.88)
      ..close();

    canvas.drawPath(
      pyramid1,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFDAA520),
            const Color(0xFF8B7355),
          ],
        ).createShader(pyramid1.getBounds()),
    );

    // Shadow side
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.30, baseY)
        ..lineTo(size.width * 0.40, size.height * 0.88)
        ..lineTo(size.width * 0.30, size.height * 0.88)
        ..close(),
      Paint()..color = Colors.black.withOpacity(0.3),
    );

    // Second Pyramid
    final pyramid2 = Path()
      ..moveTo(size.width * 0.55, size.height * 0.75)
      ..lineTo(size.width * 0.47, size.height * 0.88)
      ..lineTo(size.width * 0.63, size.height * 0.88)
      ..close();

    canvas.drawPath(
      pyramid2,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFCD853F),
            const Color(0xFF8B7355),
          ],
        ).createShader(pyramid2.getBounds()),
    );

    // Sphinx silhouette
    final sphinx = Path()
      ..moveTo(size.width * 0.65, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.78,
        size.width * 0.72,
        size.height * 0.82,
      )
      ..lineTo(size.width * 0.75, size.height * 0.88)
      ..lineTo(size.width * 0.62, size.height * 0.88)
      ..close();

    canvas.drawPath(
      sphinx,
      Paint()..color = const Color(0xFF8B7355).withOpacity(0.7),
    );

    // Desert dunes
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.88)
        ..quadraticBezierTo(
          size.width * 0.25,
          size.height * 0.82,
          size.width * 0.5,
          size.height * 0.88,
        )
        ..quadraticBezierTo(
          size.width * 0.75,
          size.height * 0.84,
          size.width,
          size.height * 0.88,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close(),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFCD853F).withOpacity(0.6),
            const Color(0xFF8B4513).withOpacity(0.8),
          ],
        ).createShader(Rect.fromLTWH(0, size.height * 0.82, size.width, size.height * 0.18)),
    );
  }

  void _paintRome(Canvas canvas, Size size) {
    // Colosseum (iconic amphitheater)
    final colosseum = Offset(size.width * 0.50, size.height * 0.60);

    // Colosseum main structure
    canvas.drawOval(
      Rect.fromCenter(
        center: colosseum,
        width: size.width * 0.65,
        height: size.height * 0.50,
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFD4A574),
            const Color(0xFF8B7355),
          ],
        ).createShader(Rect.fromCenter(
          center: colosseum,
          width: size.width * 0.65,
          height: size.height * 0.50,
        )),
    );

    // Arched levels (3 levels of arches)
    for (int level = 0; level < 3; level++) {
      final levelY = colosseum.dy - size.height * 0.15 + level * size.height * 0.12;

      for (int i = -5; i <= 5; i++) {
        final archX = colosseum.dx + i * size.width * 0.055;
        final archWidth = size.width * 0.045;
        final archHeight = size.height * 0.08;

        // Arch shadow (depth)
        canvas.drawPath(
          Path()
            ..moveTo(archX - archWidth / 2, levelY + archHeight)
            ..lineTo(archX - archWidth / 2, levelY + archHeight * 0.3)
            ..quadraticBezierTo(
              archX,
              levelY,
              archX + archWidth / 2,
              levelY + archHeight * 0.3,
            )
            ..lineTo(archX + archWidth / 2, levelY + archHeight)
            ..close(),
          Paint()..color = const Color(0xFF3D2817),
        );

        // Arch pillar
        canvas.drawRect(
          Rect.fromLTWH(
            archX + archWidth / 2 - 3,
            levelY,
            6,
            archHeight,
          ),
          Paint()..color = const Color(0xFFB8956A),
        );
      }
    }

    // Roman soldiers with shields (marching)
    for (int i = 0; i < 3; i++) {
      final soldierX = size.width * 0.25 + i * 80 + (time * 20) % 80;
      final soldierY = size.height * 0.82;

      // Shield (red with gold trim)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(soldierX - 15, soldierY - 35, 30, 45),
          const Radius.circular(15),
        ),
        Paint()..color = const Color(0xFF8B0000),
      );

      // Shield border
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(soldierX - 15, soldierY - 35, 30, 45),
          const Radius.circular(15),
        ),
        Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Shield emblem (cross)
      canvas.drawLine(
        Offset(soldierX, soldierY - 30),
        Offset(soldierX, soldierY),
        Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 3,
      );
      canvas.drawLine(
        Offset(soldierX - 10, soldierY - 15),
        Offset(soldierX + 10, soldierY - 15),
        Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 3,
      );

      // Helmet crest
      canvas.drawPath(
        Path()
          ..moveTo(soldierX - 8, soldierY - 35)
          ..lineTo(soldierX, soldierY - 45)
          ..lineTo(soldierX + 8, soldierY - 35)
          ..close(),
        Paint()..color = const Color(0xFFDC143C),
      );

      // Spear
      canvas.drawLine(
        Offset(soldierX + 18, soldierY - 50),
        Offset(soldierX + 18, soldierY + 10),
        Paint()
          ..color = const Color(0xFF8B4513)
          ..strokeWidth = 2,
      );

      // Spear tip
      canvas.drawPath(
        Path()
          ..moveTo(soldierX + 18, soldierY - 60)
          ..lineTo(soldierX + 15, soldierY - 50)
          ..lineTo(soldierX + 21, soldierY - 50)
          ..close(),
        Paint()..color = const Color(0xFFC0C0C0),
      );
    }

    // Roman laurel wreath (victory symbol)
    final wreathCenter = Offset(size.width * 0.50, size.height * 0.25);
    final wreathRadius = 40.0;

    // Wreath circle
    for (double angle = 0; angle < 2 * math.pi; angle += 0.2) {
      final x = wreathCenter.dx + wreathRadius * math.cos(angle);
      final y = wreathCenter.dy + wreathRadius * math.sin(angle);

      // Leaves
      canvas.drawPath(
        Path()
          ..moveTo(x, y)
          ..quadraticBezierTo(
            x + 8 * math.cos(angle + 0.5),
            y + 8 * math.sin(angle + 0.5),
            x + 5 * math.cos(angle),
            y + 5 * math.sin(angle),
          )
          ..quadraticBezierTo(
            x + 8 * math.cos(angle - 0.5),
            y + 8 * math.sin(angle - 0.5),
            x,
            y,
          )
          ..close(),
        Paint()..color = const Color(0xFF228B22),
      );
    }

    // SPQR in center
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Roman',
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(wreathCenter.dx - textPainter.width / 2, wreathCenter.dy - 11),
    );
  }

  void _paintMedieval(Canvas canvas, Size size) {
    // Medieval castle with detailed architecture
    final castleY = size.height * 0.45;
    final castlePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF708090),
          const Color(0xFF2F4F4F),
        ],
      ).createShader(Rect.fromLTWH(0, castleY, size.width, size.height * 0.43));

    // Main castle keep
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.35,
        castleY,
        size.width * 0.30,
        size.height * 0.43,
      ),
      castlePaint,
    );

    // Battlements (crenellations)
    for (double x = size.width * 0.35; x < size.width * 0.65; x += 30) {
      // Merlon (solid part)
      canvas.drawRect(
        Rect.fromLTWH(x, castleY - 20, 18, 20),
        Paint()..color = const Color(0xFF708090),
      );
    }

    // Left tower
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.23,
        castleY - size.height * 0.05,
        size.width * 0.10,
        size.height * 0.48,
      ),
      castlePaint,
    );

    // Left tower cone roof
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.22, castleY - size.height * 0.05)
        ..lineTo(size.width * 0.28, castleY - size.height * 0.15)
        ..lineTo(size.width * 0.34, castleY - size.height * 0.05)
        ..close(),
      Paint()..color = const Color(0xFF8B0000),
    );

    // Right tower
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.67,
        castleY - size.height * 0.05,
        size.width * 0.10,
        size.height * 0.48,
      ),
      castlePaint,
    );

    // Right tower cone roof
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.66, castleY - size.height * 0.05)
        ..lineTo(size.width * 0.72, castleY - size.height * 0.15)
        ..lineTo(size.width * 0.78, castleY - size.height * 0.05)
        ..close(),
      Paint()..color = const Color(0xFF8B0000),
    );

    // Arched gate
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.43, size.height * 0.88)
        ..lineTo(size.width * 0.43, castleY + size.height * 0.25)
        ..quadraticBezierTo(
          size.width * 0.50,
          castleY + size.height * 0.18,
          size.width * 0.57,
          castleY + size.height * 0.25,
        )
        ..lineTo(size.width * 0.57, size.height * 0.88)
        ..close(),
      Paint()..color = const Color(0xFF000000),
    );

    // Portcullis (gate bars)
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        Offset(size.width * 0.44 + i * 8, castleY + size.height * 0.25),
        Offset(size.width * 0.44 + i * 8, size.height * 0.88),
        Paint()
          ..color = const Color(0xFF4A4A4A)
          ..strokeWidth = 2,
      );
    }

    // Windows with cross pattern
    final windowPositions = [
      [0.40, 0.55],
      [0.54, 0.55],
      [0.40, 0.65],
      [0.54, 0.65],
    ];

    for (final pos in windowPositions) {
      final wx = size.width * pos[0];
      final wy = castleY + size.height * pos[1];

      // Window glow (candlelight)
      canvas.drawRect(
        Rect.fromLTWH(wx, wy, 18, 22),
        Paint()..color = const Color(0xFFFFD700).withOpacity(0.7),
      );

      // Window cross
      canvas.drawLine(
        Offset(wx, wy + 11),
        Offset(wx + 18, wy + 11),
        Paint()
          ..color = const Color(0xFF2F4F4F)
          ..strokeWidth = 2,
      );
      canvas.drawLine(
        Offset(wx + 9, wy),
        Offset(wx + 9, wy + 22),
        Paint()
          ..color = const Color(0xFF2F4F4F)
          ..strokeWidth = 2,
      );
    }

    // Knight on horseback (silhouette)
    final knightX = size.width * 0.15 + (time * 50) % (size.width * 0.20);
    final knightY = size.height * 0.80;

    // Horse body
    canvas.drawPath(
      Path()
        ..moveTo(knightX, knightY)
        ..quadraticBezierTo(knightX + 15, knightY - 15, knightX + 30, knightY)
        ..lineTo(knightX + 35, knightY + 20)
        ..lineTo(knightX + 30, knightY + 25)
        ..lineTo(knightX + 10, knightY + 25)
        ..lineTo(knightX + 5, knightY + 20)
        ..close(),
      Paint()..color = const Color(0xFF4A4A4A),
    );

    // Knight with armor
    canvas.drawPath(
      Path()
        ..moveTo(knightX + 18, knightY - 5)
        ..lineTo(knightX + 18, knightY - 25)
        ..lineTo(knightX + 25, knightY - 25)
        ..lineTo(knightX + 25, knightY - 5)
        ..close(),
      Paint()..color = const Color(0xFF708090),
    );

    // Helmet
    canvas.drawCircle(
      Offset(knightX + 21, knightY - 30),
      6,
      Paint()..color = const Color(0xFFC0C0C0),
    );

    // Sword raised
    canvas.drawLine(
      Offset(knightX + 28, knightY - 25),
      Offset(knightX + 35, knightY - 45),
      Paint()
        ..color = const Color(0xFFC0C0C0)
        ..strokeWidth = 3,
    );

    // Full moon
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.22),
      38,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFFACD),
            const Color(0xFFEEE8AA).withOpacity(0.9),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(size.width * 0.85, size.height * 0.22), radius: 38),
        ),
    );

    // Moon glow
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.22),
      50,
      Paint()
        ..color = const Color(0xFFFFFACD).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Flag waving
    final flagPole = size.width * 0.72;
    final flagTop = castleY - size.height * 0.10;

    canvas.drawLine(
      Offset(flagPole, flagTop),
      Offset(flagPole, flagTop - 70),
      Paint()
        ..color = const Color(0xFF8B7355)
        ..strokeWidth = 3,
    );

    // Flag cloth (animated wave)
    final flagPath = Path()..moveTo(flagPole, flagTop - 70);
    for (double i = 0; i <= 1.0; i += 0.1) {
      final x = flagPole + 45 * i;
      final y = flagTop - 70 + math.sin((time * 4 + i) * 2 * math.pi) * 4;
      flagPath.lineTo(x, y);
    }
    flagPath.lineTo(flagPole + 45, flagTop - 50);
    flagPath.lineTo(flagPole, flagTop - 50);
    flagPath.close();

    canvas.drawPath(
      flagPath,
      Paint()..color = const Color(0xFF4169E1),
    );

    // Coat of arms on flag
    canvas.drawPath(
      Path()
        ..moveTo(flagPole + 15, flagTop - 65)
        ..lineTo(flagPole + 20, flagTop - 55)
        ..lineTo(flagPole + 25, flagTop - 65)
        ..close(),
      Paint()..color = const Color(0xFFFFD700),
    );
  }

  void _paintRenaissance(Canvas canvas, Size size) {
    // Leonardo da Vinci's Vitruvian Man inspired scene

    // Parchment scroll background
    final scrollRect = Rect.fromCenter(
      center: Offset(size.width * 0.50, size.height * 0.50),
      width: size.width * 0.50,
      height: size.height * 0.60,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(scrollRect, const Radius.circular(8)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFFF8DC),
            const Color(0xFFFFE4B5),
          ],
        ).createShader(scrollRect),
    );

    // Scroll border
    canvas.drawRRect(
      RRect.fromRectAndRadius(scrollRect, const Radius.circular(8)),
      Paint()
        ..color = const Color(0xFF8B4513)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Vitruvian Man circle and square
    final manCenter = Offset(size.width * 0.50, size.height * 0.50);

    // Circle (represents divine/spiritual)
    canvas.drawCircle(
      manCenter,
      size.width * 0.18,
      Paint()
        ..color = const Color(0xFF8B4513).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Square (represents earthly/material)
    canvas.drawRect(
      Rect.fromCenter(
        center: manCenter,
        width: size.width * 0.25,
        height: size.width * 0.25,
      ),
      Paint()
        ..color = const Color(0xFF8B4513).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Human figure (simplified Vitruvian Man)
    final manPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Head
    canvas.drawCircle(
      manCenter.translate(0, -size.height * 0.08),
      size.width * 0.03,
      manPaint,
    );

    // Body
    canvas.drawLine(
      manCenter.translate(0, -size.height * 0.05),
      manCenter.translate(0, size.height * 0.08),
      manPaint,
    );

    // Arms (spread)
    final armAngle = math.sin(time * 2) * 0.3;
    canvas.drawLine(
      manCenter.translate(0, -size.height * 0.02),
      manCenter.translate(-size.width * 0.15, -size.height * 0.02 + armAngle * 20),
      manPaint,
    );
    canvas.drawLine(
      manCenter.translate(0, -size.height * 0.02),
      manCenter.translate(size.width * 0.15, -size.height * 0.02 - armAngle * 20),
      manPaint,
    );

    // Legs (spread)
    final legAngle = math.sin(time * 2) * 0.2;
    canvas.drawLine(
      manCenter.translate(0, size.height * 0.08),
      manCenter.translate(-size.width * 0.08 - legAngle * 15, size.height * 0.18),
      manPaint,
    );
    canvas.drawLine(
      manCenter.translate(0, size.height * 0.08),
      manCenter.translate(size.width * 0.08 + legAngle * 15, size.height * 0.18),
      manPaint,
    );

    // Measurement lines and annotations
    final annotationPaint = Paint()
      ..color = const Color(0xFF8B4513).withOpacity(0.6)
      ..strokeWidth = 1;

    // Horizontal measurement lines
    for (int i = 0; i < 5; i++) {
      final y = size.height * 0.25 + i * size.height * 0.10;
      canvas.drawLine(
        Offset(size.width * 0.20, y),
        Offset(size.width * 0.28, y),
        annotationPaint,
      );
      canvas.drawLine(
        Offset(size.width * 0.72, y),
        Offset(size.width * 0.80, y),
        annotationPaint,
      );
    }

    // Painting tools in corner (Renaissance artist's studio)
    final toolX = size.width * 0.15;
    final toolY = size.height * 0.75;

    // Palette
    canvas.drawOval(
      Rect.fromCenter(center: Offset(toolX, toolY), width: 60, height: 45),
      Paint()..color = const Color(0xFF8B7355),
    );

    // Paint colors on palette
    final paints = [
      const Color(0xFFDC143C), // Red
      const Color(0xFF4169E1), // Blue
      const Color(0xFFFFD700), // Gold
      const Color(0xFF228B22), // Green
    ];

    for (int i = 0; i < paints.length; i++) {
      canvas.drawCircle(
        Offset(toolX - 15 + i * 10, toolY),
        5,
        Paint()..color = paints[i],
      );
    }

    // Brushes
    for (int i = 0; i < 3; i++) {
      final brushX = toolX + 60 + i * 18;
      canvas.drawLine(
        Offset(brushX, toolY - 25),
        Offset(brushX, toolY + 15),
        Paint()
          ..color = const Color(0xFF8B4513)
          ..strokeWidth = 2,
      );

      // Brush tip
      canvas.drawCircle(
        Offset(brushX, toolY - 28),
        4,
        Paint()..color = paints[i % paints.length].withOpacity(0.7),
      );
    }

    // Quill pen and inkwell
    final quillX = size.width * 0.82;
    final quillY = size.height * 0.75;

    // Inkwell
    canvas.drawPath(
      Path()
        ..moveTo(quillX - 8, quillY + 10)
        ..lineTo(quillX - 10, quillY + 20)
        ..lineTo(quillX + 10, quillY + 20)
        ..lineTo(quillX + 8, quillY + 10)
        ..close(),
      Paint()..color = const Color(0xFF2F4F4F),
    );

    // Quill feather
    final quillPath = Path()
      ..moveTo(quillX + 15, quillY + 5)
      ..quadraticBezierTo(quillX + 25, quillY - 20, quillX + 20, quillY - 35);

    canvas.drawPath(
      quillPath,
      Paint()
        ..color = const Color(0xFFFFFFFF).withOpacity(0.9)
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Quill shaft detail
    canvas.drawPath(
      quillPath,
      Paint()
        ..color = const Color(0xFF8B4513)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Architectural dome (Brunelleschi's dome inspired)
    final domeCenter = Offset(size.width * 0.50, size.height * 0.18);

    // Dome outline
    canvas.drawPath(
      Path()
        ..moveTo(domeCenter.dx - 70, domeCenter.dy + 20)
        ..quadraticBezierTo(
          domeCenter.dx - 60,
          domeCenter.dy - 30,
          domeCenter.dx,
          domeCenter.dy - 40,
        )
        ..quadraticBezierTo(
          domeCenter.dx + 60,
          domeCenter.dy - 30,
          domeCenter.dx + 70,
          domeCenter.dy + 20,
        ),
      Paint()
        ..color = const Color(0xFFCD853F)
        ..style = PaintingStyle.fill,
    );

    // Dome segments
    for (int i = -2; i <= 2; i++) {
      canvas.drawPath(
        Path()
          ..moveTo(domeCenter.dx + i * 25, domeCenter.dy + 20)
          ..quadraticBezierTo(
            domeCenter.dx + i * 20,
            domeCenter.dy - 10,
            domeCenter.dx,
            domeCenter.dy - 40,
          ),
        Paint()
          ..color = const Color(0xFF8B4513).withOpacity(0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }

    // Lantern on top
    canvas.drawRect(
      Rect.fromCenter(
        center: domeCenter.translate(0, -45),
        width: 15,
        height: 20,
      ),
      Paint()..color = const Color(0xFFFFD700),
    );
  }

  void _paintIndustrial(Canvas canvas, Size size) {
    // Industrial Revolution - Steam engine and factory

    // Factory skyline with smokestacks
    final factoryY = size.height * 0.50;

    // Main factory building
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.15,
        factoryY,
        size.width * 0.70,
        size.height * 0.38,
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF696969),
            const Color(0xFF505050),
          ],
        ).createShader(Rect.fromLTWH(
          size.width * 0.15,
          factoryY,
          size.width * 0.70,
          size.height * 0.38,
        )),
    );

    // Factory windows (lit)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 10; col++) {
        final wx = size.width * 0.18 + col * size.width * 0.065;
        final wy = factoryY + 15 + row * 38;

        canvas.drawRect(
          Rect.fromLTWH(wx, wy, 22, 28),
          Paint()..color = const Color(0xFFFFD700).withOpacity(0.8),
        );

        // Window frames
        canvas.drawRect(
          Rect.fromLTWH(wx, wy, 22, 28),
          Paint()
            ..color = const Color(0xFF2F4F4F)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        // Window cross
        canvas.drawLine(
          Offset(wx + 11, wy),
          Offset(wx + 11, wy + 28),
          Paint()
            ..color = const Color(0xFF2F4F4F)
            ..strokeWidth = 2,
        );
      }
    }

    // Smokestacks
    for (int i = 0; i < 3; i++) {
      final stackX = size.width * (0.25 + i * 0.25);
      final stackWidth = 28.0;

      // Stack body
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(stackX, factoryY - 100, stackWidth, 100),
          const Radius.circular(4),
        ),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF8B4513),
              const Color(0xFFCD853F),
              const Color(0xFF8B4513),
            ],
          ).createShader(Rect.fromLTWH(stackX, factoryY - 100, stackWidth, 100)),
      );

      // Stack rings
      for (int ring = 0; ring < 3; ring++) {
        canvas.drawRect(
          Rect.fromLTWH(stackX - 2, factoryY - 90 + ring * 35, stackWidth + 4, 4),
          Paint()..color = const Color(0xFF2F4F4F),
        );
      }

      // Smoke billowing
      for (int j = 0; j < 8; j++) {
        final smokeY = factoryY - 110 - j * 30;
        final smokeSize = 18.0 + j * 10;
        final drift = math.sin(time * 1.5 + i * 2 + j * 0.5) * 30;
        final opacity = (0.7 - j * 0.08).clamp(0.0, 1.0);

        canvas.drawCircle(
          Offset(stackX + stackWidth / 2 + drift, smokeY),
          smokeSize,
          Paint()
            ..color = const Color(0xFF696969).withOpacity(opacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
        );
      }
    }

    // Steam locomotive (moving)
    final trainX = size.width * 0.05 + (time * 120) % size.width;
    final trainY = size.height * 0.78;

    // Engine boiler
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(trainX, trainY - 25, 70, 35),
        const Radius.circular(18),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2F4F4F),
            const Color(0xFF1A1A1A),
          ],
        ).createShader(Rect.fromLTWH(trainX, trainY - 25, 70, 35)),
    );

    // Engine cab
    canvas.drawRect(
      Rect.fromLTWH(trainX + 50, trainY - 45, 35, 35),
      Paint()..color = const Color(0xFF8B0000),
    );

    // Cab window
    canvas.drawRect(
      Rect.fromLTWH(trainX + 56, trainY - 38, 18, 15),
      Paint()..color = const Color(0xFF87CEEB).withOpacity(0.6),
    );

    // Smokestack on locomotive
    canvas.drawRect(
      Rect.fromLTWH(trainX + 15, trainY - 45, 12, 20),
      Paint()..color = const Color(0xFF2F4F4F),
    );

    // Stack top rim
    canvas.drawRect(
      Rect.fromLTWH(trainX + 12, trainY - 48, 18, 4),
      Paint()..color = const Color(0xFF696969),
    );

    // Locomotive steam puff
    for (int p = 0; p < 4; p++) {
      canvas.drawCircle(
        Offset(trainX + 21 - p * 25, trainY - 52 - p * 15),
        12.0 + p * 8,
        Paint()
          ..color = Colors.white.withOpacity(0.5 - p * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Cow catcher (front)
    canvas.drawPath(
      Path()
        ..moveTo(trainX - 8, trainY + 10)
        ..lineTo(trainX, trainY - 5)
        ..lineTo(trainX, trainY + 10)
        ..close(),
      Paint()..color = const Color(0xFFC0C0C0),
    );

    // Wheels (with motion)
    final wheelRadius = 12.0;
    final wheelRotation = (time * 10) % (2 * math.pi);

    for (int w = 0; w < 4; w++) {
      final wheelX = trainX + 15 + w * 20;
      final wheelY = trainY + 10;

      // Wheel
      canvas.drawCircle(
        Offset(wheelX, wheelY),
        wheelRadius,
        Paint()..color = const Color(0xFF1A1A1A),
      );

      // Wheel rim
      canvas.drawCircle(
        Offset(wheelX, wheelY),
        wheelRadius,
        Paint()
          ..color = const Color(0xFFC0C0C0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

      // Spokes
      for (int s = 0; s < 6; s++) {
        final angle = wheelRotation + (s * math.pi / 3);
        canvas.drawLine(
          Offset(wheelX, wheelY),
          Offset(
            wheelX + (wheelRadius - 3) * math.cos(angle),
            wheelY + (wheelRadius - 3) * math.sin(angle),
          ),
          Paint()
            ..color = const Color(0xFFC0C0C0)
            ..strokeWidth = 2,
        );
      }

      // Hub
      canvas.drawCircle(
        Offset(wheelX, wheelY),
        4,
        Paint()..color = const Color(0xFF696969),
      );
    }

    // Railroad tracks
    final trackY = size.height * 0.88;

    // Rails
    canvas.drawLine(
      Offset(0, trackY),
      Offset(size.width, trackY),
      Paint()
        ..color = const Color(0xFF696969)
        ..strokeWidth = 3,
    );
    canvas.drawLine(
      Offset(0, trackY + 15),
      Offset(size.width, trackY + 15),
      Paint()
        ..color = const Color(0xFF696969)
        ..strokeWidth = 3,
    );

    // Railroad ties
    for (double x = 0; x < size.width; x += 25) {
      canvas.drawRect(
        Rect.fromLTWH(x, trackY - 3, 18, 20),
        Paint()..color = const Color(0xFF8B4513),
      );
    }

    // Gear mechanism (large display)
    final gearX = size.width * 0.85;
    final gearY = size.height * 0.40;

    _drawDetailedGear(canvas, Offset(gearX, gearY), 45, 16, time * 2);
    _drawDetailedGear(canvas, Offset(gearX - 60, gearY + 45), 32, 12, -time * 2.8);
    _drawDetailedGear(canvas, Offset(gearX + 20, gearY + 65), 25, 10, time * 3.5);

    // Connecting rod between gears
    canvas.drawLine(
      Offset(gearX - 20, gearY + 20),
      Offset(gearX + 10, gearY + 50),
      Paint()
        ..color = const Color(0xFF2F4F4F)
        ..strokeWidth = 4,
    );
  }

  void _drawDetailedGear(Canvas canvas, Offset center, double radius, int teeth, double rotation) {
    final path = Path();
    final angleStep = (2 * math.pi) / teeth;

    for (int i = 0; i < teeth; i++) {
      final angle = rotation + i * angleStep;
      final toothAngle = angleStep / 4;

      final innerR = radius - 6;
      final outerR = radius;

      final p1 = Offset(
        center.dx + outerR * math.cos(angle - toothAngle),
        center.dy + outerR * math.sin(angle - toothAngle),
      );
      final p2 = Offset(
        center.dx + outerR * math.cos(angle + toothAngle),
        center.dy + outerR * math.sin(angle + toothAngle),
      );
      final p3 = Offset(
        center.dx + innerR * math.cos(angle + toothAngle * 1.5),
        center.dy + innerR * math.sin(angle + toothAngle * 1.5),
      );

      if (i == 0) path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
    }
    path.close();

    // Gear body with metallic gradient
    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF808080),
            const Color(0xFF505050),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // Gear outline
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2F2F2F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Center hub
    canvas.drawCircle(
      center,
      radius * 0.35,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF404040),
            const Color(0xFF1A1A1A),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 0.35)),
    );

    // Center bolt
    canvas.drawCircle(
      center,
      radius * 0.15,
      Paint()..color = const Color(0xFF696969),
    );

    // Bolt head details (hex)
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * math.pi;
      canvas.drawLine(
        Offset(
          center.dx + (radius * 0.12) * math.cos(angle),
          center.dy + (radius * 0.12) * math.sin(angle),
        ),
        Offset(
          center.dx + (radius * 0.12) * math.cos(angle + math.pi / 6),
          center.dy + (radius * 0.12) * math.sin(angle + math.pi / 6),
        ),
        Paint()
          ..color = const Color(0xFF2F2F2F)
          ..strokeWidth = 1,
      );
    }
  }

  void _paintDigital(Canvas canvas, Size size) {
    // Computer screen
    final screenX = size.width * 0.25;
    final screenY = size.height * 0.35;
    final screenW = size.width * 0.50;
    final screenH = size.height * 0.35;

    // Monitor frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(screenX - 10, screenY - 10, screenW + 20, screenH + 20),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF2F4F4F),
    );

    // Screen (glowing)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(screenX, screenY, screenW, screenH),
        const Radius.circular(4),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF001F3F),
            const Color(0xFF0074D9),
          ],
        ).createShader(Rect.fromLTWH(screenX, screenY, screenW, screenH)),
    );

    // Screen glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(screenX, screenY, screenW, screenH),
        const Radius.circular(4),
      ),
      Paint()
        ..color = const Color(0xFF00CED1).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Code lines
    final rnd = math.Random(789);
    for (int i = 0; i < 12; i++) {
      final lineY = screenY + 20 + i * 22;
      final lineLength = (50 + rnd.nextDouble() * 150).toInt();

      final codePainter = TextPainter(
        text: TextSpan(
          text: '>' + '=' * (lineLength ~/ 10),
          style: TextStyle(
            color: const Color(0xFF00FF00).withOpacity(0.8),
            fontSize: 14,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      codePainter.layout();
      codePainter.paint(canvas, Offset(screenX + 15, lineY));
    }

    // Blinking cursor
    if ((time * 2) % 1.0 > 0.5) {
      canvas.drawRect(
        Rect.fromLTWH(screenX + 15, screenY + 20 + 12 * 22, 10, 16),
        Paint()..color = const Color(0xFF00FF00),
      );
    }

    // Monitor stand
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.48,
        screenY + screenH + 10,
        size.width * 0.04,
        30,
      ),
      Paint()..color = const Color(0xFF696969),
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.44,
        screenY + screenH + 40,
        size.width * 0.12,
        8,
      ),
      Paint()..color = const Color(0xFF696969),
    );

    // Network nodes (connected)
    final nodes = [
      Offset(size.width * 0.10, size.height * 0.30),
      Offset(size.width * 0.15, size.height * 0.50),
      Offset(size.width * 0.85, size.height * 0.40),
      Offset(size.width * 0.90, size.height * 0.60),
      Offset(size.width * 0.80, size.height * 0.75),
    ];

    // Connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if (rnd.nextDouble() > 0.5) {
          canvas.drawLine(
            nodes[i],
            nodes[j],
            Paint()
              ..color = const Color(0xFF00CED1).withOpacity(0.3)
              ..strokeWidth = 2,
          );
        }
      }
    }

    // Data packets flowing
    for (int i = 0; i < nodes.length - 1; i++) {
      final t = (time * 2 + i * 0.2) % 1.0;
      final packetPos = Offset.lerp(nodes[i], nodes[i + 1], t)!;

      canvas.drawCircle(
        packetPos,
        4,
        Paint()..color = const Color(0xFF00FF00),
      );
    }

    // Nodes
    for (final node in nodes) {
      canvas.drawCircle(
        node,
        8,
        Paint()..color = const Color(0xFF00CED1),
      );

      canvas.drawCircle(
        node,
        12,
        Paint()
          ..color = const Color(0xFF00CED1).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    // WiFi signal icon
    final wifiX = size.width * 0.90;
    final wifiY = size.height * 0.15;

    for (int i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(wifiX, wifiY),
          width: 30.0 + i * 20,
          height: 30.0 + i * 20,
        ),
        -math.pi * 0.75,
        math.pi * 1.5,
        false,
        Paint()
          ..color = const Color(0xFF00CED1).withOpacity(0.8 - i * 0.2)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke,
      );
    }

    canvas.drawCircle(
      Offset(wifiX, wifiY),
      4,
      Paint()..color = const Color(0xFF00CED1),
    );
  }

  @override
  bool shouldRepaint(covariant _EraScenePainter oldDelegate) =>
      oldDelegate.time != time ||
          oldDelegate.era != era ||
          oldDelegate.progress != progress;
}

//═══════════════════════════════════════════════════════════
// TIMELINE BAR
//═══════════════════════════════════════════════════════════

class _TimelineBar extends StatelessWidget {
  final double currentTime;

  const _TimelineBar({required this.currentTime});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TimelineBarPainter(currentTime: currentTime),
      size: const Size(double.infinity, 60),
    );
  }
}

class _TimelineBarPainter extends CustomPainter {
  final double currentTime;

  _TimelineBarPainter({required this.currentTime});

  @override
  void paint(Canvas canvas, Size size) {
    // Background bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 20, size.width, 8),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withOpacity(0.2),
    );

    // Progress bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 20, size.width * currentTime, 8),
        const Radius.circular(4),
      ),
      Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFDAA520),
            const Color(0xFF8B0000),
            const Color(0xFF4169E1),
            const Color(0xFF8B4513),
            const Color(0xFF696969),
            const Color(0xFF00CED1),
          ],
          stops: const [0.0, 0.16, 0.32, 0.48, 0.64, 0.80],
        ).createShader(Rect.fromLTWH(0, 20, size.width, 8)),
    );

    // Era markers
    final eras = ['3100 BCE', '27 BCE', '476 CE', '1300 CE', '1760 CE', '1970 CE'];
    for (int i = 0; i < 6; i++) {
      final x = size.width * (i / 6.0 + 0.08);

      canvas.drawCircle(
        Offset(x, 24),
        6,
        Paint()..color = Colors.white,
      );

      canvas.drawCircle(
        Offset(x, 24),
        4,
        Paint()..color = const Color(0xFF2F4F4F),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: eras[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, 35),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimelineBarPainter oldDelegate) =>
      oldDelegate.currentTime != currentTime;
}