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

  static Future<void> generateAbiToFile(String fileName, String abi) async {
    writeAbiFile(fileName, abi);
  }

  static Future<String> getContractSourceCode() async {
    final contractText = await getContractSol("contracts/nfts/myNftTokenCondensed.sol");
    return contractText.replaceAll("\n","").replaceAll(RegExp(r'\s{2,}'), " ");
  }

  static Future<void> compile(WebViewController controller, String jsonStr) async {
    final contractStream = DeployContractStream();
    final contractCode = await controller.runJavascriptReturningResult('sourceCode=\"$jsonStr\"');
    print("Contract code: $contractCode");

    final a = await controller.runJavascriptReturningResult('sourceCode;');
    print("Contract code a:  $a");

    String compiledContractResult = "";
    await controller.runJavascriptReturningResult('loadSolJson()');
    // var compiledCode = await controller.runJavascriptReturningResult('getCompiledCode()');
    await contractStream.checkAbiResult(controller)
        .firstWhere((element) => element.contains('contracts'))
        .then((value) {
          print("compiled contract: $value");
          compiledContractResult = value;

          //SHOW SOME LOADING STATE
        });

    // Sometimes we need to decode again. Check
    final resultJson = await json.decode(compiledContractResult);

    final resultB;
    if (resultJson is String) {
      resultB = await json.decode(resultJson);
    } else {
      resultB = resultJson;
    }

    final abi = resultB["contracts"]["contract"]["MyNftTokenCondensed"]["abi"];
    final bytecode = resultB["contracts"]["contract"]["MyNftTokenCondensed"]["evm"]["bytecode"]["object"];
    // print("Compilation Result: $resultJson");

    // print("Compilation bytecode: $bytecode");
    final abiStr = json.encode(abi);
    print("Compilation abi: $abiStr");

    // Deploy contract
    await controller.runJavascript('abi=JSON.stringify($abiStr);' 'bytecode="$bytecode"');
    await controller.runJavascript('deployContract()');

    contractStream.checkJavascriptResult(controller)
        .firstWhere((element) => element.startsWith('0x'))
        .then((value) async {
          print("Transaction Hash: $value");
    });

    await controller.runJavascript('removeLoader()');
    await controller.runJavascript('showResults()');
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

  static Future<bool> writeAbiFile(String fileName, String abi) async {
    try {
      File myFile = File('lib/$fileName.abi.json');
      await myFile.writeAsString(abi);
      return true;
    } catch (e) {
      return false;
    }
  }
}