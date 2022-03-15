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

    var my_data = json.decode(await getContractJson());

    Object? response = await _solc(my_data);




    // final outputId = inputId.changeExtension('.abi.json');
    // final meta = json.decode(contract['metadata'] as String) as Map;
    // await buildStep.writeAsString(outputId, json.encode(meta['output']));

    return response;
  }

  static Future<String> constructStandartSolcJsonString() async {

    final contractText = await getContractSol("test_resources/Investment.sol");

    var jsonSolcStr ='{"language": "Solidity","sources": {"Investment.sol": {"content": "$contractText"}},"settings": {"outputSelection": {"*": {"*": ["abi","evm.bytecode"]}}}}';
    // final jsonSolc = json.decode(jsonSolcStr);
    return jsonSolcStr.replaceAll("\n"," ");
  }

  Future<void> generateAbiFileFromContract(Contract contract) async {
    final meta = json.decode(contract.metadata);
    final output = meta['output'];
    writeAbiFile(contract.name, output);
  }

  Future<bool> writeAbiFile(String fileName, dynamic object) async {
    try {
      File myFile = File('$documentsPath/${fileName}ABI.json');
      await myFile.writeAsString(jsonEncode(object));
      return true;
    } catch (e) {
      return false;
    }
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