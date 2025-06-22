import 'dart:convert';
import 'package:shelf/shelf.dart';

class CommonData {
  static String encodeDataToJsonApi<T>(
    T data,
    Request response, {
    String message = 'Success',
    required bool isApiSuccess,
  }) {
    Map<String, dynamic> fixedValue = {
      'success': isApiSuccess,
      'message': message,
      'data': null,
    };
    if ((data is List<Map<String, dynamic>>) && data.isEmpty) {
      return '[]'; // Return an empty JSON array if no data is provided
    } else if (data is Map<String, dynamic> && data.isEmpty) {
      return jsonEncode(fixedValue); // Convert a single map to a JSON string
    } else if (data is List<Map<String, dynamic>> || data is List<dynamic>) {
      return jsonEncode(
        fixedValue..update('data', (value) => data),
      ); // Convert a list of maps to a JSON string
    } else if (data is String) {
      return data; // If the data is already a string, return it as is
    } else {
      throw Exception('Unsupported data type: ${data.runtimeType}');
    }
  }
}
