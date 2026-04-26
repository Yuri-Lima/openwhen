import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Caminhos dos SVG em [assets/icons/]. Use com [WhenoteSvgIcon] ou [SvgPicture.asset].
abstract final class WhenoteIcons {
  static const String _base = 'assets/icons';

  static const String envelope = '$_base/envelope.svg';
  static const String letter = '$_base/letter.svg';
  static const String capsule = '$_base/capsule.svg';
  static const String heart = '$_base/heart.svg';
  static const String lockClosed = '$_base/lock_closed.svg';
  static const String lockOpen = '$_base/lock_open.svg';
  static const String bell = '$_base/bell.svg';
  static const String sparkles = '$_base/sparkles.svg';
  static const String seal = '$_base/seal.svg';
  static const String gift = '$_base/gift.svg';

  static const List<String> all = [
    envelope,
    letter,
    capsule,
    heart,
    lockClosed,
    lockOpen,
    bell,
    sparkles,
    seal,
    gift,
  ];
}

/// Ícone SVG do kit Whenote; [color] aplica `BlendMode.srcIn` (adequado a traços `currentColor`).
class WhenoteSvgIcon extends StatelessWidget {
  const WhenoteSvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final String assetPath;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      semanticsLabel: semanticLabel,
      colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
    );
  }
}
