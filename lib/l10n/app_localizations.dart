import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('sl'),
    Locale('sr'),
    Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'),
  ];

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Taking a photo failed.
  ///
  /// In en, this message translates to:
  /// **'That didn\'t work. Please try again.'**
  String get commonDidNotWork;

  /// An aligner by its number, e.g. 'Aligner 04' or 'Aligner 5'. The number may be zero-padded.
  ///
  /// In en, this message translates to:
  /// **'Aligner {number}'**
  String commonAlignerNumber(Object number);

  /// Label over the date the last aligner of the treatment ends.
  ///
  /// In en, this message translates to:
  /// **'Last aligner'**
  String get commonLastAligner;

  /// How late an aligner change is (or was). Also used after ' · ' in the schedule.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day late} other{{count} days late}}'**
  String commonDaysLate(num count);

  /// Lower case, used inside a sentence: 'Aligner 5 today', 'Due today.'
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get dateToday;

  /// Lower case, used inside a sentence: 'Aligner 5 tomorrow', 'Due tomorrow.'
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get dateTomorrow;

  /// A day within the next week, inside a sentence: 'Aligner 5 on Thursday', 'Due on Thursday.'
  ///
  /// In en, this message translates to:
  /// **'{weekday, select, monday{on Monday} tuesday{on Tuesday} wednesday{on Wednesday} thursday{on Thursday} friday{on Friday} saturday{on Saturday} sunday{on Sunday} other{on {weekday}}}'**
  String dateOnWeekday(String weekday);

  /// A day more than a week away, inside a sentence: 'Aligner 5 on 4 Nov'. {date} is already formatted.
  ///
  /// In en, this message translates to:
  /// **'on {date}'**
  String dateOnDate(Object date);

  /// No description provided for @browserBadLink.
  ///
  /// In en, this message translates to:
  /// **'This link doesn\'t work.'**
  String get browserBadLink;

  /// No description provided for @browserCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open the link.'**
  String get browserCouldNotOpen;

  /// {target} is a phone number or email address.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open {target}.'**
  String browserCouldNotOpenContact(Object target);

  /// No description provided for @apiErrorSlow.
  ///
  /// In en, this message translates to:
  /// **'The connection is slow. Please try again in a moment.'**
  String get apiErrorSlow;

  /// No description provided for @apiErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reach myShine. Check your internet connection.'**
  String get apiErrorOffline;

  /// No description provided for @apiErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Please connect with your clinic again.'**
  String get apiErrorUnauthorized;

  /// No description provided for @apiErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t available for your account.'**
  String get apiErrorForbidden;

  /// No description provided for @apiErrorTooManyTries.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Please wait a few minutes and try again.'**
  String get apiErrorTooManyTries;

  /// No description provided for @apiErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again later.'**
  String get apiErrorServer;

  /// No description provided for @apiErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get apiErrorUnknown;

  /// Small badge next to the myShine logo.
  ///
  /// In en, this message translates to:
  /// **'by SmileLabs'**
  String get welcomeBySmileLabs;

  /// No description provided for @welcomeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Shine clear aligners'**
  String get welcomeEyebrow;

  /// First half of the headline 'Your smile, revealed.'
  ///
  /// In en, this message translates to:
  /// **'Your treatment,'**
  String get welcomeTitle;

  /// Second half of the headline 'Your smile, revealed.', shown in grey.
  ///
  /// In en, this message translates to:
  /// **'with your clinic.'**
  String get welcomeTitleMuted;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your aligner of the day, every change date, your plan and messages with your clinic. In one place.'**
  String get welcomeBody;

  /// First half of the headline 'Your clinic has a key for you.'
  ///
  /// In en, this message translates to:
  /// **'Your clinic'**
  String get connectTitle;

  /// No description provided for @connectTitleMuted.
  ///
  /// In en, this message translates to:
  /// **'has a key for you.'**
  String get connectTitleMuted;

  /// No description provided for @connectBody.
  ///
  /// In en, this message translates to:
  /// **'Type the 8-character code from your clinic. Your plan, aligners and messages open right away.'**
  String get connectBody;

  /// Follows the myShine logo on the code card: 'myShine pass'.
  ///
  /// In en, this message translates to:
  /// **'pass'**
  String get connectPass;

  /// No description provided for @connectWorksOnce.
  ///
  /// In en, this message translates to:
  /// **'Works once'**
  String get connectWorksOnce;

  /// No description provided for @connectValidDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Valid 1 day} other{Valid {days} days}}'**
  String connectValidDays(num days);

  /// No description provided for @connectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectButton;

  /// No description provided for @connectFooter.
  ///
  /// In en, this message translates to:
  /// **'Private between you and your clinic. No password. No code? Ask your clinic for one.'**
  String get connectFooter;

  /// No description provided for @connectCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type the code from your clinic.'**
  String get connectCodeEmpty;

  /// No description provided for @connectCodeConfusing.
  ///
  /// In en, this message translates to:
  /// **'Codes don\'t use 0, O, 1, I or L. Check the letter \"{letter}\".'**
  String connectCodeConfusing(Object letter);

  /// No description provided for @connectCodeLength.
  ///
  /// In en, this message translates to:
  /// **'{length, plural, =1{The code has 1 character.} other{The code has {length} characters.}}'**
  String connectCodeLength(num length);

  /// No description provided for @homeLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load myShine'**
  String get homeLoadError;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// No description provided for @tabSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get tabSchedule;

  /// No description provided for @tabMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get tabMessages;

  /// Tab label with the number of unread messages.
  ///
  /// In en, this message translates to:
  /// **'Messages ({count})'**
  String tabMessagesUnread(Object count);

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @todayHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String todayHello(Object name);

  /// No description provided for @todayNotStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your clinic starts your treatment'**
  String get todayNotStartedTitle;

  /// No description provided for @todayNotStartedBody.
  ///
  /// In en, this message translates to:
  /// **'You get your first aligners there. Your schedule shows here then.'**
  String get todayNotStartedBody;

  /// No description provided for @todayAllDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment finished'**
  String get todayAllDoneTitle;

  /// No description provided for @todayAllDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Your clinic tells you what comes next.'**
  String get todayAllDoneBody;

  /// No description provided for @todayAllDoneBodyWithDate.
  ///
  /// In en, this message translates to:
  /// **'Your last aligner ended on {date}. Your clinic will tell you what comes next.'**
  String todayAllDoneBodyWithDate(Object date);

  /// No description provided for @todayWearHint.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{Wear your aligners about 1 hour a day. Take them out only to eat and brush.} other{Wear your aligners about {hours} hours a day. Take them out only to eat and brush.}}'**
  String todayWearHint(num hours);

  /// Small caption over the aligner number: the aligner series and the day of this aligner.
  ///
  /// In en, this message translates to:
  /// **'Series {series} · day {day} of {days}'**
  String todaySeriesDay(int series, int day, int days);

  /// No description provided for @todayDay.
  ///
  /// In en, this message translates to:
  /// **'day {day} of {days}'**
  String todayDay(int day, int days);

  /// Screen reader label for the big 'Aligner 04/22'.
  ///
  /// In en, this message translates to:
  /// **'Aligner {aligner} of {total}'**
  String todayAlignerOf(int aligner, int total);

  /// Button: confirm you switched to the next aligner (the check-in).
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get todayCheckIn;

  /// No description provided for @todayLastOne.
  ///
  /// In en, this message translates to:
  /// **'Last one {date}'**
  String todayLastOne(String date);

  /// No description provided for @todayNextAligner.
  ///
  /// In en, this message translates to:
  /// **'Next aligner'**
  String get todayNextAligner;

  /// No description provided for @todayThisAligner.
  ///
  /// In en, this message translates to:
  /// **'This aligner'**
  String get todayThisAligner;

  /// Unit after a big number: '4 days left'. The number itself is shown separately.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day left} other{days left}}'**
  String todayDaysLeft(num count);

  /// Label over the treatment progress in percent.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get todayTreatment;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get planTitle;

  /// No description provided for @planIn3d.
  ///
  /// In en, this message translates to:
  /// **'In 3D'**
  String get planIn3d;

  /// No description provided for @planSeriesIn3d.
  ///
  /// In en, this message translates to:
  /// **'Series {series} · in 3D'**
  String planSeriesIn3d(Object series);

  /// No description provided for @planCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan in 3D'**
  String get planCardTitle;

  /// No description provided for @planCardBody.
  ///
  /// In en, this message translates to:
  /// **'Your doctor shared it with you. It shows how your teeth move, aligner by aligner. Questions? Write in Messages.'**
  String get planCardBody;

  /// No description provided for @planOpen.
  ///
  /// In en, this message translates to:
  /// **'Open your plan'**
  String get planOpen;

  /// No description provided for @planNotSharedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your doctor shares your plan when it\'s ready'**
  String get planNotSharedTitle;

  /// No description provided for @planNotSharedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see it here in 3D.'**
  String get planNotSharedBody;

  /// No description provided for @scheduleEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No schedule yet'**
  String get scheduleEmptyTitle;

  /// No description provided for @scheduleEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your aligner schedule shows here once your treatment starts.'**
  String get scheduleEmptyBody;

  /// No description provided for @scheduleAligners.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 aligner} other{{count} aligners}}'**
  String scheduleAligners(num count);

  /// {aligners} is the text of scheduleAligners, e.g. 'Series 1 · 22 aligners'.
  ///
  /// In en, this message translates to:
  /// **'Series {series} · {aligners}'**
  String scheduleSeries(int series, String aligners);

  /// No description provided for @scheduleLastEnds.
  ///
  /// In en, this message translates to:
  /// **'Your last aligner ends on {date}.'**
  String scheduleLastEnds(Object date);

  /// No description provided for @scheduleStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get scheduleStarted;

  /// Label over the percentage of aligners finished.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get scheduleDone;

  /// No description provided for @scheduleDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String scheduleDays(num count);

  /// Marks the aligner worn now in the schedule list.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get scheduleNow;

  /// The patient confirmed switching to this aligner (date unknown).
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get scheduleCheckedIn;

  /// The patient confirmed switching to this aligner on {date}. Followed by ' · on time' or ' · 2 days late'.
  ///
  /// In en, this message translates to:
  /// **'Checked in {date}'**
  String scheduleCheckedInOn(Object date);

  /// No description provided for @scheduleOnTime.
  ///
  /// In en, this message translates to:
  /// **'on time'**
  String get scheduleOnTime;

  /// No description provided for @checkInFitSeated.
  ///
  /// In en, this message translates to:
  /// **'Fits well'**
  String get checkInFitSeated;

  /// No description provided for @checkInFitLoose.
  ///
  /// In en, this message translates to:
  /// **'Not fully seated'**
  String get checkInFitLoose;

  /// No description provided for @checkInFitTight.
  ///
  /// In en, this message translates to:
  /// **'Very tight'**
  String get checkInFitTight;

  /// No description provided for @checkInFitDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged or lost'**
  String get checkInFitDamaged;

  /// Discomfort: none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get checkInComfortNone;

  /// No description provided for @checkInComfortMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get checkInComfortMild;

  /// No description provided for @checkInComfortStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get checkInComfortStrong;

  /// No description provided for @checkInConfirmError.
  ///
  /// In en, this message translates to:
  /// **'Confirm that you have put in aligner {aligner}.'**
  String checkInConfirmError(Object aligner);

  /// No description provided for @checkInChooseFitError.
  ///
  /// In en, this message translates to:
  /// **'Choose how aligner {aligner} fits.'**
  String checkInChooseFitError(Object aligner);

  /// Camera screen title; {view} is one of intraoralFront, intraoralRight, ... e.g. 'Front photo'.
  ///
  /// In en, this message translates to:
  /// **'{view} photo'**
  String checkInPhotoTitle(Object view);

  /// No description provided for @intraoralFront.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get intraoralFront;

  /// No description provided for @intraoralRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get intraoralRight;

  /// No description provided for @intraoralLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get intraoralLeft;

  /// No description provided for @intraoralUpper.
  ///
  /// In en, this message translates to:
  /// **'Upper'**
  String get intraoralUpper;

  /// No description provided for @intraoralLower.
  ///
  /// In en, this message translates to:
  /// **'Lower'**
  String get intraoralLower;

  /// No description provided for @intraoralFrontHint.
  ///
  /// In en, this message translates to:
  /// **'Bite together and smile wide, so all front teeth show.'**
  String get intraoralFrontHint;

  /// No description provided for @intraoralRightHint.
  ///
  /// In en, this message translates to:
  /// **'Bite together, pull your right cheek back and turn a little.'**
  String get intraoralRightHint;

  /// No description provided for @intraoralLeftHint.
  ///
  /// In en, this message translates to:
  /// **'Bite together, pull your left cheek back and turn a little.'**
  String get intraoralLeftHint;

  /// No description provided for @intraoralUpperHint.
  ///
  /// In en, this message translates to:
  /// **'Tilt your head back and open wide to show your upper teeth.'**
  String get intraoralUpperHint;

  /// No description provided for @intraoralLowerHint.
  ///
  /// In en, this message translates to:
  /// **'Tilt your head down and open wide to show your lower teeth.'**
  String get intraoralLowerHint;

  /// Shown right after the patient checked in the switch to aligner {aligner}.
  ///
  /// In en, this message translates to:
  /// **'Aligner {aligner} it is. Thank you!'**
  String checkInThanks(Object aligner);

  /// Caption over the check-in card. Check-in = the patient confirms switching to the next aligner.
  ///
  /// In en, this message translates to:
  /// **'Your check-in'**
  String get checkInEyebrow;

  /// No description provided for @checkInNext.
  ///
  /// In en, this message translates to:
  /// **'Next: aligner {aligner}'**
  String checkInNext(Object aligner);

  /// {when} is dateToday, dateTomorrow, dateOnWeekday or dateOnDate, e.g. 'Aligner 5 on Thursday'.
  ///
  /// In en, this message translates to:
  /// **'Aligner {aligner} {when}'**
  String checkInAlignerWhen(int aligner, String when);

  /// No description provided for @checkInUpcomingBody.
  ///
  /// In en, this message translates to:
  /// **'When you put it in, check in here. Your schedule follows the day you change.'**
  String get checkInUpcomingBody;

  /// No description provided for @checkInEarly.
  ///
  /// In en, this message translates to:
  /// **'I\'ve switched to aligner {aligner} already'**
  String checkInEarly(Object aligner);

  /// No description provided for @checkInClinicSees.
  ///
  /// In en, this message translates to:
  /// **'Your clinic sees your check-in.'**
  String get checkInClinicSees;

  /// No description provided for @checkInDueYesterday.
  ///
  /// In en, this message translates to:
  /// **'Due yesterday. Check in when you\'ve changed.'**
  String get checkInDueYesterday;

  /// No description provided for @checkInDueDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Due 1 day ago. Check in when you\'ve changed.} other{Due {count} days ago. Check in when you\'ve changed.}}'**
  String checkInDueDaysAgo(num count);

  /// {when} is dateToday, dateTomorrow, dateOnWeekday or dateOnDate, e.g. 'Due on Thursday.'
  ///
  /// In en, this message translates to:
  /// **'Due {when}.'**
  String checkInDue(Object when);

  /// No description provided for @checkInSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to aligner {aligner}'**
  String checkInSwitchTitle(Object aligner);

  /// No description provided for @checkInSwitchedLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'ve put in aligner {aligner}'**
  String checkInSwitchedLabel(Object aligner);

  /// No description provided for @checkInFitQuestion.
  ///
  /// In en, this message translates to:
  /// **'How does aligner {aligner} fit?'**
  String checkInFitQuestion(Object aligner);

  /// No description provided for @checkInDiscomfort.
  ///
  /// In en, this message translates to:
  /// **'Discomfort'**
  String get checkInDiscomfort;

  /// No description provided for @checkInNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note for your clinic'**
  String get checkInNoteLabel;

  /// No description provided for @checkInNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Anything you\'d like them to know (optional)'**
  String get checkInNoteHint;

  /// No description provided for @checkInSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get checkInSending;

  /// Button that sends the check-in for the switch to aligner {aligner}.
  ///
  /// In en, this message translates to:
  /// **'Check in aligner {aligner}'**
  String checkInSend(Object aligner);

  /// No description provided for @checkInPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get checkInPhotos;

  /// No description provided for @checkInPhotosAsking.
  ///
  /// In en, this message translates to:
  /// **'Photos of your teeth with the aligner in help your clinic see what\'s wrong.'**
  String get checkInPhotosAsking;

  /// No description provided for @checkInPhotosOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional. Photos of your teeth with the aligner in. Only your clinic sees them.'**
  String get checkInPhotosOptional;

  /// No description provided for @checkInPhotosWebOnly.
  ///
  /// In en, this message translates to:
  /// **'You can add photos of your teeth in the myShine app on your phone.'**
  String get checkInPhotosWebOnly;

  /// Screen reader label; {view} is e.g. 'Front'.
  ///
  /// In en, this message translates to:
  /// **'Take the {view} photo'**
  String checkInTakePhoto(Object view);

  /// No description provided for @photoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoRemove;

  /// Screen reader label; {view} is e.g. 'Front'.
  ///
  /// In en, this message translates to:
  /// **'Remove the {view} photo'**
  String photoRemoveNamed(Object view);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileDisconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect myShine?'**
  String get profileDisconnectTitle;

  /// No description provided for @profileDisconnectBody.
  ///
  /// In en, this message translates to:
  /// **'Your plan, schedule and messages will no longer show on this phone. To connect again, ask your clinic for a new code.'**
  String get profileDisconnectBody;

  /// No description provided for @profileDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get profileDisconnect;

  /// No description provided for @profileYourClinic.
  ///
  /// In en, this message translates to:
  /// **'Your clinic'**
  String get profileYourClinic;

  /// No description provided for @profileYourDentist.
  ///
  /// In en, this message translates to:
  /// **'Your dentist'**
  String get profileYourDentist;

  /// No description provided for @profileCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get profileCall;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileThisPhone.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get profileThisPhone;

  /// No description provided for @profileReminders.
  ///
  /// In en, this message translates to:
  /// **'Aligner reminders'**
  String get profileReminders;

  /// No description provided for @profileRemindersDetail.
  ///
  /// In en, this message translates to:
  /// **'On the day you change'**
  String get profileRemindersDetail;

  /// No description provided for @profileOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get profileOn;

  /// No description provided for @profileOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get profileOff;

  /// No description provided for @profileFooter.
  ///
  /// In en, this message translates to:
  /// **'Shine clear aligners by SmileLabs'**
  String get profileFooter;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @documentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get documentsEmptyTitle;

  /// No description provided for @documentsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'What you sign, and the statements for your aligners, show here.'**
  String get documentsEmptyBody;

  /// No description provided for @documentsFootnote.
  ///
  /// In en, this message translates to:
  /// **'Everything you signed and the statement for each of your devices stays here. Tap one to open, print or save it. Your clinic keeps the same copies.'**
  String get documentsFootnote;

  /// No description provided for @documentsConsent.
  ///
  /// In en, this message translates to:
  /// **'Treatment consent'**
  String get documentsConsent;

  /// {devices} comes from the clinic, e.g. 'Shine aligners'.
  ///
  /// In en, this message translates to:
  /// **'Consent: {devices}'**
  String documentsConsentFor(Object devices);

  /// No description provided for @documentsSigned.
  ///
  /// In en, this message translates to:
  /// **'Signed'**
  String get documentsSigned;

  /// No description provided for @documentsSignedOn.
  ///
  /// In en, this message translates to:
  /// **'Signed on {date}'**
  String documentsSignedOn(Object date);

  /// The consent is signed at the clinic, not in the app.
  ///
  /// In en, this message translates to:
  /// **'Your clinic will ask you to sign it there'**
  String get documentsSignThere;

  /// No description provided for @documentsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your signature'**
  String get documentsWaiting;

  /// No description provided for @documentsSign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get documentsSign;

  /// No description provided for @documentsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get documentsOpen;

  /// No description provided for @messagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTitle;

  /// No description provided for @messagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write to your clinic. They usually answer within a working day.'**
  String get messagesSubtitle;

  /// No description provided for @messagesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Messages didn\'t load'**
  String get messagesLoadError;

  /// No description provided for @messagesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get messagesEmptyTitle;

  /// No description provided for @messagesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Questions about your aligners? Write to your clinic here.'**
  String get messagesEmptyBody;

  /// No description provided for @messagesPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo for your clinic'**
  String get messagesPhotoTitle;

  /// No description provided for @messagesPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo in good light. It\'s sent with your message.'**
  String get messagesPhotoHint;

  /// No description provided for @messagesAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get messagesAddPhoto;

  /// No description provided for @messagesInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message your clinic'**
  String get messagesInputHint;

  /// No description provided for @messagesSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get messagesSend;

  /// No description provided for @messagesOpenPhoto.
  ///
  /// In en, this message translates to:
  /// **'Open photo'**
  String get messagesOpenPhoto;

  /// No description provided for @messagesPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get messagesPhoto;

  /// No description provided for @messagesPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'This photo didn\'t load. Please try again later.'**
  String get messagesPhotoFailed;

  /// No description provided for @cameraSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get cameraSwitch;

  /// No description provided for @cameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access for myShine in Settings to add a photo.'**
  String get cameraDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable here'**
  String get cameraUnavailable;

  /// No description provided for @cameraTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get cameraTakePhoto;

  /// Phone notification title on the morning of an aligner change.
  ///
  /// In en, this message translates to:
  /// **'Time for aligner {aligner}'**
  String reminderChangeTitle(Object aligner);

  /// No description provided for @reminderChangeBody.
  ///
  /// In en, this message translates to:
  /// **'Put in aligner {aligner} today.'**
  String reminderChangeBody(Object aligner);

  /// No description provided for @reminderCheckInBody.
  ///
  /// In en, this message translates to:
  /// **'Put in aligner {aligner} today, then check in in myShine.'**
  String reminderCheckInBody(Object aligner);

  /// Phone notification two days after the change day, when the patient hasn't checked in.
  ///
  /// In en, this message translates to:
  /// **'Did you switch to aligner {aligner}?'**
  String reminderLateTitle(Object aligner);

  /// No description provided for @reminderLateBody.
  ///
  /// In en, this message translates to:
  /// **'Check in when you have, so your schedule stays right.'**
  String get reminderLateBody;

  /// No description provided for @welcomeHaveCode.
  ///
  /// In en, this message translates to:
  /// **'I have a code'**
  String get welcomeHaveCode;

  /// No description provided for @welcomeWhatIs.
  ///
  /// In en, this message translates to:
  /// **'What is myShine?'**
  String get welcomeWhatIs;

  /// No description provided for @welcomeNoCode.
  ///
  /// In en, this message translates to:
  /// **'No code yet? Ask your Shine clinic.'**
  String get welcomeNoCode;

  /// No description provided for @welcomePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'A smile with a clear Shine aligner'**
  String get welcomePhotoLabel;

  /// No description provided for @commonPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get commonPrivacy;

  /// No description provided for @commonHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get commonHelp;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'What myShine is for'**
  String get aboutTitle;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'myShine is your companion during Shine aligner treatment. Your clinic gives it to you.'**
  String get aboutIntro;

  /// No description provided for @aboutToday.
  ///
  /// In en, this message translates to:
  /// **'Which aligner you wear and when to change.'**
  String get aboutToday;

  /// No description provided for @aboutCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get aboutCheckInTitle;

  /// No description provided for @aboutCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Tell your doctor you changed: the fit, a note, photos if you like. When your doctor uses check-ins.'**
  String get aboutCheckIn;

  /// No description provided for @aboutPlan.
  ///
  /// In en, this message translates to:
  /// **'Your plan in 3D, when your doctor shares it.'**
  String get aboutPlan;

  /// No description provided for @aboutSchedule.
  ///
  /// In en, this message translates to:
  /// **'Every change date.'**
  String get aboutSchedule;

  /// No description provided for @aboutMessages.
  ///
  /// In en, this message translates to:
  /// **'Ask your clinic something, or send a photo.'**
  String get aboutMessages;

  /// No description provided for @aboutDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get aboutDocumentsTitle;

  /// No description provided for @aboutDocuments.
  ///
  /// In en, this message translates to:
  /// **'Sign and keep your papers.'**
  String get aboutDocuments;

  /// No description provided for @aboutClinic.
  ///
  /// In en, this message translates to:
  /// **'Your doctor, phone and email.'**
  String get aboutClinic;

  /// No description provided for @aboutNot.
  ///
  /// In en, this message translates to:
  /// **'myShine doesn\'t diagnose and never changes your treatment. Your doctor decides every step. For pain or a broken aligner, call your clinic.'**
  String get aboutNot;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About myShine'**
  String get profileAbout;

  /// No description provided for @profileAboutDetail.
  ///
  /// In en, this message translates to:
  /// **'What it\'s for, help and privacy'**
  String get profileAboutDetail;

  /// {when} is dateToday, dateTomorrow, dateOnWeekday or dateOnDate, e.g. 'Change to aligner 5 on Saturday'.
  ///
  /// In en, this message translates to:
  /// **'Change to aligner {aligner} {when}'**
  String todayChangeTo(int aligner, String when);

  /// {late} is commonDaysLate, e.g. '2 days late'.
  ///
  /// In en, this message translates to:
  /// **'Change to aligner {aligner} · {late}'**
  String todayChangeLate(int aligner, String late);

  /// No description provided for @todayLastAlignerNow.
  ///
  /// In en, this message translates to:
  /// **'This is your last aligner'**
  String get todayLastAlignerNow;

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} aligners done'**
  String todayProgress(int done, int total);

  /// No description provided for @todayDaysLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Days left on this aligner'**
  String get todayDaysLeftLabel;

  /// No description provided for @todayStarted.
  ///
  /// In en, this message translates to:
  /// **'Treatment started'**
  String get todayStarted;

  /// No description provided for @todayLastCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Your last check-in'**
  String get todayLastCheckIn;

  /// No description provided for @todayCheckInOnTime.
  ///
  /// In en, this message translates to:
  /// **'on time'**
  String get todayCheckInOnTime;

  /// No description provided for @todayCheckInPhotos.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String todayCheckInPhotos(int count);

  /// No description provided for @planCardSeries.
  ///
  /// In en, this message translates to:
  /// **'Series {series}'**
  String planCardSeries(int series);

  /// No description provided for @todayOfAligners.
  ///
  /// In en, this message translates to:
  /// **'of {total} aligners'**
  String todayOfAligners(int total);

  /// No description provided for @todayDoneCount.
  ///
  /// In en, this message translates to:
  /// **'{count} done'**
  String todayDoneCount(int count);

  /// No description provided for @todayCheckInAligner.
  ///
  /// In en, this message translates to:
  /// **'Check in aligner {aligner}'**
  String todayCheckInAligner(int aligner);

  /// No description provided for @todayDaysLeftUnit.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get todayDaysLeftUnit;

  /// No description provided for @todayWear.
  ///
  /// In en, this message translates to:
  /// **'Wear'**
  String get todayWear;

  /// No description provided for @todayHoursUnit.
  ///
  /// In en, this message translates to:
  /// **'h a day'**
  String get todayHoursUnit;

  /// No description provided for @todayLastCheckInOn.
  ///
  /// In en, this message translates to:
  /// **'Last check-in · {date}'**
  String todayLastCheckInOn(String date);

  /// No description provided for @todayOpenSchedule.
  ///
  /// In en, this message translates to:
  /// **'See the schedule'**
  String get todayOpenSchedule;

  /// No description provided for @scheduleEndsOn.
  ///
  /// In en, this message translates to:
  /// **'ends {date}'**
  String scheduleEndsOn(String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'sl', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'sr':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return AppLocalizationsSrLatn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'sl':
      return AppLocalizationsSl();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
