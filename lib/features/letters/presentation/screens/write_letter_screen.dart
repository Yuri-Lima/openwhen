import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/utils/location_prompt_flow.dart';
import '../voice_letter.dart';

class EmotionalState {
  final String key;
  final String label;
  final String emoji;
  final Color color;
  final Color bgColor;
  const EmotionalState({required this.key, required this.label, required this.emoji, required this.color, required this.bgColor});
}

const List<EmotionalState> emotionalStates = [
  EmotionalState(key: 'love', label: 'Amor', emoji: '💕', color: Color(0xFFE91E8C), bgColor: Color(0xFFFCE4F3)),
  EmotionalState(key: 'achievement', label: 'Conquista', emoji: '🏆', color: Color(0xFFF59E0B), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'advice', label: 'Conselho', emoji: '🌿', color: Color(0xFF10B981), bgColor: Color(0xFFD1FAE5)),
  EmotionalState(key: 'nostalgia', label: 'Saudade', emoji: '🍂', color: Color(0xFFD97706), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'farewell', label: 'Despedida', emoji: '🦋', color: Color(0xFF8B5CF6), bgColor: Color(0xFFEDE9FE)),
];

String emotionalStateLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'love': return l10n.writeLetterEmotionLove;
    case 'achievement': return l10n.writeLetterEmotionAchievement;
    case 'advice': return l10n.writeLetterEmotionAdvice;
    case 'nostalgia': return l10n.writeLetterEmotionNostalgia;
    case 'farewell': return l10n.writeLetterEmotionFarewell;
    default: return key;
  }
}

class WriteLetterScreen extends ConsumerStatefulWidget {
  const WriteLetterScreen({super.key});

  @override
  ConsumerState<WriteLetterScreen> createState() => _WriteLetterScreenState();
}

class _WriteLetterScreenState extends ConsumerState<WriteLetterScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();
  final _musicUrlController = TextEditingController();

  DateTime _openDate = DateTime.now().add(const Duration(days: 7));
  bool _isPublic = false;
  bool _isLoading = false;
  EmotionalState? _selectedEmotion;

  // Tipo de carta
  bool _isHandwritten = false;
  String? _handwrittenImageUrl;
  bool _uploadingImage = false;

  // Destinatario
  String? _receiverUid;
  String? _receiverName;
  String? _receiverUsername;
  String? _receiverPhotoUrl;
  bool _receiverHasAccount = false;

  // Busca
  List<Map<String, dynamic>> _searchResults = [];
  bool _searching = false;
  bool _showResults = false;

  // Mensagem digitada: recolhida por padrão
  bool _messageExpanded = false;
  final FocusNode _messageFocusNode = FocusNode();

  // Voz (mobile/desktop com IO; web usa stub de upload)
  static const int _voiceMaxSeconds = 60;
  final AudioRecorder _audioRecorder = AudioRecorder();
  AudioPlayer? _previewPlayer;
  String? _voiceLocalPath;
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;

  void _onMessageChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    if (_isRecording) {
      unawaited(_audioRecorder.stop());
    }
    unawaited(_audioRecorder.dispose());
    _previewPlayer?.dispose();
    _messageController.removeListener(_onMessageChanged);
    _messageFocusNode.dispose();
    _titleController.dispose();
    _messageController.dispose();
    _searchController.dispose();
    _emailController.dispose();
    _musicUrlController.dispose();
    if (!kIsWeb && _voiceLocalPath != null) {
      unawaited(deleteVoiceFile(_voiceLocalPath));
    }
    super.dispose();
  }

  Future<bool> _ensureMicPermission() async {
    final l10n = AppLocalizations.of(context)!;
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    if (!mounted) return false;
    if (status.isPermanentlyDenied) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.writeLetterVoicePermissionDenied),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.actionCancel)),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: Text(l10n.writeLetterVoiceOpenSettings),
            ),
          ],
        ),
      );
      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.writeLetterVoicePermissionDenied)),
    );
    return false;
  }

  Future<void> _startRecording() async {
    if (kIsWeb) return;
    if (!await _ensureMicPermission()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_voiceLocalPath != null) {
      await deleteVoiceFile(_voiceLocalPath);
      setState(() => _voiceLocalPath = null);
    }
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    try {
      if (!await _audioRecorder.hasPermission()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.writeLetterVoicePermissionDenied)),
          );
        }
        return;
      }
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.writeLetterVoicePermissionDenied)),
        );
      }
      return;
    }
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _recordingSeconds++;
        if (_recordingSeconds >= _voiceMaxSeconds) {
          unawaited(_stopRecording(maxReached: true));
        }
      });
    });
  }

  Future<void> _stopRecording({bool maxReached = false}) async {
    final l10n = AppLocalizations.of(context)!;
    _recordingTimer?.cancel();
    _recordingTimer = null;
    if (!_isRecording) return;
    String? outPath;
    try {
      outPath = await _audioRecorder.stop();
    } catch (_) {
      outPath = null;
    }
    if (!mounted) return;
    setState(() {
      _isRecording = false;
      if (outPath != null) _voiceLocalPath = outPath;
    });
    if (maxReached) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.writeLetterVoiceMaxDuration)),
      );
    }
  }

  Future<void> _discardVoice() async {
    await deleteVoiceFile(_voiceLocalPath);
    await _previewPlayer?.stop();
    setState(() => _voiceLocalPath = null);
  }

  Future<void> _togglePreview() async {
    if (kIsWeb || _voiceLocalPath == null) return;
    _previewPlayer ??= AudioPlayer()
      ..playerStateStream.listen((_) {
        if (mounted) setState(() {});
      });
    final p = _previewPlayer!;
    try {
      if (p.playing) {
        await p.pause();
        setState(() {});
        return;
      }
      await p.setAudioSource(AudioSource.uri(Uri.file(_voiceLocalPath!)));
      await p.play();
      setState(() {});
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.voiceLetterPlayError)),
        );
      }
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) {
      setState(() { _searchResults = []; _showResults = false; });
      return;
    }
    setState(() => _searching = true);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final allDocs = <String, Map<String, dynamic>>{};
    final q = query.toLowerCase().replaceAll('@', '');

    try {
      final snap = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .get();

      for (final doc in snap.docs) {
        if (doc.id == currentUid) continue;
        final data = doc.data();
        final username = (data['username'] ?? '').toString().toLowerCase();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final displayName = (data['displayName'] ?? '').toString().toLowerCase();
        final email = (data['email'] ?? '').toString().toLowerCase();
        if (username.contains(q) || name.contains(q) || displayName.contains(q) || email.contains(q)) {
          allDocs[doc.id] = {'uid': doc.id, ...data};
        }
      }
    } catch (e) {
      print('Erro busca: $e');
    }

    setState(() {
      _searchResults = allDocs.values.toList();
      _searching = false;
      _showResults = true;
    });
  }

  void _selectUser(Map<String, dynamic> user) {
    setState(() {
      _receiverUid = user['uid'];
      _receiverName = user['displayName'] ?? user['name'] ?? '';
      _receiverUsername = user['username'] ?? '';
      _receiverPhotoUrl = user['photoUrl'];
      _receiverHasAccount = true;
      _searchResults = [];
      _showResults = false;
      _searchController.clear();
    });
  }

  void _selectByEmail() {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.writeLetterSnackEmailInvalid)),
      );
      return;
    }
    setState(() {
      _receiverUid = null;
      _receiverName = email;
      _receiverUsername = '';
      _receiverPhotoUrl = null;
      _receiverHasAccount = false;
    });
  }

  void _clearReceiver() {
    setState(() {
      _receiverUid = null;
      _receiverName = null;
      _receiverUsername = null;
      _receiverPhotoUrl = null;
      _receiverHasAccount = false;
      _emailController.clear();
    });
  }

  Future<void> _pickHandwrittenImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _uploadingImage = true);
    try {
      final bytes = await picked.readAsBytes();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance
          .ref('handwritten/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      setState(() => _handwrittenImageUrl = url);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.writeLetterSnackStorageError),
            backgroundColor: context.pal.accent,
          ),
        );
      }
    }
    setState(() => _uploadingImage = false);
  }

  Future<void> _pickDate() async {
    final accent = context.pal.accent;
    final picked = await showDatePicker(
      context: context,
      initialDate: _openDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: ColorScheme.light(primary: accent)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _openDate = picked);
  }

  Future<void> _saveLetter() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackTitle)));
      return;
    }
    if (!_isHandwritten && _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackMessage)));
      return;
    }
    if (_isHandwritten && _handwrittenImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackPhoto)));
      return;
    }
    if (_receiverName == null || _receiverName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackRecipient)));
      return;
    }
    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackEmotion)));
      return;
    }
    final musicTrim = _musicUrlController.text.trim();
    if (musicTrim.isNotEmpty && !isValidHttpsMusicUrl(musicTrim)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.writeLetterSnackMusicUrlInvalid)));
      return;
    }

    final locOpts = await promptSenderLocationAndProximity(context, l10n);
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final firestore = FirebaseFirestore.instance;

      String? voiceUrlToSave;
      if (!kIsWeb && _voiceLocalPath != null) {
        voiceUrlToSave = await uploadVoiceLetterFile(_voiceLocalPath!, currentUser.uid);
        if (voiceUrlToSave == null) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.writeLetterVoiceUploadError)),
            );
          }
          return;
        }
        if (mounted) setState(() => _voiceLocalPath = null);
      }

      final senderDoc = await firestore.collection(FirestoreCollections.users).doc(currentUser.uid).get();
      final senderName = senderDoc.data()?['displayName'] ?? senderDoc.data()?['name'] ?? currentUser.email ?? '';

      bool areFriends = false;
      if (_receiverUid != null) {
        final followCheck = await firestore
            .collection('follows')
            .where('followerUid', isEqualTo: currentUser.uid)
            .where('followingUid', isEqualTo: _receiverUid)
            .get();
        areFriends = followCheck.docs.isNotEmpty || _receiverUid == currentUser.uid;
      }

      await firestore.collection(FirestoreCollections.letters).add({
        'senderUid': currentUser.uid,
        'senderName': senderName,
        'receiverUid': _receiverUid ?? '',
        'receiverName': _receiverName ?? '',
        'receiverEmail': _receiverHasAccount ? null : _receiverName,
        'receiverHasAccount': _receiverHasAccount,
        'title': _titleController.text.trim(),
        'message': _isHandwritten ? '' : _messageController.text.trim(),
        'isHandwritten': _isHandwritten,
        'handwrittenImageUrl': _handwrittenImageUrl,
        'openDate': Timestamp.fromDate(_openDate),
        'status': 'locked',
        'isPublic': _isPublic,
        'canBeShared': _isPublic,
        'emotionalState': _selectedEmotion!.key,
        'requestStatus': areFriends ? 'accepted' : 'pending',
        'createdAt': Timestamp.now(),
        'openedAt': null,
        'publishedAt': null,
        'likeCount': 0,
        'commentCount': 0,
        if (musicTrim.isNotEmpty) 'musicUrl': musicTrim,
        if (voiceUrlToSave != null) 'voiceUrl': voiceUrlToSave,
        if (locOpts.senderLocation != null)
          ...<String, dynamic>{
            'senderLocation': locOpts.senderLocation!,
            'openRequiresProximity': locOpts.openRequiresProximity,
          },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_receiverHasAccount
              ? (areFriends ? l10n.writeLetterSnackSentFriend : l10n.writeLetterSnackSentPending)
              : l10n.writeLetterSnackSentExternal),
          backgroundColor: context.pal.accent,
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorGeneric(e.toString()))));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: context.pal.card,
              border: Border(bottom: BorderSide(color: context.pal.border)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: context.pal.ink)),
              const SizedBox(width: 16),
              Row(children: [
                Text(l10n.writeLetterTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.ink)),
                const SizedBox(width: 6),
                OwlFeedbackAffordance(
                  child: OwlWatermark(width: 18, height: 22, color: context.pal.ink),
                ),
              ]),
            ]),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showResults = false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                  // Estado emocional
                  Text(l10n.writeLetterFeeling, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(children: emotionalStates.map((e) {
                    final isSelected = _selectedEmotion?.key == e.key;
                    return Expanded(child: GestureDetector(
                      onTap: () => setState(() => _selectedEmotion = e),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? e.bgColor : context.pal.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? e.color : context.pal.border, width: isSelected ? 2 : 1),
                        ),
                        child: Column(children: [
                          Text(e.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(emotionalStateLabel(l10n, e.key), style: GoogleFonts.dmSans(fontSize: 9, color: isSelected ? e.color : context.pal.inkFaint, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                        ]),
                      ),
                    ));
                  }).toList()),
                  const SizedBox(height: 20),

                  // Titulo
                  _buildField(controller: _titleController, label: l10n.writeLetterFieldTitle, hint: l10n.writeLetterFieldTitleHint),
                  const SizedBox(height: 20),

                  // TIPO DE CARTA
                  Text(l10n.writeLetterTypeSection, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isHandwritten = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_isHandwritten ? context.pal.accentWarm : context.pal.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: !_isHandwritten ? context.pal.accent : context.pal.border, width: !_isHandwritten ? 2 : 1),
                          ),
                          child: Column(children: [
                            Text('⌨️', style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(l10n.writeLetterTypeTyped, style: GoogleFonts.dmSans(fontSize: 12, color: !_isHandwritten ? context.pal.accent : context.pal.inkSoft, fontWeight: !_isHandwritten ? FontWeight.w600 : FontWeight.w400)),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isHandwritten = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isHandwritten ? context.pal.accentWarm : context.pal.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _isHandwritten ? context.pal.accent : context.pal.border, width: _isHandwritten ? 2 : 1),
                          ),
                          child: Column(children: [
                            Text('✍️', style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(l10n.writeLetterTypeHandwritten, style: GoogleFonts.dmSans(fontSize: 12, color: _isHandwritten ? context.pal.accent : context.pal.inkSoft, fontWeight: _isHandwritten ? FontWeight.w600 : FontWeight.w400)),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),

                  // CONTEUDO DA CARTA
                  if (!_isHandwritten) ...[
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _messageExpanded
                          ? Container(
                              decoration: BoxDecoration(
                                color: context.pal.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: context.pal.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.writeLetterFieldMessage,
                                            style: GoogleFonts.dmSans(color: context.pal.inkSoft, fontSize: 12),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.expand_less, color: context.pal.inkFaint),
                                          onPressed: () {
                                            _messageFocusNode.unfocus();
                                            setState(() => _messageExpanded = false);
                                          },
                                          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextField(
                                    controller: _messageController,
                                    focusNode: _messageFocusNode,
                                    maxLines: 8,
                                    style: GoogleFonts.dmSerifDisplay(
                                      color: context.pal.ink,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                      height: 1.8,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: l10n.writeLetterFieldMessage,
                                      hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      alignLabelWithHint: true,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  setState(() => _messageExpanded = true);
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _messageFocusNode.requestFocus();
                                    final ctx = _messageFocusNode.context;
                                    if (ctx != null && ctx.mounted) {
                                      Scrollable.ensureVisible(
                                        ctx,
                                        duration: const Duration(milliseconds: 250),
                                        alignment: 0.2,
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: context.pal.card,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: context.pal.border),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.writeLetterFieldMessage,
                                              style: GoogleFonts.dmSans(color: context.pal.inkSoft, fontSize: 12),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              _messageController.text.isEmpty
                                                  ? l10n.writeLetterMessageTapToExpand
                                                  : _messageController.text,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSerifDisplay(
                                                color: context.pal.ink,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.expand_more, color: context.pal.inkFaint),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    if (!kIsWeb) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.writeLetterVoiceSection,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          color: context.pal.inkFaint,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.pal.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.pal.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_isRecording)
                              Row(
                                children: [
                                  Icon(Icons.fiber_manual_record, color: Colors.red.shade400, size: 14),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_recordingSeconds ~/ 60}:${(_recordingSeconds % 60).toString().padLeft(2, '0')} / 1:00',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: context.pal.ink,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => _stopRecording(),
                                    child: Text(l10n.writeLetterVoiceStop),
                                  ),
                                ],
                              )
                            else if (_voiceLocalPath != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    l10n.writeLetterVoiceWillSend,
                                    style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: _togglePreview,
                                        icon: Icon(
                                          (_previewPlayer?.playing ?? false)
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 18,
                                        ),
                                        label: Text(l10n.writeLetterVoicePreview),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton.icon(
                                        onPressed: _discardVoice,
                                        icon: const Icon(Icons.delete_outline, size: 18),
                                        label: Text(l10n.writeLetterVoiceDiscard),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FilledButton.icon(
                                  onPressed: _startRecording,
                                  icon: const Icon(Icons.mic_rounded, size: 18),
                                  label: Text(l10n.writeLetterVoiceRecord),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ] else
                    GestureDetector(
                      onTap: _pickHandwrittenImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: _handwrittenImageUrl != null ? null : 180,
                        decoration: BoxDecoration(
                          color: context.pal.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _handwrittenImageUrl != null ? context.pal.accent : context.pal.border,
                            width: _handwrittenImageUrl != null ? 2 : 1,
                          ),
                        ),
                        child: _uploadingImage
                            ? Center(child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: context.pal.accent),
                              ))
                            : _handwrittenImageUrl != null
                                ? Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.network(_handwrittenImageUrl!, fit: BoxFit.cover, width: double.infinity),
                                    ),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _handwrittenImageUrl = null),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: context.pal.accent, shape: BoxShape.circle),
                                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ])
                                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: context.pal.inkFaint),
                                    const SizedBox(height: 10),
                                    Text(l10n.writeLetterPhotoTap, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft)),
                                    const SizedBox(height: 4),
                                    Text(l10n.writeLetterPhotoHint, style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
                                  ]),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Link opcional de música
                  Text(l10n.writeLetterMusicUrlLabel, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _musicUrlController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      style: GoogleFonts.dmSans(color: context.pal.ink),
                      decoration: InputDecoration(
                        hintText: l10n.writeLetterMusicUrlHint,
                        hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DESTINATARIO
                  Text(l10n.writeLetterRecipientSection, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),

                  if (_receiverName != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.pal.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.pal.accent),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: _receiverHasAccount ? context.pal.accentWarm : const Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: _receiverHasAccount
                              ? Text((_receiverName ?? 'U').substring(0, 1).toUpperCase(), style: GoogleFonts.dmSans(color: context.pal.accent, fontWeight: FontWeight.bold))
                              : const Icon(Icons.email_outlined, color: Color(0xFF6366F1), size: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_receiverName ?? '', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: context.pal.ink)),
                          Text(
                            _receiverHasAccount ? '@${_receiverUsername ?? ''}' : l10n.writeLetterReceiverLink,
                            style: GoogleFonts.dmSans(fontSize: 12, color: _receiverHasAccount ? context.pal.inkSoft : const Color(0xFF6366F1)),
                          ),
                        ])),
                        GestureDetector(onTap: _clearReceiver, child: Icon(Icons.close, color: context.pal.accent, size: 20)),
                      ]),
                    )
                  else
                    Column(children: [
                      // Busca por usuario
                      Container(
                        decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(children: [
                          Icon(Icons.search, color: context.pal.inkFaint, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(
                            controller: _searchController,
                            onChanged: _searchUsers,
                            style: GoogleFonts.dmSans(color: context.pal.ink),
                            decoration: InputDecoration(
                              hintText: l10n.writeLetterSearchHint,
                              hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          )),
                          if (_searching) SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: context.pal.accent)),
                        ]),
                      ),

                      // Resultados da busca
                      if (_showResults && _searchResults.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
                          child: Column(children: _searchResults.map((u) {
                            final nome = u['displayName'] ?? u['name'] ?? '';
                            final foto = u['photoUrl'];
                            final username = u['username'] ?? '';
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: context.pal.accentWarm,
                                backgroundImage: foto != null ? NetworkImage(foto) : null,
                                child: foto == null ? Text(nome.isNotEmpty ? nome.substring(0, 1).toUpperCase() : 'U', style: GoogleFonts.dmSans(color: context.pal.accent, fontWeight: FontWeight.bold)) : null,
                              ),
                              title: Text(nome, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: context.pal.ink)),
                              subtitle: Text('@$username', style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft)),
                              onTap: () => _selectUser(u),
                            );
                          }).toList()),
                        ),

                      // Divisor OU
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(children: [
                          Expanded(child: Divider(color: context.pal.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(l10n.writeLetterOrSendExternal, style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
                          ),
                          Expanded(child: Divider(color: context.pal.border)),
                        ]),
                      ),

                      // Email para quem nao tem conta
                      Row(children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.dmSans(color: context.pal.ink),
                              decoration: InputDecoration(
                                hintText: l10n.writeLetterEmailHint,
                                hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _selectByEmail,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(color: context.pal.accent, borderRadius: BorderRadius.circular(14)),
                            child: Text(l10n.actionOk, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ]),
                    ]),
                  const SizedBox(height: 20),

                  // Data de abertura
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
                      child: Row(children: [
                        Icon(Icons.calendar_today, color: context.pal.accent, size: 20),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(l10n.writeLetterOpenDateLabel, style: GoogleFonts.dmSans(color: context.pal.inkSoft, fontSize: 11)),
                          Text(formatShortDate(_openDate, locale), style: GoogleFonts.dmSans(color: context.pal.ink, fontSize: 15, fontWeight: FontWeight.w500)),
                        ]),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Toggle publico
                  Container(
                    decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
                    child: SwitchListTile(
                      title: Text(l10n.writeLetterPublicToggle, style: GoogleFonts.dmSans(color: context.pal.ink)),
                      subtitle: Text(l10n.writeLetterPublicHint, style: GoogleFonts.dmSans(color: context.pal.inkSoft, fontSize: 12)),
                      value: _isPublic,
                      activeColor: context.pal.accent,
                      onChanged: (value) => setState(() => _isPublic = value),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botao enviar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveLetter,
                    child: _isLoading
                        ? CircularProgressIndicator(color: context.pal.white)
                        : Text(l10n.writeLetterSend, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, required String label, required String hint, TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: context.pal.border)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: GoogleFonts.dmSans(color: context.pal.ink),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.dmSans(color: context.pal.inkSoft),
          hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
