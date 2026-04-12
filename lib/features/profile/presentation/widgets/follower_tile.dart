import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/models/app_user.dart';
import '../screens/user_profile_screen.dart';

/// A single row in the followers / following list.
///
/// Shows avatar, name, @username, and a Follow/Following toggle button
/// (hidden when the tile represents the current user).
class FollowerTile extends StatelessWidget {
  const FollowerTile({
    super.key,
    required this.user,
    required this.isFollowing,
    required this.onToggleFollow,
  });

  final AppUser user;
  final bool isFollowing;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizations.of(context)!;
    final isMe = currentUid == user.uid;

    return InkWell(
      onTap: () {
        if (!isMe) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileScreen(
                userId: user.uid,
                userName: user.name,
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.pal.border,
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: UserAvatar(
                  photoUrl: user.photoUrl,
                  name: user.name,
                  size: 48,
                  backgroundColor: context.pal.accent,
                  textColor: context.pal.white,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name + username
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.pal.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: context.pal.inkSoft,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            // Follow / Following button (hidden for self)
            if (!isMe)
              GestureDetector(
                onTap: onToggleFollow,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isFollowing
                        ? Colors.transparent
                        : context.pal.accent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isFollowing
                          ? context.pal.inkFaint
                          : context.pal.accent,
                    ),
                  ),
                  child: Text(
                    isFollowing
                        ? l10n.userProfileFollowing
                        : l10n.userProfileFollow,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isFollowing
                          ? context.pal.inkSoft
                          : context.pal.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
