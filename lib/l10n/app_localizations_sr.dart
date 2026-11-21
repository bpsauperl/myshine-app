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
  String get welcomeTitle => 'Tvoja terapija,';

  @override
  String get welcomeTitleMuted => 'sa tvojom ordinacijom.';

  @override
  String get welcomeBody =>
      'Alajner koji danas nosiš, svi datumi promena, tvoj plan i poruke sa ordinacijom. Na jednom mestu.';

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
  String get todayNotStartedTitle => 'Terapiju započinje tvoja ordinacija';

  @override
  String get todayNotStartedBody =>
      'Tamo dobijaš prve alajnere. Zatim se ovde prikazuje tvoj raspored.';

  @override
  String get todayAllDoneTitle => 'Terapija je završena';

  @override
  String get todayAllDoneBody => 'Ordinacija će ti reći šta sledi.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Tvoj poslednji alajner završen je $date. Tvoja ordinacija će ti reći šta sledi.';
  }

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
  String todayLastOne(String date) {
    return 'Poslednji $date';
  }

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
  String get planIn3d => 'U 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serija $series · u 3D';
  }

  @override
  String get planCardTitle => 'Tvoj plan u 3D';

  @override
  String get planCardBody =>
      'Doktor ga je podelio s tobom. Pokazuje kako se zubi pomeraju, alajner po alajner. Pitanja? Piši u Poruke.';

  @override
  String get planOpen => 'Otvori svoj plan';

  @override
  String get planNotSharedTitle => 'Doktor deli tvoj plan kada bude spreman';

  @override
  String get planNotSharedBody => 'Ovde ćeš ga videti u 3D.';

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
  String get documentsEmptyTitle => 'Ovde još nema ničega';

  @override
  String get documentsEmptyBody =>
      'Ono što potpišeš i izjave za tvoje alajnere pojaviće se ovde.';

  @override
  String get documentsFootnote =>
      'Sve što si potpisao/-la i izjava za svako tvoje pomagalo ostaje ovde. Dodirni dokument da ga otvoriš, odštampaš ili sačuvaš. Iste primerke čuva tvoja ordinacija.';

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
  String get documentsOpen => 'Otvori';

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

  @override
  String get welcomeHaveCode => 'Imam kod';

  @override
  String get welcomeWhatIs => 'Šta je myShine?';

  @override
  String get welcomeNoCode => 'Još nemaš kod? Pitaj svoju Shine ordinaciju.';

  @override
  String get welcomePhotoLabel => 'Osmeh sa providnim Shine alajnerom';

  @override
  String get commonPrivacy => 'Privatnost';

  @override
  String get commonHelp => 'Pomoć';

  @override
  String get aboutTitle => 'Čemu služi myShine';

  @override
  String get aboutIntro =>
      'myShine te prati tokom terapije Shine alajnerima. Pristup ti daje tvoja ordinacija.';

  @override
  String get aboutToday => 'Koji alajner nosiš i kada ga menjaš.';

  @override
  String get aboutCheckInTitle => 'Prijava promene';

  @override
  String get aboutCheckIn =>
      'Javi doktoru da si promenio alajner: kako naleže, napomenu i fotografije po želji. Ako tvoj doktor koristi prijave.';

  @override
  String get aboutPlan => 'Tvoj plan u 3D, kada ga doktor podeli s tobom.';

  @override
  String get aboutSchedule => 'Svi datumi promena.';

  @override
  String get aboutMessages => 'Pitaj ordinaciju ili pošalji fotografiju.';

  @override
  String get aboutDocumentsTitle => 'Dokumenti';

  @override
  String get aboutDocuments => 'Potpiši i sačuvaj svoja dokumenta.';

  @override
  String get aboutClinic => 'Tvoj doktor, telefon i e-pošta.';

  @override
  String get aboutNot =>
      'myShine ne postavlja dijagnoze i nikada ne menja terapiju. O svakom koraku odlučuje tvoj doktor. Kod bola ili slomljenog alajnera pozovi ordinaciju.';

  @override
  String aboutVersion(String version) {
    return 'Verzija $version';
  }

  @override
  String get profileAbout => 'O aplikaciji myShine';

  @override
  String get profileAboutDetail => 'Namena, pomoć i privatnost';

  @override
  String todayChangeTo(int aligner, String when) {
    return 'Promena na alajner $aligner $when';
  }

  @override
  String todayChangeLate(int aligner, String late) {
    return 'Promena na alajner $aligner · $late';
  }

  @override
  String get todayLastAlignerNow => 'Ovo je tvoj poslednji alajner';

  @override
  String todayProgress(int done, int total) {
    return '$done od $total alajnera završeno';
  }

  @override
  String get todayDaysLeftLabel => 'Još dana sa ovim alajnerom';

  @override
  String get todayStarted => 'Početak terapije';

  @override
  String get todayLastCheckIn => 'Tvoja poslednja prijava';

  @override
  String get todayCheckInOnTime => 'na vreme';

  @override
  String todayCheckInPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotografija',
      few: '$count fotografije',
      one: '1 fotografija',
    );
    return '$_temp0';
  }

  @override
  String planCardSeries(int series) {
    return 'Serija $series';
  }

  @override
  String todayOfAligners(int total) {
    return 'od $total alajnera';
  }

  @override
  String todayDoneCount(int count) {
    return '$count gotovo';
  }

  @override
  String todayCheckInAligner(int aligner) {
    return 'Potvrdi alajner $aligner';
  }

  @override
  String get todayDaysLeftUnit => 'dana još';

  @override
  String get todayWear => 'Nošenje';

  @override
  String get todayHoursUnit => 'sati dnevno';

  @override
  String todayLastCheckInOn(String date) {
    return 'Poslednja prijava · $date';
  }

  @override
  String get todayOpenSchedule => 'Pogledaj raspored';

  @override
  String scheduleEndsOn(String date) {
    return 'kraj $date';
  }

  @override
  String get introConsult => 'Sve počinje kod tvog stomatologa.';

  @override
  String get introScan => 'Brz 3D sken. Bez otisaka.';

  @override
  String get introPlan => 'Tvoj plan, alajner po alajner.';

  @override
  String get introWear => 'Providni alajneri, napravljeni za tebe.';

  @override
  String get introAligner => 'A myShine te vodi kroz sve.';

  @override
  String get introPause => 'Zaustavi video';

  @override
  String get introPlay => 'Pusti video';

  @override
  String introScene(int scene, int total) {
    return 'Scena $scene od $total';
  }

  @override
  String get installTitle => 'Dodaj myShine na početni ekran';

  @override
  String get installIos =>
      'Dodirni Podeli, pa Dodaj na početni ekran. myShine se onda otvara kao aplikacija.';

  @override
  String get installAndroid =>
      'Dodirni meni ⋮, pa Instaliraj aplikaciju ili Dodaj na početni ekran. myShine se onda otvara kao aplikacija.';

  @override
  String get installDismiss => 'Ne sada';
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
  String get welcomeTitle => 'Tvoja terapija,';

  @override
  String get welcomeTitleMuted => 'sa tvojom ordinacijom.';

  @override
  String get welcomeBody =>
      'Alajner koji danas nosiš, svi datumi promena, tvoj plan i poruke sa ordinacijom. Na jednom mestu.';

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
  String get todayNotStartedTitle => 'Terapiju započinje tvoja ordinacija';

  @override
  String get todayNotStartedBody =>
      'Tamo dobijaš prve alajnere. Zatim se ovde prikazuje tvoj raspored.';

  @override
  String get todayAllDoneTitle => 'Terapija je završena';

  @override
  String get todayAllDoneBody => 'Ordinacija će ti reći šta sledi.';

  @override
  String todayAllDoneBodyWithDate(Object date) {
    return 'Tvoj poslednji alajner završen je $date. Tvoja ordinacija će ti reći šta sledi.';
  }

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
  String todayLastOne(String date) {
    return 'Poslednji $date';
  }

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
  String get planIn3d => 'U 3D';

  @override
  String planSeriesIn3d(Object series) {
    return 'Serija $series · u 3D';
  }

  @override
  String get planCardTitle => 'Tvoj plan u 3D';

  @override
  String get planCardBody =>
      'Doktor ga je podelio s tobom. Pokazuje kako se zubi pomeraju, alajner po alajner. Pitanja? Piši u Poruke.';

  @override
  String get planOpen => 'Otvori svoj plan';

  @override
  String get planNotSharedTitle => 'Doktor deli tvoj plan kada bude spreman';

  @override
  String get planNotSharedBody => 'Ovde ćeš ga videti u 3D.';

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
  String get documentsEmptyTitle => 'Ovde još nema ničega';

  @override
  String get documentsEmptyBody =>
      'Ono što potpišeš i izjave za tvoje alajnere pojaviće se ovde.';

  @override
  String get documentsFootnote =>
      'Sve što si potpisao/-la i izjava za svako tvoje pomagalo ostaje ovde. Dodirni dokument da ga otvoriš, odštampaš ili sačuvaš. Iste primerke čuva tvoja ordinacija.';

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
  String get documentsOpen => 'Otvori';

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

  @override
  String get welcomeHaveCode => 'Imam kod';

  @override
  String get welcomeWhatIs => 'Šta je myShine?';

  @override
  String get welcomeNoCode => 'Još nemaš kod? Pitaj svoju Shine ordinaciju.';

  @override
  String get welcomePhotoLabel => 'Osmeh sa providnim Shine alajnerom';

  @override
  String get commonPrivacy => 'Privatnost';

  @override
  String get commonHelp => 'Pomoć';

  @override
  String get aboutTitle => 'Čemu služi myShine';

  @override
  String get aboutIntro =>
      'myShine te prati tokom terapije Shine alajnerima. Pristup ti daje tvoja ordinacija.';

  @override
  String get aboutToday => 'Koji alajner nosiš i kada ga menjaš.';

  @override
  String get aboutCheckInTitle => 'Prijava promene';

  @override
  String get aboutCheckIn =>
      'Javi doktoru da si promenio alajner: kako naleže, napomenu i fotografije po želji. Ako tvoj doktor koristi prijave.';

  @override
  String get aboutPlan => 'Tvoj plan u 3D, kada ga doktor podeli s tobom.';

  @override
  String get aboutSchedule => 'Svi datumi promena.';

  @override
  String get aboutMessages => 'Pitaj ordinaciju ili pošalji fotografiju.';

  @override
  String get aboutDocumentsTitle => 'Dokumenti';

  @override
  String get aboutDocuments => 'Potpiši i sačuvaj svoja dokumenta.';

  @override
  String get aboutClinic => 'Tvoj doktor, telefon i e-pošta.';

  @override
  String get aboutNot =>
      'myShine ne postavlja dijagnoze i nikada ne menja terapiju. O svakom koraku odlučuje tvoj doktor. Kod bola ili slomljenog alajnera pozovi ordinaciju.';

  @override
  String aboutVersion(String version) {
    return 'Verzija $version';
  }

  @override
  String get profileAbout => 'O aplikaciji myShine';

  @override
  String get profileAboutDetail => 'Namena, pomoć i privatnost';

  @override
  String todayChangeTo(int aligner, String when) {
    return 'Promena na alajner $aligner $when';
  }

  @override
  String todayChangeLate(int aligner, String late) {
    return 'Promena na alajner $aligner · $late';
  }

  @override
  String get todayLastAlignerNow => 'Ovo je tvoj poslednji alajner';

  @override
  String todayProgress(int done, int total) {
    return '$done od $total alajnera završeno';
  }

  @override
  String get todayDaysLeftLabel => 'Još dana sa ovim alajnerom';

  @override
  String get todayStarted => 'Početak terapije';

  @override
  String get todayLastCheckIn => 'Tvoja poslednja prijava';

  @override
  String get todayCheckInOnTime => 'na vreme';

  @override
  String todayCheckInPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotografija',
      few: '$count fotografije',
      one: '1 fotografija',
    );
    return '$_temp0';
  }

  @override
  String planCardSeries(int series) {
    return 'Serija $series';
  }

  @override
  String todayOfAligners(int total) {
    return 'od $total alajnera';
  }

  @override
  String todayDoneCount(int count) {
    return '$count gotovo';
  }

  @override
  String todayCheckInAligner(int aligner) {
    return 'Potvrdi alajner $aligner';
  }

  @override
  String get todayDaysLeftUnit => 'dana još';

  @override
  String get todayWear => 'Nošenje';

  @override
  String get todayHoursUnit => 'sati dnevno';

  @override
  String todayLastCheckInOn(String date) {
    return 'Poslednja prijava · $date';
  }

  @override
  String get todayOpenSchedule => 'Pogledaj raspored';

  @override
  String scheduleEndsOn(String date) {
    return 'kraj $date';
  }

  @override
  String get introConsult => 'Sve počinje kod tvog stomatologa.';

  @override
  String get introScan => 'Brz 3D sken. Bez otisaka.';

  @override
  String get introPlan => 'Tvoj plan, alajner po alajner.';

  @override
  String get introWear => 'Providni alajneri, napravljeni za tebe.';

  @override
  String get introAligner => 'A myShine te vodi kroz sve.';

  @override
  String get introPause => 'Zaustavi video';

  @override
  String get introPlay => 'Pusti video';

  @override
  String introScene(int scene, int total) {
    return 'Scena $scene od $total';
  }

  @override
  String get installTitle => 'Dodaj myShine na početni ekran';

  @override
  String get installIos =>
      'Dodirni Podeli, pa Dodaj na početni ekran. myShine se onda otvara kao aplikacija.';

  @override
  String get installAndroid =>
      'Dodirni meni ⋮, pa Instaliraj aplikaciju ili Dodaj na početni ekran. myShine se onda otvara kao aplikacija.';

  @override
  String get installDismiss => 'Ne sada';
}
