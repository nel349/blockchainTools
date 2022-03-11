import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Web3DartServices {
  // JSON-RPC is a remote procedure call protocol encoded in JSON
  // Remote Procedure Call (RPC) is about executing a block of code on another server
  static const _rpcUrl = 'http://0.0.0.0:7545';
  late Client _httpClient;
  late Web3Client? ethClient;
  EthereumAddress? _currentEthereumAddress;

  Future<EtherAmount>? get getCurrentEthereumAddressBalance =>
      this.ethClient?.getBalance(_currentEthereumAddress
          ?? EthereumAddress.fromHex('0'));

  Web3DartServices() {
    /// This will start a client that connects to a JSON RPC API, available at RPC URL.
    /// The httpClient will be used to send requests to the [RPC server].
    _httpClient = Client();

    /// It connects to an Ethereum [node] to send transactions, interact with smart contracts, and much more!
    ethClient = Web3Client(_rpcUrl, _httpClient);
  }

  void setCurrentAddressFromHex(String address) =>
      _currentEthereumAddress = EthereumAddress.fromHex(address);

  Future<void> init() async {
    await getDeployedContract();
    await getContractFunctions();
  }

  /// This will parse an Ethereum address of the contract in [contractAddress]
  /// from the hexadecimal representation present inside the [ABI]
  String? abi;
  EthereumAddress? contractAddress;

  Future<void> getDeployedContract() async {
    String abiString = await rootBundle.loadString('src/abis/Investment.json');
    var abiJson = jsonDecode(abiString);
    abi = jsonEncode(abiJson['abi']);

    contractAddress =
        EthereumAddress.fromHex(abiJson['networks']['5777']['address']);
  }

  /// This will help us to find all the [public functions] defined by the [contract]
  DeployedContract? contract;
  ContractFunction? getContractBalanceAmount,
      getContractDepositAmount,
      addContractDepositAmount,
      withdrawContractBalance;

  Future<void> getContractFunctions() async {

    if (abi != null && contractAddress != null ) {
      contract =
          DeployedContract(ContractAbi.fromJson(abi ?? "", "Investment"), contractAddress!);
    }
    getContractBalanceAmount = contract?.function('getBalanceAmount');
    getContractDepositAmount = contract?.function('getDepositAmount');
    addContractDepositAmount = contract?.function('addDepositAmount');
    withdrawContractBalance = contract?.function('withdrawBalance');
  }

  /// This will call a [functionName] with [functionArgs] as parameters
  /// defined in the [contract] and returns its result
  Future<List<dynamic>?> readContract(
      ContractFunction functionName,
      List<dynamic> functionArgs,
      ) async {

    // if (contract != null) {
    //   return await ethClient?.call(
    //     sender: myAddress,
    //     contract: contract!,
    //     function: functionName,
    //     params: functionArgs,
    //   );
    // }
    return null;
  }

  /// Signs the given transaction using the keys supplied in the [credentials] object
  /// to upload it to the client so that it can be executed
  Future<void> writeContract(
      ContractFunction functionName,
      List<dynamic> functionArgs,
      ) async {

    // if (credentials != null && contract != null) {
    //   await ethClient?.sendTransaction(
    //     credentials!,
    //     Transaction.callContract(
    //       contract: contract!,
    //       function: functionName,
    //       parameters: functionArgs,
    //     ),
    //   );
    // }
  }
}