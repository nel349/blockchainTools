import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_contract/pinata/metadata.dart';
import 'package:smart_contract/pinata/pinata.dart';
import 'package:smart_contract/utils.dart';

void main() {

  const PINATA_API_KEY = '167c76e59775e6b354d9';
  const PINATA_SECRET_API_KEY = 'ee3cf789c187d15db5ad9fee72ccadd86bc45a2d2d2df36b4d5610faacb68133';
  test('pin to file', () async {
    dynamic options = {"sdfs": "sdfsdf"};

    File file = File("test_resources/nftResources/nft3.jpeg");
    final result = await Pinata().pinFileToIPFS(file, options);

    expect(result?.data, isNotNull);
    expect(result?.data['IpfsHash'], isNotEmpty);
  });

  test('generate metadata', () async {
      Metadata metadata = Metadata()
          ..name = "testName"
          ..image = "testImage"
          ..externalUrl = "testExternalImage"
          ..description = "testDescription";

      Utils.writeFile('test_resources/nftResources/metadata.json', metadata.toJson());
  });

  test('generate abi file from contract', () async {

  });

  test('test3', () {

  });
}