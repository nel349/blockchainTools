import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';


//REMOVE KEYS and replace with personal api keys.
const PINATA_API_KEY = '167c76e59775e6b354d9';
const PINATA_SECRET_API_KEY = 'ee3cf789c187d15db5ad9fee72ccadd86bc45a2d2d2df36b4d5610faacb68133';

class Pinata {
  static String postFileEndpoint = 'https://api.pinata.cloud/pinning/pinFileToIPFS';
  static String postJsonEndpoint = 'https://api.pinata.cloud/pinning/pinJSONToIPFS';
  Dio? dio;

  Pinata() {
    dio = Dio();
  }

  Future<Response<dynamic>?> pinFileToIPFS({File? file, dynamic options = const {}}) async {
    String? fileName = file?.path.split('/').last;
    final bytes = await file?.readAsBytes();
    var response;
    if (bytes != null ) {
      response = await _pinFileToIPFS(PINATA_API_KEY, PINATA_SECRET_API_KEY, bytes, fileName = fileName ?? "noName", options);
    }

    return response;
  }

  Future<Response<dynamic>?> _pinFileToIPFS(String pinataApiKey, String pinataSecretApiKey,
      Uint8List bytes, String fileName,  dynamic options) async {

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes, filename:fileName),
    });
    return await dio?.post(
      postFileEndpoint,
      data: formData,
      options: Options(
        headers: {
          'pinata_api_key': pinataApiKey,
          'pinata_secret_api_key': pinataSecretApiKey
        },
          contentType: 'multipart/form-data; boundary=${formData.boundary}'
      ),
    ).catchError((e){
      print('Got error: $e');
    });
  }

  Future<Response<dynamic>?> pinJSONToIPFS(dynamic json) async {
    return await dio?.post(
      postJsonEndpoint,
      data: json,
      options: Options(
          headers: {
            'pinata_api_key': PINATA_API_KEY,
            'pinata_secret_api_key': PINATA_SECRET_API_KEY
          },
      ),
    ).catchError((e){
      print('Got error: $e');
    });
  }
}