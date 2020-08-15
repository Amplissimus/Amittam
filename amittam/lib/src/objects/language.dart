import 'package:Amittam/src/libs/lib.dart';
import 'package:Amittam/src/libs/prefslib.dart';

import 'langs/english.dart';
import 'langs/german.dart';

abstract class Language {
  String get appTitle => 'Amittam';

  String get versionString => '1.2.0';

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

  String get signInWithGoogle;

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

  String get searchDot;

  String get appInfo;

  String get fieldIsEmpty;

  String get mailAddress;

  String get confirmMasterPW;

  String get enterMasterPW;

  String get logIn;

  String get enteredPWIsWrong;

  String get editMasterPassword;

  String get proceedByUsingOnlineData;

  String get proceedByUsingOnlineDataDesc;

  String get proceedByUsingLocalData;

  String get proceedByUsingLocalDataDesc;

  String get useLocalStoredData;

  String get useOnlineStoredData;

  String get notesOptional;

  String get deletePassword;

  String get deletion;

  String get finishLogin;

  String get showQr;

  String get reallyDeletePassword;

  String get scanOptimized;

  String get displayPassword;

  String get requestedText;

  String get resetActionRequest;

  String deleteSelectedPasswordsWarning(bool multiple);

  String firstLoginConfirmPW(String s);

  String pwTypeToString(PasswordType pwType);
}

enum Lang {
  german,
  english,
}

Lang _currentLang = Lang.english;

Language get currentLang => langToLanguage(_currentLang);

set currentLang(Language l) {
  _currentLang = languageToLang(l);
  Prefs.lang = languageToLang(l);
}

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
