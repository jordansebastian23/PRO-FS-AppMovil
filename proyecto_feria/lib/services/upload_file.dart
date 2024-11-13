import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadFile {
  static const String baseUrl = 'http://192.168.1.90:8000';

  static Future<void> uploadFile({
    required File file,
    required String tramiteId,
    required String tipoArchivoId,
  }) async {
    final url = Uri.parse('$baseUrl/upload_file/');
    final mimeType = lookupMimeType(file.path);

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      Fluttertoast.showToast(
        msg: "Error: No token found. Please log in again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    print(tipoArchivoId);
    // Create the multipart request and include required fields
    final request = http.MultipartRequest('POST', url)
      ..headers['X-Auth-Token'] = token  // Add the token in headers
      ..fields['tramite_id'] = tramiteId
      ..fields['tipo_archivo_id'] = tipoArchivoId
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType!),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        print('File uploaded successfully: $responseBody');
        Fluttertoast.showToast(
          msg: "Archivo subido exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to upload file: ${response.statusCode}');
        print('Response body: $responseBody');
        Fluttertoast.showToast(
          msg: "Error al subir el archivo: ${response.statusCode} - $responseBody",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}