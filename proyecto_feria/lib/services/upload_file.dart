import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

Future<void> uploadFile(File file) async {
  // Ocupa URL del servidor local, cambiar si es necesario
  final url = Uri.parse('http://10.32.110.72:8000/upload_file/');  // Asegúrate de que esta URL sea correcta
  final mimeType = lookupMimeType(file.path);

  final request = http.MultipartRequest('POST', url)
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: MediaType.parse(mimeType!),
    ));

  final response = await request.send();

  if (response.statusCode == 201) {
    final responseBody = await response.stream.bytesToString();
    print('File uploaded successfully: $responseBody');
  } else {
    print('Failed to upload file: ${response.statusCode}');
  }
}