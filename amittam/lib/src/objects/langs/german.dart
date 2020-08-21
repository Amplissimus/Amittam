import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/objects/language.dart';

class German extends Language {
  @override
  String get addPassword => 'Passwort hinzufügen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get chooseLang => 'Sprache auswählen';

  @override
  String get confirm => 'bestätigen';

  @override
  String get context => 'Kontext';

  @override
  String get copyPWToClipboard => 'Passwort in Zwischenablage kopieren';

  @override
  String get copiedPWToClipboard => 'Passwort in Zwischenablage kopiert!';

  @override
  String get deleteAppData => 'App-Daten löschen';

  @override
  String get fastLogin => 'Schneller Login';

  @override
  String get generatePassword => 'Passwort generieren';

  @override
  String get logOut => 'Abmelden';

  @override
  String get noPasswordsRegistered => 'Keine Passwörter registriert!';

  @override
  String get notes => 'Notizen';

  @override
  String get password => 'Passwort';

  @override
  String get platform => 'Plattform';

  @override
  String get pwNotStrongEnough => 'Passwort zu schwach!';

  @override
  String get save => 'Speichern';

  @override
  String get setMasterPW => 'Hauptzugangspasswort speichern';

  @override
  String get settings => 'Einstellungen';

  @override
  String get showAppInfo => 'App-Informationen anzeigen';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get useNumbers => 'Ziffern verwenden';

  @override
  String get useSpecialChars => 'Sonderzeichen verwenden';

  @override
  String get username => 'Benutzername';

  @override
  String get englishName => 'German';

  @override
  String get nativeName => 'Deutsch';

  @override
  String get searchDot => 'Suchen...';

  @override
  String get appInfo =>
      'Amittam ist ein quelloffener Passwortmanager, der fast alle Daten, sogar das Hauptzugangspasswort, mithilfe des Hauptzugangspasswort verschlüsselt, abspeichert und eine Aktualisierung zwischen Geräten in Echtzeit ermöglicht, sobald sich der Benutzer mit seinem Google Konto verifiziert hat. Die manuell eingetragenen Daten können nur mit Eingabe des korrekten Hauptzugangspassworts im Loginbildschirm eingesehen werden.';

  @override
  String get fieldIsEmpty => 'Feld ist leer!';

  @override
  String get confirmMasterPW => 'Hauptzugangspasswort bestätigen';

  @override
  String get enterMasterPW => 'Hauptzugangspasswort eingeben';

  @override
  String get logIn => 'Einloggen';

  @override
  String get enteredPWIsWrong => 'Das eingegebene Passwort ist nicht korrekt!';

  @override
  String get deletePassword => 'Passwort löschen';

  @override
  String get deletion => 'Löschung';

  @override
  String get editMasterPassword => 'Hauptzugangspasswort ändern';

  @override
  String get notesOptional => 'Notizen (optional)';

  @override
  String get proceedByUsingLocalData =>
      'Mit dem Sichern der lokalen App-Daten fortfahren';

  @override
  String get proceedByUsingLocalDataDesc =>
      'Mit dem Sichern der lokal gespeicherten App-Daten werden alle, derzeit online gespeicherten App-Daten gelöscht un durch die derzeit lokal gespeichert Daten ersetzt.';

  @override
  String get proceedByUsingOnlineData =>
      'Mit dem Herunterladen der online gespeicherten App-Daten fortfahren';

  @override
  String get proceedByUsingOnlineDataDesc =>
      'Mit dem Herunterladen der online gespeicherten App-Daten musst du das derzeit online gespeicherte Hauptzugangspasswort eingeben. Alle derzeit lokal gespeicherten App-Daten gehen dabei verloren!';

  @override
  String get useLocalStoredData => 'Lokal gespeicherte Daten verwenden';

  @override
  String get useOnlineStoredData => 'Online gespeicherte Daten verwenden';

  @override
  String get finishLogin => 'Login abschließen';

  @override
  String get mailAddress => 'E-Mail Adresse';

  @override
  String get showQr => 'QR Code anzeigen';

  @override
  String get reallyDeletePassword => 'Willst du dieses Passwort wirklich löschen?';

  @override
  String get scanOptimized => 'Optimiert für Scans';

  @override
  String get displayPassword => 'Passwort anzeigen';

  @override
  String get requestedText => 'Angefordeter Text';

  @override
  String get resetActionRequest => 'Bitte gib "${this.confirm.toUpperCase()}" in die Textbox unterhalb ein und bestätige daraufhin das Löschen der gesamten App-Daten mit dem Hauptzugangspasswort.${FirebaseService.isSignedIn ? ' Damit werden deine sämtlichen App-Daten auch aus unserer Datenbank gelöscht!' : ''}';

  @override
  String get noResults => 'Keine Ergebnisse!';

  @override
  String get wifi => 'WLAN';

  @override
  String get confirmFirstGoogleLogin => 'Mit Google-Anmeldung fortfahren';

  @override
  String get confirmFirstGoogleLoginDesc => 'Mit dem vollenden der Google-Anmeldung werden alle lokalen App-Daten online gespeichert und sind auf mehreren Geräten abrufbar. Solange du mit deinem Google-Konto angemeldet bist, werden deine Daten in Echtzeit mit den online gespeicherten Daten synchronisiert. Du kannst die online gespeicherten App-Daten allerdings nur abrufen, wenn du das gleiche Google-Konto verwendest.';

  @override
  String get confirmGoogleLogout => 'Mit Google-Abmeldung fortfahren';

  @override
  String get confirmGoogleLogoutDesc => 'Wenn du dich aus Amittam mit deinem Google-Konto abmeldest, werden sämtliche lokal gespeicherten App-Daten nicht mehr mit den online gespeicherten App-Daten synchronisiert. Mochtest du wiklich fortfahren?';

  @override
  String get howWeUseYourData => 'Was wir mit deinen Daten machen';

  @override
  String get howWeUseYourDataDesc => 'Deine eingetragenen Passwörter werden mithilfe des Hauptzugangspassworts verschlüsselt abgespeichert. Solange du nicht mit deinem Google-Konto in unserer App angemeldet bist, bleiben alle manuell eingatragenen App-Daten auf deinem Gerät. Falls du mit deinem Google-Konto inunserer App angemeldet bist, werden deine Daten mit unserer Datenbank synchronisiert.\nWir können dann das, mithilfe des Hauptzugangspassworts verschlüsselte, Haupzugangspasswort einsehen. Für uns und potenzielle Hacker sieht ein von dir gespeichertes Passwort mit Plattform, Benutzernamen und gegebenenfalls Notizen so aus: "okSNZuS1k6S1SIEyiGxA7pFn3sXOWm5/uRq+OzdZZSipU9eVqTX62M0Fr1gzlf9SnqhCb2U8tvKurGv/iyhO5zFduAqEEbsdWNVNs9V865zaxZSWwBOoilbqbfWUmwEab67ORboGOqU3cp9iU9GoGUyJ7ImNg5pzHuJDR3tzqy1/KC+8I8G+7KAkQJn29IjoFkN0dM9134C5G0CEAYgGRcJONbJW0439mbGx63//tbdnJmNDZD81D/ehAoWvtmBEYL2z7Si2bfcOy/wckVx1yNHnrGoz4mp0qRzOjNumQfF5x0xoj/bivArxr2wkxEgSD0WUdkL1kD98IsYjxFFfZlX3NpPbZPT+uHKcxCCXlxT0UdUCx04BOJES1ffkFp6d1udCVYWXnKwwzk4feiQkpy4OTS7FAyq31fwAFmpGzau6qhujW3/dbtejspUNIQS5zPm7QaJssyKtWMto4f3/cW+nJGmqiBQymf+OATbBdYQ6OTQUXMSrGXZ95W/rvppPw0qNY4BD/olh87yt0eXoS2rKKgDEk0+hhV9jLNlb23TzToTS5/vqXYTarByfWYkC6vOP8mIHzwda9ofogbrnlKAeE2B5PWG1Nfb5fy5UGD0ER+cuH3TKUtlsGQETPTpDRzxMTLZ/cRc9i5BmsB7uh6hTPK6YyP86zFd6rgof3LkWi1DBkS07ZNRHr0m/N8baQT+wb5+eSMN9axTyZfKa2boGHt2HWUidiUWZk8Bw3Z8IP2baJvzNOS70DETPfeFhTlP7Uspq04Z2tLmpYjqi1A==". Deine Passwörter werden mithilfe deines Hauptzugangspassworts und zwei zufällig generierten Schlüsseln verschlüsselt.\nAußerdem können wir, falls du mit deinem Google-Konto angemeldet bist, deine Einstellungen voll und ganz einsehen, da diese, für ein besseres Nutzererlebnis, nicht verschlüsselt abgespeichert werden. Du kannst auch jederzeit die online gespeicherten Daten löschen lassen, indem du, wenn du eingeloggt bist, in den Einstellungen unter "App-Daten löschen" die dort angeführten Schritte befolgst. Wir erheben außerdem Analysedaten über App-Abstürze, Performance, Nutzerbindung, und Nutzerherkunft. Dabei bleiben deine manuell eingetragenen Daten stets sicher, solange nur du dein Hauptzugangspasswort kennst.';

  @override
  String get useDarkTheme => 'Dunkles Thema verwenden';

  @override
  String get useSystemTheme => 'Systemthema verwenden';

  @override
  String get invalidInput => 'Ungültige Eingabe!';

  @override
  String get enterNewMasterPassword => 'Neues Hauptzugangspasswort eingeben';

  @override
  String get reallyDeleteAppData => FirebaseService.isSignedIn ? 'Willst du wirklich die gesamten online und lokal gespeicherten App-Daten löschen?' : 'Willst du wirklich die gesamten lokal gespeicherten App-Daten löschen?';

  @override
  String pwTypeToString(PasswordType pwType) {
    switch (pwType) {
      case PasswordType.onlineAccount:
        return 'Online-Konto';
      case PasswordType.emailAccount:
        return 'E-Mail Konto';
      case PasswordType.wifiPassword:
        return 'WLAN Passwort';
      case PasswordType.other:
        return 'Sonstiges';
      default:
        return 'Error!';
    }
  }

  @override
  String deleteSelectedPasswordsWarning(bool multiple) =>
      'Möchtest du ${multiple ? 'die ausgewählten Passwörter' : 'das ausgewählte Passwort'} wirklich löschen?';

  @override
  String firstLoginConfirmPW(String s) =>
      'Bitte bestätige, dass "$s" dein gewolltes Hauptzugangspasswort ist! Dein Hauptzugangspasswort ist der einzige Weg, um Zugang zu deinen Daten zu erlangen, da diese mithilfe des Hauptzugangspasswortes verschlüsselt werden. Bitte notiere das Hauptzugangspasswort für den Fall, dass du es vergessen solltest!';




}
