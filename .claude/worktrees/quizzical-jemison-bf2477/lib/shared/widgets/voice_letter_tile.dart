import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/voice_url.dart';

/// Dark tile (letter detail) — play/pause hosted voice audio.
class VoiceLetterTileDark extends StatefulWidget {
  final String url;

  const VoiceLetterTileDark({super.key, required this.url});

  @override
  State<VoiceLetterTileDark> createState() => _VoiceLetterTileDarkState();
}

class _VoiceLetterTileDarkState extends State<VoiceLetterTileDark> {
  late final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((state) {
      if (mounted) setState(() => _playing = state.playing);
    });
    _player.processingStateStream.listen((ps) {
      if (ps == ProcessingState.completed && mounted) {
        _player.seek(Duration.zero);
        setState(() => _playing = false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant VoiceLetterTileDark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _player.stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final l10n = AppLocalizations.of(context)!;
    if (!isValidVoiceLetterUrl(widget.url)) return;
    try {
      if (_playing) {
        await _player.pause();
        return;
      }
      await _player.setUrl(widget.url);
      await _player.play();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.voiceLetterPlayError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = context.pal.accent;
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1714),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withOpacity(0.35)),
              ),
              child: Icon(
                _playing ? Icons.pause_rounded : Icons.mic_rounded,
                size: 22,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.voiceLetterTitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    l10n.voiceLetterSubtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
              color: Colors.white.withOpacity(0.35),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

/// Opening flow: outlined button matching music control style.
class VoiceLetterOpeningButton extends StatefulWidget {
  final String url;
  final Color accentColor;

  const VoiceLetterOpeningButton({
    super.key,
    required this.url,
    required this.accentColor,
  });

  @override
  State<VoiceLetterOpeningButton> createState() => _VoiceLetterOpeningButtonState();
}

class _VoiceLetterOpeningButtonState extends State<VoiceLetterOpeningButton> {
  late final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((state) {
      if (mounted) setState(() => _playing = state.playing);
    });
    _player.processingStateStream.listen((ps) {
      if (ps == ProcessingState.completed && mounted) {
        _player.seek(Duration.zero);
        setState(() => _playing = false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant VoiceLetterOpeningButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _player.stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    final l10n = AppLocalizations.of(context)!;
    if (!isValidVoiceLetterUrl(widget.url)) return;
    try {
      if (_playing) {
        await _player.pause();
        return;
      }
      await _player.setUrl(widget.url);
      await _player.play();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.voiceLetterPlayError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accentColor;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _play,
        icon: Icon(
          _playing ? Icons.pause_rounded : Icons.mic_rounded,
          color: accent,
          size: 22,
        ),
        label: Text(
          _playing ? l10n.voiceLetterPause : l10n.voiceLetterPlay,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A2E14),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: accent.withOpacity(0.55)),
          backgroundColor: accent.withOpacity(0.06),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
