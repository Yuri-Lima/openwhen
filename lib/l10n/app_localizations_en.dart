// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Whenote';

  @override
  String get splashTagline => 'Letters for the future';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get snackFillAllFields => 'Please fill in all fields!';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authErrorInvalidEmail => 'Invalid email address.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorEmailAlreadyInUse => 'This email is already in use.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Wait a few minutes or reset your password.';

  @override
  String get authErrorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authErrorGeneric => 'Couldn\'t sign in. Please try again.';

  @override
  String get loginForgotPasswordInline => 'Forgot my password';

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
      'Turn on location services and allow Whenote to access your location to open this.';

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
  String get firstActionTitle => 'What would you like\nto do first?';

  @override
  String get firstActionSubtitle =>
      'Choose one to get started — you can always do the other later.';

  @override
  String get firstActionLetterTitle => 'Send a letter';

  @override
  String get firstActionLetterSubtitle => 'For someone special';

  @override
  String get firstActionCapsuleTitle => 'Create a time capsule';

  @override
  String get firstActionCapsuleSubtitle => 'For your future self';

  @override
  String get firstActionSkip => 'Explore first';

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
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordBody =>
      'Enter the email address associated with your account and we\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordHint => 'your email';

  @override
  String get forgotPasswordButton => 'Send reset link';

  @override
  String forgotPasswordSent(String email) {
    return 'Reset link sent to $email';
  }

  @override
  String get forgotPasswordErrorNoUser => 'No account found with this email.';

  @override
  String get forgotPasswordErrorInvalidEmail =>
      'Please enter a valid email address.';

  @override
  String get forgotPasswordErrorGeneric =>
      'Something went wrong. Please try again.';

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
      'Account created! Check your email and sign in to continue.';

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
      'Your message contains inappropriate words. Whenote is a space of love and respect. 💌';

  @override
  String get commentsModerationAiBlocked =>
      'This comment did not pass automatic moderation. Please rephrase respectfully.';

  @override
  String get commentsModerationUnavailable =>
      'Automatic moderation is unavailable right now. Please try again shortly.';

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
  String get writeLetterSnackEmailInvalid =>
      'Please enter a valid email address (e.g. name@example.com)';

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
  String get writeLetterSendErrorEmailLookup =>
      'Could not verify the recipient email. Please check your connection and try again.';

  @override
  String get writeLetterSendErrorLoadProfile =>
      'Could not load your profile. Please try again.';

  @override
  String get writeLetterSendErrorFriendshipCheck =>
      'Could not verify friend status. Please try again.';

  @override
  String get writeLetterSendErrorSave =>
      'Could not save your letter. Please try again.';

  @override
  String get writeLetterSendErrorUnexpected =>
      'Something went wrong while sending. Please try again.';

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
  String get letterEmotionalPrimerTitle => 'This letter may be emotional.';

  @override
  String get letterEmotionalPrimerBody => 'Open it when you feel ready.';

  @override
  String get letterEmotionalPrimerOpenNow => 'Open now';

  @override
  String get letterEmotionalPrimerViewLater => 'View later';

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
    return '💌 A special letter is waiting for you on Whenote!\n\n\"$title\"\n\nScan the QR Code or visit: $link';
  }

  @override
  String get qrShareSubject => 'A special letter is waiting for you 💌';

  @override
  String qrShareLinkOnly(String title, String link) {
    return '💌 A special letter is waiting for you on Whenote!\n\n\"$title\"\n\nVisit: $link';
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
  String get userProfileActionSendLetter => 'Letter';

  @override
  String get userProfileEmptyLetters => 'No public letters yet';

  @override
  String get searchTitle => 'Search people';

  @override
  String get searchHint => 'Search by name or @username...';

  @override
  String get searchEmpty => 'No results';

  @override
  String get searchMinCharsHint => 'Enter at least 2 characters to search';

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
  String get qrFooterBrand => 'whenote.app';

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
  String get settingsAbout => 'About Whenote';

  @override
  String get settingsAboutVersion => 'Version 1.0.0';

  @override
  String get settingsLogout => 'Sign out';

  @override
  String get settingsLogoutTitle => 'Sign out';

  @override
  String get settingsLogoutConfirmMessage =>
      'Are you sure you want to sign out?';

  @override
  String get settingsLogoutConfirmButton => 'Sign out';

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
  String get settingsDeletePendingLettersWarning =>
      'Important: You may have locked letters waiting to be delivered to recipients or letters waiting to be received. If you choose \"Delete All\", pending letters you sent will not be delivered and letters you haven\'t opened yet will be lost. If you choose \"Anonymize\", your sent letters will still be delivered but your name will be replaced with \"Deleted user\".';

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
  String get legalTitleAbout => 'About Whenote';

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
  String get aboutWhatIsTitle => 'What is Whenote';

  @override
  String get aboutWhatIsBody =>
      'Whenote is a digital platform for time-based communication and an emotional social network. It allows you to create digital letters with a future opening date, combining the sentimental value of a physical letter with the virality of a modern social network.';

  @override
  String get aboutSecurityTitle => 'Security and Privacy';

  @override
  String get aboutSecurityBody =>
      'Developed in compliance with the LGPD (Law No. 13,709/2018) and the Brazilian Internet Civil Framework (Law No. 12,965/2014). Your data is protected with end-to-end encryption and stored on the Google Cloud Platform infrastructure.';

  @override
  String get aboutComplianceTitle => 'Legal Compliance';

  @override
  String get aboutComplianceBody =>
      'Whenote operates in full compliance with current Brazilian legislation, including the LGPD, the Internet Civil Framework, the Consumer Protection Code (Law No. 8,078/1990), and other regulations applicable to the technology sector.';

  @override
  String get aboutCompanyTitle => 'Company';

  @override
  String get aboutCompanyBody =>
      'Developed and operated by Yuri Matos de Lima (Oviedo, Spain) and Diego Ricardo Martins Rocha (Miami, FL, USA). Jurisdiction: Miami-Dade County, FL, USA.';

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
  String get aboutCopyright => '© 2026 Whenote. All rights reserved.';

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
  String get helpFaq2Q => 'Does the recipient need an Whenote account?';

  @override
  String get helpFaq2A =>
      'Yes. Currently the recipient needs a registered Whenote account to receive letters. Sending to external emails will be available soon.';

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
  String get adminModerationIncidentsTab => 'AI alerts';

  @override
  String get adminModerationAiBannerTitle => 'AI moderation (server)';

  @override
  String get adminModerationProviderOpenai => 'OpenAI Moderation API';

  @override
  String get adminModerationCredentialsOk => 'Credentials configured';

  @override
  String get adminModerationCredentialsMissing =>
      'Credentials missing (Functions env)';

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
  String get adminResetFirstAction => 'Reset first-action guide';

  @override
  String get adminResetFirstActionSubtitle =>
      'Shows the guide again on next login';

  @override
  String get adminResetFirstActionDone =>
      'First-action guide reset. Restart the app to see it.';

  @override
  String get adminModerationReviewsTab => 'Human review';

  @override
  String get moderationNotificationsSection => 'Moderation';

  @override
  String get moderationNotificationsEntry => 'Notifications';

  @override
  String get moderationNotificationsTitle => 'Notifications';

  @override
  String get moderationNotificationsEmpty => 'No notifications yet.';

  @override
  String get commentsModerationPendingReview =>
      'Your comment was sent for review. You will be notified when it is approved or rejected.';

  @override
  String get commentsModerationQueueFailed =>
      'Could not submit for review. Please try again.';

  @override
  String get adminModerationApprove => 'Approve and publish';

  @override
  String get adminModerationReject => 'Reject';

  @override
  String get adminModerationFeedbackLabel =>
      'Message to user (required when rejecting)';

  @override
  String get adminModerationFeedbackHint => 'Explain what they should change…';

  @override
  String get adminModerationReviewsLoadError =>
      'Could not load the review queue.';

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
      'Could not open email. Please contact suporte@whenote.app.';

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
      'These Terms of Use (\"Terms\") govern access to and use of the Whenote application (\"Platform\"), developed and operated by Yuri Matos de Lima (NIE: Z2387345L, Oviedo, Spain) and Diego Ricardo Martins Rocha (Miami, FL, USA), individuals (\"Operators\"). Use of the Platform implies full and unconditional acceptance of these Terms, in compliance with applicable laws including the General Data Protection Regulation — GDPR (EU), the Lei Geral de Proteção de Dados — LGPD (Brazil), and the California Consumer Privacy Act — CCPA (USA).';

  @override
  String get termsSection1Title => '1. PURPOSE AND NATURE OF THE SERVICE';

  @override
  String get termsSection1Body =>
      'Whenote is a digital platform for time-based communication that allows users to create, send, receive, and store electronic messages (\"Letters\") scheduled to be opened on a future date determined by the sender. The service is a digital communication intermediary and, when authorized by the user, a social network publication environment (\"Public Feed\"). The Company acts as an application provider, pursuant to Article 5, Clause VII, of the Internet Civil Framework.';

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
      'The user is and remains the holder of copyright over the content they create on the Platform, pursuant to Law No. 9,610/1998 (Copyright Law). By publishing content on the Public Feed, the user grants the Company a non-exclusive, irrevocable, free, and worldwide license to reproduce, distribute, and display such content exclusively within the Platform, and may revoke such license by deleting the content or terminating the account. The brand, logo, design, and source code of Whenote are the exclusive property of the Company and protected by Law No. 9,279/1996 (Industrial Property Law).';

  @override
  String get termsSection6Title => '6. TERM AND TERMINATION';

  @override
  String get termsSection6Body =>
      'This agreement shall remain in effect for an indefinite period from the user\'s registration. The user may terminate the agreement at any time by deleting their account in the Platform settings, pursuant to Article 7, Clause IX, of the Internet Civil Framework. The Company reserves the right to suspend or terminate accounts that violate these Terms, without prejudice to other applicable legal measures.';

  @override
  String get termsSection7Title =>
      '7. SERVICE DISCONTINUATION AND LETTER DELIVERY GUARANTEE';

  @override
  String get termsSection7Body =>
      'Whenote makes every effort to ensure the delivery of all letters and capsules on the dates chosen by the sender. In the event of a planned discontinuation of services, the Company commits to: (i) notify all registered users by email and in-app notification at least 90 (ninety) days before the definitive shutdown; (ii) during the notice period, make available the export of all user data (letters, capsules, profile, media) via the app or email; (iii) deliver all locked letters whose opening date falls within the notice period; (iv) after the 90-day period, permanently and irreversibly delete all user data from its servers. The Company may establish a Continuity Fund — a financial reserve sufficient to maintain essential infrastructure (Firebase, storage, delivery functions) for at least 2 (two) years even if the app ceases to generate revenue. When established, the existence and status of this fund will be documented in these Terms. This commitment serves as a product guarantee, not a legal obligation, and may be adjusted as the Company\'s financial capacity evolves.';

  @override
  String get termsSection8Title => '8. GENERAL PROVISIONS';

  @override
  String get termsSection8Body =>
      'These Terms are governed by the laws of the State of Florida, United States. The courts of Miami-Dade County, FL, USA are hereby elected to resolve any disputes arising from this instrument. The invalidity of any clause does not affect the validity of the remaining clauses. Questions and notices should be sent to: juridico@whenote.app. Last updated: May 1, 2026.';

  @override
  String get privacyIntro =>
      'This Privacy Policy (\"Policy\") describes how Yuri Matos de Lima and Diego Ricardo Martins Rocha (\"Operators\", \"we\", \"us\", \"our\") collect, processes, stores, and shares the personal data of users of the Whenote platform and mobile application (\"Platform\"). This Policy applies globally and complies with: (a) the Brazilian General Data Protection Law — LGPD (Law No. 13,709/2018); (b) the General Data Protection Regulation of the European Union — GDPR (Regulation EU 2016/679); (c) the California Consumer Privacy Act and California Privacy Rights Act — CCPA/CPRA (California Civil Code §§ 1798.100–1798.199.100); (d) the Brazilian Internet Civil Framework (Law No. 12,965/2014); and (e) the U.S. Children\'s Online Privacy Protection Act — COPPA (16 CFR Part 312). The Company acts as Data Controller (LGPD Art. 5 VI / GDPR Art. 4(7)) and as a \"Business\" under CCPA. Effective date: April 10, 2026.';

  @override
  String get privacySection1Title => '1. DEFINITIONS';

  @override
  String get privacySection1Body =>
      'For the purposes of this Policy: \"Personal Data\" means any information relating to an identified or identifiable natural person (LGPD Art. 5 I / GDPR Art. 4(1)); \"Personal Information\" (PI) has the meaning defined in CCPA § 1798.140(v); \"Processing\" means any operation performed on personal data (LGPD Art. 5 X / GDPR Art. 4(2)); \"Data Subject\" or \"Consumer\" means any natural person whose personal data is processed; \"Controller\" means the entity that determines the purposes and means of processing; \"Processor\" or \"Operator\" means the entity that processes data on behalf of the Controller; \"Sensitive Personal Data\" means data concerning racial or ethnic origin, religious belief, political opinion, health, sexual life, or biometric/genetic data (LGPD Art. 5 II / GDPR Art. 9).';

  @override
  String get privacySection2Title => '2. DATA WE COLLECT';

  @override
  String get privacySection2Body =>
      'We collect the following categories of personal data:\n\n(a) Registration Data: full name, display name, email address, username, profile photo (optional), and biographical text (optional).\n\n(b) User-Generated Content: letters (text, title, emotional state), handwritten letter images (captured via camera), voice messages (up to 1 minute, captured via microphone), time capsules (text, theme, photos), comments on public letters, and optional music links.\n\n(c) Precise Location Data (opt-in): when you choose to attach a location to a letter or capsule, we collect your precise GPS coordinates (latitude and longitude) and the timestamp of capture. You may also enable a proximity requirement (approximately 10 meters) for the recipient to open the letter. Location collection is always optional and requested per letter or capsule — we never collect location data in the background.\n\n(d) Technical and Device Data: IP address, device identifier, operating system, app version, push notification token (Firebase Cloud Messaging), device platform (Android/iOS/web), preferred locale, and access logs pursuant to Article 15 of the Internet Civil Framework.\n\n(e) Analytics Data: usage events (letters created, opened, shared; capsules created, opened; feed views; likes, comments, follows; profile views; theme and language changes), screen views, and crash/error reports, collected via Firebase Analytics and Firebase Crashlytics.\n\n(f) Social Data: follower/following relationships, user blocks, likes on public letters, and comments.\n\n(g) Billing Data: when subscription features are enabled, we store your Stripe customer identifier, subscription identifier, subscription tier (free/plus/pro), and subscription status. Payment card details are processed and stored exclusively by Stripe and never touch our servers.\n\n(h) Moderation Data: content reports submitted by users (reason, detail, target content), AI moderation analysis results (flagged categories and scores), human moderation review records, and moderation incident logs.\n\n(i) Communication Data: product feedback messages (including platform and app locale metadata) and support requests.\n\n(j) Gamification Data: badge unlock records and in-app notification history.\n\nFor purposes of CCPA, the categories of PI collected in the preceding 12 months include: identifiers (name, email, username, device ID); internet/electronic network activity (usage events, access logs); geolocation data (precise GPS when opted in); audio/visual information (voice messages, photos); and professional or personal information inferred from content you create.';

  @override
  String get privacySection3Title => '3. HOW WE COLLECT DATA';

  @override
  String get privacySection3Body =>
      '(a) Directly from you: when you create an account, write letters or capsules, upload photos or voice messages, grant location permission, submit feedback, post comments, or interact with other users.\n\n(b) Automatically: device and technical data, analytics events, crash reports, and push notification tokens are collected automatically when you use the Platform, through Firebase SDKs integrated into the app.\n\n(c) From third parties: payment status updates from Stripe (via webhooks) when subscription features are active; device attestation from Firebase App Check (Google Play Integrity on Android, DeviceCheck on iOS) to protect against abuse.';

  @override
  String get privacySection4Title => '4. LEGAL BASES FOR PROCESSING';

  @override
  String get privacySection4Body =>
      'Under the LGPD (Art. 7) and GDPR (Art. 6), we process your data based on:\n\n(a) Consent (LGPD Art. 7 I / GDPR Art. 6(1)(a)): expressed at registration when you accept this Policy; for optional features such as location data and voice messages, consent is obtained at the moment of use.\n\n(b) Contract Performance (LGPD Art. 7 V / GDPR Art. 6(1)(b)): processing necessary to provide the Platform\'s services — delivering letters, managing capsules, enabling social features, and maintaining your account.\n\n(c) Legitimate Interest (LGPD Art. 7 IX / GDPR Art. 6(1)(f)): Platform improvement, fraud prevention, content moderation, service security, and analytics. We conduct a balancing test to ensure our interests do not override your fundamental rights.\n\n(d) Legal Obligation (LGPD Art. 7 II / GDPR Art. 6(1)(c)): retention of access logs for 6 months (Internet Civil Framework Art. 15), compliance with court orders, and regulatory requirements.\n\nUnder CCPA, the collection and use of PI is disclosed in Sections 2, 6, and 8 of this Policy. We do not use or disclose sensitive personal information for purposes beyond those permitted by CCPA § 1798.121.';

  @override
  String get privacySection5Title => '5. PURPOSES OF PROCESSING';

  @override
  String get privacySection5Body =>
      'We process your personal data for the following purposes: (i) providing and operating Platform services (letter delivery, capsule management, social feed); (ii) personalizing your experience (themes, language, emotional states); (iii) sending service-related notifications (letter delivery alerts, capsule opening reminders) via push notifications and, when applicable, email; (iv) content moderation to ensure a safe and respectful environment; (v) analytics and continuous improvement of the Platform; (vi) fraud prevention and security assurance; (vii) processing payments and managing subscriptions (when enabled); (viii) compliance with legal and regulatory obligations; (ix) exercise of rights in judicial, administrative, or arbitration proceedings. We do not use your data for third-party advertising, behavioral profiling for ad targeting, or sale to data brokers.';

  @override
  String get privacySection6Title =>
      '6. AUTOMATED DECISION-MAKING AND PROFILING';

  @override
  String get privacySection6Body =>
      'The Platform uses automated content moderation powered by artificial intelligence (OpenAI Moderations API) to analyze text content (such as comments) for potentially harmful material. This system may: (a) allow content to be published without intervention (low risk score); (b) present a gentle warning to the author while allowing publication (medium risk score); or (c) block content from being published (high risk score). When human moderation is enabled, flagged content is queued for manual review by our moderation team before a final decision is made. No automated decision is based on sensitive personal data categories. Pursuant to GDPR Article 22, you have the right not to be subject to decisions based solely on automated processing that produce legal or similarly significant effects. You may contest any automated moderation decision by contacting us at privacidade@whenote.app or through the in-app report/feedback feature. Under LGPD Article 20, you may request a review of automated decisions that affect your interests.';

  @override
  String get privacySection7Title =>
      '7. DATA SHARING AND THIRD-PARTY PROCESSORS';

  @override
  String get privacySection7Body =>
      'We do not sell, rent, or trade your personal data. For CCPA purposes: we have not sold or shared (as defined in CCPA § 1798.140(ad) and (ah)) consumers\' personal information in the preceding 12 months, and we do not have actual knowledge of selling or sharing PI of consumers under 16 years of age. Data is shared with the following categories of service providers/processors, each bound by data processing agreements:\n\n(a) Google LLC / Firebase: cloud infrastructure (Firestore database, Cloud Storage for files, Cloud Functions for server logic), authentication services, push notifications (FCM), analytics (Firebase Analytics), crash reporting (Crashlytics), and device attestation (App Check). Google processes data as a Processor under our instructions. Google\'s privacy commitments: https://firebase.google.com/support/privacy.\n\n(b) OpenAI, Inc.: text content is sent to OpenAI\'s Moderations API exclusively for content safety analysis. Only the text of the content being moderated is transmitted — no user identifiers, images, or voice data are sent. OpenAI\'s data usage policy for API customers states that API inputs are not used to train models.\n\n(c) Twilio Inc. (SendGrid): email addresses of external letter recipients are processed to send invitation emails when a letter is addressed to someone who does not yet have an account. Only the recipient email, a sender display name, and a letter title are included.\n\n(d) Stripe, Inc.: when subscription/payment features are active, Stripe processes payment card data, customer identifiers, and subscription status. Card details are collected directly by Stripe and never pass through our servers.\n\n(e) Google Fonts: the app may load typefaces from Google\'s servers, which involves sending your IP address to Google.\n\n(f) Public authorities: we may share data with government authorities when required by court order or substantiated legal request.\n\n(g) Corporate transactions: in the event of a merger, acquisition, or restructuring, your data may be transferred to the successor entity, which will be bound by this Policy.';

  @override
  String get privacySection8Title => '8. INTERNATIONAL DATA TRANSFERS';

  @override
  String get privacySection8Body =>
      'Your personal data is stored on servers operated by Google Cloud Platform, which may be located in the United States or other countries outside your country of residence. These transfers are carried out in compliance with: (a) LGPD Article 33, using standard contractual clauses approved by the Brazilian National Data Protection Authority (ANPD); (b) GDPR Chapter V, relying on Standard Contractual Clauses (SCCs) adopted by the European Commission (Decision 2021/914) and, where applicable, supplementary measures per the Schrems II ruling; (c) for U.S.-based processors, contractual commitments ensuring data protection equivalent to that provided under applicable law. For OpenAI and Stripe, data processed in the United States is subject to their respective data processing agreements incorporating SCCs.';

  @override
  String get privacySection9Title => '9. DATA RETENTION';

  @override
  String get privacySection9Body =>
      'We retain your data for the minimum period necessary for the purposes described in this Policy. Specific retention periods:\n\n• Account/profile data: retained until you delete your account.\n• Letters and capsules: retained until you delete them or delete/anonymize your account.\n• Comments, likes, follows: retained until you or we delete them, or until account deletion.\n• Push notification tokens (FCM): overwritten on each login; deleted upon account deletion.\n• Precise location data: stored only when you opt in; deleted or anonymized upon account deletion.\n• Billing data (Stripe IDs): subscription cancelled and IDs deleted upon account deletion. Stripe may retain data per its own retention policy.\n• Content reports: anonymized 90 days after resolution.\n• Product feedback: anonymized after 1 year.\n• Moderation logs: retained for 2 years (without direct PII).\n• Analytics data (Firebase): retained per Firebase\'s default policy (14 months for user-level data).\n• Deletion audit logs: retained for 3 years with hashed (non-reversible) identifiers only — no PII.\n• Access logs: retained for 6 months pursuant to Internet Civil Framework Article 15.\n\nUpon expiration of these periods, data is permanently deleted or irreversibly anonymized.';

  @override
  String get privacySection10Title => '10. YOUR RIGHTS';

  @override
  String get privacySection10Body =>
      'Your rights vary depending on your jurisdiction. You can exercise any of the rights below via the app (Settings > Data and Privacy), by emailing privacidade@whenote.app (or privacy@whenote.app for English), or by contacting our DPO.\n\n— LGPD (Brazil — Art. 18): You have the right to: (i) confirmation of processing; (ii) access to your data; (iii) correction of incomplete or inaccurate data; (iv) anonymization, blocking, or deletion of unnecessary or excessive data; (v) portability to another service provider; (vi) deletion of data processed based on consent; (vii) information about third parties with whom data has been shared; (viii) information about the possibility of denying consent and its consequences; (ix) revocation of consent. Response deadline: 15 business days. You may file a complaint with the ANPD (Autoridade Nacional de Proteção de Dados): https://www.gov.br/anpd.\n\n— GDPR (EU/EEA — Arts. 15–22): You have the right to: (i) access (Art. 15); (ii) rectification (Art. 16); (iii) erasure / right to be forgotten (Art. 17); (iv) restriction of processing (Art. 18); (v) data portability (Art. 20); (vi) object to processing based on legitimate interest (Art. 21); (vii) not be subject to solely automated decisions, including profiling (Art. 22) — see Section 6 above; (viii) withdraw consent at any time (Art. 7(3)). Response deadline: 30 days. You may lodge a complaint with your local supervisory authority.\n\n— CCPA/CPRA (California): As a California consumer, you have the right to: (i) know what PI we collect, use, disclose, and sell (Right to Know); (ii) request deletion of your PI (Right to Delete) — response deadline: 45 days; (iii) correct inaccurate PI (Right to Correct); (iv) opt out of the sale or sharing of PI — we do not sell or share your PI, but you may submit a request at any time; (v) limit the use of sensitive PI — we do not use sensitive PI beyond what is necessary to provide our services; (vi) non-discrimination for exercising your rights. You may designate an authorized agent to submit requests on your behalf. We verify requests using your account email. Categories of PI collected, purposes, and third-party disclosures are detailed in Sections 2, 5, and 7.';

  @override
  String get privacySection11Title => '11. ACCOUNT DELETION';

  @override
  String get privacySection11Body =>
      'You may delete your account at any time via Settings > Data and Privacy > Delete Account. Before deletion, you must re-authenticate for security. You will be offered two modes:\n\n(a) Delete All: permanently removes your profile, all letters (sent and received), capsules, comments, likes, follows, blocks, reports, feedback, badges, notifications, and all uploaded files (photos, voice messages, handwritten images). Your Firebase authentication record is also deleted.\n\n(b) Anonymize: preserves letters and capsules for their recipients, but replaces your name with \"Deleted user\" and removes your identifying information (user ID, location data, personal media). Your profile, social connections, comments, and likes are deleted.\n\nIn both modes: (i) active Stripe subscriptions are cancelled; (ii) a non-reversible audit log is recorded (hashed identifier + timestamp, no PII) for compliance purposes; (iii) the deletion is irreversible. Locked letters you have already sent may continue to be delivered to their recipients per our Terms of Use — a letter sent is a gift entrusted to the recipient.';

  @override
  String get privacySection12Title => '12. DATA PORTABILITY AND EXPORT';

  @override
  String get privacySection12Body =>
      'Pursuant to LGPD Article 18 V and GDPR Article 20, you have the right to receive your personal data in a structured, commonly used, and machine-readable format. You can export your data via Settings > Data and Privacy > Export My Data. The export includes: your profile information (JSON), all letters you sent (JSON + attached media files), capsules you created (JSON + photos), your comments (JSON), likes (JSON), follower/following lists (JSON), and badges (JSON). The export is generated as a ZIP archive. You may also request a manual export by contacting privacidade@whenote.app.';

  @override
  String get privacySection13Title => '13. CHILDREN\'S PRIVACY';

  @override
  String get privacySection13Body =>
      'Whenote is not directed at children under 13 years of age. In compliance with COPPA (16 CFR Part 312), we do not knowingly collect personal information from children under 13. During registration, users must confirm that they are 13 years of age or older. If we become aware that we have collected data from a child under 13 without verifiable parental consent, we will promptly delete such data. Parents or guardians who believe their child has provided personal data to us may contact us at privacidade@whenote.app to request deletion. For users aged 13 to 17, we recommend parental guidance when using the Platform.';

  @override
  String get privacySection14Title => '14. SECURITY MEASURES';

  @override
  String get privacySection14Body =>
      'We implement appropriate technical and organizational measures to protect your personal data, including: (a) encryption in transit using TLS 1.3 for all communications between the app and our servers; (b) encryption at rest for data stored in Google Cloud/Firebase; (c) Firebase App Check (Play Integrity on Android, DeviceCheck on iOS) to protect backend services from abuse; (d) role-based access control limiting employee access to personal data; (e) Firestore Security Rules enforcing data access restrictions at the database level; (f) continuous security monitoring and logging. In the event of a personal data breach: under GDPR, we will notify the competent supervisory authority within 72 hours of becoming aware of the breach (Art. 33) and affected data subjects without undue delay when the breach poses a high risk (Art. 34); under LGPD, we will notify the ANPD and affected data subjects within a reasonable time (Art. 48); under CCPA, we will notify affected California consumers as required by California Civil Code § 1798.82.';

  @override
  String get privacySection15Title => '15. TRACKING TECHNOLOGIES';

  @override
  String get privacySection15Body =>
      'The Platform does not use traditional browser cookies. However, the following technologies collect data automatically: (a) Firebase Analytics: collects anonymous usage events, screen views, and device properties using mobile identifiers. You can reset your advertising identifier in your device settings. Firebase Analytics data retention is set to 14 months. (b) Firebase Crashlytics: collects crash reports including device state, app version, and stack traces to help us fix bugs. (c) Firebase App Check: verifies device integrity to protect against automated abuse. These technologies are essential for the operation, security, and improvement of the Platform. We do not use any tracking technologies for advertising or cross-site/cross-app behavioral tracking. We honor the Global Privacy Control (GPC) signal as a valid opt-out request under CCPA.';

  @override
  String get privacySection16Title => '16. CHANGES TO THIS POLICY';

  @override
  String get privacySection16Body =>
      'We may update this Policy from time to time to reflect changes in our practices, legal requirements, or Platform features. When we make material changes, we will: (a) update the \"Effective date\" at the top of this Policy; (b) notify you via in-app notification and/or email at least 15 days before the changes take effect; (c) for changes requiring renewed consent under GDPR or LGPD, request your explicit consent before the changes take effect. Continued use of the Platform after the effective date of a non-consent-requiring update constitutes acceptance of the revised Policy. Previous versions of this Policy are available upon request.';

  @override
  String get privacySection17Title => '17. CONTACT US';

  @override
  String get privacySection17Body =>
      'If you have questions about this Policy, wish to exercise your rights, or need to report a privacy concern, please contact us:\n\n• Data Protection Officer (DPO): dpo@whenote.app\n• Privacy requests (Portuguese): privacidade@whenote.app\n• Privacy requests (English): privacy@whenote.app\n• Legal department: juridico@whenote.app\n• General support: suporte@whenote.app\n\nBrazil — You may file a complaint with the ANPD: https://www.gov.br/anpd\nEU/EEA — You may lodge a complaint with your local data protection supervisory authority.\nCalifornia — You may contact the California Attorney General: https://oag.ca.gov/privacy\n\nYuri Matos de Lima & Diego Ricardo Martins Rocha\nLast updated: May 1, 2026.';

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
  String get feedOpenLetter => 'Open letter';

  @override
  String get feedCloseLetter => 'Close';

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

  @override
  String get registerAcceptTermsPrefix => 'I have read and accept the ';

  @override
  String get registerAcceptTermsAnd => ' and the ';

  @override
  String get registerConfirmAge => 'I confirm that I am 13 years old or older';

  @override
  String get registerMustAcceptTerms =>
      'You must accept the terms and confirm your age to continue';

  @override
  String get registerSectionUsername => 'USERNAME';

  @override
  String get registerHintUsername => 'your_username';

  @override
  String get registerUsernameSuggestions => 'Suggestions:';

  @override
  String get registerUsernameAvailable => 'Available';

  @override
  String get registerUsernameChecking => 'Checking...';

  @override
  String get registerUsernameRules => 'Letters, numbers, . and _ only';

  @override
  String get registerErrorUsernameEmpty => 'Choose a username';

  @override
  String get registerErrorUsernameShort =>
      'Username must be at least 3 characters';

  @override
  String get registerErrorUsernameLong =>
      'Username must be at most 20 characters';

  @override
  String get registerErrorUsernameInvalid =>
      'Only letters, numbers, . and _ (cannot start/end with . or _)';

  @override
  String get registerErrorUsernameTaken => 'This username is already taken';

  @override
  String get settingsDeleteChoiceTitle =>
      'What should happen with your letters?';

  @override
  String get settingsDeleteOptionDeleteAll => 'Delete everything';

  @override
  String get settingsDeleteOptionDeleteAllDesc =>
      'All letters, capsules, and data will be permanently removed.';

  @override
  String get settingsDeleteOptionAnonymize => 'Anonymize my letters';

  @override
  String get settingsDeleteOptionAnonymizeDesc =>
      'Your letters remain for recipients, but your name and info are removed.';

  @override
  String get settingsDeletePasswordLabel => 'CONFIRM YOUR PASSWORD';

  @override
  String get settingsDeletePasswordHint => 'Enter your current password';

  @override
  String get settingsDeleteIrreversibleConfirm =>
      'I understand this action is irreversible and all my data will be processed according to my choice above.';

  @override
  String get settingsDeleteProcessing => 'Deleting your account...';

  @override
  String get settingsDeleteWrongPassword =>
      'Incorrect password. Please try again.';

  @override
  String get settingsDeleteReauthFailed =>
      'Authentication failed. Please try again.';

  @override
  String get settingsDeleteError =>
      'Account deletion failed. Please try again later.';

  @override
  String settingsDeletePendingBanner(int days) {
    return 'Your account will be deleted in $days day(s). You can cancel the deletion at any time.';
  }

  @override
  String get settingsDeleteCancelButton => 'Cancel deletion';

  @override
  String get settingsDeleteCancelled =>
      'Account deletion cancelled. Your account is active again.';

  @override
  String settingsDeleteScheduled(int day, int month, int year) {
    return 'Deletion scheduled for $day/$month/$year. Your data has been sent via email.';
  }

  @override
  String get privacyCenterTitle => 'Privacy Center';

  @override
  String get privacyCenterSubtitle => 'View all your stored data';

  @override
  String get privacyCenterIntro =>
      'Here you can see all the data Whenote stores about you. This includes your profile, letters, capsules, social interactions and more. In compliance with GDPR Art. 15 and LGPD Art. 18.';

  @override
  String get privacyCenterProfile => 'Profile';

  @override
  String get privacyCenterFieldName => 'Name';

  @override
  String get privacyCenterFieldUsername => 'Username';

  @override
  String get privacyCenterFieldEmail => 'Email';

  @override
  String get privacyCenterFieldBio => 'Bio';

  @override
  String get privacyCenterFieldCountry => 'Country';

  @override
  String get privacyCenterFieldLanguage => 'Language';

  @override
  String get privacyCenterFieldCreatedAt => 'Created at';

  @override
  String get privacyCenterFieldPhoto => 'Photo';

  @override
  String get privacyCenterYes => 'Yes';

  @override
  String get privacyCenterNo => 'No';

  @override
  String get privacyCenterLetters => 'Letters';

  @override
  String get privacyCenterLettersSent => 'Sent';

  @override
  String get privacyCenterLettersReceived => 'Received';

  @override
  String get privacyCenterLettersLocked => 'Locked';

  @override
  String get privacyCenterLettersWithLocation => 'With location';

  @override
  String get privacyCenterCapsules => 'Capsules';

  @override
  String get privacyCenterCapsulesTotal => 'Total';

  @override
  String get privacyCenterSocial => 'Social';

  @override
  String get privacyCenterFollowers => 'Followers';

  @override
  String get privacyCenterFollowing => 'Following';

  @override
  String get privacyCenterBlocks => 'Blocks';

  @override
  String get privacyCenterEngagement => 'Engagement';

  @override
  String get privacyCenterComments => 'Comments';

  @override
  String get privacyCenterLikes => 'Likes';

  @override
  String get privacyCenterBadges => 'Badges';

  @override
  String get privacyCenterBadgesUnlocked => 'Unlocked';

  @override
  String get privacyCenterBilling => 'Subscription';

  @override
  String get privacyCenterSubscriptionTier => 'Plan';

  @override
  String get privacyCenterSubscriptionStatus => 'Status';

  @override
  String get privacyCenterLocation => 'Location';

  @override
  String get privacyCenterLocationExplainer =>
      'Whenote only saves your location when you choose to include it in a letter. Location is optional and controlled per letter.';

  @override
  String get emailVerificationTitle => 'Verify your email';

  @override
  String emailVerificationSubtitle(String email) {
    return 'We sent a verification link to $email. Confirm it to unlock sending letters, capsules and comments.';
  }

  @override
  String get emailVerificationResend => 'Resend email';

  @override
  String emailVerificationResendCooldown(String seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get emailVerificationAlreadyDone => 'I already verified';

  @override
  String get emailVerificationNotYet =>
      'Email not verified yet. Check your inbox and spam folder.';

  @override
  String get emailVerificationLater => 'Later';

  @override
  String get registerSuccessVerify =>
      'Account created! Check your email to verify.';

  @override
  String get notificationEmailBounceTitle => 'Email not delivered';

  @override
  String notificationEmailBounceBody(String email) {
    return 'The email to $email could not be delivered. Check the address and try again.';
  }

  @override
  String get notificationEmailSendFailedTitle => 'Email could not be sent';

  @override
  String notificationEmailSendFailedBody(String email) {
    return 'The email to $email could not be sent. Try again later.';
  }

  @override
  String get resendEmail => 'Resend';

  @override
  String get resendEmailDialogTitle => 'Resend invite email';

  @override
  String resendEmailDialogBody(String email) {
    return 'The email to $email failed. You can edit the address and resend.';
  }

  @override
  String get resendEmailSuccess => 'Email resent successfully!';

  @override
  String get resendEmailCooldown =>
      'Please wait a few minutes before resending.';

  @override
  String get resendEmailGenericError =>
      'Could not resend the email. Please try again later.';

  @override
  String get letterModerationWarning =>
      'Your letter has a tone that could hurt. Would you like to review it before sealing?';

  @override
  String get letterModerationBlocked =>
      'This letter cannot be sent. Whenote exists to connect people with love, resilience, and genuine connection.';

  @override
  String get letterModerationUnavailable =>
      'Content verification is temporarily unavailable. Please try again shortly.';

  @override
  String get letterModerationReviewBtn => 'Review letter';

  @override
  String get letterModerationSendAnywayBtn => 'Send anyway';

  @override
  String get letterModerationStepLabel => 'Checking content…';

  @override
  String get capsuleModerationWarning =>
      'Your capsule has a tone that could hurt. Would you like to review it before sealing?';

  @override
  String get capsuleModerationBlocked =>
      'This capsule cannot be created. Whenote exists to connect people with love, resilience, and genuine connection.';

  @override
  String get capsuleModerationUnavailable =>
      'Content verification is temporarily unavailable. Please try again shortly.';

  @override
  String get capsuleModerationReviewBtn => 'Review capsule';

  @override
  String get capsuleModerationSendAnywayBtn => 'Create anyway';

  @override
  String get mediaModerationImageRemovedTitle => 'Image removed';

  @override
  String get mediaModerationImageRemovedBody =>
      'An image you uploaded was removed for not meeting Whenote\'s guidelines.';

  @override
  String get mediaModerationAudioRemovedTitle => 'Audio removed';

  @override
  String get mediaModerationAudioRemovedBody =>
      'An audio recording you uploaded was removed for not meeting Whenote\'s guidelines.';

  @override
  String get mediaModerationImageUnavailable => 'Image unavailable';

  @override
  String get mediaModerationAudioUnavailable => 'Audio unavailable';

  @override
  String get followersTabFollowers => 'Followers';

  @override
  String get followersTabFollowing => 'Following';

  @override
  String get followersEmpty => 'No followers yet';

  @override
  String get followingEmpty => 'Not following anyone yet';
}
