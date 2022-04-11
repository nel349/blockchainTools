import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/Contract.dart';

class SolcBuilder {
  Map<String, String>? params;

  String? documentsPath;

  String? tempPath;

  SolcBuilder({this.params});

  Future<Object?> buildSolcObject() async {
    var myData = json.decode(await getContractJson());
    Object? response = await _solc(myData);
    return response;
  }

  static Future<String> constructStandartSolcJsonString() async {
    final contractText = await getContractSol("test_resources/Investment.sol");
    var jsonSolcStr ='{"language": "Solidity","sources": {"Investment.sol": {"content": "$contractText"}},"settings": {"outputSelection": {"*": {"*": ["abi","evm.bytecode"]}}}}';
    return jsonSolcStr.replaceAll("\n"," ");
  }

  Future<void> generateAbiFileFromContract(Contract contract) async {
    // final meta = json.decode(contract.metadata);
    // final output = meta['output'];
    // Utils.writeFile(contract.name, output);
  }

  Future getPaths() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    documentsPath = appDocDir.path;
  }

  static Future<String> getContractJson() {
    return rootBundle.loadString('test_resources/Investment.json');
  }

  static Future<String> getContractSol(String filename) async {
    final str = await rootBundle.loadString(filename);
    return str.replaceAll("\n"," ");
  }

  Future<Object?> _solc(Object? input) async {
    final proc = await Process.start('solc', ['--standard-json']);
    final jsonUtf8 = json.fuse(utf8);

    await Stream.value(input).transform(jsonUtf8.encoder).pipe(proc.stdin);
    return proc.stdout.transform(jsonUtf8.decoder).first;
  }

  static Future<String> getFileContractAsString(String fileContractPath) async {
    final file = new File(fileContractPath);
    final result = await file.readAsString();
    return result;
  }
}