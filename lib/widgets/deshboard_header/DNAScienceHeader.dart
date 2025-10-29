// lib/src/widgets/dna_science_header.dart
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Use inside SliverAppBar → FlexibleSpaceBar(background: DNAScienceHeader())
class DNAScienceHeader extends StatefulWidget {
  const DNAScienceHeader({super.key, this.loop = true});
  final bool loop;

  @override
  State<DNAScienceHeader> createState() => _DNAScienceHeaderState();
}

class _DNAScienceHeaderState extends State<DNAScienceHeader>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _helixRotation;
  late final Animation<double> _moleculeScale;
  late final Animation<double> _environmentBlend;
  late final Animation<double> _particleFlow;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
    );

    widget.loop ? _ctrl.repeat() : _ctrl.forward();

    // Smooth helix rotation
    _helixRotation = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.linear,
    );

    // Molecule assembly sequence
    _moleculeScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_ctrl);

    // Environment transition: lab → cellular → quantum
    _environmentBlend = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.20, 0.85, curve: Curves.easeInOut),
    );

    // Particle motion flow
    _particleFlow = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.linear,
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
      animation: _ctrl,
      builder: (context, _) {
        return LayoutBuilder(builder: (_, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final envBlend = _environmentBlend.value.clamp(0.0, 1.0);
          final scale = _moleculeScale.value.clamp(0.0, 1.2);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Dynamic gradient background
              _ScientificBackground(blend: envBlend),

              // Particle field (ions, electrons)
              IgnorePointer(
                child: CustomPaint(
                  painter: _ParticleFieldPainter(
                    time: _particleFlow.value,
                    density: lerpDouble(0.3, 1.0, envBlend)!,
                    seed: 42,
                  ),
                ),
              ),

              // Grid overlay (subtle)
              IgnorePointer(
                child: Opacity(
                  opacity: 0.12 * (1 - envBlend * 0.5),
                  child: CustomPaint(
                    painter: _GridPainter(),
                  ),
                ),
              ),

              // Cellular structures (background)
              if (envBlend > 0.2)
                Positioned(
                  left: w * 0.08,
                  top: h * 0.15,
                  child: Opacity(
                    opacity: (envBlend - 0.2).clamp(0.0, 0.6),
                    child: _CellStructure(
                      radius: 45 + 15 * envBlend,
                      phase: _ctrl.value,
                    ),
                  ),
                ),
              if (envBlend > 0.3)
                Positioned(
                  right: w * 0.12,
                  bottom: h * 0.20,
                  child: Opacity(
                    opacity: (envBlend - 0.3).clamp(0.0, 0.5),
                    child: _CellStructure(
                      radius: 38 + 12 * envBlend,
                      phase: _ctrl.value + 0.5,
                    ),
                  ),
                ),

              // DNA Helix (center-stage)
              Positioned.fill(
                child: Center(
                  child: Transform.scale(
                    scale: scale,
                    child: _DNAHelixWidget(
                      rotation: _helixRotation.value,
                      colorScheme: cs,
                    ),
                  ),
                ),
              ),

              // Quantum particles (late stage)
              if (envBlend > 0.6)
                IgnorePointer(
                  child: Opacity(
                    opacity: (envBlend - 0.6).clamp(0.0, 0.8),
                    child: CustomPaint(
                      painter: _QuantumParticlesPainter(
                        time: _ctrl.value,
                        intensity: envBlend,
                      ),
                    ),
                  ),
                ),

              // Title and subtitle
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 180),
                        // Text(
                        //   'BioTech Research Institute',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontWeight: FontWeight.w800,
                        //     fontSize: 26,
                        //     letterSpacing: 1.2,
                        //     shadows: [
                        //       const Shadow(
                        //         blurRadius: 16,
                        //         color: Colors.black45,
                        //         offset: Offset(0, 3),
                        //       ),
                        //       Shadow(
                        //         blurRadius: 8,
                        //         color: cs.primary.withOpacity(0.4),
                        //         offset: const Offset(0, 0),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   'Advancing Molecular Sciences',
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.85),
                        //     fontWeight: FontWeight.w400,
                        //     fontSize: 14,
                        //     letterSpacing: 0.8,
                        //     shadows: const [
                        //       Shadow(
                        //         blurRadius: 8,
                        //         color: Colors.black38,
                        //         offset: Offset(0, 2),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              // Interactive badge navigation
              Positioned(
                left: 0,
                right: 0,
                bottom: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BadgeWrapper(
                      tooltip: 'Genetics Lab',
                      onTap: () => Navigator.pushNamed(context, '/genetics'),
                      child: GeneticsBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 14),
                    _BadgeWrapper(
                      tooltip: 'Molecular Biology',
                      onTap: () => Navigator.pushNamed(context, '/molecular'),
                      child: MolecularBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 14),
                    _BadgeWrapper(
                      tooltip: 'Quantum Research',
                      onTap: () => Navigator.pushNamed(context, '/quantum'),
                      child: QuantumBadge(t: _ctrl.value, cs: cs),
                    ),
                    const SizedBox(width: 14),
                    _BadgeWrapper(
                      tooltip: 'Research Data',
                      onTap: () => Navigator.pushNamed(context, '/data'),
                      child: DataBadge(t: _ctrl.value, cs: cs),
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

//═══════════════════════════════════════════════════════════
// BACKGROUND GRADIENTS
//═══════════════════════════════════════════════════════════

class _ScientificBackground extends StatelessWidget {
  final double blend; // 0 = lab, 1 = quantum field
  const _ScientificBackground({required this.blend});

  @override
  Widget build(BuildContext context) {
    // Lab environment colors
    const labTop = Color(0xFF1A2332);
    const labBottom = Color(0xFF0D1418);

    // Cellular/quantum colors
    const quantumTop = Color(0xFF0A1628);
    const quantumBottom = Color(0xFF1A0F28);

    final topColor = Color.lerp(labTop, quantumTop, blend)!;
    final bottomColor = Color.lerp(labBottom, quantumBottom, blend)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

//═══════════════════════════════════════════════════════════
// DNA HELIX (Main Feature)
//═══════════════════════════════════════════════════════════

class _DNAHelixWidget extends StatelessWidget {
  final double rotation; // 0..1 loop
  final ColorScheme colorScheme;

  const _DNAHelixWidget({
    required this.rotation,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 280),
      painter: _DNAHelixPainter(
        rotation: rotation,
        colorScheme: colorScheme,
      ),
    );
  }
}

class _DNAHelixPainter extends CustomPainter {
  final double rotation;
  final ColorScheme colorScheme;

  _DNAHelixPainter({required this.rotation, required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;

    // Helix parameters
    const turns = 3.5;
    const points = 70;
    final radiusX = w * 0.28;
    final radiusY = w * 0.12;

    // Colors for base pairs
    final colorA = colorScheme.primary; // Adenine
    final colorT = const Color(0xFFE91E63); // Thymine
    final colorG = const Color(0xFF00BCD4); // Guanine
    final colorC = const Color(0xFFFFC107); // Cytosine

    final backbonePaint = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final List<_HelixPoint> strand1 = [];
    final List<_HelixPoint> strand2 = [];

    // Generate helix points
    for (int i = 0; i < points; i++) {
      final t = i / (points - 1);
      final angle = (rotation * 2 * math.pi) + (t * turns * 2 * math.pi);
      final y = h * 0.15 + (h * 0.70 * t);

      final x1 = cx + radiusX * math.cos(angle);
      final z1 = radiusY * math.sin(angle);

      final x2 = cx + radiusX * math.cos(angle + math.pi);
      final z2 = radiusY * math.sin(angle + math.pi);

      strand1.add(_HelixPoint(Offset(x1, y), z1, t));
      strand2.add(_HelixPoint(Offset(x2, y), z2, t));
    }

    // Draw base pair connections (behind)
    for (int i = 0; i < points; i += 4) {
      if (strand1[i].z < 0 || strand2[i].z < 0) {
        final baseColor = _getBaseColor(i, colorA, colorT, colorG, colorC);
        _drawBasePair(canvas, strand1[i].pos, strand2[i].pos, baseColor, 0.4);
      }
    }

    // Draw backbone (behind)
    _drawBackbone(canvas, strand1.where((p) => p.z < 0).toList(), backbonePaint, 0.5);
    _drawBackbone(canvas, strand2.where((p) => p.z < 0).toList(), backbonePaint, 0.5);

    // Draw nucleotides (behind)
    for (final pt in strand1.where((p) => p.z < 0)) {
      _drawNucleotide(canvas, pt.pos, colorScheme.primary, 0.6);
    }
    for (final pt in strand2.where((p) => p.z < 0)) {
      _drawNucleotide(canvas, pt.pos, colorScheme.secondary, 0.6);
    }

    // Draw base pair connections (front)
    for (int i = 0; i < points; i += 4) {
      if (strand1[i].z >= 0 && strand2[i].z >= 0) {
        final baseColor = _getBaseColor(i, colorA, colorT, colorG, colorC);
        _drawBasePair(canvas, strand1[i].pos, strand2[i].pos, baseColor, 1.0);
      }
    }

    // Draw backbone (front)
    _drawBackbone(canvas, strand1.where((p) => p.z >= 0).toList(), backbonePaint, 1.0);
    _drawBackbone(canvas, strand2.where((p) => p.z >= 0).toList(), backbonePaint, 1.0);

    // Draw nucleotides (front)
    for (final pt in strand1.where((p) => p.z >= 0)) {
      _drawNucleotide(canvas, pt.pos, colorScheme.primary, 1.0);
    }
    for (final pt in strand2.where((p) => p.z >= 0)) {
      _drawNucleotide(canvas, pt.pos, colorScheme.secondary, 1.0);
    }
  }

  Color _getBaseColor(int index, Color a, Color t, Color g, Color c) {
    final pattern = ['A', 'T', 'G', 'C', 'G', 'C', 'A', 'T'];
    final base = pattern[index % pattern.length];
    switch (base) {
      case 'A': return a;
      case 'T': return t;
      case 'G': return g;
      case 'C': return c;
      default: return a;
    }
  }

  void _drawBackbone(Canvas canvas, List<_HelixPoint> points, Paint paint, double opacity) {
    if (points.length < 2) return;
    final path = Path()..moveTo(points.first.pos.dx, points.first.pos.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].pos.dx, points[i].pos.dy);
    }
    canvas.drawPath(path, paint..color = paint.color.withOpacity(0.75 * opacity));
  }

  void _drawNucleotide(Canvas canvas, Offset pos, Color color, double opacity) {
    final nucleotidePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(opacity),
          color.withOpacity(opacity * 0.6),
        ],
      ).createShader(Rect.fromCircle(center: pos, radius: 5));

    canvas.drawCircle(pos, 5, nucleotidePaint);
    canvas.drawCircle(
      pos,
      5,
      Paint()
        ..color = Colors.white.withOpacity(0.4 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _drawBasePair(Canvas canvas, Offset p1, Offset p2, Color color, double opacity) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(opacity * 0.7),
          color.withOpacity(opacity * 0.3),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromPoints(p1, p2))
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);

    // Hydrogen bonds (small dots)
    final mid = Offset.lerp(p1, p2, 0.5)!;
    canvas.drawCircle(mid, 2.2, Paint()..color = Colors.white.withOpacity(0.6 * opacity));
  }

  @override
  bool shouldRepaint(covariant _DNAHelixPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

class _HelixPoint {
  final Offset pos;
  final double z; // depth
  final double t; // position along helix 0..1

  _HelixPoint(this.pos, this.z, this.t);
}

//═══════════════════════════════════════════════════════════
// PARTICLE FIELD
//═══════════════════════════════════════════════════════════

class _ParticleFieldPainter extends CustomPainter {
  final double time;
  final double density;
  final int seed;

  _ParticleFieldPainter({
    required this.time,
    required this.density,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final count = (80 * density).toInt();

    for (int i = 0; i < count; i++) {
      final baseX = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final speed = 0.3 + rnd.nextDouble() * 0.7;
      final phase = rnd.nextDouble() * 2 * math.pi;

      final x = baseX + 30 * math.sin((time * speed + phase) * 2 * math.pi);
      final y = baseY + 15 * math.cos((time * speed + phase) * 2 * math.pi);

      final radius = 0.8 + rnd.nextDouble() * 2.0;
      final opacity = (0.3 + 0.4 * rnd.nextDouble()) * density;

      final colors = [
        const Color(0xFF64B5F6),
        const Color(0xFF81C784),
        const Color(0xFFFFB74D),
        const Color(0xFFE57373),
      ];
      final color = colors[rnd.nextInt(colors.length)];

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.density != density;
}

//═══════════════════════════════════════════════════════════
// GRID OVERLAY
//═══════════════════════════════════════════════════════════

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//═══════════════════════════════════════════════════════════
// CELL STRUCTURES
//═══════════════════════════════════════════════════════════

class _CellStructure extends StatelessWidget {
  final double radius;
  final double phase;

  const _CellStructure({required this.radius, required this.phase});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: _CellPainter(phase: phase),
    );
  }
}

class _CellPainter extends CustomPainter {
  final double phase;
  _CellPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Cell membrane
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF1E88E5).withOpacity(0.15)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF42A5F5).withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Nucleus
    final nucleusRadius = radius * 0.4;
    canvas.drawCircle(
      center,
      nucleusRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF7B1FA2).withOpacity(0.5),
            const Color(0xFF4A148C).withOpacity(0.3),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: nucleusRadius)),
    );

    // Organelles
    final rnd = math.Random(42);
    for (int i = 0; i < 8; i++) {
      final angle = (phase + i * 0.125) * 2 * math.pi;
      final dist = radius * (0.5 + 0.2 * rnd.nextDouble());
      final pos = Offset(
        center.dx + dist * math.cos(angle),
        center.dy + dist * math.sin(angle),
      );
      final r = 3.0 + rnd.nextDouble() * 4.0;

      canvas.drawCircle(
        pos,
        r,
        Paint()..color = const Color(0xFF66BB6A).withOpacity(0.6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CellPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

//═══════════════════════════════════════════════════════════
// QUANTUM PARTICLES
//═══════════════════════════════════════════════════════════

class _QuantumParticlesPainter extends CustomPainter {
  final double time;
  final double intensity;

  _QuantumParticlesPainter({required this.time, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(99);
    final count = (25 * intensity).toInt();

    for (int i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final phase = time * 2 * math.pi + i * 0.3;

      final radius = 2.0 + 3.0 * (0.5 + 0.5 * math.sin(phase));
      final opacity = 0.4 + 0.4 * math.sin(phase + math.pi / 2);

      // Quantum glow effect
      canvas.drawCircle(
        Offset(x, y),
        radius * 2,
        Paint()
          ..color = const Color(0xFF00E5FF).withOpacity(opacity * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = const Color(0xFF00E5FF).withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _QuantumParticlesPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.intensity != intensity;
}

//═══════════════════════════════════════════════════════════
// BADGE WRAPPER
//═══════════════════════════════════════════════════════════

class _BadgeWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String tooltip;

  const _BadgeWrapper({
    required this.child,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.white.withOpacity(0.08),
        elevation: 0,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

//═══════════════════════════════════════════════════════════
// GENETICS BADGE (DNA Strand)
//═══════════════════════════════════════════════════════════

class GeneticsBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;

  const GeneticsBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GeneticsBadgePainter(t: t, cs: cs),
      willChange: true,
    );
  }
}

class _GeneticsBadgePainter extends CustomPainter {
  final double t;
  final ColorScheme cs;

  _GeneticsBadgePainter({required this.t, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Mini DNA helix
    final points = 20;
    final radiusX = w * 0.18;
    final phase = t * 2 * math.pi;

    for (int i = 0; i < points; i++) {
      final ty = i / points;
      final y = h * 0.1 + h * 0.8 * ty;
      final angle = phase + ty * 3.0 * 2 * math.pi;

      final x1 = w * 0.35 + radiusX * math.cos(angle);
      final x2 = w * 0.35 + radiusX * math.cos(angle + math.pi);

      if (i % 3 == 0) {
        canvas.drawLine(
          Offset(x1, y),
          Offset(x2, y),
          Paint()
            ..color = cs.primary.withOpacity(0.5)
            ..strokeWidth = 1.5,
        );
      }

      canvas.drawCircle(
        Offset(x1, y),
        2.5,
        Paint()..color = cs.primary,
      );
      canvas.drawCircle(
        Offset(x2, y),
        2.5,
        Paint()..color = cs.secondary,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GeneticsBadgePainter oldDelegate) =>
      oldDelegate.t != t;
}

//═══════════════════════════════════════════════════════════
// MOLECULAR BADGE (Molecule Structure)
//═══════════════════════════════════════════════════════════

class MolecularBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;

  const MolecularBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MolecularBadgePainter(t: t, cs: cs),
      willChange: true,
    );
  }
}

class _MolecularBadgePainter extends CustomPainter {
  final double t;
  final ColorScheme cs;

  _MolecularBadgePainter({required this.t, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rotation = t * 2 * math.pi;

    // Central atom
    canvas.drawCircle(
      center,
      7,
      Paint()
        ..shader = RadialGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.5)],
        ).createShader(Rect.fromCircle(center: center, radius: 7)),
    );

    // Orbiting electrons (6 atoms in hexagonal pattern)
    final bondPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 6; i++) {
      final angle = rotation + (i * math.pi / 3);
      final radius = size.width * 0.32;
      final pos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // Bond
      canvas.drawLine(center, pos, bondPaint);

      // Atom
      final atomSize = 4.5 + 1.5 * math.sin(rotation + i);
      canvas.drawCircle(
        pos,
        atomSize,
        Paint()..color = i.isEven ? const Color(0xFF64B5F6) : const Color(0xFFFFB74D),
      );
    }

    // Electron orbit rings
    canvas.drawCircle(
      center,
      size.width * 0.32,
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _MolecularBadgePainter oldDelegate) =>
      oldDelegate.t != t;
}

//═══════════════════════════════════════════════════════════
// QUANTUM BADGE (Quantum State)
//═══════════════════════════════════════════════════════════

class QuantumBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;

  const QuantumBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QuantumBadgePainter(t: t, cs: cs),
      willChange: true,
    );
  }
}

class _QuantumBadgePainter extends CustomPainter {
  final double t;
  final ColorScheme cs;

  _QuantumBadgePainter({required this.t, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final phase = t * 2 * math.pi;

    // Quantum superposition effect (three orbital rings)
    for (int ring = 0; ring < 3; ring++) {
      final ringRadius = (size.width * 0.15) + (ring * size.width * 0.1);
      final ringPhase = phase + ring * 0.5;

      // Ring
      canvas.drawCircle(
        center,
        ringRadius,
        Paint()
          ..color = Colors.cyanAccent.withOpacity(0.15 - ring * 0.03)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );

      // Orbiting particle
      final particleAngle = ringPhase + ring * math.pi * 0.3;
      final particlePos = Offset(
        center.dx + ringRadius * math.cos(particleAngle),
        center.dy + ringRadius * math.sin(particleAngle),
      );

      // Quantum glow
      canvas.drawCircle(
        particlePos,
        4,
        Paint()
          ..color = const Color(0xFF00E5FF).withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      // Particle
      canvas.drawCircle(
        particlePos,
        2.5,
        Paint()..color = const Color(0xFF00E5FF),
      );
    }

    // Center nucleus
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFE1F5FE),
            const Color(0xFF0288D1),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 5)),
    );

    // Energy waves
    final waveRadius = 8 + 6 * (0.5 + 0.5 * math.sin(phase * 2));
    canvas.drawCircle(
      center,
      waveRadius,
      Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant _QuantumBadgePainter oldDelegate) =>
      oldDelegate.t != t;
}

//═══════════════════════════════════════════════════════════
// DATA BADGE (Data Visualization)
//═══════════════════════════════════════════════════════════

class DataBadge extends StatelessWidget {
  final double t;
  final ColorScheme cs;

  const DataBadge({super.key, required this.t, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DataBadgePainter(t: t, cs: cs),
      willChange: true,
    );
  }
}

class _DataBadgePainter extends CustomPainter {
  final double t;
  final ColorScheme cs;

  _DataBadgePainter({required this.t, required this.cs});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Bar chart with animated bars
    final barCount = 6;
    final barWidth = w / (barCount * 2);
    final spacing = barWidth * 0.8;

    for (int i = 0; i < barCount; i++) {
      final x = (w * 0.15) + (i * (barWidth + spacing));
      final heightFactor = 0.3 + 0.5 * math.sin((t * 2 * math.pi) + i * 0.5);
      final barHeight = h * 0.7 * heightFactor;
      final y = h * 0.8 - barHeight;

      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(2),
      );

      // Bar gradient
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          cs.primary.withOpacity(0.9),
          cs.primary.withOpacity(0.4),
        ],
      ).createShader(Rect.fromLTWH(x, y, barWidth, barHeight));

      canvas.drawRRect(
        barRect,
        Paint()..shader = gradient,
      );

      // Bar outline
      canvas.drawRRect(
        barRect,
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }

    // Connecting line (trend)
    final linePath = Path();
    bool first = true;
    for (int i = 0; i < barCount; i++) {
      final x = (w * 0.15) + (i * (barWidth + spacing)) + barWidth / 2;
      final heightFactor = 0.3 + 0.5 * math.sin((t * 2 * math.pi) + i * 0.5);
      final barHeight = h * 0.7 * heightFactor;
      final y = h * 0.8 - barHeight;

      if (first) {
        linePath.moveTo(x, y);
        first = false;
      } else {
        linePath.lineTo(x, y);
      }

      // Data points
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(x, y),
        2,
        Paint()..color = cs.secondary,
      );
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Axis lines
    canvas.drawLine(
      Offset(w * 0.1, h * 0.82),
      Offset(w * 0.9, h * 0.82),
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..strokeWidth = 1.0,
    );
    canvas.drawLine(
      Offset(w * 0.12, h * 0.15),
      Offset(w * 0.12, h * 0.82),
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _DataBadgePainter oldDelegate) =>
      oldDelegate.t != t;
}