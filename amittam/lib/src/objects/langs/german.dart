import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/objects/language.dart';

class German extends Language {
  @override
  String get addPassword => 'Passwort hinzufügen';

  @override
  String get cancel => 'abbrechen';

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
  String get logOut => 'Ausloggen';

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
      'Amittam ist ein quelloffener Passwortmanager, der fast alle Daten, sogar das Hauptzugangspasswort, mithilfe des Hauptzugangspasswort verschlüsselt, abspeichert und eine Aktualisierung zwischen Geräten in Echtzeit ermöglicht, sobald sich der Benutzer mit seinem Google Konto verifiziert hat. Die manuell eingetragenen Daten können nur mit Eingabe des korrekten Hauptzugangspassworts im Login Bildschirm eingesehen werden.';

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
      'Mit dem Sichern der lokal gespeicherten App-Daten werden alle, derzeit online gespeicherten App-Daten gelöscht!';

  @override
  String get proceedByUsingOnlineData =>
      'Mit dem Herunterladen der online gespeicherten App-Daten fortfahren';

  @override
  String get proceedByUsingOnlineDataDesc =>
      'Mit dem Herunterladen der online gespeicherten App-Daten wird der Benutzer ausgeloggt, wenn das aktuelle Hauptzugangspasswort nicht der online gespeicherten Variante gleicht. Alle derzeit lokal gespeicherten App-Daten gehen dabei verloren!';

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
