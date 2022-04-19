import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

const PINATA_API_KEY = '167c76e59775e6b354d9';
const PINATA_SECRET_API_KEY = 'ee3cf789c187d15db5ad9fee72ccadd86bc45a2d2d2df36b4d5610faacb68133';

class Pinata {
  static String endpoint = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

  Dio? dio;

  Pinata() {
    dio = Dio();
  }

  Future<Response<dynamic>?> pinFileToIPFS(File file, dynamic options) async {
    String fileName = file.path.split('/').last;
    final bytes = await file.readAsBytes();
    final response = await _pinFileToIPFS(PINATA_API_KEY, PINATA_SECRET_API_KEY, bytes, fileName, options);
    if (response?.statusCode != 200) {
      throw DioError(requestOptions: options);
    }
    return response;
  }

  Future<Response<dynamic>?> _pinFileToIPFS(String pinataApiKey, String pinataSecretApiKey,
      Uint8List bytes, String fileName,  dynamic options) async {

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes, filename:fileName),
    });

    if (options != null) {
      if (options['pinataMetadata'] != null ) {
        formData.fields.add(MapEntry("pinataMetadata", jsonEncode(options['pinataMetadata'])));
      }
      // if (options['pinataOptions'] != null ) {
      //   formData.fields.add(MapEntry("pinataOptions", jsonEncode(options['pinataOptions'])));
      // }
    }

    Response? response;
    await dio?.post(
      endpoint,
      data: formData,
      options: Options(
      //   extra: {
      //     'withCredential': true,
      //     'maxContentLength': 'Infinity', //this is needed to prevent axios from erroring out with large files
      //     'maxBodyLength': 'Infinity'
      //
      //   },
        headers: {
          'pinata_api_key': pinataApiKey,
          'pinata_secret_api_key': pinataSecretApiKey
        },
          contentType: 'multipart/form-data; boundary=${formData.boundary}'
      ),
    ).catchError((e){
      print('Got error: $e');
    });

    return response;
  }
}