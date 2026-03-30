// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OpenWhen';

  @override
  String get splashTagline => 'Letters for the future';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get snackFillAllFields => 'Please fill in all fields!';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionShare => 'Share';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionOk => 'OK';

  @override
  String get locationAskShareTitle => 'Share your location?';

  @override
  String get locationAskShareBody =>
      'The recipient can see where you were when you sent this and copy a Maps link. You can also require opening only within 10 meters of this spot.';

  @override
  String get locationAskShareAllow => 'Share location';

  @override
  String get locationAskShareDeny => 'Don\'t share';

  @override
  String get locationAskRestrictTitle => 'Require being on site to open?';

  @override
  String get locationAskRestrictBody =>
      'The recipient will only be able to open this within 10 meters of the point you shared.';

  @override
  String get locationAskRestrictYes => 'Yes, within 10 m';

  @override
  String get locationAskRestrictNo => 'No';

  @override
  String get locationCaptureFailed =>
      'Could not get location. Sending without it.';

  @override
  String get locationShareTileTitle => 'Sender location';

  @override
  String get locationShareTileSubtitle => 'Tap to copy a Google Maps link';

  @override
  String get locationCopiedSnack => 'Copied to clipboard';

  @override
  String get locationProximityTooFarTitle => 'Too far away';

  @override
  String get locationProximityTooFarBody =>
      'This can only be opened within 10 meters of the shared location. Move closer and try again.';

  @override
  String get locationProximityNeedLocationTitle => 'Location needed';

  @override
  String get locationProximityNeedLocationBody =>
      'Turn on location services and allow OpenWhen to access your location to open this.';

  @override
  String get navFeed => 'Feed';

  @override
  String get navSearch => 'Search';

  @override
  String get navVault => 'Vault';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeWriteLetter => 'Write a Letter';

  @override
  String get homeWriteLetterSubtitle => 'For someone special';

  @override
  String get homeNewCapsule => 'New Time Capsule';

  @override
  String get homeNewCapsuleSubtitle => 'For yourself or a group';

  @override
  String get onboardingTag1 => 'LETTERS FOR THE FUTURE';

  @override
  String get onboardingTitle1 => 'Words that arrive\nat the right time';

  @override
  String get onboardingSubtitle1 =>
      'Write a letter today. Choose when it will be opened. Let time work its magic.';

  @override
  String get onboardingTag2 => 'YOUR DIGITAL VAULT';

  @override
  String get onboardingTitle2 => 'Locked until the\nperfect moment';

  @override
  String get onboardingSubtitle2 =>
      'Your letter is safely stored until the date you choose — it could be tomorrow, or 10 years from now.';

  @override
  String get onboardingTag3 => 'SHARE LOVE';

  @override
  String get onboardingTitle3 => 'Inspire others\nwith your story';

  @override
  String get onboardingSubtitle3 =>
      'Opened letters can go to the public feed. Spread love, friendship, and emotion to the world.';

  @override
  String get onboardingCreateFirst => 'Create my first letter';

  @override
  String get onboardingAlreadyHaveAccount => 'I already have an account';

  @override
  String get loginHeroLetters => 'LETTERS FOR THE FUTURE';

  @override
  String get loginHeroCreateAccount => 'CREATE YOUR FREE ACCOUNT';

  @override
  String get loginTabSignIn => 'Sign In';

  @override
  String get loginTabCreateAccount => 'Create Account';

  @override
  String get hintEmail => 'you@email.com';

  @override
  String get labelEmail => 'Email';

  @override
  String get hintPassword => 'your password';

  @override
  String get labelPassword => 'Password';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginButtonSignIn => 'Sign In';

  @override
  String get loginRegisterBlurb =>
      'Create your account in a single step: name, email, and password on the next screen.';

  @override
  String get loginBullet1 => 'Letters to open in the future';

  @override
  String get loginBullet2 => 'Secure vault and optional feed';

  @override
  String get loginBullet3 => 'Free to get started';

  @override
  String get loginCreateAccount => 'Create my account';

  @override
  String get loginAlreadyHaveAccount => 'I already have an account — sign in';

  @override
  String get loginOrContinueWith => 'or continue with';

  @override
  String get loginLegalFooter =>
      'By signing in you agree to the Terms of Use and Privacy Policy.';

  @override
  String get registerSuccess =>
      'Account created successfully! Sign in to continue.';

  @override
  String get hintName => 'your name';

  @override
  String get labelName => 'Name';

  @override
  String get hintCreatePassword => 'create a password';

  @override
  String get registerCreateAccount => 'Create my account';

  @override
  String get registerAlreadyHaveAccount => 'I already have an account';

  @override
  String get registerLegalFooter =>
      'By creating your account you agree to the Terms of Use and Privacy Policy.';

  @override
  String get feedPublicHeader => 'PUBLIC FEED';

  @override
  String get feedFilterAll => 'For everyone';

  @override
  String get feedFilterLove => 'Love';

  @override
  String get feedFilterFriendship => 'Friendship';

  @override
  String get feedFilterFamily => 'Family';

  @override
  String get feedLayerExplore => 'Explore';

  @override
  String get feedLayerHighlights => 'Highlights';

  @override
  String get feedLayerFollowing => 'Following';

  @override
  String get feedFiltersButton => 'Feed';

  @override
  String get feedFiltersSheetTitle => 'Choose feed';

  @override
  String get feedFiltersButtonSemantic => 'Open feed type filters';

  @override
  String get feedCustomizePinnedFilters => 'Pin quick filters…';

  @override
  String get feedCustomizePinnedFiltersHint =>
      'Choose up to 3 mood chips for the bar';

  @override
  String get feedPinFiltersSheetTitle => 'Pin quick filters';

  @override
  String get feedPinFiltersMaxNote =>
      'Pick up to 3 filters. Order is kept as you select them.';

  @override
  String get feedPinFiltersSave => 'Save';

  @override
  String get feedFollowingEmptyTitle => 'No letters from people you follow';

  @override
  String get feedFollowingEmptySubtitle =>
      'Follow profiles to see their public letters here.';

  @override
  String get feedFollowingSignedOutTitle => 'Sign in to see this feed';

  @override
  String get feedFollowingSignedOutSubtitle =>
      'The Following tab shows public letters from people you follow.';

  @override
  String get feedLoadError => 'Could not load the feed. Pull to retry.';

  @override
  String get feedLoadMore => 'Load more';

  @override
  String get feedEmptyTitle => 'No public letters yet';

  @override
  String get feedEmptySubtitle =>
      'Be the first to share\na letter with the world';

  @override
  String get feedFilterEmptyTitle => 'No letters in this filter';

  @override
  String get feedFilterEmptySubtitle =>
      'Try another filter or go back to \"For everyone\"';

  @override
  String feedCardTo(String name) {
    return 'To: $name';
  }

  @override
  String get feedCardFeatured => '✦ Featured';

  @override
  String feedOpenedOnDate(String date) {
    return 'Opened on $date';
  }

  @override
  String feedViewAllComments(int count) {
    return 'View all $count comments';
  }

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsEmptyTitle => 'No comments yet';

  @override
  String get commentsEmptySubtitle => 'Be the first to comment';

  @override
  String get commentsInputHint => 'Write with love... 💌';

  @override
  String get commentsModerationWarning =>
      'Your message contains inappropriate words. OpenWhen is a space of love and respect. 💌';

  @override
  String get vaultTitle => 'My Vault';

  @override
  String get vaultSubtitle => 'YOUR LETTERS AND CAPSULES';

  @override
  String get vaultTabReceived => 'Received';

  @override
  String get vaultTabSent => 'Sent';

  @override
  String get vaultTabCapsules => 'Capsules';

  @override
  String get vaultEmptyReceivedTitle => 'No received letters yet';

  @override
  String get vaultEmptyReceivedSubtitle =>
      'When someone sends you a letter\nit will appear here';

  @override
  String get vaultEmptyReceivedCta =>
      'Share your profile so people can send you letters.';

  @override
  String get vaultEmptyReceivedCtaButton => 'Open profile';

  @override
  String get vaultLetterChipPrivate => '🔒 Private · Make public';

  @override
  String get vaultLetterChipPublic => '🌍 Public · Make private';

  @override
  String get vaultLetterSheetMakePublic => 'Make public';

  @override
  String get vaultLetterSheetMakePrivate => 'Make private';

  @override
  String get vaultLetterSheetDelete => 'Remove from vault';

  @override
  String get vaultLetterSheetFavoriteSoon => 'Favorite (coming soon)';

  @override
  String get vaultLetterDeleteTitle => 'Remove letter?';

  @override
  String get vaultLetterDeleteMessage =>
      'This removes the letter from your vault and from the public feed if it was shared.';

  @override
  String get vaultMenuHint =>
      'Tip: tap ⋯ on a card to change privacy or delete.';

  @override
  String get vaultMenuHintGotIt => 'Got it';

  @override
  String get vaultCountdownReady => 'Ready to open!';

  @override
  String vaultCountdownDays(int count) {
    return 'Opens in $count days';
  }

  @override
  String vaultCountdownHours(int count) {
    return 'Opens in $count hours';
  }

  @override
  String vaultCountdownMinutes(int count) {
    return 'Opens in $count minutes';
  }

  @override
  String get vaultEmptyWaitingTitle => 'No letters waiting';

  @override
  String get vaultEmptyWaitingSubtitle =>
      'When someone sends you a letter\nit will appear here';

  @override
  String get vaultEmptyOpenedTitle => 'No opened letters yet';

  @override
  String get vaultEmptyOpenedSubtitle =>
      'Your opened letters\nwill appear here';

  @override
  String get vaultEmptySentTitle => 'No sent letters';

  @override
  String get vaultEmptySentSubtitle => 'The letters you send\nwill appear here';

  @override
  String get vaultStatusWaiting => 'Waiting';

  @override
  String get vaultStatusPending => 'Pending';

  @override
  String get vaultStatusOpened => 'Opened';

  @override
  String get vaultStatusReady => 'Ready!';

  @override
  String get vaultStatusLocked => 'Locked';

  @override
  String vaultTo(String name) {
    return 'To: $name';
  }

  @override
  String vaultFrom(String name) {
    return 'From: $name';
  }

  @override
  String get vaultAlreadyOpened => 'Already opened!';

  @override
  String get vaultPendingRecipient =>
      'Waiting for the recipient to accept the letter';

  @override
  String get vaultOpenLetter => 'Open letter';

  @override
  String get vaultLetterOpened => 'Letter opened';

  @override
  String get vaultReadFullLetter => 'Read full letter';

  @override
  String get vaultOpenCapsule => 'Open Capsule';

  @override
  String get vaultViewFullCapsule => 'View full capsule';

  @override
  String get vaultEmptyCapsulesTitle => 'No capsules yet';

  @override
  String get vaultEmptyCapsulesSubtitle =>
      'Create your first time capsule\nand save memories for the future';

  @override
  String get vaultCreateCapsule => 'Create Capsule';

  @override
  String vaultPhotoCount(int count) {
    return '$count photo(s)';
  }

  @override
  String vaultAnswerCount(int count) {
    return '$count answer(s)';
  }

  @override
  String vaultCapsuleOpenedOn(String date) {
    return 'Opened on $date';
  }

  @override
  String get vaultCapsuleSealed => 'Sealed';

  @override
  String get capsulePhotoAdd => 'Add photo';

  @override
  String get capsulePhotoHint => 'Tap to add a photo to your capsule';

  @override
  String get capsulePhotoWebDisabled =>
      'Photos are only available in the mobile app';

  @override
  String get capsulePhotoRemove => 'Remove photo';

  @override
  String get capsulePhotoErrorUpload =>
      'Error uploading photo. Please try again.';

  @override
  String capsulePhotoMax(int count) {
    return 'Maximum of $count photos reached';
  }

  @override
  String get vaultFilterTitle => 'Filter and sort';

  @override
  String get vaultFilterSearchHint => 'Search by title or name...';

  @override
  String get vaultFilterSortLabel => 'Sort by';

  @override
  String get vaultFilterApply => 'Apply';

  @override
  String get vaultFilterClear => 'Clear filters';

  @override
  String get vaultFilterOpenDateFrom => 'Opens from';

  @override
  String get vaultFilterOpenDateTo => 'Opens until';

  @override
  String get vaultFilterClearDate => 'Clear date';

  @override
  String get vaultFilterPendingOnly => 'Pending acceptance only';

  @override
  String get vaultFilterThemesLabel => 'Themes';

  @override
  String get vaultFilterDirectionAll => 'All';

  @override
  String get vaultFilterDirectionReceived => 'Received';

  @override
  String get vaultFilterDirectionSent => 'Sent';

  @override
  String get vaultFilterEmptyTitle => 'Nothing matches this filter';

  @override
  String get vaultFilterEmptySubtitle =>
      'Adjust your search or clear filters to see everything again';

  @override
  String get vaultFilterActiveBadge => 'Filtered';

  @override
  String get vaultSortWaitingOpenDateAsc => 'Open date (soonest first)';

  @override
  String get vaultSortWaitingOpenDateDesc => 'Open date (latest first)';

  @override
  String get vaultSortWaitingCreatedDesc => 'Created (newest)';

  @override
  String get vaultSortWaitingCreatedAsc => 'Created (oldest)';

  @override
  String get vaultSortWaitingTitleAsc => 'Title (A–Z)';

  @override
  String get vaultSortOpenedOpenedAtDesc => 'Opened at (newest)';

  @override
  String get vaultSortOpenedOpenedAtAsc => 'Opened at (oldest)';

  @override
  String get vaultSortOpenedOpenDateDesc => 'Planned open date (farthest)';

  @override
  String get vaultSortOpenedOpenDateAsc => 'Planned open date (soonest)';

  @override
  String get vaultSortOpenedTitleAsc => 'Title (A–Z)';

  @override
  String get vaultSortSentOpenDateAsc => 'Open date (soonest first)';

  @override
  String get vaultSortSentOpenDateDesc => 'Open date (latest first)';

  @override
  String get vaultSortSentCreatedDesc => 'Created (newest)';

  @override
  String get vaultSortSentCreatedAsc => 'Created (oldest)';

  @override
  String get vaultSortSentTitleAsc => 'Title (A–Z)';

  @override
  String get vaultSortCapsulesOpenDateAsc => 'Open date (soonest first)';

  @override
  String get vaultSortCapsulesOpenDateDesc => 'Open date (latest first)';

  @override
  String get vaultSortCapsulesCreatedDesc => 'Created (newest)';

  @override
  String get vaultSortCapsulesCreatedAsc => 'Created (oldest)';

  @override
  String get vaultSortCapsulesTitleAsc => 'Title (A–Z)';

  @override
  String get capsuleThemeMemories => 'Memories';

  @override
  String get capsuleThemeGoals => 'Goals';

  @override
  String get capsuleThemeFeelings => 'Feelings';

  @override
  String get capsuleThemeRelationships => 'Relationships';

  @override
  String get capsuleThemeGrowth => 'Growth';

  @override
  String get capsuleThemeDefault => 'Capsule';

  @override
  String get writeLetterTitle => 'Write a letter';

  @override
  String get writeLetterFeeling => 'HOW ARE YOU FEELING?';

  @override
  String get writeLetterEmotionLove => 'Love';

  @override
  String get writeLetterEmotionAchievement => 'Achievement';

  @override
  String get writeLetterEmotionAdvice => 'Advice';

  @override
  String get writeLetterEmotionNostalgia => 'Nostalgia';

  @override
  String get writeLetterEmotionFarewell => 'Farewell';

  @override
  String get writeLetterFieldTitle => 'Title';

  @override
  String get writeLetterFieldTitleHint => 'E.g.: Open when you miss me';

  @override
  String get writeLetterTypeSection => 'LETTER TYPE';

  @override
  String get writeLetterTypeTyped => 'Typed';

  @override
  String get writeLetterTypeHandwritten => 'Handwritten';

  @override
  String get writeLetterFieldMessage => 'Your message';

  @override
  String get writeLetterPhotoTap => 'Tap to add a photo of the letter';

  @override
  String get writeLetterPhotoHint => 'Take a photo of your handwritten letter';

  @override
  String get writeLetterRecipientSection => 'FOR WHOM?';

  @override
  String get writeLetterSearchHint => 'Search by @username or name...';

  @override
  String get writeLetterOrSendExternal =>
      'or send to someone without an account';

  @override
  String get writeLetterEmailHint => 'email@example.com';

  @override
  String get writeLetterReceiverLink =>
      'They will receive a link to create an account';

  @override
  String get writeLetterOpenDateLabel => 'Opening date';

  @override
  String get writeLetterPrivacyNote =>
      'Sent letters are private. Only the recipient can choose to share on the public feed after opening.';

  @override
  String get writeLetterSend => 'Send letter 💌';

  @override
  String get writeLetterSnackTitle => 'Please fill in the title!';

  @override
  String get writeLetterSnackMessage => 'Write your message!';

  @override
  String get writeLetterSnackPhoto => 'Add a photo of the letter!';

  @override
  String get writeLetterSnackRecipient => 'Choose the recipient!';

  @override
  String get writeLetterSnackEmotion => 'Choose the emotional state!';

  @override
  String get writeLetterSnackSentFriend => 'Letter sent! 💌';

  @override
  String get writeLetterSnackSentPending =>
      'Letter sent! Awaiting approval. 💌';

  @override
  String get writeLetterSnackSentExternal =>
      'Letter created! Share the link with the recipient. 💌';

  @override
  String get writeLetterSnackEmailInvalid => 'Enter a valid email!';

  @override
  String get writeLetterSnackStorageError =>
      'Enable Firebase Storage to use this feature';

  @override
  String get writeLetterMusicUrlLabel => 'Song link (optional)';

  @override
  String get writeLetterMusicUrlHint => 'https://open.spotify.com/...';

  @override
  String get writeLetterSnackMusicUrlInvalid =>
      'Use a valid https:// link for the song.';

  @override
  String get writeLetterMessageTapToExpand => 'Tap to write your message';

  @override
  String get writeLetterVoiceSection => 'Voice message (optional)';

  @override
  String get writeLetterVoiceRecord => 'Record';

  @override
  String get writeLetterVoiceStop => 'Stop';

  @override
  String get writeLetterVoiceDiscard => 'Discard audio';

  @override
  String get writeLetterVoicePreview => 'Preview';

  @override
  String get writeLetterVoiceMaxDuration => 'The limit is 1 minute.';

  @override
  String get writeLetterVoicePermissionDenied =>
      'Microphone permission is required to record.';

  @override
  String get writeLetterVoiceOpenSettings => 'Open settings';

  @override
  String get writeLetterVoiceWillSend => 'Will be sent with the letter';

  @override
  String get writeLetterVoiceUploadError =>
      'Could not upload audio. Please try again.';

  @override
  String get voiceLetterTitle => 'Voice message';

  @override
  String get voiceLetterSubtitle => 'Recorded by the sender';

  @override
  String get voiceLetterPlay => 'Listen';

  @override
  String get voiceLetterPause => 'Pause';

  @override
  String get voiceLetterPlayError => 'Could not play audio.';

  @override
  String get musicLinkTitle => 'Listen to music';

  @override
  String get musicLinkSubtitle => 'Opens in the app or browser';

  @override
  String get musicLinkOpenError => 'Could not open this link.';

  @override
  String get letterDetailHeaderFrom => 'A LETTER FROM';

  @override
  String letterDetailTo(String name) {
    return 'to $name';
  }

  @override
  String letterDetailWrittenOn(String date) {
    return 'Written $date';
  }

  @override
  String letterDetailOpenedOn(String date) {
    return 'Opened $date';
  }

  @override
  String get letterDetailQrTitle => 'Generate QR Code';

  @override
  String get letterDetailQrSubtitle => 'Place it on a physical gift 🎁';

  @override
  String get letterDetailShareTitle => 'Share letter';

  @override
  String get letterDetailShareSubtitle => 'Instagram Stories or share sheet';

  @override
  String get storyShareFallbackSnack =>
      'Share sheet opened — pick Instagram or another app.';

  @override
  String get storyShareSheetTitle => 'Share capsule';

  @override
  String get storyShareInstagramOption => 'Instagram Stories';

  @override
  String get storyShareTextOption => 'Plain text (Q&A)';

  @override
  String get letterOpeningEmotionLove => 'A love letter is waiting for you 💕';

  @override
  String get letterOpeningEmotionAchievement =>
      'An achievement has been saved for you 🏆';

  @override
  String get letterOpeningEmotionAdvice =>
      'Special advice is waiting for you 🌿';

  @override
  String get letterOpeningEmotionNostalgia => 'Memories saved for you 🍂';

  @override
  String get letterOpeningEmotionFarewell =>
      'Words of farewell have been waiting for you 🦋';

  @override
  String letterOpeningWrittenOpenedToday(String date) {
    return 'Written $date  ·  Opened today';
  }

  @override
  String get letterOpeningPublishFeed => '✦  Publish to feed';

  @override
  String get letterOpeningKeepPrivate => 'Keep it just for me';

  @override
  String get letterOpeningTapToOpen => 'TAP TO OPEN';

  @override
  String get requestsTitle => 'Letter requests';

  @override
  String get requestsSubtitle => 'From people you don\'t follow';

  @override
  String get requestsEmptyTitle => 'No pending requests';

  @override
  String get requestsEmptySubtitle =>
      'When someone you don\'t follow\nsends you a letter, it will appear here.';

  @override
  String get requestsSheetTitle => 'What would you like to do?';

  @override
  String requestsSheetLetterFrom(String name) {
    return 'Letter from $name';
  }

  @override
  String get requestsAccept => 'Accept letter';

  @override
  String get requestsDecline => 'Decline letter';

  @override
  String requestsBlockUser(String name) {
    return 'Block $name';
  }

  @override
  String get requestsSnackAccepted =>
      'Letter accepted! It will appear in your vault. 💌';

  @override
  String get requestsSnackDeclined => 'Letter declined.';

  @override
  String get requestsSnackBlocked => 'User blocked.';

  @override
  String get requestsSenderNotFollowing => 'Person you don\'t follow';

  @override
  String get requestsBadgePending => 'Pending';

  @override
  String get requestsRevealHint => 'Accept to reveal the message';

  @override
  String requestsOpensOn(String date) {
    return 'Opens on $date';
  }

  @override
  String get requestsViewOptions => 'View options';

  @override
  String get qrScreenTitle => 'Letter QR Code';

  @override
  String get qrScreenSubtitle => 'Print and place it on the gift';

  @override
  String get qrCardHeadline => 'A special letter is waiting for you';

  @override
  String qrCardMeta(String sender, String date) {
    return 'From $sender  ·  Opens $date';
  }

  @override
  String get qrScanHint => 'Scan to access the letter';

  @override
  String get qrHowToTitle => 'How to use on a physical gift';

  @override
  String get qrStep1 => 'Share the QR Code via WhatsApp or print it';

  @override
  String get qrStep2 => 'Place it inside or on the gift wrapping';

  @override
  String get qrStep3 => 'The person scans it and discovers the letter';

  @override
  String get qrStep4 => 'The letter opens automatically on the right date';

  @override
  String get qrLinkCopied => 'Link copied! 🔗';

  @override
  String qrShareText(String title, String link) {
    return '💌 A special letter is waiting for you on OpenWhen!\n\n\"$title\"\n\nScan the QR Code or visit: $link';
  }

  @override
  String get qrShareSubject => 'A special letter is waiting for you 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 A special letter is waiting for you on OpenWhen!\n\n\"$title\"\n\nVisit: $link';
  }

  @override
  String qrShareWhatsApp(String title, String link) {
    return '💌 A special letter is waiting for you!\n\n\"$title\"\n\nOpen here: $link';
  }

  @override
  String get createCapsuleTitle => 'New Time Capsule';

  @override
  String createCapsuleStepProgress(int current, String stepName) {
    return 'Step $current of 3 — $stepName';
  }

  @override
  String get createCapsuleStepTheme => 'Theme';

  @override
  String get createCapsuleStepMessage => 'Message';

  @override
  String get createCapsuleStepWhen => 'When to open';

  @override
  String get createCapsuleSeal => 'Seal Capsule 🦉';

  @override
  String get createCapsuleThemeQuestion =>
      'What is the essence\nof this capsule?';

  @override
  String get createCapsuleThemeHint => 'Choose a theme for your capsule.';

  @override
  String get createCapsuleAudienceTitle => 'Who is this capsule for?';

  @override
  String get createCapsuleAudiencePersonal => 'Just me';

  @override
  String get createCapsuleAudienceCollective => 'Collective';

  @override
  String get createCapsuleCollectiveHint =>
      'Invite people who will open this capsule with you on the same date. Only you write the content.';

  @override
  String get createCapsuleInviteSearchHint => 'Search by name or @username';

  @override
  String get createCapsuleCollectiveNeedInvite =>
      'Add at least one person for a collective capsule.';

  @override
  String createCapsuleMaxParticipants(int max) {
    return 'A capsule can include at most $max people (including you).';
  }

  @override
  String get vaultCapsuleCollectiveBadge => 'Collective';

  @override
  String get capsuleDetailParticipantsHeading => 'Together with';

  @override
  String get createCapsuleThemeMemoriesLabel => 'Memories';

  @override
  String get createCapsuleThemeMemoriesSubtitle =>
      'Save what you don\'t want to forget';

  @override
  String get createCapsuleThemeGoalsLabel => 'Goals';

  @override
  String get createCapsuleThemeGoalsSubtitle => 'A promise for the future';

  @override
  String get createCapsuleThemeFeelingsLabel => 'Feelings';

  @override
  String get createCapsuleThemeFeelingsSubtitle =>
      'What\'s inside you right now';

  @override
  String get createCapsuleThemeRelationshipsLabel => 'Relationships';

  @override
  String get createCapsuleThemeRelationshipsSubtitle => 'The people who matter';

  @override
  String get createCapsuleThemeGrowthLabel => 'Growth';

  @override
  String get createCapsuleThemeGrowthSubtitle => 'Who you are becoming';

  @override
  String get createCapsuleWriteHeading => 'Write to your\nfuture self';

  @override
  String get createCapsuleWriteHint =>
      'Write freely. No rules. Just you and the future.';

  @override
  String get createCapsuleFieldTitle => 'Title';

  @override
  String get createCapsuleFieldTitleHint =>
      'E.g.: To my self one year from now...';

  @override
  String get createCapsuleMusicUrlLabel => 'Song link (optional)';

  @override
  String get createCapsuleMusicUrlHint => 'https://music.youtube.com/...';

  @override
  String get createCapsuleFieldMessageHint =>
      'Dear future me...\n\nWrite what you\'re feeling, what you dream of, what you want to remember...';

  @override
  String createCapsuleCharCount(int count) {
    return '$count characters';
  }

  @override
  String get createCapsuleCharMin => ' (minimum 10)';

  @override
  String get createCapsuleWhenHeading => 'When will you\nbe able to open it?';

  @override
  String get createCapsuleWhenHint => 'Choose a date or a special event.';

  @override
  String get createCapsuleTypeDate => 'Date';

  @override
  String get createCapsuleTypeEvent => 'Event';

  @override
  String get createCapsuleTypeBoth => 'Both';

  @override
  String get createCapsulePickDate => 'Pick a date';

  @override
  String get createCapsuleCustomEventHint => 'Or describe the event...';

  @override
  String get createCapsulePublishToggle => 'Publish to feed when opened';

  @override
  String get createCapsulePublishHint =>
      'You decide after reviewing everything';

  @override
  String get createCapsuleSuccessTitle => 'Capsule sealed!';

  @override
  String get createCapsuleSuccessBody =>
      'Your words are safely stored.\nOnly you can open it at the right time.';

  @override
  String get createCapsuleSuccessViewVault => 'View my Vault';

  @override
  String get createCapsulePresetBirthday => 'My birthday';

  @override
  String get createCapsulePresetAnniversary => 'Our anniversary';

  @override
  String get createCapsulePresetGraduation => 'My graduation';

  @override
  String get createCapsulePresetBaby => 'Baby\'s birth';

  @override
  String get createCapsulePresetMoving => 'Our move';

  @override
  String get createCapsulePresetTrip => 'End of trip';

  @override
  String get createCapsulePresetCareer => 'New career chapter';

  @override
  String get createCapsulePresetChristmas => 'Christmas';

  @override
  String get createCapsulePresetNewYear => 'New Year';

  @override
  String get capsuleDetailYourCapsule => 'Your capsule';

  @override
  String capsuleDetailDates(String createdDate, String openedDate) {
    return 'Created on $createdDate  ·  Opened on $openedDate';
  }

  @override
  String get capsuleDetailOnFeed => 'On feed';

  @override
  String get capsuleDetailShareSubtitle => 'Instagram Stories or share sheet';

  @override
  String get capsuleDetailDeleteTitle => 'Delete capsule';

  @override
  String get capsuleDetailDeleteSubtitle => 'Permanently remove from vault';

  @override
  String get capsuleDetailDeleteConfirm => 'Delete capsule?';

  @override
  String get capsuleDetailDeleteBody => 'This action cannot be undone.';

  @override
  String get capsuleOpeningHeader => 'TIME CAPSULE';

  @override
  String get capsuleOpeningThemeMemories => 'Memories saved for the future';

  @override
  String get capsuleOpeningThemeGoals => 'Your goals are waiting for you';

  @override
  String get capsuleOpeningThemeFeelings => 'What you felt, kept here';

  @override
  String get capsuleOpeningThemeRelationships => 'Connections that matter';

  @override
  String get capsuleOpeningThemeGrowth => 'Who you are becoming';

  @override
  String get capsuleOpeningPublishFeed => 'Publish to feed';

  @override
  String get capsuleOpeningKeepPrivate => 'Keep it just for me';

  @override
  String get capsuleOpeningTapToOpen => 'TAP TO OPEN';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePrivate => 'Private';

  @override
  String get profilePublic => 'Public';

  @override
  String get profileDefaultName => 'User';

  @override
  String get profileStatFollowers => 'Followers';

  @override
  String get profileStatFollowing => 'Following';

  @override
  String get profileStatSent => 'Sent';

  @override
  String get profileStatOpened => 'Opened';

  @override
  String get profileBadgesTitle => 'BADGES';

  @override
  String get badgeFirstLetterSentTitle => 'First letter';

  @override
  String get badgeFirstLetterSentDesc => 'You sent your first letter.';

  @override
  String get badgeFirstLetterOpenedTitle => 'First open';

  @override
  String get badgeFirstLetterOpenedDesc => 'You opened your first letter.';

  @override
  String get badgeFirstPublicTitle => 'First share';

  @override
  String get badgeFirstPublicDesc => 'You shared a letter to the public feed.';

  @override
  String get badgeLettersSentFiveTitle => '5 letters';

  @override
  String get badgeLettersSentFiveDesc => 'You sent 5 letters.';

  @override
  String get badgeLettersSentTenTitle => '10 letters';

  @override
  String get badgeLettersSentTenDesc => 'You sent 10 letters.';

  @override
  String get badgeVoiceLetterTitle => 'Voice';

  @override
  String get badgeVoiceLetterDesc => 'You sent a letter with voice.';

  @override
  String get profileStatLetters => 'Letters';

  @override
  String get profileEmptyTitle => 'No published letters';

  @override
  String get profileEmptySubtitle =>
      'Your opened and public letters\nwill appear here';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileSectionName => 'NAME';

  @override
  String get editProfileSectionUsername => 'USERNAME';

  @override
  String get editProfileSectionBio => 'BIO';

  @override
  String get editProfileHintName => 'Your full name';

  @override
  String get editProfileHintUsername => 'your_username';

  @override
  String get editProfileHintBio => 'Tell a little about yourself...';

  @override
  String get editProfileUsernameRules => 'Letters, numbers, and _ only';

  @override
  String get editProfileSaveChanges => 'Save changes';

  @override
  String get editProfileErrorNameEmpty => 'Name cannot be empty';

  @override
  String get editProfileErrorUsernameEmpty => 'Username cannot be empty';

  @override
  String get editProfileErrorUsernameShort =>
      'Username must be at least 3 characters';

  @override
  String get editProfileErrorUsernameTaken => 'This username is already taken';

  @override
  String get editProfileSaved => 'Profile updated!';

  @override
  String get userProfileFollowing => 'Following';

  @override
  String get userProfileFollow => 'Follow';

  @override
  String get userProfileEmptyLetters => 'No public letters yet';

  @override
  String get searchTitle => 'Search people';

  @override
  String get searchHint => 'Search by name or @username...';

  @override
  String get searchEmpty => 'No results';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeSection => 'APP THEME';

  @override
  String get themeSystem => 'Automatic (system)';

  @override
  String get themeSystemSubtitle => 'Light or dark based on device settings';

  @override
  String get themeClassic => 'Classic';

  @override
  String get themeClassicSubtitle => 'Light background with red accent';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDarkSubtitle => 'Comfortable dark interface';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeMidnightSubtitle => 'Deep blue';

  @override
  String get themeSepia => 'Sepia';

  @override
  String get themeSepiaSubtitle => 'Warm paper tones';

  @override
  String get languageSection => 'LANGUAGE';

  @override
  String get languageSystem => 'Automatic (system)';

  @override
  String get languageSystemSubtitle =>
      'Uses the device language (pt, en, or es)';

  @override
  String get languagePt => 'Português (Brasil)';

  @override
  String get languageEn => 'English';

  @override
  String get languageEs => 'Español';

  @override
  String get activeLabel => 'Active';

  @override
  String get settingsMyAccount => 'MY ACCOUNT';

  @override
  String get settingsProfilePhoto => 'Profile photo';

  @override
  String get settingsProfilePhotoSubtitle => 'Gallery or remove';

  @override
  String get avatarChooseFromGallery => 'Choose from gallery';

  @override
  String get avatarRemovePhoto => 'Remove photo';

  @override
  String get avatarPhotoRemovedSnack => 'Photo removed';

  @override
  String get avatarPhotoUpdatedSnack => 'Profile photo updated';

  @override
  String avatarUploadError(String error) {
    return 'Could not upload photo: $error';
  }

  @override
  String settingsNotifPermissionStatus(String status) {
    return 'Permission status: $status';
  }

  @override
  String get qrFooterBrand => 'openwhen.app';

  @override
  String get qrShareWhatsAppLabel => 'WhatsApp';

  @override
  String get settingsEditProfile => 'Edit profile';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsPrivacySection => 'PRIVACY AND SECURITY';

  @override
  String get settingsPrivateAccount => 'Private account';

  @override
  String get settingsPrivateAccountOn =>
      'Your letters don\'t appear on the feed';

  @override
  String get settingsPrivateAccountOff => 'Your letters may appear on the feed';

  @override
  String get settingsBlockedUsers => 'Blocked users';

  @override
  String get settingsWhoCanSend => 'Who can send me letters';

  @override
  String get settingsWhoCanSendValue => 'Everyone';

  @override
  String get settingsNotificationsSection => 'NOTIFICATIONS';

  @override
  String get settingsNotifSystemAlert => 'Alert permissions (system)';

  @override
  String get settingsNotifSystemAlertSubtitle =>
      'Required to receive push notifications on your phone';

  @override
  String get settingsNotifUpdated => 'Notification permissions updated.';

  @override
  String get settingsNotifLikes => 'Likes';

  @override
  String get settingsNotifLikesSubtitle => 'When someone likes your letter';

  @override
  String get settingsNotifComments => 'Comments';

  @override
  String get settingsNotifCommentsSubtitle =>
      'When someone comments on your letter';

  @override
  String get settingsNotifFollowers => 'New followers';

  @override
  String get settingsNotifFollowersSubtitle =>
      'When someone starts following you';

  @override
  String get settingsNotifLetterUnlocked => 'Letter unlocked';

  @override
  String get settingsNotifLetterUnlockedSubtitle =>
      'When a letter is ready to open';

  @override
  String get settingsDataSection => 'DATA AND PRIVACY';

  @override
  String get settingsExportLetters => 'Export my letters';

  @override
  String get settingsExportLettersSubtitle =>
      'PDF or zip with all opened letters';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle => 'This action is irreversible';

  @override
  String get settingsLegalSection => 'LEGAL AND SUPPORT';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsHelp => 'Help and support';

  @override
  String get settingsAbout => 'About OpenWhen';

  @override
  String get settingsAboutVersion => 'Version 1.0.0';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get settingsEditProfileSheetTitle => 'Edit profile';

  @override
  String get settingsEditProfileFieldName => 'Name';

  @override
  String get settingsEditProfileFieldUsername => '@Username';

  @override
  String get settingsEditProfileFieldBio => 'Bio';

  @override
  String get settingsChangePasswordTitle => 'Change password';

  @override
  String get settingsChangePasswordBody => 'We will send a link to your email.';

  @override
  String get settingsChangePasswordButton => 'Send reset email';

  @override
  String settingsChangePasswordSent(String email) {
    return 'Email sent to $email';
  }

  @override
  String get settingsExportTitle => 'Export letters';

  @override
  String get settingsExportBody =>
      'Your opened letters will be exported in PDF format. This may take a few minutes.';

  @override
  String get settingsExportButton => 'Export as ZIP';

  @override
  String get settingsExportZipSubtitle =>
      'PDF per letter plus voice and handwritten images when available.';

  @override
  String settingsExportSuccess(int count) {
    return 'Exported $count letters.';
  }

  @override
  String get settingsExportSnack => 'Preparing export…';

  @override
  String get letterDetailExportPdfTitle => 'Export PDF';

  @override
  String get letterDetailExportPdfSubtitle =>
      'Download a portable copy of this letter';

  @override
  String get settingsDeleteTitle => 'Delete account';

  @override
  String get settingsDeleteBody =>
      'This action is irreversible. All your letters, followers, and data will be permanently deleted.';

  @override
  String get settingsDeleteConfirm => 'Confirm deletion';

  @override
  String get settingsBlockedTitle => 'Blocked users';

  @override
  String get settingsBlockedEmpty => 'No blocked users.';

  @override
  String get settingsBlockedUnblock => 'Unblock';

  @override
  String get legalTitleTerms => 'Terms of Use';

  @override
  String get legalTitlePrivacy => 'Privacy Policy';

  @override
  String get legalTitleAbout => 'About OpenWhen';

  @override
  String get legalTitleHelp => 'Help and Support';

  @override
  String legalLastUpdate(String date) {
    return 'Last updated: $date';
  }

  @override
  String get aboutTagline => 'Write today. Feel it tomorrow.';

  @override
  String get aboutVersion => 'Version 1.0.0 — Build 2026.03.22';

  @override
  String get aboutWhatIsTitle => 'What is OpenWhen';

  @override
  String get aboutWhatIsBody =>
      'OpenWhen is a digital platform for time-based communication and an emotional social network. It allows you to create digital letters with a future opening date, combining the sentimental value of a physical letter with the virality of a modern social network.';

  @override
  String get aboutSecurityTitle => 'Security and Privacy';

  @override
  String get aboutSecurityBody =>
      'Developed in compliance with the LGPD (Law No. 13,709/2018) and the Brazilian Internet Civil Framework (Law No. 12,965/2014). Your data is protected with end-to-end encryption and stored on the Google Cloud Platform infrastructure.';

  @override
  String get aboutComplianceTitle => 'Legal Compliance';

  @override
  String get aboutComplianceBody =>
      'OpenWhen operates in full compliance with current Brazilian legislation, including the LGPD, the Internet Civil Framework, the Consumer Protection Code (Law No. 8,078/1990), and other regulations applicable to the technology sector.';

  @override
  String get aboutCompanyTitle => 'Company';

  @override
  String get aboutCompanyBody =>
      'OpenWhen Tecnologia Ltda. — Brazilian company, headquartered in Brazil. Jurisdiction: São Paulo/SP.';

  @override
  String get aboutContacts => 'Contacts';

  @override
  String get aboutContactSupport => 'General support';

  @override
  String get aboutContactPrivacy => 'Privacy and LGPD';

  @override
  String get aboutContactLegal => 'Legal';

  @override
  String get aboutContactDpo => 'DPO';

  @override
  String get aboutCopyright =>
      '© 2026 OpenWhen Tecnologia Ltda. All rights reserved.';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get helpCenterSubtitle =>
      'Find answers to the most frequently asked questions.';

  @override
  String get helpFaqSection => 'FREQUENTLY ASKED QUESTIONS';

  @override
  String get helpFaq1Q => 'How do I send a letter?';

  @override
  String get helpFaq1A =>
      'Tap the ✏️ button on the main screen. Fill in the title, select the emotional state, write your message, enter the recipient\'s email, and set the opening date. The letter will be locked until the chosen date.';

  @override
  String get helpFaq2Q => 'Does the recipient need an OpenWhen account?';

  @override
  String get helpFaq2A =>
      'Yes. Currently the recipient needs a registered OpenWhen account to receive letters. Sending to external emails will be available soon.';

  @override
  String get helpFaq3Q => 'Can I edit a letter after sending it?';

  @override
  String get helpFaq3A =>
      'No. Letters are sealed immediately after sending to preserve the authenticity and integrity of the message, similar to physical letters. This is an intentional product decision.';

  @override
  String get helpFaq4Q => 'How does the Public Feed work?';

  @override
  String get helpFaq4A =>
      'When you open a letter, you can choose to publish it on the Public Feed. This authorization is individual per letter. Private letters are never displayed publicly without your express consent.';

  @override
  String get helpFaq5Q =>
      'I received a letter from a stranger. What should I do?';

  @override
  String get helpFaq5A =>
      'Letters from people you don\'t follow go to \"Letter Requests\" in the Vault. You can accept, decline, or block the sender without them knowing your decision.';

  @override
  String get helpFaq6Q => 'How do I export my letters?';

  @override
  String get helpFaq6A =>
      'Go to Settings > Data and Privacy > Export my letters. You will receive a file with all your opened letters, as guaranteed by data portability rights under Article 18, Clause V, of the LGPD.';

  @override
  String get helpFaq7Q => 'How do I delete my account?';

  @override
  String get helpFaq7A =>
      'Go to Settings > Data and Privacy > Delete account. Deletion is irreversible and all your data will be permanently removed within 30 days, as per Article 18, Clause VI, of the LGPD.';

  @override
  String get helpFaq8Q => 'I found offensive content. How do I report it?';

  @override
  String get helpFaq8A =>
      'Tap the three dots next to any letter or comment and select \"Report\". Our team will review the content within 24 hours. Serious reports are handled with priority.';

  @override
  String get reportMenuLabel => 'Report';

  @override
  String get reportSheetTitle => 'Report content';

  @override
  String get reportSheetSubtitle =>
      'Tell us what is wrong. Optional details help our team review faster.';

  @override
  String get reportReasonSpam => 'Spam or misleading';

  @override
  String get reportReasonHarassment => 'Harassment or bullying';

  @override
  String get reportReasonHate => 'Hate speech';

  @override
  String get reportReasonIllegal => 'Illegal content';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportDetailLabel => 'Additional details (optional)';

  @override
  String get reportDetailHint => 'Context that helps moderation…';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String get reportSuccess => 'Thanks — we received your report.';

  @override
  String get adminModerationTitle => 'Moderation';

  @override
  String get adminModerationReportsTab => 'Reports';

  @override
  String get adminModerationFeedbackTab => 'Feedback';

  @override
  String get adminModerationEmpty => 'Nothing pending.';

  @override
  String get adminModerationResolve => 'Dismiss';

  @override
  String get adminModerationConfirm => 'Mark reviewed';

  @override
  String get adminModerationLoadError => 'Could not load moderation queue.';

  @override
  String get adminEntrySettings => 'Moderation (admin)';

  @override
  String get helpNotFoundTitle => 'Didn\'t find what you were looking for?';

  @override
  String get helpNotFoundBody => 'Our team is available to help:';

  @override
  String get helpResponseTime => 'Response time';

  @override
  String get helpResponseTimeValue => 'up to 2 business days';

  @override
  String get feedbackTooltip => 'Send feedback';

  @override
  String get feedbackSemanticsLabel => 'Send feedback or feature request';

  @override
  String get feedbackSheetTitle => 'Feedback';

  @override
  String get feedbackCategoryLabel => 'Category';

  @override
  String get feedbackTypeFeature => 'Feature';

  @override
  String get feedbackTypeRecommendation => 'Idea';

  @override
  String get feedbackTypeGeneral => 'General';

  @override
  String get feedbackMessageHint => 'What would you like to share?';

  @override
  String feedbackCharCount(int current, int max) {
    return '$current / $max';
  }

  @override
  String get feedbackSubmit => 'Send';

  @override
  String get feedbackEmptyError => 'Please enter a message.';

  @override
  String get feedbackTooLongError => 'Message is too long.';

  @override
  String get feedbackSuccess => 'Thanks — we received your feedback.';

  @override
  String get feedbackSignedOutHint =>
      'You are not signed in. We will open your email app so you can send this to our team.';

  @override
  String get feedbackCouldNotOpenEmail =>
      'Could not open email. Please contact suporte@openwhen.app.';

  @override
  String feedbackEmailBodyPrefix(String category) {
    return 'Category: $category';
  }

  @override
  String get keyboardDismissTooltip => 'Hide keyboard';

  @override
  String get keyboardDismissSemanticsLabel => 'Dismiss keyboard';

  @override
  String get subscriptionSectionTitle => 'Plan & subscription';

  @override
  String get subscriptionScreenTitle => 'Plans';

  @override
  String get subscriptionPlanAmanhaName => 'Amanhã';

  @override
  String get subscriptionPlanBrisaName => 'Brisa';

  @override
  String get subscriptionPlanHorizonteName => 'Horizonte';

  @override
  String get subscriptionPlanAmanhaPitch =>
      'The essentials to write today and feel it at the right time.';

  @override
  String get subscriptionPlanBrisaPitch =>
      'Share and express more — richer vault and social moments.';

  @override
  String get subscriptionPlanHorizontePitch =>
      'Archive, family context, and transparent intelligence.';

  @override
  String get subscriptionCurrentPlanLabel => 'Your current plan';

  @override
  String get subscriptionSubscribeBrisa => 'Subscribe to Brisa';

  @override
  String get subscriptionSubscribeHorizonte => 'Subscribe to Horizonte';

  @override
  String get subscriptionManageBilling => 'Manage subscription & payment';

  @override
  String get subscriptionCheckoutError =>
      'Could not open checkout. Please try again.';

  @override
  String get subscriptionPortalError => 'Could not open the billing portal.';

  @override
  String get subscriptionUpgradeDialogTitle => 'Plan required';

  @override
  String subscriptionUpgradeDialogBody(String planName) {
    return 'This feature requires the $planName plan or higher.';
  }

  @override
  String get subscriptionUpgradeDialogViewPlans => 'View plans';

  @override
  String get subscriptionBillingDisabledBanner =>
      'Subscription checkout is not enabled yet. You can keep using the app on the Amanhã plan. Enable billing in the project when Stripe is ready.';

  @override
  String get subscriptionBillingDisabledSnack =>
      'Billing is not enabled yet. Set BILLING_ENABLED=true when Stripe is configured.';

  @override
  String get termsIntro =>
      'These Terms of Use (\"Terms\") govern access to and use of the OpenWhen application (\"Platform\"), developed and operated by OpenWhen Tecnologia Ltda. (\"Company\"), registered under CNPJ No. [XX.XXX.XXX/0001-XX], headquartered in Brazil. Use of the Platform implies full and unconditional acceptance of these Terms, pursuant to Article 8 of Law No. 12,965/2014 (Internet Civil Framework) and Law No. 13,709/2018 (General Data Protection Law — LGPD).';

  @override
  String get termsSection1Title => '1. PURPOSE AND NATURE OF THE SERVICE';

  @override
  String get termsSection1Body =>
      'OpenWhen is a digital platform for time-based communication that allows users to create, send, receive, and store electronic messages (\"Letters\") scheduled to be opened on a future date determined by the sender. The service is a digital communication intermediary and, when authorized by the user, a social network publication environment (\"Public Feed\"). The Company acts as an application provider, pursuant to Article 5, Clause VII, of the Internet Civil Framework.';

  @override
  String get termsSection2Title => '2. REQUIREMENTS FOR USE';

  @override
  String get termsSection2Body =>
      'To use the Platform, the user must: (i) have full legal capacity, pursuant to Article 3 of the Brazilian Civil Code (Law No. 10,406/2002), or be assisted by a legal guardian if under 16 years of age; (ii) provide truthful information during registration, subject to immediate account cancellation, pursuant to Article 7, Clause VI, of the Internet Civil Framework; (iii) maintain the confidentiality of their access credentials, being responsible for all activities carried out under their account.';

  @override
  String get termsSection3Title => '3. USER OBLIGATIONS AND RESPONSIBILITIES';

  @override
  String get termsSection3Body =>
      'The user agrees to use the Platform in compliance with current legislation, particularly: (i) Law No. 12,965/2014 (Internet Civil Framework); (ii) Law No. 13,709/2018 (LGPD); (iii) the Brazilian Penal Code regarding crimes against honor (Articles 138 to 140); (iv) Law No. 7,716/1989 (Anti-Discrimination Law); and (v) the Child and Adolescent Statute (ECA — Law No. 8,069/1990). The user is expressly prohibited from publishing content that: (a) is defamatory, slanderous, or injurious; (b) incites violence, hatred, or discrimination of any kind; (c) violates third-party intellectual property rights; (d) constitutes harassment, cyberbullying, or stalking; (e) involves child pornography or sexual content involving minors.';

  @override
  String get termsSection4Title => '4. COMPANY LIABILITY';

  @override
  String get termsSection4Body =>
      'The Company, as an application provider, is not responsible for user-generated content (\"UGC — User Generated Content\"), pursuant to Article 19 of the Internet Civil Framework. The Company\'s civil liability is only established upon failure to comply with a specific court order requiring content removal. The Company adopts moderation and reporting mechanisms without assuming editorial responsibility for user content.';

  @override
  String get termsSection5Title => '5. INTELLECTUAL PROPERTY';

  @override
  String get termsSection5Body =>
      'The user is and remains the holder of copyright over the content they create on the Platform, pursuant to Law No. 9,610/1998 (Copyright Law). By publishing content on the Public Feed, the user grants the Company a non-exclusive, irrevocable, free, and worldwide license to reproduce, distribute, and display such content exclusively within the Platform, and may revoke such license by deleting the content or terminating the account. The brand, logo, design, and source code of OpenWhen are the exclusive property of the Company and protected by Law No. 9,279/1996 (Industrial Property Law).';

  @override
  String get termsSection6Title => '6. TERM AND TERMINATION';

  @override
  String get termsSection6Body =>
      'This agreement shall remain in effect for an indefinite period from the user\'s registration. The user may terminate the agreement at any time by deleting their account in the Platform settings, pursuant to Article 7, Clause IX, of the Internet Civil Framework. The Company reserves the right to suspend or terminate accounts that violate these Terms, without prejudice to other applicable legal measures.';

  @override
  String get termsSection7Title => '7. GENERAL PROVISIONS';

  @override
  String get termsSection7Body =>
      'These Terms are governed by the laws of the Federative Republic of Brazil. The courts of São Paulo/SP are hereby elected to resolve any disputes arising from this instrument, with express waiver of any other jurisdiction, however privileged. The invalidity of any clause does not affect the validity of the remaining clauses. Questions and notices should be sent to: juridico@openwhen.app. Last updated: March 22, 2026.';

  @override
  String get privacyIntro =>
      'This Privacy Policy (\"Policy\") describes how OpenWhen Tecnologia Ltda. (\"Company\", \"we\") collects, processes, stores, and shares the personal data of Platform users, in compliance with Law No. 13,709/2018 (General Data Protection Law — LGPD), the General Data Protection Regulation of the European Union (GDPR — Regulation EU 2016/679), Law No. 12,965/2014 (Internet Civil Framework), and other applicable regulations. The Company acts as a Data Controller, pursuant to Article 5, Clause VI, of the LGPD.';

  @override
  String get privacySection1Title => '1. PERSONAL DATA COLLECTED';

  @override
  String get privacySection1Body =>
      'The Company collects the following categories of personal data: (i) Registration data: full name, email address, username, and profile photo; (ii) Usage data: interactions on the Platform, letters created, sent and received, likes and comments; (iii) Technical data: IP address, device identifier, operating system and access logs, pursuant to Article 15 of the Internet Civil Framework; (iv) Location data: country of origin, collected in a non-precise manner solely for service personalization. We do not collect sensitive personal data, as defined in Article 5, Clause II, of the LGPD, except with express consent.';

  @override
  String get privacySection2Title => '2. LEGAL BASES FOR PROCESSING';

  @override
  String get privacySection2Body =>
      'The processing of users\' personal data is based on the following legal grounds provided in Article 7 of the LGPD: (i) Consent of the data subject, pursuant to Article 7, Clause I, expressed at the time of registration; (ii) Contract performance, pursuant to Article 7, Clause V, for the provision of contracted services; (iii) Legitimate interest of the Company, pursuant to Article 7, Clause IX, for Platform improvement, fraud prevention, and service security; (iv) Compliance with legal or regulatory obligations, pursuant to Article 7, Clause II.';

  @override
  String get privacySection3Title => '3. PURPOSE OF PROCESSING';

  @override
  String get privacySection3Body =>
      'The personal data collected is processed for the following purposes: (i) Provision of Platform services; (ii) Personalization of user experience; (iii) Sending service-related notifications; (iv) Continuous improvement of the Platform; (v) Fraud prevention and security assurance; (vi) Compliance with legal and regulatory obligations; (vii) Regular exercise of rights in judicial, administrative, or arbitration proceedings. Data is not used for third-party advertising.';

  @override
  String get privacySection4Title => '4. DATA SHARING';

  @override
  String get privacySection4Body =>
      'The Company does not sell, rent, or transfer personal data to third parties for commercial purposes. Data sharing occurs exclusively in the following cases: (i) With essential service providers for the Platform\'s operation (Firebase/Google Cloud), acting as Data Processors, under contracts that ensure an adequate level of protection; (ii) With public authorities, by court order or substantiated legal request; (iii) With an acquirer in the event of a merger, acquisition, or corporate restructuring, ensuring continuity of this Policy.';

  @override
  String get privacySection5Title =>
      '5. DATA SUBJECT RIGHTS (LGPD — Article 18)';

  @override
  String get privacySection5Body =>
      'Pursuant to Article 18 of the LGPD, the data subject has the right to: (i) Confirmation of the existence of processing; (ii) Access to data; (iii) Correction of incomplete, inaccurate, or outdated data; (iv) Anonymization, blocking, or deletion of unnecessary data; (v) Data portability to another provider, upon express request; (vi) Deletion of data processed based on consent; (vii) Information about sharing with third parties; (viii) Revocation of consent. To exercise your rights, go to Settings > Data and Privacy or contact: privacidade@openwhen.app. The response deadline is up to 15 business days.';

  @override
  String get privacySection6Title => '6. DATA SECURITY AND RETENTION';

  @override
  String get privacySection6Body =>
      'The Company adopts appropriate technical and organizational measures to protect personal data against unauthorized access, destruction, loss, or alteration, including: encryption in transit (TLS 1.3) and at rest, role-based access control, and continuous security monitoring. Data is retained for the period necessary for the purposes of processing and deleted upon termination of the contractual relationship, except for legal retention obligations. In the event of a security incident, the data subject will be notified pursuant to Article 48 of the LGPD.';

  @override
  String get privacySection7Title => '7. INTERNATIONAL TRANSFERS';

  @override
  String get privacySection7Body =>
      'Users\' personal data may be transferred to servers located outside Brazil (Google Cloud Platform), in compliance with Article 33 of the LGPD, ensuring an adequate level of protection through standard contractual clauses approved by the National Data Protection Authority (ANPD).';

  @override
  String get privacySection8Title => '8. DATA PROTECTION OFFICER (DPO)';

  @override
  String get privacySection8Body =>
      'Pursuant to Article 41 of the LGPD, the Company\'s Data Protection Officer (DPO) can be contacted at: dpo@openwhen.app. Last updated: March 22, 2026.';

  @override
  String get letterPrivacyPublicLabel => 'Public';

  @override
  String get letterPrivacyPublicSubtitle => 'Visible to everyone in the feed';

  @override
  String get letterPrivacyPrivateLabel => 'Private';

  @override
  String get letterPrivacyPrivateSubtitle => 'Only you can see it';

  @override
  String get letterPrivacyActionMakePublic => 'Make public';

  @override
  String get letterPrivacyActionMakePrivate => 'Make private';

  @override
  String get letterDetailSentView => 'YOUR SENT LETTER';

  @override
  String get feedReadMore => 'Read more';

  @override
  String get feedReadFullLetter => 'Read full letter';

  @override
  String get feedCardToAnonymous => 'To: someone special';

  @override
  String get vaultLetterSheetHideReceiver => 'Hide recipient name';

  @override
  String get vaultLetterSheetShowReceiver => 'Show recipient name';

  @override
  String get feedRemoveFromFeed => 'Remove from feed';

  @override
  String get feedHideSenderName => 'Hide who sent this';

  @override
  String get feedShowSenderName => 'Show who sent this';

  @override
  String get feedSenderAnonymous => 'Someone special';
}
