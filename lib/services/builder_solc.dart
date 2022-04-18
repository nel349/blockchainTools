import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_contract/services/deploy_contract_stream.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SolcBuilder {
  Map<String, String>? params;

  String? documentsPath;

  String? tempPath;

  static Future<String> constructStandartSolcJsonString() async {
    final contractText = await getContractSol("contracts/nfts/myNftTokenCondensed.sol");
    var jsonSolcStr ='{"language": "Solidity","sources": {"myNftTokenCondensed.sol": {"content": "$contractText"}},"settings": {"outputSelection": {"*": {"*": ["abi","evm.bytecode"]}}}}';
    return jsonSolcStr.replaceAll("\n","").replaceAll(RegExp(r'\s{2,}'), " ");
  }

  static Future<void> compile(WebViewController controller, String jsonStr) async {
    final solcInput = await controller.runJavascriptReturningResult('solcInput=JSON.stringify($jsonStr);');
    print("Input solc: $solcInput");
    final result = await controller.runJavascriptReturningResult('solcCompileOptimized(compiler);');
    final resultJson = await json.decode(result);
    final abi = resultJson["contracts"]["myNftTokenCondensed.sol"]["MyNftTokenCondensed"]["abi"];
    final bytecode = resultJson["contracts"]["myNftTokenCondensed.sol"]["MyNftTokenCondensed"]["evm"]["bytecode"]["object"];
    print("Compilation Result: $resultJson");
    print("Compilation abi: $abi");
    print("Compilation bytecode: $bytecode");
    final abiStr = json.encode(abi);

    // Deploy contract
    await controller.runJavascript('abi=JSON.stringify($abiStr);' 'bytecode="$bytecode"');
    await controller.runJavascript('deployContract()');
    final contractStream = DeployContractStream();
    contractStream.checkJavascriptResult(controller)
        .firstWhere((element) => element.startsWith('0x'))
        .then((value) => print("Transaction Hash: $value"));
  }

  Future getPaths() async {
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    documentsPath = appDocDir.path;
  }

  static Future<String> getContractSol(String filename) async {
    final str = await rootBundle.loadString(filename);
    return str.replaceAll("\n"," ");
  }

}