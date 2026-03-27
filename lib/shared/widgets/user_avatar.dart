import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Avatar circular: foto de rede se [photoUrl] for válido; senão inicial do nome.
class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const UserAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';
    final bg = backgroundColor ?? AppColors.accent;
    final fg = textColor ?? AppColors.white;

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(initial, bg, fg),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return SizedBox(
              width: size,
              height: size,
              child: Center(
                child: SizedBox(
                  width: size * 0.35,
                  height: size * 0.35,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      );
    }

    return _fallback(initial, bg, fg);
  }

  Widget _fallback(String initial, Color bg, Color fg) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.dmSerifDisplay(
          fontSize: size * 0.42,
          color: fg,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
