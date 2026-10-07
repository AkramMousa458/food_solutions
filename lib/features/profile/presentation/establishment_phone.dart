class ArabPhoneCode {
  final String nameKey;
  final String dial;
  final String flag;
  final int minLength;
  final int maxLength;

  const ArabPhoneCode({
    required this.nameKey,
    required this.dial,
    required this.flag,
    required this.minLength,
    required this.maxLength,
  });

  String get displayCode => '+$dial';

  bool get isSaudi => dial == '966';
}

class EstablishmentPhone {
  static const ArabPhoneCode saudi = ArabPhoneCode(
    nameKey: 'phone_country_sa',
    dial: '966',
    flag: '🇸🇦',
    minLength: 9,
    maxLength: 9,
  );

  static const List<ArabPhoneCode> arabCodes = [
    ArabPhoneCode(
      nameKey: 'phone_country_dz',
      dial: '213',
      flag: '🇩🇿',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_bh',
      dial: '973',
      flag: '🇧🇭',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_km',
      dial: '269',
      flag: '🇰🇲',
      minLength: 7,
      maxLength: 7,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_dj',
      dial: '253',
      flag: '🇩🇯',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_eg',
      dial: '20',
      flag: '🇪🇬',
      minLength: 10,
      maxLength: 10,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_iq',
      dial: '964',
      flag: '🇮🇶',
      minLength: 10,
      maxLength: 10,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_jo',
      dial: '962',
      flag: '🇯🇴',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_kw',
      dial: '965',
      flag: '🇰🇼',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_lb',
      dial: '961',
      flag: '🇱🇧',
      minLength: 7,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_ly',
      dial: '218',
      flag: '🇱🇾',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_mr',
      dial: '222',
      flag: '🇲🇷',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_ma',
      dial: '212',
      flag: '🇲🇦',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_om',
      dial: '968',
      flag: '🇴🇲',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_ps',
      dial: '970',
      flag: '🇵🇸',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_qa',
      dial: '974',
      flag: '🇶🇦',
      minLength: 8,
      maxLength: 8,
    ),
    saudi,
    ArabPhoneCode(
      nameKey: 'phone_country_so',
      dial: '252',
      flag: '🇸🇴',
      minLength: 8,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_sd',
      dial: '249',
      flag: '🇸🇩',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_sy',
      dial: '963',
      flag: '🇸🇾',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_tn',
      dial: '216',
      flag: '🇹🇳',
      minLength: 8,
      maxLength: 8,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_ae',
      dial: '971',
      flag: '🇦🇪',
      minLength: 9,
      maxLength: 9,
    ),
    ArabPhoneCode(
      nameKey: 'phone_country_ye',
      dial: '967',
      flag: '🇾🇪',
      minLength: 9,
      maxLength: 9,
    ),
  ];

  static ArabPhoneCode byDial(String dial) {
    for (final code in arabCodes) {
      if (code.dial == dial) return code;
    }
    return saudi;
  }

  static ArabPhoneCode match(String? raw) {
    var digits = _digits(raw);
    if (digits.startsWith('00')) digits = digits.substring(2);
    ArabPhoneCode? match;
    for (final code in arabCodes) {
      if (!digits.startsWith(code.dial)) continue;
      final national = digits.substring(code.dial.length);
      if (national.length < code.minLength) continue;
      if (match == null || code.dial.length > match.dial.length) match = code;
    }
    return match ?? saudi;
  }

  static String local(String? raw, ArabPhoneCode code) {
    var digits = _digits(raw);
    if (digits.startsWith('00${code.dial}')) {
      digits = digits.substring(code.dial.length + 2);
    } else if (digits.startsWith(code.dial) && digits.length > code.maxLength) {
      digits = digits.substring(code.dial.length);
    }
    if (digits.startsWith('0')) digits = digits.substring(1);
    if (digits.length > code.maxLength) {
      digits = digits.substring(0, code.maxLength);
    }
    return digits;
  }

  static String international(String? raw, ArabPhoneCode code) {
    final digits = local(raw, code);
    if (digits.isEmpty) return '';
    return '${code.displayCode}$digits';
  }

  static bool isValid(String? raw, ArabPhoneCode code) {
    final digits = local(raw, code);
    if (digits.length < code.minLength || digits.length > code.maxLength) {
      return false;
    }
    if (code.isSaudi && !digits.startsWith('5')) return false;
    return true;
  }

  static String _digits(String? raw) {
    return (raw ?? '').replaceAll(RegExp(r'\D'), '');
  }
}
