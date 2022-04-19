import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_contract/pinata/metadata.dart';
import 'package:smart_contract/pinata/pinata.dart';
import 'package:smart_contract/utils.dart';

void main() {
  test('pin to file', () async {
    dynamic options = {"sdfs": "sdfsdf"};

    File file = File("test_resources/nftResources/nft3.jpeg");
    final actual = await Pinata().pinFileToIPFS(file: file, options: options);

    expect(actual?.data, isNotNull);
    expect(actual?.data['IpfsHash'], isNotEmpty);
  });

  test('generate metadata', () async {
      Metadata metadata = Metadata()
          ..name = "testName"
          ..image = "testImage"
          ..externalUrl = "testExternalImage"
          ..description = "testDescription";

      Utils.writeFile('test_resources/nftResources/metadata.json', metadata.toJson());
  });

  test('upload metadata to Pinata', () async {
    final pinataOptions = PinataOptions();
    final pinataMetadata = PinataMetadata()
      ..name = "NFTmetaDataFileName";

    Metadata metadata = Metadata()
      ..name = "nftName"
      ..image = "nftImage"
      ..externalUrl = "NFTExternalImage"
      ..description = "nftDescription";

    final jsonBody = {
      "pinataOptions" : pinataOptions.toJson(),
      "pinataMetadata" : pinataMetadata.toJson(),
      "pinataContent" : metadata
    };

    final actual = await Pinata().pinJSONToIPFS(jsonBody);

    expect(actual?.data, isNotNull);
    expect(actual?.data['IpfsHash'], isNotEmpty);
  });

  test('test3', () {

  });
}