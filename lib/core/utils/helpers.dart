import 'dart:convert';

double toDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

T decodeOrDefault<T>(
    dynamic value, T defaultValue, T Function(dynamic) converter) {
  if (value == null) return defaultValue;
  if (value is String) {
    try {
      final decoded = json.decode(value);
      return converter(decoded);
    } catch (e) {
      return defaultValue;
    }
  }
  return converter(value);
}

 final Map<String, String> _htmlEntities = {
    // Basic HTML Entities
    '&quot;': '"',
    '&amp;': '&',
    '&lt;': '<',
    '&gt;': '>',
    '&nbsp;': ' ',

    // Currency Symbols
    '&pound;': '£',
    '&euro;': '€',
    '&dollar;': '\$',
    '&cent;': '¢',
    '&yen;': '¥',

    // Typography and Punctuation
    '&copy;': '©',
    '&reg;': '®',
    '&trade;': '™',
    '&times;': '×',
    '&divide;': '÷',
    '&plusmn;': '±',
    '&micro;': 'µ',
    '&middot;': '·',
    '&deg;': '°',
    '&acute;': '´',
    '&cedil;': '¸',

    // Quotation Marks and Apostrophes
    '&#39;': "'",
    '&apos;': "'",
    '&laquo;': '«',
    '&raquo;': '»',
    '&ldquo;': '"',
    '&rdquo;': '"',
    '&lsquo;': ''',
    '&rsquo;': ''',

    // Mathematical and Technical Symbols
    '&fnof;': 'ƒ',
    '&ordf;': 'ª',
    '&ordm;': 'º',
    '&not;': '¬',
    '&shy;': '­',
    '&macr;': '¯',
    '&sup1;': '¹',
    '&sup2;': '²',
    '&sup3;': '³',

    // Accented Letters and Special Characters
    '&Agrave;': 'À', '&agrave;': 'à',
    '&Aacute;': 'Á', '&aacute;': 'á',
    '&Acirc;': 'Â', '&acirc;': 'â',
    '&Atilde;': 'Ã', '&atilde;': 'ã',
    '&Auml;': 'Ä', '&auml;': 'ä',
    '&Aring;': 'Å', '&aring;': 'å',
    '&AElig;': 'Æ', '&aelig;': 'æ',

    '&Ccedil;': 'Ç', '&ccedil;': 'ç',

    '&Egrave;': 'È', '&egrave;': 'è',
    '&Eacute;': 'É', '&eacute;': 'é',
    '&Ecirc;': 'Ê', '&ecirc;': 'ê',
    '&Euml;': 'Ë', '&euml;': 'ë',

    '&Igrave;': 'Ì', '&igrave;': 'ì',
    '&Iacute;': 'Í', '&iacute;': 'í',
    '&Icirc;': 'Î', '&icirc;': 'î',
    '&Iuml;': 'Ï', '&iuml;': 'ï',

    '&Ntilde;': 'Ñ', '&ntilde;': 'ñ',

    '&Ograve;': 'Ò', '&ograve;': 'ò',
    '&Oacute;': 'Ó', '&oacute;': 'ó',
    '&Ocirc;': 'Ô', '&ocirc;': 'ô',
    '&Otilde;': 'Õ', '&otilde;': 'õ',
    '&Ouml;': 'Ö', '&ouml;': 'ö',

    '&Ugrave;': 'Ù', '&ugrave;': 'ù',
    '&Uacute;': 'Ú', '&uacute;': 'ú',
    '&Ucirc;': 'Û', '&ucirc;': 'û',
    '&Uuml;': 'Ü', '&uuml;': 'ü',

    '&Yacute;': 'Ý', '&yacute;': 'ý',
    '&yuml;': 'ÿ',

    // Fractions and Symbols
    '&frac14;': '¼',
    '&frac12;': '½',
    '&frac34;': '¾',

    // Space and Special Whitespace
    '&ensp;': ' ', // En space
    '&emsp;': ' ', // Em space
    '&thinsp;': ' ', // Thin space

    // Arrows and Miscellaneous Symbols
    '&larr;': '←',
    '&uarr;': '↑',
    '&rarr;': '→',
    '&darr;': '↓',
    '&harr;': '↔',
  };

String decodeHtmlEntities(String input) {
  String decoded = input;
  _htmlEntities.forEach((entity, replacement) {
    decoded = decoded.replaceAll(entity, replacement);
  });

  // Handle numeric HTML entities
  decoded = decoded.replaceAllMapped(
    RegExp(r'&#(\d+);'),
    (match) => String.fromCharCode(int.parse(match.group(1)!)),
  );

  // Handle hexadecimal HTML entities
  decoded = decoded.replaceAllMapped(
    RegExp(r'&#x([0-9a-fA-F]+);'),
    (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
  );

  return decoded;
}
