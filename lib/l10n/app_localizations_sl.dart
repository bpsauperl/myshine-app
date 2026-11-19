// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get commonTryAgain => 'Poskusi znova';

  @override
  String get commonBack => 'Nazaj';

  @override
  String get commonCancel => 'Prekliči';

  @override
  String get commonDidNotWork => 'Ni uspelo. Poskusi znova.';

  @override
  String commonAlignerNumber(Object number) {
    return 'Alajner $number';
  }

  @override
  String get commonLastAligner => 'Zadnji alajner';

  @override
  String commonDaysLate(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni zamude',
      few: '$count dnevi zamude',
      two: '$count dneva zamude',
      one: '$count dan zamude',
    );
    return '$_temp0';
  }

  @override
  String get dateToday => 'danes';

  @override
  String get dateTomorrow => 'jutri';

  @override
  String dateOnWeekday(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'v ponedeljek',
      'tuesday': 'v torek',
      'wednesday': 'v sredo',
      'thursday': 'v četrtek',
      'friday': 'v petek',
      'saturday': 'v soboto',
      'sunday': 'v nedeljo',
      'other': '$weekday',
    });
    return '$_temp0';
  }

  @override
  String dateOnDate(Object date) {
    return '$date';
  }

  @override
  String get browserBadLink => 'Ta povezava ne deluje.';

  @override
  String get browserCouldNotOpen => 'Povezave ni bilo mogoče odpreti.';

  @override
  String browserCouldNotOpenContact(Object target) {
    return 'Ni bilo mogoče odpreti: $target.';
  }

  @override
  String get apiErrorSlow => 'Povezava je počasna. Poskusi znova čez trenutek.';

  @override
  String get apiErrorOffline =>
      'Ne moremo doseči myShine. Preveri internetno povezavo.';

  @override
  String get apiErrorUnauthorized => 'Znova se poveži s svojo ordinacijo.';

  @override
  String get apiErrorForbidden => 'To za tvoj račun ni na voljo.';

  @override
  String get apiErrorTooManyTries =>
      'Preveč poskusov. Počakaj nekaj minut in poskusi znova.';

  @override
  String get apiErrorServer =>
      'Pri nas je šlo nekaj narobe. Poskusi znova pozneje.';

  @override
  String get apiErrorUnknown => 'Nekaj je šlo narobe. Poskusi znova.';

  @override
  String get welcomeBySmileLabs => 'od SmileLabs';

  @override
  String get welcomeEyebrow => 'Prozorni alajnerji Shine';

  @override
  String get welcomeTitle => 'Tvoje zdravljenje,';

  @override
  String get welcomeTitleMuted => 's tvojo ordinacijo.';

  @override
  String get welcomeBody =>
      'Alajner, ki ga nosiš danes, vsi datumi menjav, tvoj plan in sporočila z ordinacijo. Na enem mestu.';

  @override
  String get connectTitle => 'Tvoja ordinacija';

  @override
  String get connectTitleMuted => 'ima ključ zate.';

  @override
  String get connectBody =>
      'Vpiši 8-mestno kodo iz svoje ordinacije. Tvoj plan, alajnerji in sporočila se odprejo takoj.';

  @override
  String get connectPass => 'ključ';

  @override
  String get connectWorksOnce => 'Velja enkrat';

  @override
  String connectValidDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Velja $days dni',
      few: 'Velja $days dni',
      two: 'Velja $days dneva',
      one: 'Velja $days dan',
    );
    return '$_temp0';
  }

  @override
  String get connectButton => 'Poveži';

  @override
  String get connectFooter =>
      'Zasebno med tabo in tvojo ordinacijo. Brez gesla. Nimaš kode? Prosi zanjo svojo ordinacijo.';

  @override
  String get connectCodeEmpty => 'Vpiši kodo iz svoje ordinacije.';

  @override
  String connectCodeConfusing(Object letter) {
    return 'Kode ne vsebujejo 0, O, 1, I ali L. Preveri znak »$letter«.';
  }

  @override
  String connectCodeLength(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Koda ima $length znakov.',
      few: 'Koda ima $length znake.',
      two: 'Koda ima $length znaka.',
      one: 'Koda ima $length znak.',
    );
    return '$_temp0';
  }

  @override
  String get homeLoadError => 'myShine se ni naložil';

  @override
  String get tabToday => 'Danes';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabSchedule => 'Urnik';

  @override
  String get tabMessages => 'Sporočila';

  @override
  String tabMessagesUnread(Object count) {
    return 'Sporočila ($count)';
  }

  @override
  String get tabProfile => 'Profil';

  @override
  String todayHello(Object name) {
    return 'Živjo, $name';
  }

  @override
  String get todayNotStartedTitle => 'Zdravljenje začne tvoja ordinacija';

  @override
  String get todayNotStartedBody =>
      'Tam dobiš prve alajnerje. Nato se tukaj prikaže tvoj urnik.';

  @override
  String get todayAllDoneTitle => 'Zdravljenje je končano';

  @override
  String get todayAllDoneBody => 'Ordinacija ti pove, kaj sledi.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Tvoj zadnji alajner se je končal $date. Tvoja ordinacija ti bo povedala, kaj sledi.';
  }

  @override
  String todayWearHint(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other:
          'Alajnerje nosi približno $hours ur na dan. Odstrani jih le za jed in ščetkanje.',
      few:
          'Alajnerje nosi približno $hours ure na dan. Odstrani jih le za jed in ščetkanje.',
      two:
          'Alajnerje nosi približno $hours uri na dan. Odstrani jih le za jed in ščetkanje.',
      one:
          'Alajnerje nosi približno $hours uro na dan. Odstrani jih le za jed in ščetkanje.',
    );
    return '$_temp0';
  }

  @override
  String todaySeriesDay(int series, int day, int days) {
    return 'Serija $series · dan $day od $days';
  }

  @override
  String todayDay(int day, int days) {
    return 'dan $day od $days';
  }

  @override
  String todayAlignerOf(int aligner, int total) {
    return 'Alajner $aligner od $total';
  }

  @override
  String get todayCheckIn => 'Prijavi menjavo';

  @override
  String get todayLastOne => 'Zadnji';

  @override
  String get todayNextAligner => 'Naslednji alajner';

  @override
  String get todayThisAligner => 'Ta alajner';

  @override
  String todayDaysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'preostalih dni',
      few: 'preostali dnevi',
      two: 'preostala dneva',
      one: 'preostali dan',
    );
    return '$_temp0';
  }

  @override
  String get todayTreatment => 'Zdravljenje';

  @override
  String get planTitle => 'Tvoj plan';

  @override
  String get planIn3d => 'V 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serija $series · v 3D';
  }

  @override
  String get planCardTitle => 'Tvoj plan v 3D';

  @override
  String get planCardBody =>
      'Zdravnik ga je delil s tabo. Pokaže, kako se zobje premikajo, alajner za alajnerjem. Vprašanja? Piši v Sporočila.';

  @override
  String get planOpen => 'Odpri svoj plan';

  @override
  String get planNotSharedTitle => 'Zdravnik deli tvoj plan, ko je pripravljen';

  @override
  String get planNotSharedBody => 'Tukaj ga boš videl v 3D.';

  @override
  String get scheduleEmptyTitle => 'Urnika še ni';

  @override
  String get scheduleEmptyBody =>
      'Urnik alajnerjev se prikaže tukaj, ko se začne zdravljenje.';

  @override
  String scheduleAligners(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alajnerjev',
      few: '$count alajnerji',
      two: '$count alajnerja',
      one: '$count alajner',
    );
    return '$_temp0';
  }

  @override
  String scheduleSeries(int series, String aligners) {
    return 'Serija $series · $aligners';
  }

  @override
  String scheduleLastEnds(Object date) {
    return 'Tvoj zadnji alajner se konča $date.';
  }

  @override
  String get scheduleStarted => 'Začetek';

  @override
  String get scheduleDone => 'Opravljeno';

  @override
  String scheduleDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dni',
      few: '$count dnevi',
      two: '$count dneva',
      one: '$count dan',
    );
    return '$_temp0';
  }

  @override
  String get scheduleNow => 'Danes';

  @override
  String get scheduleCheckedIn => 'Menjava prijavljena';

  @override
  String scheduleCheckedInOn(Object date) {
    return 'Menjava prijavljena $date';
  }

  @override
  String get scheduleOnTime => 'pravočasno';

  @override
  String get checkInFitSeated => 'Se dobro prilega';

  @override
  String get checkInFitLoose => 'Ne nalega povsem';

  @override
  String get checkInFitTight => 'Zelo tesen';

  @override
  String get checkInFitDamaged => 'Poškodovan ali izgubljen';

  @override
  String get checkInComfortNone => 'Brez';

  @override
  String get checkInComfortMild => 'Blago';

  @override
  String get checkInComfortStrong => 'Močno';

  @override
  String checkInConfirmError(Object aligner) {
    return 'Potrdi, da je alajner $aligner že nameščen.';
  }

  @override
  String checkInChooseFitError(Object aligner) {
    return 'Izberi, kako se prilega alajner $aligner.';
  }

  @override
  String checkInPhotoTitle(Object view) {
    return 'Fotografija: $view';
  }

  @override
  String get intraoralFront => 'Spredaj';

  @override
  String get intraoralRight => 'Desno';

  @override
  String get intraoralLeft => 'Levo';

  @override
  String get intraoralUpper => 'Zgoraj';

  @override
  String get intraoralLower => 'Spodaj';

  @override
  String get intraoralFrontHint =>
      'Zagrizi in se široko nasmehni, da se vidijo vsi sprednji zobje.';

  @override
  String get intraoralRightHint =>
      'Zagrizi, povleci desno lice nazaj in se malo obrni.';

  @override
  String get intraoralLeftHint =>
      'Zagrizi, povleci levo lice nazaj in se malo obrni.';

  @override
  String get intraoralUpperHint =>
      'Nagni glavo nazaj in široko odpri usta, da se vidijo zgornji zobje.';

  @override
  String get intraoralLowerHint =>
      'Nagni glavo naprej in široko odpri usta, da se vidijo spodnji zobje.';

  @override
  String checkInThanks(Object aligner) {
    return 'Alajner $aligner je na vrsti. Hvala!';
  }

  @override
  String get checkInEyebrow => 'Prijava menjave';

  @override
  String checkInNext(Object aligner) {
    return 'Naslednji: alajner $aligner';
  }

  @override
  String checkInAlignerWhen(int aligner, String when) {
    return 'Alajner $aligner $when';
  }

  @override
  String get checkInUpcomingBody =>
      'Ko ga vstaviš, tukaj prijavi menjavo. Urnik se prilagodi dnevu menjave.';

  @override
  String checkInEarly(Object aligner) {
    return 'Alajner $aligner že nosim';
  }

  @override
  String get checkInClinicSees =>
      'Tvoja ordinacija vidi tvojo prijavo menjave.';

  @override
  String get checkInDueYesterday =>
      'Rok je bil včeraj. Prijavi menjavo, ko zamenjaš alajner.';

  @override
  String checkInDueDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Rok je bil pred $count dnevi. Prijavi menjavo, ko zamenjaš alajner.',
      few:
          'Rok je bil pred $count dnevi. Prijavi menjavo, ko zamenjaš alajner.',
      two:
          'Rok je bil pred $count dnevoma. Prijavi menjavo, ko zamenjaš alajner.',
      one:
          'Rok je bil pred $count dnevom. Prijavi menjavo, ko zamenjaš alajner.',
    );
    return '$_temp0';
  }

  @override
  String checkInDue(Object when) {
    return 'Rok: $when.';
  }

  @override
  String checkInSwitchTitle(Object aligner) {
    return 'Zamenjaj na alajner $aligner';
  }

  @override
  String checkInSwitchedLabel(Object aligner) {
    return 'Alajner $aligner je nameščen';
  }

  @override
  String checkInFitQuestion(Object aligner) {
    return 'Kako se prilega alajner $aligner?';
  }

  @override
  String get checkInDiscomfort => 'Nelagodje';

  @override
  String get checkInNoteLabel => 'Sporočilo za ordinacijo';

  @override
  String get checkInNoteHint => 'Karkoli naj vedo (neobvezno)';

  @override
  String get checkInSending => 'Pošiljanje …';

  @override
  String checkInSend(Object aligner) {
    return 'Prijavi menjavo na alajner $aligner';
  }

  @override
  String get checkInPhotos => 'Fotografije';

  @override
  String get checkInPhotosAsking =>
      'Fotografije zob z vstavljenim alajnerjem ordinaciji pomagajo videti, kaj je narobe.';

  @override
  String get checkInPhotosOptional =>
      'Neobvezno. Fotografije zob z vstavljenim alajnerjem. Vidi jih le tvoja ordinacija.';

  @override
  String get checkInPhotosWebOnly =>
      'Fotografije zob lahko dodaš v aplikaciji myShine na telefonu.';

  @override
  String checkInTakePhoto(Object view) {
    return 'Posnemi fotografijo: $view';
  }

  @override
  String get photoRemove => 'Odstrani fotografijo';

  @override
  String photoRemoveNamed(Object view) {
    return 'Odstrani fotografijo: $view';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisconnectTitle => 'Prekineš povezavo z myShine?';

  @override
  String get profileDisconnectBody =>
      'Tvoj plan, urnik in sporočila na tem telefonu ne bodo več prikazani. Za ponovno povezavo prosi ordinacijo za novo kodo.';

  @override
  String get profileDisconnect => 'Prekini povezavo';

  @override
  String get profileYourClinic => 'Tvoja ordinacija';

  @override
  String get profileYourDentist => 'Tvoj zobozdravnik';

  @override
  String get profileCall => 'Pokliči';

  @override
  String get profileEmail => 'E-pošta';

  @override
  String get profileThisPhone => 'Ta telefon';

  @override
  String get profileReminders => 'Opomniki za alajnerje';

  @override
  String get profileRemindersDetail => 'Na dan menjave';

  @override
  String get profileOn => 'Vklopljeno';

  @override
  String get profileOff => 'Izklopljeno';

  @override
  String get profileFooter => 'Prozorni alajnerji Shine od SmileLabs';

  @override
  String get documentsTitle => 'Dokumenti';

  @override
  String get documentsEmptyTitle => 'Tukaj še ni ničesar';

  @override
  String get documentsEmptyBody =>
      'Kar podpišeš, in izjave za tvoje opornice, se prikažejo tukaj.';

  @override
  String get documentsFootnote =>
      'Vse, kar si podpisal/-a, in izjava za vsak tvoj pripomoček ostane tukaj. Tapni, da dokument odpreš, natisneš ali shraniš. Enake izvode hrani tvoja ordinacija.';

  @override
  String get documentsConsent => 'Soglasje za zdravljenje';

  @override
  String documentsConsentFor(Object devices) {
    return 'Soglasje: $devices';
  }

  @override
  String get documentsSigned => 'Podpisano';

  @override
  String documentsSignedOn(Object date) {
    return 'Podpisano $date';
  }

  @override
  String get documentsSignThere =>
      'Ordinacija te bo prosila, da ga podpišeš tam';

  @override
  String get documentsWaiting => 'Čaka na tvoj podpis';

  @override
  String get documentsSign => 'Podpiši';

  @override
  String get documentsOpen => 'Odpri';

  @override
  String get messagesTitle => 'Sporočila';

  @override
  String get messagesSubtitle =>
      'Piši svoji ordinaciji. Običajno odgovorijo v enem delovnem dnevu.';

  @override
  String get messagesLoadError => 'Sporočila se niso naložila';

  @override
  String get messagesEmptyTitle => 'Še ni sporočil';

  @override
  String get messagesEmptyBody =>
      'Imaš vprašanje o alajnerjih? Piši ordinaciji tukaj.';

  @override
  String get messagesPhotoTitle => 'Fotografija za ordinacijo';

  @override
  String get messagesPhotoHint =>
      'Posnemi jasno fotografijo ob dobri svetlobi. Poslana bo s tvojim sporočilom.';

  @override
  String get messagesAddPhoto => 'Dodaj fotografijo';

  @override
  String get messagesInputHint => 'Sporočilo za ordinacijo';

  @override
  String get messagesSend => 'Pošlji';

  @override
  String get messagesOpenPhoto => 'Odpri fotografijo';

  @override
  String get messagesPhoto => 'Fotografija';

  @override
  String get messagesPhotoFailed =>
      'Fotografija se ni naložila. Poskusi znova pozneje.';

  @override
  String get cameraSwitch => 'Zamenjaj kamero';

  @override
  String get cameraDenied =>
      'V Nastavitvah dovoli aplikaciji myShine dostop do kamere, da dodaš fotografijo.';

  @override
  String get cameraUnavailable => 'Kamera tukaj ni na voljo';

  @override
  String get cameraTakePhoto => 'Posnemi fotografijo';

  @override
  String reminderChangeTitle(Object aligner) {
    return 'Čas je za alajner $aligner';
  }

  @override
  String reminderChangeBody(Object aligner) {
    return 'Danes vstavi alajner $aligner.';
  }

  @override
  String reminderCheckInBody(Object aligner) {
    return 'Danes vstavi alajner $aligner, nato prijavi menjavo v myShine.';
  }

  @override
  String reminderLateTitle(Object aligner) {
    return 'Že nosiš alajner $aligner?';
  }

  @override
  String get reminderLateBody => 'Prijavi menjavo, da bo tvoj urnik pravilen.';

  @override
  String get welcomeHaveCode => 'Imam kodo';

  @override
  String get welcomeWhatIs => 'Kaj je myShine?';

  @override
  String get welcomeNoCode => 'Še nimaš kode? Vprašaj svojo ordinacijo Shine.';

  @override
  String get welcomePhotoLabel => 'Nasmeh s prozornim alajnerjem Shine';

  @override
  String get commonPrivacy => 'Zasebnost';

  @override
  String get commonHelp => 'Pomoč';

  @override
  String get aboutTitle => 'Čemu je namenjen myShine';

  @override
  String get aboutIntro =>
      'myShine te spremlja med zdravljenjem z alajnerji Shine. Dostop ti da tvoja ordinacija.';

  @override
  String get aboutToday => 'Kateri alajner nosiš in kdaj ga zamenjaš.';

  @override
  String get aboutCheckInTitle => 'Prijava menjave';

  @override
  String get aboutCheckIn =>
      'Sporoči zdravniku, da si zamenjal alajner: kako se prilega, opombo in po želji fotografije. Če tvoj zdravnik uporablja prijave.';

  @override
  String get aboutPlan => 'Tvoj plan v 3D, ko ga zdravnik deli s tabo.';

  @override
  String get aboutSchedule => 'Vsi datumi menjav.';

  @override
  String get aboutMessages => 'Vprašaj ordinacijo ali pošlji fotografijo.';

  @override
  String get aboutDocumentsTitle => 'Dokumenti';

  @override
  String get aboutDocuments => 'Podpiši in shrani svoje dokumente.';

  @override
  String get aboutClinic => 'Tvoj zdravnik, telefon in e-pošta.';

  @override
  String get aboutNot =>
      'myShine ne postavlja diagnoz in nikoli ne spreminja zdravljenja. O vsakem koraku odloča tvoj zdravnik. Ob bolečini ali zlomljenem alajnerju pokliči ordinacijo.';

  @override
  String aboutVersion(String version) {
    return 'Različica $version';
  }

  @override
  String get profileAbout => 'O aplikaciji myShine';

  @override
  String get profileAboutDetail => 'Namen, pomoč in zasebnost';

  @override
  String todayChangeTo(int aligner, String when) {
    return 'Menjava na alajner $aligner $when';
  }

  @override
  String todayChangeLate(int aligner, String late) {
    return 'Menjava na alajner $aligner · $late';
  }

  @override
  String get todayLastAlignerNow => 'To je tvoj zadnji alajner';

  @override
  String todayProgress(int done, int total) {
    return '$done od $total alajnerjev za tabo';
  }

  @override
  String get todayDaysLeftLabel => 'Še dni s tem alajnerjem';

  @override
  String get todayStarted => 'Začetek zdravljenja';

  @override
  String get todayLastCheckIn => 'Tvoja zadnja prijava';

  @override
  String get todayCheckInOnTime => 'pravočasno';

  @override
  String todayCheckInPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotografij',
      few: '$count fotografije',
      two: '2 fotografiji',
      one: '1 fotografija',
    );
    return '$_temp0';
  }

  @override
  String planCardSeries(int series) {
    return 'Serija $series';
  }
}
