import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/theme/app_theme.dart';
import 'avatar_service.dart';

/// Fluxo de escolha de foto (galeria) e upload para Storage + Firestore.
class AvatarUploadHelper {
  AvatarUploadHelper._();

  static final ImagePicker _picker = ImagePicker();

  /// Abre bottom sheet: galeria ou remover foto.
  static Future<void> showAvatarOptions(BuildContext context, String uid) async {
    final p = context.pal;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: p.accent),
              title: Text('Escolher da galeria', style: GoogleFonts.dmSans(color: p.ink)),
              onTap: () async {
                Navigator.pop(ctx);
                await pickFromGalleryAndUpload(context, uid);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
              title: Text('Remover foto', style: GoogleFonts.dmSans(color: Colors.red.shade400)),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await AvatarService.removeUserPhotoUrl(uid);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto removida')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> pickFromGalleryAndUpload(BuildContext context, String uid) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 88,
    );
    if (file == null) return;
    try {
      final url = await AvatarService.uploadAvatar(uid, file);
      await AvatarService.updateUserPhotoUrl(uid, url);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil atualizada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar foto: $e')),
        );
      }
    }
  }
}
