import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'feedback_entry_button.dart';

/// Wraps the owl glyph: tap opens feedback sheet; a wobble + short “buzz” motion
/// repeats on unpredictable intervals while the widget is mounted (each screen
/// visit restarts its own schedule).
class OwlFeedbackAffordance extends StatefulWidget {
  const OwlFeedbackAffordance({
    super.key,
    required this.child,
    this.forDarkHeader = false,
    this.navigatorKey,
  });

  final Widget child;
  final bool forDarkHeader;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<OwlFeedbackAffordance> createState() => _OwlFeedbackAffordanceState();
}

class _OwlFeedbackAffordanceState extends State<OwlFeedbackAffordance>
    with TickerProviderStateMixin {
  late AnimationController _wobbleController;
  late Animation<double> _tilt;
  late Animation<double> _lift;
  late AnimationController _buzzController;
  Timer? _idleTimer;
  final math.Random _rng = math.Random();

  /// Slight per-nudge variation so the buzz never feels identical.
  double _buzzTurns = 26;

  /// First nudge after mount: short random wait so it feels natural per screen.
  static const int _firstDelayMinMs = 900;
  static const int _firstDelayMaxMs = 4800;

  /// Later nudges: wide random gap so the motion never feels rhythmic.
  static const int _betweenMinMs = 11000;
  static const int _betweenMaxMs = 52000;

  late final Listenable _motionListenable;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buzzController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _motionListenable =
        Listenable.merge([_wobbleController, _buzzController]);

    _tilt = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.13),
        weight: 0.28,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.13, end: -0.11),
        weight: 0.38,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.11, end: 0.0),
        weight: 0.34,
      ),
    ]).animate(CurvedAnimation(
      parent: _wobbleController,
      curve: Curves.easeInOutCubic,
    ));
    _lift = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -3.6),
        weight: 0.35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -3.6, end: 1.6),
        weight: 0.35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.6, end: 0.0),
        weight: 0.3,
      ),
    ]).animate(CurvedAnimation(
      parent: _wobbleController,
      curve: Curves.easeInOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleIdle(initial: true);
    });
  }

  int _randomInclusiveMs(int min, int max) {
    if (max <= min) return min;
    return min + _rng.nextInt(max - min + 1);
  }

  void _scheduleIdle({required bool initial}) {
    _idleTimer?.cancel();
    final delayMs = initial
        ? _randomInclusiveMs(_firstDelayMinMs, _firstDelayMaxMs)
        : _randomInclusiveMs(_betweenMinMs, _betweenMaxMs);
    _idleTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      _runNudge();
    });
  }

  Future<void> _runNudge() async {
    if (!mounted) return;
    _buzzTurns = 22 + _rng.nextDouble() * 14;
    await _wobbleController.forward();
    if (!mounted) return;
    _wobbleController.reset();
    await _buzzController.forward();
    if (!mounted) return;
    _buzzController.reset();
    _scheduleIdle(initial: false);
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _wobbleController.dispose();
    _buzzController.dispose();
    super.dispose();
  }

  void _openSheet() {
    showFeedbackSheet(context, navigatorKey: widget.navigatorKey);
  }

  /// Rapid decaying oscillation (rotation + 2D jitter) for a “vibrating” feel.
  ({double tilt, double dx, double dy}) _buzzMotion(double t) {
    final env = math.pow(1.0 - t, 0.72).toDouble();
    final turns = _buzzTurns;
    final tilt = math.sin(t * turns * math.pi) * 0.095 * env;
    final dx = math.sin(t * (turns * 1.12) * math.pi) * 3.6 * env;
    final dy = math.cos(t * (turns * 0.88) * math.pi) * 3.8 * env;
    return (tilt: tilt, dx: dx, dy: dy);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final splash = widget.forDarkHeader
        ? Colors.white.withValues(alpha: 0.12)
        : null;

    return Semantics(
      label: l10n.feedbackSemanticsLabel,
      tooltip: l10n.feedbackTooltip,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openSheet,
          splashColor: splash,
          highlightColor: splash,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedBuilder(
            animation: _motionListenable,
            builder: (context, child) {
              final double tilt;
              final double dx;
              final double dy;
              if (_wobbleController.value > 0) {
                tilt = _tilt.value;
                dx = 0;
                dy = _lift.value;
              } else if (_buzzController.value > 0) {
                final b = _buzzMotion(_buzzController.value);
                tilt = b.tilt;
                dx = b.dx;
                dy = b.dy;
              } else {
                // Idle: do not use _buzzMotion(0) — it is not at rest (dy would be ~3.8px down).
                tilt = 0;
                dx = 0;
                dy = 0;
              }
              return Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.rotate(
                  angle: tilt,
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
