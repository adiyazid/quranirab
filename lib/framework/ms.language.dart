import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_custom.dart' as date_symbol_data_custom;
import 'package:intl/date_symbols.dart' as intl;
import 'package:intl/intl.dart' as intl;

/// A custom set of date patterns for the `nn` locale.
///
/// These are not accurate and are just a clone of the date patterns for the
/// `no` locale to demonstrate how one would write and use custom date patterns.
// #docregion Date
const msLocaleDatePatterns = {
  'd': 'd.',
  'E': 'ccc',
  'EEEE': 'cccc',
  'LLL': 'LLL',
// #enddocregion Date
  'LLLL': 'LLLL',
  'M': 'L.',
  'Md': 'd.M.',
  'MEd': 'EEE d.M.',
  'MMM': 'LLL',
  'MMMd': 'd. MMM',
  'MMMEd': 'EEE d. MMM',
  'MMMM': 'LLLL',
  'MMMMd': 'd. MMMM',
  'MMMMEEEEd': 'EEEE d. MMMM',
  'QQQ': 'QQQ',
  'QQQQ': 'QQQQ',
  'y': 'y',
  'yM': 'M.y',
  'yMd': 'd.M.y',
  'yMEd': 'EEE d.MM.y',
  'yMMM': 'MMM y',
  'yMMMd': 'd. MMM y',
  'yMMMEd': 'EEE d. MMM y',
  'yMMMM': 'MMMM y',
  'yMMMMd': 'd. MMMM y',
  'yMMMMEEEEd': 'EEEE d. MMMM y',
  'yQQQ': 'QQQ y',
  'yQQQQ': 'QQQQ y',
  'H': 'HH',
  'Hm': 'HH:mm',
  'Hms': 'HH:mm:ss',
  'j': 'HH',
  'jm': 'HH:mm',
  'jms': 'HH:mm:ss',
  'jmv': 'HH:mm v',
  'jmz': 'HH:mm z',
  'jz': 'HH z',
  'm': 'm',
  'ms': 'mm:ss',
  's': 's',
  'v': 'v',
  'z': 'z',
  'zzzz': 'zzzz',
  'ZZZZ': 'ZZZZ',
};

/// A custom set of date symbols for the `nn` locale.
///
/// These are not accurate and are just a clone of the date symbols for the
/// `no` locale to demonstrate how one would write and use custom date symbols.
// #docregion Date2
const msDateSymbols = {
  'NAME': 'ms',
  'ERAS': <dynamic>[
    'f.Kr.',
    'e.Kr.',
  ],
// #enddocregion Date2
  'ERANAMES': <dynamic>[
    'før Kristus',
    'etter Kristus',
  ],
  'NARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'STANDALONENARROWMONTHS': <dynamic>[
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ],
  'MONTHS': <dynamic>[
    'januari',
    'februari',
    'mac',
    'april',
    'mei',
    'jun',
    'julai',
    'ogos',
    'september',
    'oktober',
    'november',
    'disember',
  ],
  'STANDALONEMONTHS': <dynamic>[
    'januari',
    'februari',
    'mac',
    'april',
    'mei',
    'jun',
    'julai',
    'ogos',
    'september',
    'oktober',
    'november',
    'disember',
  ],
  'SHORTMONTHS': <dynamic>[
    'jan',
    'feb',
    'mac',
    'apr',
    'mei',
    'jun',
    'jul',
    'ogos',
    'sept',
    'okt',
    'nov',
    'dis',
  ],
  'STANDALONESHORTMONTHS': <dynamic>[
    'jan',
    'feb',
    'mac',
    'apr',
    'mei',
    'jun',
    'jul',
    'ogos',
    'sept',
    'okt',
    'nov',
    'dis',
  ],
  'WEEKDAYS': <dynamic>[
    'ahad',
    'isnin',
    'selasa',
    'rabu',
    'khamis',
    'jumaat',
    'sabtu',
  ],
  'STANDALONEWEEKDAYS': <dynamic>[
    'ahad',
    'isnin',
    'selasa',
    'rabu',
    'khamis',
    'jumaat',
    'sabtu',
  ],
  'SHORTWEEKDAYS': <dynamic>[
    'ahad',
    'isnin',
    'sel',
    'rabu',
    'kha',
    'jum',
    'sab',
  ],
  'STANDALONESHORTWEEKDAYS': <dynamic>[
    'ahad',
    'isnin',
    'sel',
    'rabu',
    'kha',
    'jum',
    'sab',
  ],
  'NARROWWEEKDAYS': <dynamic>[
    'A',
    'I',
    'S',
    'R',
    'K',
    'J',
    'S',
  ],
  'STANDALONENARROWWEEKDAYS': <dynamic>[
    'A',
    'I',
    'S',
    'R',
    'K',
    'J',
    'S',
  ],
  'SHORTQUARTERS': <dynamic>[
    'K1',
    'K2',
    'K3',
    'K4',
  ],
  'QUARTERS': <dynamic>[
    '1. kvartal',
    '2. kvartal',
    '3. kvartal',
    '4. kvartal',
  ],
  'AMPMS': <dynamic>[
    'a.m.',
    'p.m.',
  ],
  'DATEFORMATS': <dynamic>[
    'EEEE d. MMMM y',
    'd. MMMM y',
    'd. MMM y',
    'dd.MM.y',
  ],
  'TIMEFORMATS': <dynamic>[
    'HH:mm:ss zzzz',
    'HH:mm:ss z',
    'HH:mm:ss',
    'HH:mm',
  ],
  'AVAILABLEFORMATS': null,
  'FIRSTDAYOFWEEK': 0,
  'WEEKENDRANGE': <dynamic>[
    5,
    6,
  ],
  'FIRSTWEEKCUTOFFDAY': 3,
  'DATETIMEFORMATS': <dynamic>[
    '{1} {0}',
    '{1} \'kl\'. {0}',
    '{1}, {0}',
    '{1}, {0}',
  ],
};

// #docregion Delegate
class _MsMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MsMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ms';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final String localeName = intl.Intl.canonicalizedLocale(locale.toString());

    // The locale (in this case `nn`) needs to be initialized into the custom
    // date symbols and patterns setup that Flutter uses.
    date_symbol_data_custom.initializeDateFormattingCustom(
      locale: localeName,
      patterns: msLocaleDatePatterns,
      symbols: intl.DateSymbols.deserializeFromMap(msDateSymbols),
    );

    return SynchronousFuture<MaterialLocalizations>(
      MsMaterialLocalizations(
        localeName: localeName,
        // The `intl` library's NumberFormat class is generated from CLDR data
        // (see https://github.com/dart-lang/intl/blob/master/lib/number_symbols_data.dart).
        // Unfortunately, there is no way to use a locale that isn't defined in
        // this map and the only way to work around this is to use a listed
        // locale's NumberFormat symbols. So, here we use the number formats
        // for 'en_US' instead.
        decimalFormat: intl.NumberFormat('#,##0.###', 'en_US'),
        twoDigitZeroPaddedFormat: intl.NumberFormat('00', 'en_US'),
        // DateFormat here will use the symbols and patterns provided in the
        // `date_symbol_data_custom.initializeDateFormattingCustom` call above.
        // However, an alternative is to simply use a supported locale's
        // DateFormat symbols, similar to NumberFormat above.
        fullYearFormat: intl.DateFormat('y', localeName),
        compactDateFormat: intl.DateFormat('yMd', localeName),
        shortDateFormat: intl.DateFormat('yMMMd', localeName),
        mediumDateFormat: intl.DateFormat('EEE, MMM d', localeName),
        longDateFormat: intl.DateFormat('EEEE, MMMM d, y', localeName),
        yearMonthFormat: intl.DateFormat('MMMM y', localeName),
        shortMonthDayFormat: intl.DateFormat('MMM d'),
      ),
    );
  }

  @override
  bool shouldReload(_MsMaterialLocalizationsDelegate old) => false;
}
// #enddocregion Delegate

/// A custom set of localizations for the 'nn' locale. In this example, only
/// the value for openAppDrawerTooltip was modified to use a custom message as
/// an example. Everything else uses the American English (en_US) messages
/// and formatting.
class MsMaterialLocalizations extends GlobalMaterialLocalizations {
  MsMaterialLocalizations(
      {required String localeName,
      required intl.NumberFormat twoDigitZeroPaddedFormat,
      required intl.DateFormat fullYearFormat,
      required intl.DateFormat compactDateFormat,
      required intl.NumberFormat decimalFormat,
      required intl.DateFormat shortDateFormat,
      required intl.DateFormat mediumDateFormat,
      required intl.DateFormat longDateFormat,
      required intl.DateFormat yearMonthFormat,
      required intl.DateFormat shortMonthDayFormat})
      : super(
            localeName: localeName,
            twoDigitZeroPaddedFormat: twoDigitZeroPaddedFormat,
            fullYearFormat: fullYearFormat,
            compactDateFormat: compactDateFormat,
            decimalFormat: decimalFormat,
            shortDateFormat: shortDateFormat,
            mediumDateFormat: mediumDateFormat,
            longDateFormat: longDateFormat,
            yearMonthFormat: yearMonthFormat,
            shortMonthDayFormat: shortMonthDayFormat);

// #docregion Getters
  @override
  String get moreButtonTooltip => r'Lagi';

  @override
  String get aboutListTileTitleRaw => r'Tentang $applicationName';

  @override
  String get alertDialogLabel => r'Amaran';

// #enddocregion Getters

  @override
  String get anteMeridiemAbbreviation => r'AM';

  @override
  String get backButtonTooltip => r'Kembali';

  @override
  String get cancelButtonLabel => r'Batal';

  @override
  String get closeButtonLabel => r'TUTUP';

  @override
  String get closeButtonTooltip => r'tutup';

  @override
  String get collapsedIconTapHint => r'Buka';

  @override
  String get continueButtonLabel => r'TERUSKAN';

  @override
  String get copyButtonLabel => r'SALIN';

  @override
  String get cutButtonLabel => r'POTONG';

  @override
  String get deleteButtonTooltip => r'Padam';

  @override
  String get dialogLabel => r'Dialog';

  @override
  String get drawerLabel => r'Alur halaman';

  @override
  String get expandedIconTapHint => r'Tutup';

  @override
  String get firstPageTooltip => r'Muka Surat Pertama';

  @override
  String get hideAccountsLabel => r'Sembunyi akaun';

  @override
  String get lastPageTooltip => r'Muka Surat Terakhir';

  @override
  String get licensesPageTitle => r'Lesen';

  @override
  String get modalBarrierDismissLabel => r'Hilang';

  @override
  String get nextMonthTooltip => r'Bulan Hadapan';

  @override
  String get nextPageTooltip => r'Muka Surat Seterusnya';

  @override
  String get okButtonLabel => r'OK';

  @override
  // A custom drawer tooltip message.
  String get openAppDrawerTooltip => r'Bantuan Alur Halaman Kustom';

// #docregion Raw
  @override
  String get pageRowsInfoTitleRaw => r'$firstRow–$lastRow dari $rowCount';

  @override
  String get pageRowsInfoTitleApproximateRaw =>
      r'$firstRow–$lastRow daripada $rowCount';

// #enddocregion Raw

  @override
  String get pasteButtonLabel => r'TAMPAL';

  @override
  String get popupMenuLabel => r'Halaman muncul';

  @override
  String get postMeridiemAbbreviation => r'PM';

  @override
  String get previousMonthTooltip => r'Bulan Lepas';

  @override
  String get previousPageTooltip => r'Muka Surat sebelumnya';

  @override
  String get refreshIndicatorSemanticLabel => r'Segarkan';

  @override
  String? get remainingTextFieldCharacterCountFew => null;

  @override
  String? get remainingTextFieldCharacterCountMany => null;

  @override
  String get remainingTextFieldCharacterCountOne => r'1 karakter yang tinggal';

  @override
  String get remainingTextFieldCharacterCountOther =>
      r'$remainingCount karakter yang tinggal';

  @override
  String? get remainingTextFieldCharacterCountTwo => null;

  @override
  String get remainingTextFieldCharacterCountZero => r'Tiada karakter yang tinggal';

  @override
  String get reorderItemDown => r'Gerak bawah';

  @override
  String get reorderItemLeft => r'Gerak kiri';

  @override
  String get reorderItemRight => r'Gerak kanan';

  @override
  String get reorderItemToEnd => r'Gerak ke hujung';

  @override
  String get reorderItemToStart => r'Gerak ke garisan mula';

  @override
  String get reorderItemUp => r'Gerak keatas';

  @override
  String get rowsPerPageTitle => r'Jalur per muka surat:';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.englishLike;

  @override
  String get searchFieldLabel => r'Carian';

  @override
  String get selectAllButtonLabel => r'PLIH SEMUA';

  @override
  String? get selectedRowCountTitleFew => null;

  @override
  String? get selectedRowCountTitleMany => null;

  @override
  String get selectedRowCountTitleOne => r'1 barang yang dipilih';

  @override
  String get selectedRowCountTitleOther => r'$selectedRowCount barangan yang dipilih';

  @override
  String? get selectedRowCountTitleTwo => null;

  @override
  String get selectedRowCountTitleZero => r'Tiada barangan yang dipilih';

  @override
  String get showAccountsLabel => r'Tunjuk akaun';

  @override
  String get showMenuTooltip => r'Tunjuk Halaman';

  @override
  String get signedInLabel => r'Log Masuk';

  @override
  String get tabLabelRaw => r'Tab $tabIndex  $tabCount';

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;

  @override
  String get timePickerHourModeAnnouncement => r'Pilih Jam';

  @override
  String get timePickerMinuteModeAnnouncement => r'Pilih minit';

  @override
  String get viewLicensesButtonLabel => r'TUNJUK LESEN';

  @override
  List<String> get narrowWeekdays =>
      const <String>['A', 'I', 'S', 'R', 'K', 'J', 'S'];

  @override
  int get firstDayOfWeekIndex => 0;

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _MsMaterialLocalizationsDelegate();

  @override
  String get calendarModeButtonLabel => r'Tukar ke Kalender';

  @override
  String get dateHelpText => r'mm/dd/yyyy';

  @override
  String get dateInputLabel => r'Masukkan Tarikh';

  @override
  String get dateOutOfRangeLabel => r'Luar dari jankauan.';

  @override
  String get datePickerHelpText => r'PILIH TARIKH';

  @override
  String get dateRangeEndDateSemanticLabelRaw => r'Tarikh akhir $fullDate';

  @override
  String get dateRangeEndLabel => r'Tarikh akhir';

  @override
  String get dateRangePickerHelpText => 'PILIH DARI JARAK';

  @override
  String get dateRangeStartDateSemanticLabelRaw => 'Tarikh mula \$fullDate';

  @override
  String get dateRangeStartLabel => 'Tarikh mula';

  @override
  String get dateSeparator => '/';

  @override
  String get dialModeButtonLabel => 'Tukar ke mod memanggil';

  @override
  String get inputDateModeButtonLabel => 'Tukar ke data masukkan';

  @override
  String get inputTimeModeButtonLabel => 'Tukar ke text masukkan';

  @override
  String get invalidDateFormatLabel => 'Format Salah.';

  @override
  String get invalidDateRangeLabel => 'Luar Jangkauan.';

  @override
  String get invalidTimeLabel => 'Masukkan masa yang sah';

  @override
  String get licensesPackageDetailTextOther => '\$licenseCount lesen';

  @override
  String get saveButtonLabel => 'SIMPAN';

  @override
  String get selectYearSemanticsLabel => 'PILIH TAHUN';

  @override
  String get timePickerDialHelpText => 'PILIH MASA';

  @override
  String get timePickerHourLabel => 'Jam';

  @override
  String get timePickerInputHelpText => 'PILIH MASA';

  @override
  String get timePickerMinuteLabel => 'Minit';

  @override
  String get unspecifiedDate => 'Tarikh';

  @override
  String get unspecifiedDateRange => 'Jarak tarikh';

  @override
  // TODO: implement keyboardKeyAlt
  String get keyboardKeyAlt => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyAltGraph
  String get keyboardKeyAltGraph => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyBackspace
  String get keyboardKeyBackspace => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyCapsLock
  String get keyboardKeyCapsLock => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyChannelDown
  String get keyboardKeyChannelDown => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyChannelUp
  String get keyboardKeyChannelUp => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyControl
  String get keyboardKeyControl => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyDelete
  String get keyboardKeyDelete => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyEisu
  String get keyboardKeyEisu => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyEject
  String get keyboardKeyEject => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyEnd
  String get keyboardKeyEnd => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyEscape
  String get keyboardKeyEscape => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyFn
  String get keyboardKeyFn => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHangulMode
  String get keyboardKeyHangulMode => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHanjaMode
  String get keyboardKeyHanjaMode => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHankaku
  String get keyboardKeyHankaku => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHiragana
  String get keyboardKeyHiragana => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHiraganaKatakana
  String get keyboardKeyHiraganaKatakana => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyHome
  String get keyboardKeyHome => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyInsert
  String get keyboardKeyInsert => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyKanaMode
  String get keyboardKeyKanaMode => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyKanjiMode
  String get keyboardKeyKanjiMode => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyKatakana
  String get keyboardKeyKatakana => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyMeta
  String get keyboardKeyMeta => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyMetaMacOs
  String get keyboardKeyMetaMacOs => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyMetaWindows
  String get keyboardKeyMetaWindows => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumLock
  String get keyboardKeyNumLock => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad0
  String get keyboardKeyNumpad0 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad1
  String get keyboardKeyNumpad1 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad2
  String get keyboardKeyNumpad2 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad3
  String get keyboardKeyNumpad3 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad4
  String get keyboardKeyNumpad4 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad5
  String get keyboardKeyNumpad5 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad6
  String get keyboardKeyNumpad6 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad7
  String get keyboardKeyNumpad7 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad8
  String get keyboardKeyNumpad8 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpad9
  String get keyboardKeyNumpad9 => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadAdd
  String get keyboardKeyNumpadAdd => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadComma
  String get keyboardKeyNumpadComma => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadDecimal
  String get keyboardKeyNumpadDecimal => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadDivide
  String get keyboardKeyNumpadDivide => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadEnter
  String get keyboardKeyNumpadEnter => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadEqual
  String get keyboardKeyNumpadEqual => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadMultiply
  String get keyboardKeyNumpadMultiply => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadParenLeft
  String get keyboardKeyNumpadParenLeft => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadParenRight
  String get keyboardKeyNumpadParenRight => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyNumpadSubtract
  String get keyboardKeyNumpadSubtract => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyPageDown
  String get keyboardKeyPageDown => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyPageUp
  String get keyboardKeyPageUp => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyPower
  String get keyboardKeyPower => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyPowerOff
  String get keyboardKeyPowerOff => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyPrintScreen
  String get keyboardKeyPrintScreen => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyRomaji
  String get keyboardKeyRomaji => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyScrollLock
  String get keyboardKeyScrollLock => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeySelect
  String get keyboardKeySelect => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeySpace
  String get keyboardKeySpace => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyZenkaku
  String get keyboardKeyZenkaku => throw UnimplementedError();

  @override
  // TODO: implement keyboardKeyZenkakuHankaku
  String get keyboardKeyZenkakuHankaku => throw UnimplementedError();

}
