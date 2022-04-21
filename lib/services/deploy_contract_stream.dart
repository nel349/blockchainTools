import 'package:webview_flutter/webview_flutter.dart';

class DeployContractStream {
  Stream<String> checkAbiResult(WebViewController controller) async* {
    yield* Stream.periodic(Duration(milliseconds: 500), (_) {
      return controller.runJavascriptReturningResult('getCompiledCode()');
    }).asyncMap((event) async => await event);
  }

  Stream<String> checkJavascriptResult(WebViewController controller) async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return controller.runJavascriptReturningResult('getTransactionHashResult()');
    }).asyncMap((event) async => await event);
  }
}