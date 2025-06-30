RegExp amountRegex = RegExp(r'(rs\.?|inr\.?|₹)\s?([\d,]+(\.\d{1,2})?)', caseSensitive: false);

Map<String, dynamic> parseSms(String body) {
  double? amount;
  String? type;
  String? name;

  final lower = body.toLowerCase();

  // Original: reliable amount detection
  final match = amountRegex.firstMatch(body);
  if (match != null) {
    String raw = match.group(2)!.replaceAll(',', '');
    amount = double.tryParse(raw);
  }

  // Original: simple type detection
  if (lower.contains('debited') || lower.contains('credited')) {
    type = 'transaction';
  } else if (lower.contains('otp')) {
    type = 'otp';
  } else {
    type = 'other';
  }

  // ADD: Counterparty name extraction — only if transaction
  if (type == 'transaction') {
    final nameMatch = RegExp(r';\s+([A-Z][A-Z\s]{3,})\s+(credited|debited|via|on)', caseSensitive: false).firstMatch(body);
    if (nameMatch != null) {
      name = nameMatch.group(1)?.trim();
    }

    if (name == null) {
      final genericMatch = RegExp(
        r'(?:paid to|received from|sent to|from)\s+((?!Rs|INR|₹)[A-Z\s]{3,})',
        caseSensitive: false,
      ).firstMatch(body);

      if (genericMatch != null) {
        name = genericMatch.group(1)?.trim();
      }
    }
  }

  return {
    'amount': amount,
    'type': type,
    'name': name,
  };
}
