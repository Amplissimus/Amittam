import 'package:Amittam/src/libs/firebaselib.dart';
import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/objects/language.dart';

class English extends Language {
  @override
  String get addPassword => 'Add password';

  @override
  String get cancel => 'Cancel';

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
      'By downloading the online data, you will have to enter the current online stored master password. All current local app data will be deleted!';

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
  String get confirmFirstGoogleLogin => 'Continue with Google login';

  @override
  String get confirmFirstGoogleLoginDesc => 'By finishing the Google login, all local stored app data will be saved online and is available on multiple devices. As long as you are logged in using your Google account, all local app data will be synchronized with the online stored app data. You can only access your online stored app data by using the same Google account.';

  @override
  String get confirmGoogleLogout => 'Continue with Google logout';

  @override
  String get confirmGoogleLogoutDesc => 'By logging out of Amittam using your Google account, your app data will no longer be synchronized with the onlie stored app data. Do you really want to continue?';

  @override
  String get howWeUseYourData => 'What we do with your data';

  @override
  String get howWeUseYourDataDesc => 'The registered passwords will be saved after encrypting their important information using your master password. As long as you are not singed into our app using your Google account, all of your manually input data remains only on your device. If you are logged into our app using your Google account, your data will be synchronized with our databases.\nIn this case we can see the encrypted version of your master password. For us and potential hackers, a password you have saved with platform, user name and, if applicable, notes looks like this: "okSNZuS1k6S1SIEyiGxA7pFn3sXOWm5/uRq+OzdZZSipU9eVqTX62M0Fr1gzlf9SnqhCb2U8tvKurGv/iyhO5zFduAqEEbsdWNVNs9V865zaxZSWwBOoilbqbfWUmwEab67ORboGOqU3cp9iU9GoGUyJ7ImNg5pzHuJDR3tzqy1/KC+8I8G+7KAkQJn29IjoFkN0dM9134C5G0CEAYgGRcJONbJW0439mbGx63//tbdnJmNDZD81D/ehAoWvtmBEYL2z7Si2bfcOy/wckVx1yNHnrGoz4mp0qRzOjNumQfF5x0xoj/bivArxr2wkxEgSD0WUdkL1kD98IsYjxFFfZlX3NpPbZPT+uHKcxCCXlxT0UdUCx04BOJES1ffkFp6d1udCVYWXnKwwzk4feiQkpy4OTS7FAyq31fwAFmpGzau6qhujW3/dbtejspUNIQS5zPm7QaJssyKtWMto4f3/cW+nJGmqiBQymf+OATbBdYQ6OTQUXMSrGXZ95W/rvppPw0qNY4BD/olh87yt0eXoS2rKKgDEk0+hhV9jLNlb23TzToTS5/vqXYTarByfWYkC6vOP8mIHzwda9ofogbrnlKAeE2B5PWG1Nfb5fy5UGD0ER+cuH3TKUtlsGQETPTpDRzxMTLZ/cRc9i5BmsB7uh6hTPK6YyP86zFd6rgof3LkWi1DBkS07ZNRHr0m/N8baQT+wb5+eSMN9axTyZfKa2boGHt2HWUidiUWZk8Bw3Z8IP2baJvzNOS70DETPfeFhTlP7Uspq04Z2tLmpYjqi1A==". It looks like a random String because we encrypt your important information using your master password and two random generated keys.\nIf you are logged into our app using your Google account, we can also see all of your settings, because the settings are saved without using ecryption for getting a better user experience. You can delete your online and locally saved app data at any time. Just navigate to the settings and click on "Delete app data" and follow the given instructions. We also collect analytical data, such as app crashes, performance, user loyality and user origin. Your manually entered data will always be secure as long as you only know your main access password.';

  @override
  String get useDarkTheme => 'Use dark theme';

  @override
  String get useSystemTheme => 'Use system theme';

  @override
  String get invalidInput => 'Invalid input!';

  @override
  String get reallyDeleteAppData => FirebaseService.isSignedIn ? 'Do you really want to delete the entire local and online stored app data?' : 'Do you really want to delete the entire local stored app data?';

  @override
  String get enterNewMasterPassword => 'Enter new master password';

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
