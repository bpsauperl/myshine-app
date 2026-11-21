// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get commonTryAgain => 'Erneut versuchen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDidNotWork =>
      'Das hat nicht geklappt. Bitte versuch es noch einmal.';

  @override
  String commonAlignerNumber(Object number) {
    return 'Aligner $number';
  }

  @override
  String get commonLastAligner => 'Letzter Aligner';

  @override
  String commonDaysLate(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage zu spät',
      one: '1 Tag zu spät',
    );
    return '$_temp0';
  }

  @override
  String get dateToday => 'heute';

  @override
  String get dateTomorrow => 'morgen';

  @override
  String dateOnWeekday(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'am Montag',
      'tuesday': 'am Dienstag',
      'wednesday': 'am Mittwoch',
      'thursday': 'am Donnerstag',
      'friday': 'am Freitag',
      'saturday': 'am Samstag',
      'sunday': 'am Sonntag',
      'other': 'am $weekday',
    });
    return '$_temp0';
  }

  @override
  String dateOnDate(Object date) {
    return 'am $date';
  }

  @override
  String get browserBadLink => 'Dieser Link funktioniert nicht.';

  @override
  String get browserCouldNotOpen => 'Der Link konnte nicht geöffnet werden.';

  @override
  String browserCouldNotOpenContact(Object target) {
    return '$target konnte nicht geöffnet werden.';
  }

  @override
  String get apiErrorSlow =>
      'Die Verbindung ist langsam. Bitte versuch es gleich noch einmal.';

  @override
  String get apiErrorOffline =>
      'myShine ist nicht erreichbar. Prüfe deine Internetverbindung.';

  @override
  String get apiErrorUnauthorized =>
      'Bitte verbinde dich erneut mit deiner Praxis.';

  @override
  String get apiErrorForbidden => 'Das ist für dein Konto nicht verfügbar.';

  @override
  String get apiErrorTooManyTries =>
      'Zu viele Versuche. Bitte warte ein paar Minuten und versuch es dann noch einmal.';

  @override
  String get apiErrorServer =>
      'Bei uns ist etwas schiefgelaufen. Bitte versuch es später noch einmal.';

  @override
  String get apiErrorUnknown =>
      'Etwas ist schiefgelaufen. Bitte versuch es noch einmal.';

  @override
  String get welcomeBySmileLabs => 'von SmileLabs';

  @override
  String get welcomeEyebrow => 'Transparente Shine Aligner';

  @override
  String get welcomeTitle => 'Deine Behandlung,';

  @override
  String get welcomeTitleMuted => 'mit deiner Praxis.';

  @override
  String get welcomeBody =>
      'Dein Aligner von heute, jeder Wechseltermin, dein Plan und Nachrichten mit deiner Praxis. An einem Ort.';

  @override
  String get connectTitle => 'Deine Praxis';

  @override
  String get connectTitleMuted => 'hat einen Schlüssel für dich.';

  @override
  String get connectBody =>
      'Gib den 8-stelligen Code deiner Praxis ein. Dein Plan, deine Aligner und Nachrichten öffnen sich sofort.';

  @override
  String get connectPass => 'Pass';

  @override
  String get connectWorksOnce => 'Einmal gültig';

  @override
  String connectValidDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage gültig',
      one: '1 Tag gültig',
    );
    return '$_temp0';
  }

  @override
  String get connectButton => 'Verbinden';

  @override
  String get connectFooter =>
      'Privat zwischen dir und deiner Praxis. Kein Passwort. Kein Code? Frag deine Praxis danach.';

  @override
  String get connectCodeEmpty => 'Gib den Code deiner Praxis ein.';

  @override
  String connectCodeConfusing(Object letter) {
    return 'Codes enthalten kein 0, O, 1, I oder L. Prüfe das Zeichen „$letter“.';
  }

  @override
  String connectCodeLength(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Der Code hat $length Zeichen.',
      one: 'Der Code hat 1 Zeichen.',
    );
    return '$_temp0';
  }

  @override
  String get homeLoadError => 'myShine konnte nicht geladen werden';

  @override
  String get tabToday => 'Heute';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabSchedule => 'Zeitplan';

  @override
  String get tabMessages => 'Nachrichten';

  @override
  String tabMessagesUnread(Object count) {
    return 'Nachrichten ($count)';
  }

  @override
  String get tabProfile => 'Profil';

  @override
  String todayHello(Object name) {
    return 'Hallo, $name';
  }

  @override
  String get todayNotStartedTitle => 'Deine Praxis beginnt deine Behandlung';

  @override
  String get todayNotStartedBody =>
      'Dort bekommst du deine ersten Aligner. Dann siehst du hier deinen Zeitplan.';

  @override
  String get todayAllDoneTitle => 'Behandlung abgeschlossen';

  @override
  String get todayAllDoneBody => 'Deine Praxis sagt dir, wie es weitergeht.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Dein letzter Aligner endete am $date. Deine Praxis sagt dir, wie es weitergeht.';
  }

  @override
  String todayWearHint(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other:
          'Trag deine Aligner etwa $hours Stunden am Tag. Nimm sie nur zum Essen und Zähneputzen heraus.',
      one: 'Trag deine Aligner etwa 1 Stunde am Tag. Nimm sie nur zum Essen und Zähneputzen heraus.',
    );
    return '$_temp0';
  }

  @override
  String todaySeriesDay(int series, int day, int days) {
    return 'Serie $series · Tag $day von $days';
  }

  @override
  String todayDay(int day, int days) {
    return 'Tag $day von $days';
  }

  @override
  String todayAlignerOf(int aligner, int total) {
    return 'Aligner $aligner von $total';
  }

  @override
  String get todayCheckIn => 'Wechsel bestätigen';

  @override
  String todayLastOne(String date) {
    return 'Letzter am $date';
  }

  @override
  String get todayNextAligner => 'Nächster Aligner';

  @override
  String get todayThisAligner => 'Dieser Aligner';

  @override
  String todayDaysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage übrig',
      one: 'Tag übrig',
    );
    return '$_temp0';
  }

  @override
  String get todayTreatment => 'Behandlung';

  @override
  String get planTitle => 'Dein Plan';

  @override
  String get planIn3d => 'In 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serie $series · in 3D';
  }

  @override
  String get planCardTitle => 'Dein Plan in 3D';

  @override
  String get planCardBody =>
      'Dein Arzt hat ihn mit dir geteilt. Er zeigt, wie sich deine Zähne bewegen, Aligner für Aligner. Fragen? Schreib in Nachrichten.';

  @override
  String get planOpen => 'Plan öffnen';

  @override
  String get planNotSharedTitle =>
      'Dein Arzt teilt deinen Plan, sobald er fertig ist';

  @override
  String get planNotSharedBody => 'Du siehst ihn dann hier in 3D.';

  @override
  String get scheduleEmptyTitle => 'Noch kein Zeitplan';

  @override
  String get scheduleEmptyBody =>
      'Dein Aligner-Zeitplan erscheint hier, sobald deine Behandlung beginnt.';

  @override
  String scheduleAligners(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aligner',
      one: '1 Aligner',
    );
    return '$_temp0';
  }

  @override
  String scheduleSeries(int series, String aligners) {
    return 'Serie $series · $aligners';
  }

  @override
  String scheduleLastEnds(Object date) {
    return 'Dein letzter Aligner endet am $date.';
  }

  @override
  String get scheduleStarted => 'Begonnen';

  @override
  String get scheduleDone => 'Geschafft';

  @override
  String scheduleDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get scheduleNow => 'Heute';

  @override
  String get scheduleCheckedIn => 'Wechsel bestätigt';

  @override
  String scheduleCheckedInOn(Object date) {
    return 'Wechsel bestätigt am $date';
  }

  @override
  String get scheduleOnTime => 'pünktlich';

  @override
  String get checkInFitSeated => 'Sitzt gut';

  @override
  String get checkInFitLoose => 'Sitzt nicht ganz';

  @override
  String get checkInFitTight => 'Sehr eng';

  @override
  String get checkInFitDamaged => 'Beschädigt oder verloren';

  @override
  String get checkInComfortNone => 'Keine';

  @override
  String get checkInComfortMild => 'Leicht';

  @override
  String get checkInComfortStrong => 'Stark';

  @override
  String checkInConfirmError(Object aligner) {
    return 'Bestätige, dass du Aligner $aligner eingesetzt hast.';
  }

  @override
  String checkInChooseFitError(Object aligner) {
    return 'Wähle, wie Aligner $aligner sitzt.';
  }

  @override
  String checkInPhotoTitle(Object view) {
    return 'Foto: $view';
  }

  @override
  String get intraoralFront => 'Vorne';

  @override
  String get intraoralRight => 'Rechts';

  @override
  String get intraoralLeft => 'Links';

  @override
  String get intraoralUpper => 'Oben';

  @override
  String get intraoralLower => 'Unten';

  @override
  String get intraoralFrontHint =>
      'Beiß zusammen und lächle breit, sodass alle Frontzähne zu sehen sind.';

  @override
  String get intraoralRightHint =>
      'Beiß zusammen, zieh die rechte Wange zurück und dreh dich etwas.';

  @override
  String get intraoralLeftHint =>
      'Beiß zusammen, zieh die linke Wange zurück und dreh dich etwas.';

  @override
  String get intraoralUpperHint =>
      'Neig den Kopf nach hinten und öffne den Mund weit, damit die oberen Zähne zu sehen sind.';

  @override
  String get intraoralLowerHint =>
      'Neig den Kopf nach vorne und öffne den Mund weit, damit die unteren Zähne zu sehen sind.';

  @override
  String checkInThanks(Object aligner) {
    return 'Aligner $aligner ist drin. Danke!';
  }

  @override
  String get checkInEyebrow => 'Dein Wechsel';

  @override
  String checkInNext(Object aligner) {
    return 'Als Nächstes: Aligner $aligner';
  }

  @override
  String checkInAlignerWhen(int aligner, String when) {
    return 'Aligner $aligner $when';
  }

  @override
  String get checkInUpcomingBody =>
      'Wenn du ihn eingesetzt hast, bestätige den Wechsel hier. Dein Zeitplan richtet sich nach dem Tag des Wechsels.';

  @override
  String checkInEarly(Object aligner) {
    return 'Ich trage Aligner $aligner schon';
  }

  @override
  String get checkInClinicSees => 'Deine Praxis sieht deine Bestätigung.';

  @override
  String get checkInDueYesterday =>
      'Seit gestern fällig. Bestätige den Wechsel, sobald du gewechselt hast.';

  @override
  String checkInDueDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Seit $count Tagen fällig. Bestätige den Wechsel, sobald du gewechselt hast.',
      one: 'Seit 1 Tag fällig. Bestätige den Wechsel, sobald du gewechselt hast.',
    );
    return '$_temp0';
  }

  @override
  String checkInDue(Object when) {
    return 'Fällig $when.';
  }

  @override
  String checkInSwitchTitle(Object aligner) {
    return 'Wechsel zu Aligner $aligner';
  }

  @override
  String checkInSwitchedLabel(Object aligner) {
    return 'Ich habe Aligner $aligner eingesetzt';
  }

  @override
  String checkInFitQuestion(Object aligner) {
    return 'Wie sitzt Aligner $aligner?';
  }

  @override
  String get checkInDiscomfort => 'Beschwerden';

  @override
  String get checkInNoteLabel => 'Notiz für deine Praxis';

  @override
  String get checkInNoteHint => 'Was deine Praxis wissen sollte (optional)';

  @override
  String get checkInSending => 'Wird gesendet …';

  @override
  String checkInSend(Object aligner) {
    return 'Wechsel zu Aligner $aligner bestätigen';
  }

  @override
  String get checkInPhotos => 'Fotos';

  @override
  String get checkInPhotosAsking =>
      'Fotos deiner Zähne mit eingesetztem Aligner helfen deiner Praxis zu sehen, was nicht stimmt.';

  @override
  String get checkInPhotosOptional =>
      'Optional. Fotos deiner Zähne mit eingesetztem Aligner. Nur deine Praxis sieht sie.';

  @override
  String get checkInPhotosWebOnly =>
      'Fotos deiner Zähne kannst du in der myShine App auf deinem Handy hinzufügen.';

  @override
  String checkInTakePhoto(Object view) {
    return 'Foto aufnehmen: $view';
  }

  @override
  String get photoRemove => 'Foto entfernen';

  @override
  String photoRemoveNamed(Object view) {
    return 'Foto entfernen: $view';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisconnectTitle => 'myShine trennen?';

  @override
  String get profileDisconnectBody =>
      'Dein Plan, dein Zeitplan und deine Nachrichten werden auf diesem Handy nicht mehr angezeigt. Um dich wieder zu verbinden, frag deine Praxis nach einem neuen Code.';

  @override
  String get profileDisconnect => 'Trennen';

  @override
  String get profileYourClinic => 'Deine Praxis';

  @override
  String get profileYourDentist => 'Zahnarzt/Zahnärztin';

  @override
  String get profileCall => 'Anrufen';

  @override
  String get profileEmail => 'E-Mail';

  @override
  String get profileThisPhone => 'Dieses Handy';

  @override
  String get profileReminders => 'Aligner-Erinnerungen';

  @override
  String get profileRemindersDetail => 'Am Tag des Wechsels';

  @override
  String get profileOn => 'An';

  @override
  String get profileOff => 'Aus';

  @override
  String get profileFooter => 'Transparente Shine Aligner von SmileLabs';

  @override
  String get documentsTitle => 'Dokumente';

  @override
  String get documentsEmptyTitle => 'Hier ist noch nichts';

  @override
  String get documentsEmptyBody =>
      'Was du unterschreibst und die Erklärungen zu deinen Alignern erscheinen hier.';

  @override
  String get documentsFootnote =>
      'Alles, was du unterschrieben hast, und die Erklärung zu jedem deiner Produkte bleibt hier. Tippe darauf, um es zu öffnen, zu drucken oder zu speichern. Deine Praxis bewahrt dieselben Exemplare auf.';

  @override
  String get documentsConsent => 'Einwilligung zur Behandlung';

  @override
  String documentsConsentFor(Object devices) {
    return 'Einwilligung: $devices';
  }

  @override
  String get documentsSigned => 'Unterschrieben';

  @override
  String documentsSignedOn(Object date) {
    return 'Unterschrieben am $date';
  }

  @override
  String get documentsSignThere =>
      'Deine Praxis bittet dich, es dort zu unterschreiben';

  @override
  String get documentsWaiting => 'Wartet auf deine Unterschrift';

  @override
  String get documentsSign => 'Unterschreiben';

  @override
  String get documentsOpen => 'Öffnen';

  @override
  String get messagesTitle => 'Nachrichten';

  @override
  String get messagesSubtitle =>
      'Schreib deiner Praxis. Sie antwortet meist innerhalb eines Werktags.';

  @override
  String get messagesLoadError => 'Nachrichten konnten nicht geladen werden';

  @override
  String get messagesEmptyTitle => 'Noch keine Nachrichten';

  @override
  String get messagesEmptyBody =>
      'Fragen zu deinen Alignern? Schreib deiner Praxis hier.';

  @override
  String get messagesPhotoTitle => 'Foto für deine Praxis';

  @override
  String get messagesPhotoHint =>
      'Mach ein scharfes Foto bei gutem Licht. Es wird mit deiner Nachricht gesendet.';

  @override
  String get messagesAddPhoto => 'Foto hinzufügen';

  @override
  String get messagesInputHint => 'Nachricht an deine Praxis';

  @override
  String get messagesSend => 'Senden';

  @override
  String get messagesOpenPhoto => 'Foto öffnen';

  @override
  String get messagesPhoto => 'Foto';

  @override
  String get messagesPhotoFailed =>
      'Dieses Foto konnte nicht geladen werden. Bitte versuch es später noch einmal.';

  @override
  String get cameraSwitch => 'Kamera wechseln';

  @override
  String get cameraDenied =>
      'Erlaube myShine in den Einstellungen den Kamerazugriff, um ein Foto hinzuzufügen.';

  @override
  String get cameraUnavailable => 'Kamera hier nicht verfügbar';

  @override
  String get cameraTakePhoto => 'Foto aufnehmen';

  @override
  String reminderChangeTitle(Object aligner) {
    return 'Zeit für Aligner $aligner';
  }

  @override
  String reminderChangeBody(Object aligner) {
    return 'Setz heute Aligner $aligner ein.';
  }

  @override
  String reminderCheckInBody(Object aligner) {
    return 'Setz heute Aligner $aligner ein und bestätige dann den Wechsel in myShine.';
  }

  @override
  String reminderLateTitle(Object aligner) {
    return 'Hast du zu Aligner $aligner gewechselt?';
  }

  @override
  String get reminderLateBody =>
      'Bestätige den Wechsel, damit dein Zeitplan stimmt.';

  @override
  String get welcomeHaveCode => 'Ich habe einen Code';

  @override
  String get welcomeWhatIs => 'Was ist myShine?';

  @override
  String get welcomeNoCode => 'Noch keinen Code? Frag deine Shine-Praxis.';

  @override
  String get welcomePhotoLabel =>
      'Ein Lächeln mit einem durchsichtigen Shine-Aligner';

  @override
  String get commonPrivacy => 'Datenschutz';

  @override
  String get commonHelp => 'Hilfe';

  @override
  String get aboutTitle => 'Wofür myShine da ist';

  @override
  String get aboutIntro =>
      'myShine begleitet dich während deiner Behandlung mit Shine-Alignern. Den Zugang gibt dir deine Praxis.';

  @override
  String get aboutToday => 'Welchen Aligner du trägst und wann du wechselst.';

  @override
  String get aboutCheckInTitle => 'Check-in';

  @override
  String get aboutCheckIn =>
      'Sag deinem Arzt, dass du gewechselt hast: wie er sitzt, eine Notiz, Fotos wenn du möchtest. Wenn dein Arzt Check-ins nutzt.';

  @override
  String get aboutPlan => 'Dein Plan in 3D, sobald dein Arzt ihn teilt.';

  @override
  String get aboutSchedule => 'Jeder Wechseltermin.';

  @override
  String get aboutMessages => 'Frag deine Praxis oder schick ein Foto.';

  @override
  String get aboutDocumentsTitle => 'Dokumente';

  @override
  String get aboutDocuments => 'Unterschreib und bewahre deine Unterlagen auf.';

  @override
  String get aboutClinic => 'Dein Arzt, Telefon und E-Mail.';

  @override
  String get aboutNot =>
      'myShine stellt keine Diagnosen und ändert nie deine Behandlung. Jeden Schritt entscheidet dein Arzt. Bei Schmerzen oder einem gebrochenen Aligner ruf deine Praxis an.';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get profileAbout => 'Über myShine';

  @override
  String get profileAboutDetail => 'Wofür, Hilfe und Datenschutz';

  @override
  String todayChangeTo(int aligner, String when) {
    return 'Wechsel zu Aligner $aligner $when';
  }

  @override
  String todayChangeLate(int aligner, String late) {
    return 'Wechsel zu Aligner $aligner · $late';
  }

  @override
  String get todayLastAlignerNow => 'Das ist dein letzter Aligner';

  @override
  String todayProgress(int done, int total) {
    return '$done von $total Alignern geschafft';
  }

  @override
  String get todayDaysLeftLabel => 'Tage mit diesem Aligner';

  @override
  String get todayStarted => 'Behandlung begonnen';

  @override
  String get todayLastCheckIn => 'Dein letzter Check-in';

  @override
  String get todayCheckInOnTime => 'pünktlich';

  @override
  String todayCheckInPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos',
      one: '1 Foto',
    );
    return '$_temp0';
  }

  @override
  String planCardSeries(int series) {
    return 'Serie $series';
  }

  @override
  String todayOfAligners(int total) {
    return 'von $total Alignern';
  }

  @override
  String todayDoneCount(int count) {
    return '$count erledigt';
  }

  @override
  String todayCheckInAligner(int aligner) {
    return 'Aligner $aligner bestätigen';
  }

  @override
  String get todayDaysLeftUnit => 'Tage übrig';

  @override
  String get todayWear => 'Tragen';

  @override
  String get todayHoursUnit => 'Std. am Tag';

  @override
  String todayLastCheckInOn(String date) {
    return 'Letzter Check-in · $date';
  }

  @override
  String get todayOpenSchedule => 'Zeitplan ansehen';

  @override
  String scheduleEndsOn(String date) {
    return 'endet am $date';
  }
}
