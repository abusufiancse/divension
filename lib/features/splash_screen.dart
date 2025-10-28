import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/routes/route_name.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spin1;
  late final AnimationController _spin2;
  late final AnimationController _spin3;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _spin1 = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _spin2 = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat(reverse: false);
    _spin3 = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: false);
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(RouteName.homeScreen);
    });



  }

  @override
  void dispose() {
    _spin1.dispose();
    _spin2.dispose();
    _spin3.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A2540), // deep indigo
        Color(0xFF0E7490), // teal-600
        Color(0xFF14B8A6), // teal-400
        Color(0xFF06B6D4), // cyan-400
      ],
      stops: [0.0, 0.45, 0.78, 1.0],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bg),
        child: Stack(
          children: [
            // soft glow blobs
            Positioned(left: -80, top: -60, child: _glowBlob(220)),
            Positioned(right: -60, bottom: -40, child: _glowBlob(180)),
            // content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Atom system
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // nucleus pulse
                          ScaleTransition(
                            scale: Tween<double>(begin: .92, end: 1.05).animate(
                              CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                            ),
                            child: _nucleus(),
                          ),
                          // orbit rings (light)
                          _orbitRing(100, 0.6),
                          _orbitRing(72, 0.5, tilt: .45),
                          _orbitRing(130, 0.4, tilt: -.35),

                          // electrons
                          RotationTransition(
                            turns: _spin1,
                            child: _electronOnRadius(radius: 100, angle: 0),
                          ),
                          RotationTransition(
                            turns: _spin2,
                            child: _electronOnRadius(radius: 72, angle: math.pi * .6),
                          ),
                          RotationTransition(
                            turns: _spin3,
                            child: _electronOnRadius(radius: 130, angle: math.pi * 1.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Title
                    Text(
                      "Divention Science Club",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .3,
                        color: Colors.white.withOpacity(.98),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Opacity(
                      opacity: .9,
                      child: Text(
                        "Explore • Experiment • Evolve",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    // loading line
                    const _LoadingBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowBlob(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 120, color: Color(0x8020E3D6)),
          BoxShadow(blurRadius: 200, color: Color(0x4014B8A6)),
        ],
      ),
    );
  }

  Widget _nucleus() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFF8BF3EA), Color(0x3306B6D4)],
              stops: [0.0, .45, 1.0],
            ),
            border: Border.all(color: Colors.white.withOpacity(.35), width: 1),
            boxShadow: const [
              BoxShadow(blurRadius: 34, color: Color(0x8020E3D6)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _electronOnRadius({required double radius, required double angle}) {
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);
    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: const [
            BoxShadow(blurRadius: 16, color: Color(0xB3FFFFFF)),
          ],
          border: Border.all(color: const Color(0xFFB2F5EA), width: 2),
        ),
      ),
    );
  }

  Widget _orbitRing(double radius, double opacity, {double tilt = 0}) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateX(tilt)
        ..rotateZ(tilt * .2),
      alignment: Alignment.center,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(opacity),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _LoadingBar extends StatefulWidget {
  const _LoadingBar();

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _a = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _a,
          builder: (_, __) {
            final w = 60 + 80 * _a.value;
            return Container(
              width: w,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFB2F5EA)],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
