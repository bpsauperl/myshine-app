// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get commonTryAgain => 'Pokušaj ponovo';

  @override
  String get commonBack => 'Nazad';

  @override
  String get commonCancel => 'Otkaži';

  @override
  String get commonDidNotWork => 'Nije uspelo. Pokušaj ponovo.';

  @override
  String commonAlignerNumber(Object number) {
    return 'Alajner $number';
  }

  @override
  String get commonLastAligner => 'Poslednji alajner';

  @override
  String commonDaysLate(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana kašnjenja',
      few: '$count dana kašnjenja',
      one: '$count dan kašnjenja',
    );
    return '$_temp0';
  }

  @override
  String get archHeroLabel => 'Providni Shine alajner';

  @override
  String get dateToday => 'danas';

  @override
  String get dateTomorrow => 'sutra';

  @override
  String dateOnWeekday(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'u ponedeljak',
      'tuesday': 'u utorak',
      'wednesday': 'u sredu',
      'thursday': 'u četvrtak',
      'friday': 'u petak',
      'saturday': 'u subotu',
      'sunday': 'u nedelju',
      'other': '$weekday',
    });
    return '$_temp0';
  }

  @override
  String dateOnDate(Object date) {
    return '$date';
  }

  @override
  String get browserBadLink => 'Ovaj link ne radi.';

  @override
  String get browserCouldNotOpen => 'Link nije mogao da se otvori.';

  @override
  String browserCouldNotOpenContact(Object target) {
    return 'Nije moguće otvoriti: $target.';
  }

  @override
  String get apiErrorSlow => 'Veza je spora. Pokušaj ponovo za trenutak.';

  @override
  String get apiErrorOffline =>
      'Ne možemo da dođemo do myShine. Proveri internet vezu.';

  @override
  String get apiErrorUnauthorized => 'Ponovo se poveži sa svojom ordinacijom.';

  @override
  String get apiErrorForbidden => 'Ovo nije dostupno za tvoj nalog.';

  @override
  String get apiErrorTooManyTries =>
      'Previše pokušaja. Sačekaj nekoliko minuta i pokušaj ponovo.';

  @override
  String get apiErrorServer =>
      'Nešto je pošlo naopako kod nas. Pokušaj ponovo kasnije.';

  @override
  String get apiErrorUnknown => 'Nešto je pošlo naopako. Pokušaj ponovo.';

  @override
  String get welcomeBySmileLabs => 'od SmileLabs';

  @override
  String get welcomeEyebrow => 'Providni Shine alajneri';

  @override
  String get welcomeTitle => 'Tvoj osmeh,';

  @override
  String get welcomeTitleMuted => 'otkriven.';

  @override
  String get welcomeBody =>
      'Pogledaj svoj novi osmeh za minut. Zatim sa svojom ordinacijom prati svaki alajner, dan po dan.';

  @override
  String get welcomeSimulate => 'Pogledaj novi osmeh';

  @override
  String get welcomeClinicCode => 'Kod ordinacije';

  @override
  String get connectTitle => 'Tvoja ordinacija';

  @override
  String get connectTitleMuted => 'ima ključ za tebe.';

  @override
  String get connectBody =>
      'Upiši kod od 8 znakova iz svoje ordinacije. Tvoj plan, alajneri i poruke otvaraju se odmah.';

  @override
  String get connectPass => 'ključ';

  @override
  String get connectWorksOnce => 'Važi jednom';

  @override
  String connectValidDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Važi $days dana',
      few: 'Važi $days dana',
      one: 'Važi $days dan',
    );
    return '$_temp0';
  }

  @override
  String get connectButton => 'Poveži';

  @override
  String get connectFooter =>
      'Privatno između tebe i tvoje ordinacije. Bez lozinke. Nemaš kod? Zatraži ga od svoje ordinacije.';

  @override
  String get connectCodeEmpty => 'Upiši kod iz svoje ordinacije.';

  @override
  String connectCodeConfusing(Object letter) {
    return 'Kodovi ne sadrže 0, O, 1, I ni L. Proveri znak „$letter“.';
  }

  @override
  String connectCodeLength(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Kod ima $length znakova.',
      few: 'Kod ima $length znaka.',
      one: 'Kod ima $length znak.',
    );
    return '$_temp0';
  }

  @override
  String get homeLoadError => 'myShine nije mogao da se učita';

  @override
  String get tabToday => 'Danas';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabSchedule => 'Raspored';

  @override
  String get tabMessages => 'Poruke';

  @override
  String tabMessagesUnread(Object count) {
    return 'Poruke ($count)';
  }

  @override
  String get tabProfile => 'Profil';

  @override
  String todayHello(Object name) {
    return 'Zdravo, $name';
  }

  @override
  String get todayNotStartedTitle => 'Terapija još nije počela';

  @override
  String get todayNotStartedBody =>
      'Tvoja ordinacija će započeti terapiju i dati ti prve alajnere. Tada će se ovde prikazati tvoj raspored.';

  @override
  String get todayAllDoneTitle => 'Svi alajneri završeni';

  @override
  String get todayAllDoneBody =>
      'Odlično! Tvoja ordinacija će ti reći šta sledi.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Tvoj poslednji alajner završen je $date. Tvoja ordinacija će ti reći šta sledi.';
  }

  @override
  String get todayAlignerLabel => 'Tvoj alajner';

  @override
  String todayWearHint(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other:
          'Nosi alajnere oko $hours sati dnevno. Vadi ih samo za jelo i pranje zuba.',
      few:
          'Nosi alajnere oko $hours sata dnevno. Vadi ih samo za jelo i pranje zuba.',
      one:
          'Nosi alajnere oko $hours sat dnevno. Vadi ih samo za jelo i pranje zuba.',
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
  String get todayCheckIn => 'Potvrdi zamenu';

  @override
  String get todayLastOne => 'Poslednji';

  @override
  String get todayNextAligner => 'Sledeći alajner';

  @override
  String get todayThisAligner => 'Ovaj alajner';

  @override
  String todayDaysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'preostalih dana',
      few: 'preostala dana',
      one: 'preostali dan',
    );
    return '$_temp0';
  }

  @override
  String get todayTreatment => 'Terapija';

  @override
  String get planTitle => 'Tvoj plan';

  @override
  String get planHeroLabel => 'Tvoj plan terapije';

  @override
  String get planIn3d => 'U 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serija $series · u 3D';
  }

  @override
  String get planCardTitle => 'Svaki korak do tvog novog osmeha.';

  @override
  String get planCardBody =>
      'Pogledaj kako se tvoji zubi pomeraju, alajner po alajner, od danas do kraja.';

  @override
  String get planOpen => 'Otvori svoj plan';

  @override
  String get planNotSharedTitle =>
      'Tvoja ordinacija će ovde podeliti tvoj plan.';

  @override
  String get planNotSharedBody =>
      'Kada stomatolog pripremi tvoj plan, možeš ga videti ovde u 3D.';

  @override
  String get scheduleEmptyTitle => 'Rasporeda još nema';

  @override
  String get scheduleEmptyBody =>
      'Raspored alajnera prikazaće se ovde kada terapija počne.';

  @override
  String scheduleAligners(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alajnera',
      few: '$count alajnera',
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
    return 'Tvoj poslednji alajner završava se $date.';
  }

  @override
  String get scheduleStarted => 'Početak';

  @override
  String get scheduleDone => 'Završeno';

  @override
  String scheduleDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana',
      few: '$count dana',
      one: '$count dan',
    );
    return '$_temp0';
  }

  @override
  String get scheduleNow => 'Danas';

  @override
  String get scheduleCheckedIn => 'Zamena potvrđena';

  @override
  String scheduleCheckedInOn(Object date) {
    return 'Zamena potvrđena $date';
  }

  @override
  String get scheduleOnTime => 'na vreme';

  @override
  String get checkInFitSeated => 'Dobro naleže';

  @override
  String get checkInFitLoose => 'Ne naleže potpuno';

  @override
  String get checkInFitTight => 'Veoma tesan';

  @override
  String get checkInFitDamaged => 'Oštećen ili izgubljen';

  @override
  String get checkInComfortNone => 'Bez';

  @override
  String get checkInComfortMild => 'Blago';

  @override
  String get checkInComfortStrong => 'Jako';

  @override
  String checkInConfirmError(Object aligner) {
    return 'Potvrdi da je alajner $aligner već postavljen.';
  }

  @override
  String checkInChooseFitError(Object aligner) {
    return 'Izaberi kako alajner $aligner naleže.';
  }

  @override
  String checkInPhotoTitle(Object view) {
    return 'Fotografija: $view';
  }

  @override
  String get intraoralFront => 'Spreda';

  @override
  String get intraoralRight => 'Desno';

  @override
  String get intraoralLeft => 'Levo';

  @override
  String get intraoralUpper => 'Gore';

  @override
  String get intraoralLower => 'Dole';

  @override
  String get intraoralFrontHint =>
      'Zagrizi i široko se nasmeši da se vide svi prednji zubi.';

  @override
  String get intraoralRightHint =>
      'Zagrizi, povuci desni obraz unazad i malo se okreni.';

  @override
  String get intraoralLeftHint =>
      'Zagrizi, povuci levi obraz unazad i malo se okreni.';

  @override
  String get intraoralUpperHint =>
      'Zabaci glavu i široko otvori usta da se vide gornji zubi.';

  @override
  String get intraoralLowerHint =>
      'Spusti glavu i široko otvori usta da se vide donji zubi.';

  @override
  String checkInThanks(Object aligner) {
    return 'Alajner $aligner je na redu. Hvala!';
  }

  @override
  String get checkInEyebrow => 'Potvrda zamene';

  @override
  String checkInNext(Object aligner) {
    return 'Sledeći: alajner $aligner';
  }

  @override
  String checkInAlignerWhen(int aligner, String when) {
    return 'Alajner $aligner $when';
  }

  @override
  String get checkInUpcomingBody =>
      'Kada ga staviš, ovde potvrdi zamenu. Raspored prati dan zamene.';

  @override
  String checkInEarly(Object aligner) {
    return 'Već nosim alajner $aligner';
  }

  @override
  String get checkInClinicSees => 'Tvoja ordinacija vidi tvoju potvrdu zamene.';

  @override
  String get checkInDueYesterday =>
      'Rok je bio juče. Potvrdi zamenu kada promeniš alajner.';

  @override
  String checkInDueDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Rok je bio pre $count dana. Potvrdi zamenu kada promeniš alajner.',
      few: 'Rok je bio pre $count dana. Potvrdi zamenu kada promeniš alajner.',
      one: 'Rok je bio pre $count dan. Potvrdi zamenu kada promeniš alajner.',
    );
    return '$_temp0';
  }

  @override
  String checkInDue(Object when) {
    return 'Rok: $when.';
  }

  @override
  String checkInSwitchTitle(Object aligner) {
    return 'Pređi na alajner $aligner';
  }

  @override
  String checkInSwitchedLabel(Object aligner) {
    return 'Alajner $aligner je postavljen';
  }

  @override
  String checkInFitQuestion(Object aligner) {
    return 'Kako naleže alajner $aligner?';
  }

  @override
  String get checkInDiscomfort => 'Nelagodnost';

  @override
  String get checkInNoteLabel => 'Napomena za ordinaciju';

  @override
  String get checkInNoteHint => 'Sve što treba da znaju (opciono)';

  @override
  String get checkInSending => 'Slanje…';

  @override
  String checkInSend(Object aligner) {
    return 'Potvrdi zamenu na alajner $aligner';
  }

  @override
  String get checkInPhotos => 'Fotografije';

  @override
  String get checkInPhotosAsking =>
      'Fotografije zuba sa postavljenim alajnerom pomažu ordinaciji da vidi šta nije u redu.';

  @override
  String get checkInPhotosOptional =>
      'Opciono. Fotografije zuba sa postavljenim alajnerom. Vidi ih samo tvoja ordinacija.';

  @override
  String get checkInPhotosWebOnly =>
      'Fotografije zuba možeš da dodaš u aplikaciji myShine na telefonu.';

  @override
  String checkInTakePhoto(Object view) {
    return 'Snimi fotografiju: $view';
  }

  @override
  String get photoRemove => 'Ukloni fotografiju';

  @override
  String photoRemoveNamed(Object view) {
    return 'Ukloni fotografiju: $view';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisconnectTitle => 'Prekinuti vezu sa myShine?';

  @override
  String get profileDisconnectBody =>
      'Tvoj plan, raspored i poruke više se neće prikazivati na ovom telefonu. Za ponovno povezivanje zatraži novi kod od ordinacije.';

  @override
  String get profileDisconnect => 'Prekini vezu';

  @override
  String get profileYourClinic => 'Tvoja ordinacija';

  @override
  String get profileYourDentist => 'Tvoj stomatolog';

  @override
  String get profileCall => 'Pozovi';

  @override
  String get profileEmail => 'E-pošta';

  @override
  String get profileThisPhone => 'Ovaj telefon';

  @override
  String get profileReminders => 'Podsetnici za alajnere';

  @override
  String get profileRemindersDetail => 'Na dan zamene';

  @override
  String get profileOn => 'Uključeno';

  @override
  String get profileOff => 'Isključeno';

  @override
  String get profileFooter => 'Providni Shine alajneri od SmileLabs';

  @override
  String get documentsTitle => 'Dokumenti';

  @override
  String get documentsEmptyTitle => 'Nema ničega za potpis';

  @override
  String get documentsEmptyBody =>
      'Kada te ordinacija zamoli da nešto potpišeš, pojaviće se ovde.';

  @override
  String get documentsFootnote =>
      'Kada potpišeš, ordinacija čuva potpisani primerak u tvojoj dokumentaciji. Ako želiš kopiju za sebe, zatraži je.';

  @override
  String get documentsConsent => 'Saglasnost za terapiju';

  @override
  String documentsConsentFor(Object devices) {
    return 'Saglasnost: $devices';
  }

  @override
  String get documentsSigned => 'Potpisano';

  @override
  String documentsSignedOn(Object date) {
    return 'Potpisano $date';
  }

  @override
  String get documentsSignThere =>
      'Ordinacija će te zamoliti da ga potpišeš tamo';

  @override
  String get documentsWaiting => 'Čeka tvoj potpis';

  @override
  String get documentsSign => 'Potpiši';

  @override
  String get messagesTitle => 'Poruke';

  @override
  String get messagesSubtitle =>
      'Piši svojoj ordinaciji. Obično odgovore u roku od jednog radnog dana.';

  @override
  String get messagesLoadError => 'Poruke se nisu učitale';

  @override
  String get messagesEmptyTitle => 'Još nema poruka';

  @override
  String get messagesEmptyBody =>
      'Imaš pitanje o alajnerima? Piši ordinaciji ovde.';

  @override
  String get messagesPhotoTitle => 'Fotografija za ordinaciju';

  @override
  String get messagesPhotoHint =>
      'Snimi jasnu fotografiju pri dobrom svetlu. Biće poslata uz tvoju poruku.';

  @override
  String get messagesAddPhoto => 'Dodaj fotografiju';

  @override
  String get messagesInputHint => 'Poruka za ordinaciju';

  @override
  String get messagesSend => 'Pošalji';

  @override
  String get messagesOpenPhoto => 'Otvori fotografiju';

  @override
  String get messagesPhoto => 'Fotografija';

  @override
  String get messagesPhotoFailed =>
      'Fotografija se nije učitala. Pokušaj ponovo kasnije.';

  @override
  String get cameraSwitch => 'Promeni kameru';

  @override
  String get cameraDenied =>
      'U Podešavanjima dozvoli aplikaciji myShine pristup kameri za dodavanje fotografije.';

  @override
  String get cameraUnavailable => 'Kamera ovde nije dostupna';

  @override
  String get cameraTakePhoto => 'Snimi fotografiju';

  @override
  String get selfieTitle => 'Fotografija osmeha';

  @override
  String get selfieGuide =>
      'Smesti lice u oval i nasmeši se tako da zubi budu u okviru.';

  @override
  String get selfiePrivate =>
      'Fotografija ostaje na tvom telefonu. Ništa se ne otprema.';

  @override
  String get selfieSample => 'Pogledaj primer prikaza';

  @override
  String get selfieDenied =>
      'U Podešavanjima dozvoli aplikaciji myShine pristup kameri za snimanje fotografije.';

  @override
  String get previewTitle => 'Tvoj prikaz';

  @override
  String get previewSampleNote =>
      'Kamera ovde nije dostupna, pa je ovo primer ilustracije.';

  @override
  String get previewLikeTitle => 'Sviđa ti se?';

  @override
  String get previewLikeBody =>
      'Shine stomatolog pregleda tvoje zube i sa tobom planira svaki korak.';

  @override
  String get previewFindClinic => 'Pronađi Shine ordinaciju';

  @override
  String get previewTakeAnother => 'Snimi novu fotografiju';

  @override
  String get previewHaveCode => 'Imam kod iz svoje ordinacije';

  @override
  String get previewHonest =>
      'Ilustracija, ne plan terapije. Stomatolog ti pokazuje tvoj pravi plan u 3D.';

  @override
  String get previewAfter => 'Posle';

  @override
  String get previewBefore => 'Pre';

  @override
  String reminderChangeTitle(Object aligner) {
    return 'Vreme je za alajner $aligner';
  }

  @override
  String reminderChangeBody(Object aligner) {
    return 'Danas stavi alajner $aligner.';
  }

  @override
  String reminderCheckInBody(Object aligner) {
    return 'Danas stavi alajner $aligner, zatim potvrdi zamenu u myShine.';
  }

  @override
  String reminderLateTitle(Object aligner) {
    return 'Nosiš li već alajner $aligner?';
  }

  @override
  String get reminderLateBody =>
      'Potvrdi zamenu da bi tvoj raspored ostao tačan.';
}

/// The translations for Serbian, using the Latin script (`sr_Latn`).
class AppLocalizationsSrLatn extends AppLocalizationsSr {
  AppLocalizationsSrLatn() : super('sr_Latn');

  @override
  String get commonTryAgain => 'Pokušaj ponovo';

  @override
  String get commonBack => 'Nazad';

  @override
  String get commonCancel => 'Otkaži';

  @override
  String get commonDidNotWork => 'Nije uspelo. Pokušaj ponovo.';

  @override
  String commonAlignerNumber(Object number) {
    return 'Alajner $number';
  }

  @override
  String get commonLastAligner => 'Poslednji alajner';

  @override
  String commonDaysLate(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana kašnjenja',
      few: '$count dana kašnjenja',
      one: '$count dan kašnjenja',
    );
    return '$_temp0';
  }

  @override
  String get archHeroLabel => 'Providni Shine alajner';

  @override
  String get dateToday => 'danas';

  @override
  String get dateTomorrow => 'sutra';

  @override
  String dateOnWeekday(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'u ponedeljak',
      'tuesday': 'u utorak',
      'wednesday': 'u sredu',
      'thursday': 'u četvrtak',
      'friday': 'u petak',
      'saturday': 'u subotu',
      'sunday': 'u nedelju',
      'other': '$weekday',
    });
    return '$_temp0';
  }

  @override
  String dateOnDate(Object date) {
    return '$date';
  }

  @override
  String get browserBadLink => 'Ovaj link ne radi.';

  @override
  String get browserCouldNotOpen => 'Link nije mogao da se otvori.';

  @override
  String browserCouldNotOpenContact(Object target) {
    return 'Nije moguće otvoriti: $target.';
  }

  @override
  String get apiErrorSlow => 'Veza je spora. Pokušaj ponovo za trenutak.';

  @override
  String get apiErrorOffline =>
      'Ne možemo da dođemo do myShine. Proveri internet vezu.';

  @override
  String get apiErrorUnauthorized => 'Ponovo se poveži sa svojom ordinacijom.';

  @override
  String get apiErrorForbidden => 'Ovo nije dostupno za tvoj nalog.';

  @override
  String get apiErrorTooManyTries =>
      'Previše pokušaja. Sačekaj nekoliko minuta i pokušaj ponovo.';

  @override
  String get apiErrorServer =>
      'Nešto je pošlo naopako kod nas. Pokušaj ponovo kasnije.';

  @override
  String get apiErrorUnknown => 'Nešto je pošlo naopako. Pokušaj ponovo.';

  @override
  String get welcomeBySmileLabs => 'od SmileLabs';

  @override
  String get welcomeEyebrow => 'Providni Shine alajneri';

  @override
  String get welcomeTitle => 'Tvoj osmeh,';

  @override
  String get welcomeTitleMuted => 'otkriven.';

  @override
  String get welcomeBody =>
      'Pogledaj svoj novi osmeh za minut. Zatim sa svojom ordinacijom prati svaki alajner, dan po dan.';

  @override
  String get welcomeSimulate => 'Pogledaj novi osmeh';

  @override
  String get welcomeClinicCode => 'Kod ordinacije';

  @override
  String get connectTitle => 'Tvoja ordinacija';

  @override
  String get connectTitleMuted => 'ima ključ za tebe.';

  @override
  String get connectBody =>
      'Upiši kod od 8 znakova iz svoje ordinacije. Tvoj plan, alajneri i poruke otvaraju se odmah.';

  @override
  String get connectPass => 'ključ';

  @override
  String get connectWorksOnce => 'Važi jednom';

  @override
  String connectValidDays(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Važi $days dana',
      few: 'Važi $days dana',
      one: 'Važi $days dan',
    );
    return '$_temp0';
  }

  @override
  String get connectButton => 'Poveži';

  @override
  String get connectFooter =>
      'Privatno između tebe i tvoje ordinacije. Bez lozinke. Nemaš kod? Zatraži ga od svoje ordinacije.';

  @override
  String get connectCodeEmpty => 'Upiši kod iz svoje ordinacije.';

  @override
  String connectCodeConfusing(Object letter) {
    return 'Kodovi ne sadrže 0, O, 1, I ni L. Proveri znak „$letter“.';
  }

  @override
  String connectCodeLength(num length) {
    String _temp0 = intl.Intl.pluralLogic(
      length,
      locale: localeName,
      other: 'Kod ima $length znakova.',
      few: 'Kod ima $length znaka.',
      one: 'Kod ima $length znak.',
    );
    return '$_temp0';
  }

  @override
  String get homeLoadError => 'myShine nije mogao da se učita';

  @override
  String get tabToday => 'Danas';

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabSchedule => 'Raspored';

  @override
  String get tabMessages => 'Poruke';

  @override
  String tabMessagesUnread(Object count) {
    return 'Poruke ($count)';
  }

  @override
  String get tabProfile => 'Profil';

  @override
  String todayHello(Object name) {
    return 'Zdravo, $name';
  }

  @override
  String get todayNotStartedTitle => 'Terapija još nije počela';

  @override
  String get todayNotStartedBody =>
      'Tvoja ordinacija će započeti terapiju i dati ti prve alajnere. Tada će se ovde prikazati tvoj raspored.';

  @override
  String get todayAllDoneTitle => 'Svi alajneri završeni';

  @override
  String get todayAllDoneBody =>
      'Odlično! Tvoja ordinacija će ti reći šta sledi.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Tvoj poslednji alajner završen je $date. Tvoja ordinacija će ti reći šta sledi.';
  }

  @override
  String get todayAlignerLabel => 'Tvoj alajner';

  @override
  String todayWearHint(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other:
          'Nosi alajnere oko $hours sati dnevno. Vadi ih samo za jelo i pranje zuba.',
      few:
          'Nosi alajnere oko $hours sata dnevno. Vadi ih samo za jelo i pranje zuba.',
      one:
          'Nosi alajnere oko $hours sat dnevno. Vadi ih samo za jelo i pranje zuba.',
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
  String get todayCheckIn => 'Potvrdi zamenu';

  @override
  String get todayLastOne => 'Poslednji';

  @override
  String get todayNextAligner => 'Sledeći alajner';

  @override
  String get todayThisAligner => 'Ovaj alajner';

  @override
  String todayDaysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'preostalih dana',
      few: 'preostala dana',
      one: 'preostali dan',
    );
    return '$_temp0';
  }

  @override
  String get todayTreatment => 'Terapija';

  @override
  String get planTitle => 'Tvoj plan';

  @override
  String get planHeroLabel => 'Tvoj plan terapije';

  @override
  String get planIn3d => 'U 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serija $series · u 3D';
  }

  @override
  String get planCardTitle => 'Svaki korak do tvog novog osmeha.';

  @override
  String get planCardBody =>
      'Pogledaj kako se tvoji zubi pomeraju, alajner po alajner, od danas do kraja.';

  @override
  String get planOpen => 'Otvori svoj plan';

  @override
  String get planNotSharedTitle =>
      'Tvoja ordinacija će ovde podeliti tvoj plan.';

  @override
  String get planNotSharedBody =>
      'Kada stomatolog pripremi tvoj plan, možeš ga videti ovde u 3D.';

  @override
  String get scheduleEmptyTitle => 'Rasporeda još nema';

  @override
  String get scheduleEmptyBody =>
      'Raspored alajnera prikazaće se ovde kada terapija počne.';

  @override
  String scheduleAligners(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alajnera',
      few: '$count alajnera',
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
    return 'Tvoj poslednji alajner završava se $date.';
  }

  @override
  String get scheduleStarted => 'Početak';

  @override
  String get scheduleDone => 'Završeno';

  @override
  String scheduleDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dana',
      few: '$count dana',
      one: '$count dan',
    );
    return '$_temp0';
  }

  @override
  String get scheduleNow => 'Danas';

  @override
  String get scheduleCheckedIn => 'Zamena potvrđena';

  @override
  String scheduleCheckedInOn(Object date) {
    return 'Zamena potvrđena $date';
  }

  @override
  String get scheduleOnTime => 'na vreme';

  @override
  String get checkInFitSeated => 'Dobro naleže';

  @override
  String get checkInFitLoose => 'Ne naleže potpuno';

  @override
  String get checkInFitTight => 'Veoma tesan';

  @override
  String get checkInFitDamaged => 'Oštećen ili izgubljen';

  @override
  String get checkInComfortNone => 'Bez';

  @override
  String get checkInComfortMild => 'Blago';

  @override
  String get checkInComfortStrong => 'Jako';

  @override
  String checkInConfirmError(Object aligner) {
    return 'Potvrdi da je alajner $aligner već postavljen.';
  }

  @override
  String checkInChooseFitError(Object aligner) {
    return 'Izaberi kako alajner $aligner naleže.';
  }

  @override
  String checkInPhotoTitle(Object view) {
    return 'Fotografija: $view';
  }

  @override
  String get intraoralFront => 'Spreda';

  @override
  String get intraoralRight => 'Desno';

  @override
  String get intraoralLeft => 'Levo';

  @override
  String get intraoralUpper => 'Gore';

  @override
  String get intraoralLower => 'Dole';

  @override
  String get intraoralFrontHint =>
      'Zagrizi i široko se nasmeši da se vide svi prednji zubi.';

  @override
  String get intraoralRightHint =>
      'Zagrizi, povuci desni obraz unazad i malo se okreni.';

  @override
  String get intraoralLeftHint =>
      'Zagrizi, povuci levi obraz unazad i malo se okreni.';

  @override
  String get intraoralUpperHint =>
      'Zabaci glavu i široko otvori usta da se vide gornji zubi.';

  @override
  String get intraoralLowerHint =>
      'Spusti glavu i široko otvori usta da se vide donji zubi.';

  @override
  String checkInThanks(Object aligner) {
    return 'Alajner $aligner je na redu. Hvala!';
  }

  @override
  String get checkInEyebrow => 'Potvrda zamene';

  @override
  String checkInNext(Object aligner) {
    return 'Sledeći: alajner $aligner';
  }

  @override
  String checkInAlignerWhen(int aligner, String when) {
    return 'Alajner $aligner $when';
  }

  @override
  String get checkInUpcomingBody =>
      'Kada ga staviš, ovde potvrdi zamenu. Raspored prati dan zamene.';

  @override
  String checkInEarly(Object aligner) {
    return 'Već nosim alajner $aligner';
  }

  @override
  String get checkInClinicSees => 'Tvoja ordinacija vidi tvoju potvrdu zamene.';

  @override
  String get checkInDueYesterday =>
      'Rok je bio juče. Potvrdi zamenu kada promeniš alajner.';

  @override
  String checkInDueDaysAgo(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Rok je bio pre $count dana. Potvrdi zamenu kada promeniš alajner.',
      few: 'Rok je bio pre $count dana. Potvrdi zamenu kada promeniš alajner.',
      one: 'Rok je bio pre $count dan. Potvrdi zamenu kada promeniš alajner.',
    );
    return '$_temp0';
  }

  @override
  String checkInDue(Object when) {
    return 'Rok: $when.';
  }

  @override
  String checkInSwitchTitle(Object aligner) {
    return 'Pređi na alajner $aligner';
  }

  @override
  String checkInSwitchedLabel(Object aligner) {
    return 'Alajner $aligner je postavljen';
  }

  @override
  String checkInFitQuestion(Object aligner) {
    return 'Kako naleže alajner $aligner?';
  }

  @override
  String get checkInDiscomfort => 'Nelagodnost';

  @override
  String get checkInNoteLabel => 'Napomena za ordinaciju';

  @override
  String get checkInNoteHint => 'Sve što treba da znaju (opciono)';

  @override
  String get checkInSending => 'Slanje…';

  @override
  String checkInSend(Object aligner) {
    return 'Potvrdi zamenu na alajner $aligner';
  }

  @override
  String get checkInPhotos => 'Fotografije';

  @override
  String get checkInPhotosAsking =>
      'Fotografije zuba sa postavljenim alajnerom pomažu ordinaciji da vidi šta nije u redu.';

  @override
  String get checkInPhotosOptional =>
      'Opciono. Fotografije zuba sa postavljenim alajnerom. Vidi ih samo tvoja ordinacija.';

  @override
  String get checkInPhotosWebOnly =>
      'Fotografije zuba možeš da dodaš u aplikaciji myShine na telefonu.';

  @override
  String checkInTakePhoto(Object view) {
    return 'Snimi fotografiju: $view';
  }

  @override
  String get photoRemove => 'Ukloni fotografiju';

  @override
  String photoRemoveNamed(Object view) {
    return 'Ukloni fotografiju: $view';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisconnectTitle => 'Prekinuti vezu sa myShine?';

  @override
  String get profileDisconnectBody =>
      'Tvoj plan, raspored i poruke više se neće prikazivati na ovom telefonu. Za ponovno povezivanje zatraži novi kod od ordinacije.';

  @override
  String get profileDisconnect => 'Prekini vezu';

  @override
  String get profileYourClinic => 'Tvoja ordinacija';

  @override
  String get profileYourDentist => 'Tvoj stomatolog';

  @override
  String get profileCall => 'Pozovi';

  @override
  String get profileEmail => 'E-pošta';

  @override
  String get profileThisPhone => 'Ovaj telefon';

  @override
  String get profileReminders => 'Podsetnici za alajnere';

  @override
  String get profileRemindersDetail => 'Na dan zamene';

  @override
  String get profileOn => 'Uključeno';

  @override
  String get profileOff => 'Isključeno';

  @override
  String get profileFooter => 'Providni Shine alajneri od SmileLabs';

  @override
  String get documentsTitle => 'Dokumenti';

  @override
  String get documentsEmptyTitle => 'Nema ničega za potpis';

  @override
  String get documentsEmptyBody =>
      'Kada te ordinacija zamoli da nešto potpišeš, pojaviće se ovde.';

  @override
  String get documentsFootnote =>
      'Kada potpišeš, ordinacija čuva potpisani primerak u tvojoj dokumentaciji. Ako želiš kopiju za sebe, zatraži je.';

  @override
  String get documentsConsent => 'Saglasnost za terapiju';

  @override
  String documentsConsentFor(Object devices) {
    return 'Saglasnost: $devices';
  }

  @override
  String get documentsSigned => 'Potpisano';

  @override
  String documentsSignedOn(Object date) {
    return 'Potpisano $date';
  }

  @override
  String get documentsSignThere =>
      'Ordinacija će te zamoliti da ga potpišeš tamo';

  @override
  String get documentsWaiting => 'Čeka tvoj potpis';

  @override
  String get documentsSign => 'Potpiši';

  @override
  String get messagesTitle => 'Poruke';

  @override
  String get messagesSubtitle =>
      'Piši svojoj ordinaciji. Obično odgovore u roku od jednog radnog dana.';

  @override
  String get messagesLoadError => 'Poruke se nisu učitale';

  @override
  String get messagesEmptyTitle => 'Još nema poruka';

  @override
  String get messagesEmptyBody =>
      'Imaš pitanje o alajnerima? Piši ordinaciji ovde.';

  @override
  String get messagesPhotoTitle => 'Fotografija za ordinaciju';

  @override
  String get messagesPhotoHint =>
      'Snimi jasnu fotografiju pri dobrom svetlu. Biće poslata uz tvoju poruku.';

  @override
  String get messagesAddPhoto => 'Dodaj fotografiju';

  @override
  String get messagesInputHint => 'Poruka za ordinaciju';

  @override
  String get messagesSend => 'Pošalji';

  @override
  String get messagesOpenPhoto => 'Otvori fotografiju';

  @override
  String get messagesPhoto => 'Fotografija';

  @override
  String get messagesPhotoFailed =>
      'Fotografija se nije učitala. Pokušaj ponovo kasnije.';

  @override
  String get cameraSwitch => 'Promeni kameru';

  @override
  String get cameraDenied =>
      'U Podešavanjima dozvoli aplikaciji myShine pristup kameri za dodavanje fotografije.';

  @override
  String get cameraUnavailable => 'Kamera ovde nije dostupna';

  @override
  String get cameraTakePhoto => 'Snimi fotografiju';

  @override
  String get selfieTitle => 'Fotografija osmeha';

  @override
  String get selfieGuide =>
      'Smesti lice u oval i nasmeši se tako da zubi budu u okviru.';

  @override
  String get selfiePrivate =>
      'Fotografija ostaje na tvom telefonu. Ništa se ne otprema.';

  @override
  String get selfieSample => 'Pogledaj primer prikaza';

  @override
  String get selfieDenied =>
      'U Podešavanjima dozvoli aplikaciji myShine pristup kameri za snimanje fotografije.';

  @override
  String get previewTitle => 'Tvoj prikaz';

  @override
  String get previewSampleNote =>
      'Kamera ovde nije dostupna, pa je ovo primer ilustracije.';

  @override
  String get previewLikeTitle => 'Sviđa ti se?';

  @override
  String get previewLikeBody =>
      'Shine stomatolog pregleda tvoje zube i sa tobom planira svaki korak.';

  @override
  String get previewFindClinic => 'Pronađi Shine ordinaciju';

  @override
  String get previewTakeAnother => 'Snimi novu fotografiju';

  @override
  String get previewHaveCode => 'Imam kod iz svoje ordinacije';

  @override
  String get previewHonest =>
      'Ilustracija, ne plan terapije. Stomatolog ti pokazuje tvoj pravi plan u 3D.';

  @override
  String get previewAfter => 'Posle';

  @override
  String get previewBefore => 'Pre';

  @override
  String reminderChangeTitle(Object aligner) {
    return 'Vreme je za alajner $aligner';
  }

  @override
  String reminderChangeBody(Object aligner) {
    return 'Danas stavi alajner $aligner.';
  }

  @override
  String reminderCheckInBody(Object aligner) {
    return 'Danas stavi alajner $aligner, zatim potvrdi zamenu u myShine.';
  }

  @override
  String reminderLateTitle(Object aligner) {
    return 'Nosiš li već alajner $aligner?';
  }

  @override
  String get reminderLateBody =>
      'Potvrdi zamenu da bi tvoj raspored ostao tačan.';
}
