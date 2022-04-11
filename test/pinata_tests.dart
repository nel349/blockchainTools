import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_contract/pinata/pinata.dart';

void main() {

  const PINATA_API_KEY = '167c76e59775e6b354d9';
  const PINATA_SECRET_API_KEY = 'ee3cf789c187d15db5ad9fee72ccadd86bc45a2d2d2df36b4d5610faacb68133';
  test('pin to file', () async {
    dynamic options = {"sdfs": "sdfsdf"};

    File file = File("test_resources/nftResources/nft3.jpeg");
    String fileName = file.path.split('/').last;
    final bytes = await file.readAsBytes();
    final result = await Pinata().pinFileToIPFS(
        PINATA_API_KEY,
        PINATA_SECRET_API_KEY,
        bytes,
        fileName,
        options);

    expect(result?.data, isNotNull);
    expect(result?.data['IpfsHash'], isNotEmpty);
  });

  test('dio test', () async {

  });

  test('generate abi file from contract', () async {

  });

  test('test3', () {

  });
}