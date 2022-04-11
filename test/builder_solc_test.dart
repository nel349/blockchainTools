import 'package:flutter_test/flutter_test.dart';
import 'package:smart_contract/models/Contract.dart';
import 'package:smart_contract/services/builder_solc.dart';

void main() {
  test('read solidity file', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final str = await SolcBuilder.getFileContractAsString('test_resources/Investment.sol');
    expect(str, startsWith("// SPDX-License-Identifier: GPL-3.0\npragma solidity 0.5.16"));
  });

  test('build solc object after compilation', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final builder = SolcBuilder();
    final object = await builder.buildSolcObject();
    Contract contract = Contract.fromObject(object);
    expect(object, isNotNull);
    expect(contract, isNotNull);
    expect(contract.metadata, isNotEmpty);
  });

  test('generate abi file from contract', () async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    // final builder = SolcBuilder();
    // final object = await builder.buildSolcObject();
    // Contract contract = Contract.fromObject(object);

    // await builder.generateAbiFileFromContract(contract);
  });

  test('test3', () {

  });



}