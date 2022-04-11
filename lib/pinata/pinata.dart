import 'dart:typed_data';
import 'package:dio/dio.dart';

class Pinata {
  static String endpoint = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

  Dio? dio;

  Pinata() {
    dio = Dio();
  }

  Future<Response<dynamic>?> pinFileToIPFS(String pinataApiKey, String pinataSecretApiKey,
      Uint8List bytes, String fileName,  dynamic options) async {

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes, filename:fileName),
    });

    // if (options != null) {
    //   if (options['pinataMetadata'] != null ) {
    //     formData.fields.add(MapEntry("pinataMetadata", jsonEncode(options['pinataMetadata'])));
    //   }
    //   if (options['pinataOptions'] != null ) {
    //     formData.fields.add(MapEntry("pinataOptions", jsonEncode(options['pinataOptions'])));
    //   }
    // }

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
    ).then((value) {
      response = value;
      if (response?.statusCode != 200) {
        throw DioError(requestOptions: options);
      }
    }).catchError((e){
      print('Got error: $e');
    });

    return response;
  }
}