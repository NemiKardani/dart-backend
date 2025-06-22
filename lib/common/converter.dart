// Common function to process and filter received data
import 'dart:convert';

import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';

class FilterData {

static Future<Map<String, dynamic>> processReceivedData(Request request, List<String> requiredFields) async {
  final contentType = request.headers['Content-Type'];
  Map<String, dynamic> extractedData = {};
  
  if (contentType != null && contentType.contains('multipart/form-data')) {
    // Handle multipart/form-data
    final boundary = _getBoundary(contentType);
    final transformer = MimeMultipartTransformer(boundary);
    final parts = await transformer.bind(request.read()).toList();

    for (final part in parts) {
      final contentDisposition = part.headers['content-disposition'];
      final nameMatch = RegExp(r'name="([^"]*)"').firstMatch(contentDisposition ?? '');

      if (nameMatch != null) {
        final field = nameMatch.group(1);
        final value = await utf8.decoder.bind(part).join();
        
        if (requiredFields.contains(field)) {
          extractedData[field!] = value;
        }
      }
    }
    return extractedData;
  } else {
    // Handle JSON body
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    
    for (String field in requiredFields) {
      if (data.containsKey(field)) {
        extractedData[field] = data[field].toString();
      }
    }

    return extractedData;
  }
  
  
}

static String _getBoundary(String contentType) {
    final match = RegExp(r'boundary=(.*)').firstMatch(contentType);
    if (match != null) {
      return match.group(1)!;
    } else {
      throw Exception('No boundary found in content-type');
    }
  }
}


