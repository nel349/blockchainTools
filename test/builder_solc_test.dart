import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_contract/services/builder_solc.dart';

void main() {


  test('read solidity file', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final builder = SolcBuilder();
    final str = await builder.getFileContractAsString('test_resources/Investment.sol');

    expect(str, startsWith("// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.5.16"));
  });

  test('test1', () {

  });

  test('test2', () {

  });

  test('test3', () {

  });



}