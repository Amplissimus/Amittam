import 'langs/english.dart';
import 'langs/german.dart';

abstract class Language {
  String get appTitle => 'Amittam';

  String get versionString => '1.0.1';

  String get nativeName;

  String get englishName;

  String get logOut;

  String get settings;

  String get addPassword;

  String get generatePassword;

  String get noPasswordsRegistered;

  String get setMasterPW;

  String get showAppInfo;

  String get deleteAppData;

  String get signInWithPhoneNumber;

  String get fastLogin;

  String get chooseLang;

  String get useNumbers;

  String get useSpecialChars;

  String get copyPWToClipboard;

  String get copiedPWToClipboard;

  String get platform;

  String get username;

  String get password;

  String get notes;

  String get context;

  String get save;

  String get cancel;

  String get confirm;

  String get pwNotStrongEnough;

  String get onlineAcc;

  String get wifiPW;

  String get other;

  String get emailAcc;

  String get searchDot;

  String get appInfo;

  String get phoneNumber;

  String get phoneLoginWarning;

  String get verifyPhoneNumber;

  String get phoneLogin;

  String get enterVerificationCode;

  String get verificationCode;

  String get verifyCode;

  String get enteredVerificationCodeWrong;
}

enum Lang {
  german,
  english,
}

Lang _currentLang = Lang.english;

Language get currentLang => langToLanguage(_currentLang);

set currentLang(Language l) => _currentLang = languageToLang(l);

Language langToLanguage(Lang l) {
  switch (l) {
    case Lang.german:
      return German();
    case Lang.english:
      return English();
    default:
      return English();
  }
}

Lang languageToLang(Language l) {
  if (l is German)
    return Lang.german;
  else if (l is English)
    return Lang.english;
  else
    return Lang.english;
}
