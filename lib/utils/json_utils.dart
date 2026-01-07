import 'dart:convert';

class JsonUtils {
  static String? encodeMap(Map<String, dynamic>? value) {
    if (value == null) return null;
    return jsonEncode(value);
  }

  static Map<String, dynamic> decodeMap(String? value) {
    if (value == null || value.isEmpty) return {};
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
