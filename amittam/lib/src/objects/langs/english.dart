import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/objects/language.dart';

class English extends Language {
  @override
  String get addPassword => 'Add password';

  @override
  String get cancel => 'cancel';

  @override
  String get chooseLang => 'Choose Language';

  @override
  String get confirm => 'confirm';

  @override
  String get context => 'context';

  @override
  String get copyPWToClipboard => 'Copy password to clipboard';

  @override
  String get copiedPWToClipboard => 'Copied password to clipboard!';

  @override
  String get deleteAppData => 'Delete app data';

  @override
  String get fastLogin => 'Fast login';

  @override
  String get generatePassword => 'Generate password';

  @override
  String get logOut => 'Log out';

  @override
  String get noPasswordsRegistered => 'No passwords registered!';

  @override
  String get notes => 'Notes';

  @override
  String get password => 'Password';

  @override
  String get platform => 'Platform';

  @override
  String get pwNotStrongEnough => 'Password not strong enough!';

  @override
  String get save => 'Save';

  @override
  String get setMasterPW => 'Set master password';

  @override
  String get settings => 'Settings';

  @override
  String get showAppInfo => 'Show app information';

  @override
  String get signInWithGoogle => 'Sign in with google';

  @override
  String get useNumbers => 'Use numbers';

  @override
  String get useSpecialChars => 'Use special characters';

  @override
  String get username => 'Username';

  @override
  String get englishName => 'English';

  @override
  String get nativeName => 'English';

  @override
  String get searchDot => 'Search...';

  @override
  String get appInfo =>
      'Amittam is an open source password manager, that stores mostly all data encrypted using the master password, even the master password itself. It allows realtime updates between devices as soon as the user has verified himself using his Google Account. The user is only granted access to his manually input data by inputting the correct master password on the login screen.';

  @override
  String get fieldIsEmpty => 'Field is empty!';

  @override
  String get confirmMasterPW => 'Confirm master password';

  @override
  String get enterMasterPW => 'Enter master password';

  @override
  String get logIn => 'Log in';

  @override
  String get enteredPWIsWrong => 'The entered password is not correct!';

  @override
  String get deletePassword => 'Delete password';

  @override
  String get deletion => 'Deletion';

  @override
  String get editMasterPassword => 'Edit master password';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get proceedByUsingLocalData =>
      'Proceed by uploading local stored data';

  @override
  String get proceedByUsingLocalDataDesc =>
      'By uploading the local data, all current online data will be deleted!';

  @override
  String get proceedByUsingOnlineData =>
      'Proceed by downloading online stored data';

  @override
  String get proceedByUsingOnlineDataDesc =>
      'By downloading the online data, you will be logged out, if the previous master password does not match the current one. All current local app data will be deleted!';

  @override
  String get useLocalStoredData => 'Use local stored data';

  @override
  String get useOnlineStoredData => 'Use online stored data';

  @override
  String get finishLogin => 'Finish login process';

  @override
  String get mailAddress => 'E-Mail address';

  @override
  String get showQr => 'Show QR code';

  @override
  String get reallyDeletePassword =>
      'Do you really want to delete this password?';

  @override
  String get scanOptimized => 'Optimized for scanning';

  @override
  String get displayPassword => 'Display password';

  @override
  String get requestedText => 'Requested text';

  @override
  String get resetActionRequest =>
      'Please type "${this.confirm.toUpperCase()}" in the textbox below and then confirm deleting the app data using your master password.${FirebaseService.isSignedIn ? ' By performing this action, all of your app data will also be deleted from our databases!' : ''}';

  @override
  String get noResults => 'No results!';

  @override
  String get wifi => 'WiFi';

  @override
  String deleteSelectedPasswordsWarning(bool multiple) =>
      'Do you really want to delete the selected password${multiple ? 's' : ''}?';

  @override
  String firstLoginConfirmPW(String s) =>
      'Please confirm that "$s" is your intended master password! Your master password is the only way to get access to your data because your data is encrypted using your master password. Please write down your master password in case of forgetting it!';

  @override
  String pwTypeToString(PasswordType pwType) {
    switch (pwType) {
      case PasswordType.onlineAccount:
        return 'Online account';
      case PasswordType.emailAccount:
        return 'E-Mail account';
      case PasswordType.wifiPassword:
        return 'WiFi password';
      case PasswordType.other:
        return 'Other';
      default:
        return 'Error!';
    }
  }
}
