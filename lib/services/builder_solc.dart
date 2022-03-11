import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SolcBuilder {
  Map<String, String>? params;

  SolcBuilder({this.params});

  FutureOr<void> build() async {
    //
    // final response = await _solc(
    //   {
    //     'language': 'Solidity',
    //     'sources': {
    //       'contract': {
    //         'content': contractSource,
    //       }
    //     },
    //     'settings': {
    //       'outputSelection': {
    //         '*': {
    //           '*': ['metadata']
    //         }
    //       },
    //     },
    //   },
    // );
    //
    // final contracts =
    // ((response as Map)['contracts'] as Map)['contract'] as Map;
    // final contract = contracts.values.single as Map;
    //
    // final outputId = inputId.changeExtension('.abi.json');
    // final meta = json.decode(contract['metadata'] as String) as Map;
    // await buildStep.writeAsString(outputId, json.encode(meta['output']));
  }

  Future<Object?> _solc(Object? input) async {
    final proc = await Process.start('solc', ['--standard-json']);
    final jsonUtf8 = json.fuse(utf8);

    await Stream.value(input).transform(jsonUtf8.encoder).pipe(proc.stdin);
    return proc.stdout.transform(jsonUtf8.decoder).first;
  }

  Future<String> getFileContractAsString(String fileContractPath) async {
    final file = new File(fileContractPath);
    final result = await file.readAsString();
    return result;
  }
}