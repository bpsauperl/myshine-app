// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDidNotWork => 'That didn\'t work. Please try again.';

  @override
  String commonAlignerNumber(Object number) {
    return 'Aligner $number';
  }

  @override
  String get commonLastAligner => 'Last aligner';

  @override
  String commonDaysLate(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String get archHeroLabel => 'A clear Shine aligner';

  @override
  String get dateToday => 'today';

  @override
  String get dateTomorrow => 'tomorrow';

  @override
  String dateOnWeekday(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'on Monday',
      'tuesday': 'on Tuesday',
      'wednesday': 'on Wednesday',
      'thursday': 'on Thursday',
      'friday': 'on Friday',
      'saturday': 'on Saturday',
      'sunday': 'on Sunday',
      'other': 'on $weekday',
    });
    return '$_temp0';
  }

  @override
  String dateOnDate(Object date) {
    return 'on $date';
  }

  @override
  String get browserBadLink => 'This link doesn\'t work.';

  @override
  String get browserCouldNotOpen => 'We couldn\'t open the link.';

  @override
  String browserCouldNotOpenContact(Object target) {
    return 'We couldn\'t open $target.';
  }

  @override
  String get apiErrorSlow =>
      'The connection is slow. Please try again in a moment.';

  @override
  String get apiErrorOffline =>
      'We couldn\'t reach myShine. Check your internet connection.';

  @override
  String get apiErrorUnauthorized => 'Please connect with your clinic again.';

  @override
  String get apiErrorForbidden => 'This isn\'t available for your account.';

  @override
  String get apiErrorTooManyTries =>
      'Too many tries. Please wait a few minutes and try again.';

  @override
  String get apiErrorServer =>
      'Something went wrong on our side. Please try again later.';

  @override
  String get apiErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get welcomeBySmileLabs => 'by SmileLabs';

  @override
  String get welcomeEyebrow => 'Shine clear aligners';

  @override
  String get welcomeTitle => 'Your smile,';

  @override
  String get welcomeTitleMuted => 'revealed.';

  @override
  String get welcomeBody =>
      'See your new smile in a minute. Then follow every aligner, day by day, with your clinic.';

  @override
  String get welcomeSimulate => 'See your new smile';

  @override
  String get welcomeClinicCode => 'Clinic code';

  @override
  String get connectTitle => 'Your clinic';

  @override
  String get connectTitleMuted => 'has a key for you.';

  @override
  String get connectBody =>
      'Type the 8-character code from your clinic. Your plan, aligners and messages open right away.';

  @override
  String get connectPass => 'pass';

  @override
  String get connectWorksOnce => 'Works once';

  @override
  String connectValidDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Valid $days days',
      one: 'Valid 1 day',
    );
    return '$_temp0';
  }

  @override
  String get connectButton => 'Connect';

  @override
  String get connectFooter =>
      'Private between you and your clinic. No password. No code? Ask your clinic for one.';

  @override
  String get connectCodeEmpty => 'Type the code from your clinic.';

  @override
  String connectCodeConfusing(Object letter) {
    return 'Codes don\'t use 0, O, 1, I or L. Check the letter \"$letter\".';
  }

  @override
  String connectCodeLength(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'The code has $length characters.',
      one: 'The code has 1 character.',
    );
    return '$_temp0';
  }

  @override
  String get homeLoadError => 'We couldn\'t load myShine';

  @override
  String get tabToday => 'Today';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabSchedule => 'Schedule';

  @override
  String get tabMessages => 'Messages';

  @override
  String tabMessagesUnread(Object count) {
    return 'Messages ($count)';
  }

  @override
  String get tabProfile => 'Profile';

  @override
  String todayHello(Object name) {
    return 'Hello, $name';
  }

  @override
  String get todayNotStartedTitle => 'Treatment not started yet';

  @override
  String get todayNotStartedBody =>
      'Your clinic will start your treatment and give you your first aligners. Your schedule will show here then.';

  @override
  String get todayAllDoneTitle => 'All aligners done';

  @override
  String get todayAllDoneBody =>
      'Well done! Your clinic will tell you what comes next.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Your last aligner ended on $date. Your clinic will tell you what comes next.';
  }

  @override
  String get todayAlignerLabel => 'Your aligner';

  @override
  String todayWearHint(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other:
          'Wear your aligners about $hours hours a day. Take them out only to eat and brush.',
      one: 'Wear your aligners about 1 hour a day. Take them out only to eat and brush.',
    );
    return '$_temp0';
  }

  @override
  String todaySeriesDay(int series, int day, int days) {
    return 'Series $series · day $day of $days';
  }

  @override
  String todayDay(int day, int days) {
    return 'day $day of $days';
  }

  @override
  String todayAlignerOf(int aligner, int total) {
    return 'Aligner $aligner of $total';
  }

  @override
  String get todayCheckIn => 'Check in';

  @override
  String get todayLastOne => 'Last one';

  @override
  String get todayNextAligner => 'Next aligner';

  @override
  String get todayThisAligner => 'This aligner';

  @override
  String todayDaysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days left',
      one: 'day left',
    );
    return '$_temp0';
  }

  @override
  String get todayTreatment => 'Treatment';

  @override
  String get planTitle => 'Your plan';

  @override
  String get planHeroLabel => 'Your treatment plan';

  @override
  String get planIn3d => 'In 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Series $series · in 3D';
  }

  @override
  String get planCardTitle => 'Every step to your new smile.';

  @override
  String get planCardBody =>
      'See how your teeth move, aligner by aligner, from today to the end.';

  @override
  String get planOpen => 'Open your plan';

  @override
  String get planNotSharedTitle => 'Your clinic will share your plan here.';

  @override
  String get planNotSharedBody =>
      'When your dentist has prepared your plan, you can see it in 3D right here.';

  @override
  String get scheduleEmptyTitle => 'No schedule yet';

  @override
  String get scheduleEmptyBody =>
      'Your aligner schedule shows here once your treatment starts.';

  @override
  String scheduleAligners(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aligners',
      one: '1 aligner',
    );
    return '$_temp0';
  }

  @override
  String scheduleSeries(int series, String aligners) {
    return 'Series $series · $aligners';
  }

  @override
  String scheduleLastEnds(Object date) {
    return 'Your last aligner ends on $date.';
  }

  @override
  String get scheduleStarted => 'Started';

  @override
  String get scheduleDone => 'Done';

  @override
  String scheduleDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get scheduleNow => 'Today';

  @override
  String get scheduleCheckedIn => 'Checked in';

  @override
  String scheduleCheckedInOn(Object date) {
    return 'Checked in $date';
  }

  @override
  String get scheduleOnTime => 'on time';

  @override
  String get checkInFitSeated => 'Fits well';

  @override
  String get checkInFitLoose => 'Not fully seated';

  @override
  String get checkInFitTight => 'Very tight';

  @override
  String get checkInFitDamaged => 'Damaged or lost';

  @override
  String get checkInComfortNone => 'None';

  @override
  String get checkInComfortMild => 'Mild';

  @override
  String get checkInComfortStrong => 'Strong';

  @override
  String checkInConfirmError(Object aligner) {
    return 'Confirm that you have put in aligner $aligner.';
  }

  @override
  String checkInChooseFitError(Object aligner) {
    return 'Choose how aligner $aligner fits.';
  }

  @override
  String checkInPhotoTitle(Object view) {
    return '$view photo';
  }

  @override
  String get intraoralFront => 'Front';

  @override
  String get intraoralRight => 'Right';

  @override
  String get intraoralLeft => 'Left';

  @override
  String get intraoralUpper => 'Upper';

  @override
  String get intraoralLower => 'Lower';

  @override
  String get intraoralFrontHint =>
      'Bite together and smile wide, so all front teeth show.';

  @override
  String get intraoralRightHint =>
      'Bite together, pull your right cheek back and turn a little.';

  @override
  String get intraoralLeftHint =>
      'Bite together, pull your left cheek back and turn a little.';

  @override
  String get intraoralUpperHint =>
      'Tilt your head back and open wide to show your upper teeth.';

  @override
  String get intraoralLowerHint =>
      'Tilt your head down and open wide to show your lower teeth.';

  @override
  String checkInThanks(Object aligner) {
    return 'Aligner $aligner it is. Thank you!';
  }

  @override
  String get checkInEyebrow => 'Your check-in';

  @override
  String checkInNext(Object aligner) {
    return 'Next: aligner $aligner';
  }

  @override
  String checkInAlignerWhen(int aligner, String when) {
    return 'Aligner $aligner $when';
  }

  @override
  String get checkInUpcomingBody =>
      'When you put it in, check in here. Your schedule follows the day you change.';

  @override
  String checkInEarly(Object aligner) {
    return 'I\'ve switched to aligner $aligner already';
  }

  @override
  String get checkInClinicSees => 'Your clinic sees your check-in.';

  @override
  String get checkInDueYesterday =>
      'Due yesterday. Check in when you\'ve changed.';

  @override
  String checkInDueDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due $count days ago. Check in when you\'ve changed.',
      one: 'Due 1 day ago. Check in when you\'ve changed.',
    );
    return '$_temp0';
  }

  @override
  String checkInDue(Object when) {
    return 'Due $when.';
  }

  @override
  String checkInSwitchTitle(Object aligner) {
    return 'Switch to aligner $aligner';
  }

  @override
  String checkInSwitchedLabel(Object aligner) {
    return 'I\'ve put in aligner $aligner';
  }

  @override
  String checkInFitQuestion(Object aligner) {
    return 'How does aligner $aligner fit?';
  }

  @override
  String get checkInDiscomfort => 'Discomfort';

  @override
  String get checkInNoteLabel => 'Note for your clinic';

  @override
  String get checkInNoteHint => 'Anything you\'d like them to know (optional)';

  @override
  String get checkInSending => 'Sending…';

  @override
  String checkInSend(Object aligner) {
    return 'Check in aligner $aligner';
  }

  @override
  String get checkInPhotos => 'Photos';

  @override
  String get checkInPhotosAsking =>
      'Photos of your teeth with the aligner in help your clinic see what\'s wrong.';

  @override
  String get checkInPhotosOptional =>
      'Optional. Photos of your teeth with the aligner in. Only your clinic sees them.';

  @override
  String get checkInPhotosWebOnly =>
      'You can add photos of your teeth in the myShine app on your phone.';

  @override
  String checkInTakePhoto(Object view) {
    return 'Take the $view photo';
  }

  @override
  String get photoRemove => 'Remove photo';

  @override
  String photoRemoveNamed(Object view) {
    return 'Remove the $view photo';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileDisconnectTitle => 'Disconnect myShine?';

  @override
  String get profileDisconnectBody =>
      'Your plan, schedule and messages will no longer show on this phone. To connect again, ask your clinic for a new code.';

  @override
  String get profileDisconnect => 'Disconnect';

  @override
  String get profileYourClinic => 'Your clinic';

  @override
  String get profileYourDentist => 'Your dentist';

  @override
  String get profileCall => 'Call';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileThisPhone => 'This phone';

  @override
  String get profileReminders => 'Aligner reminders';

  @override
  String get profileRemindersDetail => 'On the day you change';

  @override
  String get profileOn => 'On';

  @override
  String get profileOff => 'Off';

  @override
  String get profileFooter => 'Shine clear aligners by SmileLabs';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get documentsEmptyTitle => 'Nothing here yet';

  @override
  String get documentsEmptyBody =>
      'What you sign, and the statements for your aligners, show here.';

  @override
  String get documentsFootnote =>
      'Everything you signed and the statement for each of your devices stays here. Tap one to open, print or save it. Your clinic keeps the same copies.';

  @override
  String get documentsConsent => 'Treatment consent';

  @override
  String documentsConsentFor(Object devices) {
    return 'Consent: $devices';
  }

  @override
  String get documentsSigned => 'Signed';

  @override
  String documentsSignedOn(Object date) {
    return 'Signed on $date';
  }

  @override
  String get documentsSignThere => 'Your clinic will ask you to sign it there';

  @override
  String get documentsWaiting => 'Waiting for your signature';

  @override
  String get documentsSign => 'Sign';

  @override
  String get documentsOpen => 'Open';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSubtitle =>
      'Write to your clinic. They usually answer within a working day.';

  @override
  String get messagesLoadError => 'Messages didn\'t load';

  @override
  String get messagesEmptyTitle => 'No messages yet';

  @override
  String get messagesEmptyBody =>
      'Questions about your aligners? Write to your clinic here.';

  @override
  String get messagesPhotoTitle => 'Photo for your clinic';

  @override
  String get messagesPhotoHint =>
      'Take a clear photo in good light. It\'s sent with your message.';

  @override
  String get messagesAddPhoto => 'Add a photo';

  @override
  String get messagesInputHint => 'Message your clinic';

  @override
  String get messagesSend => 'Send';

  @override
  String get messagesOpenPhoto => 'Open photo';

  @override
  String get messagesPhoto => 'Photo';

  @override
  String get messagesPhotoFailed =>
      'This photo didn\'t load. Please try again later.';

  @override
  String get cameraSwitch => 'Switch camera';

  @override
  String get cameraDenied =>
      'Allow camera access for myShine in Settings to add a photo.';

  @override
  String get cameraUnavailable => 'Camera unavailable here';

  @override
  String get cameraTakePhoto => 'Take photo';

  @override
  String get selfieTitle => 'Smile photo';

  @override
  String get selfieGuide =>
      'Fit your face in the oval and smile, so your teeth sit in the box.';

  @override
  String get selfiePrivate =>
      'The photo stays on your phone. Nothing is uploaded.';

  @override
  String get selfieSample => 'See a sample preview';

  @override
  String get selfieDenied =>
      'Allow camera access for myShine in Settings to take your photo.';

  @override
  String get previewTitle => 'Your preview';

  @override
  String get previewSampleNote =>
      'Camera unavailable here, so this is a sample illustration.';

  @override
  String get previewLikeTitle => 'Like what you see?';

  @override
  String get previewLikeBody =>
      'A Shine dentist checks your teeth and plans every step with you.';

  @override
  String get previewFindClinic => 'Find a Shine clinic';

  @override
  String get previewTakeAnother => 'Take another photo';

  @override
  String get previewHaveCode => 'I have a code from my clinic';

  @override
  String get previewHonest =>
      'An illustration, not a treatment plan. Your dentist shows your real plan in 3D.';

  @override
  String get previewAfter => 'After';

  @override
  String get previewBefore => 'Before';

  @override
  String reminderChangeTitle(Object aligner) {
    return 'Time for aligner $aligner';
  }

  @override
  String reminderChangeBody(Object aligner) {
    return 'Put in aligner $aligner today.';
  }

  @override
  String reminderCheckInBody(Object aligner) {
    return 'Put in aligner $aligner today, then check in in myShine.';
  }

  @override
  String reminderLateTitle(Object aligner) {
    return 'Did you switch to aligner $aligner?';
  }

  @override
  String get reminderLateBody =>
      'Check in when you have, so your schedule stays right.';
}
