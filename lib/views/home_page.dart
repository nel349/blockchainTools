import 'package:flutter/material.dart';
import '../services/web3dart_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? balance = 0;
  late Web3DartServices web3dartServices;

  @override
  void initState() {
    web3dartServices = Web3DartServices()
      ..setCurrentAddressFromHex('0xB449074a8167c1B68fD9Ab8b3d687129f98C1122')
      ..init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF283593), Colors.white70],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'RAFFLE',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // show balance
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Ξ $balance',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // update balance
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton.extended(
                    heroTag: 'check_balance',
                    onPressed: () async {
                      var contractBalance = await web3dartServices.getCurrentEthereumAddressBalance;
                      balance = contractBalance?.getInEther.toDouble() ?? 0;
                      setState(() {});
                    },
                    label: Text('Check Balance'),
                    icon: Icon(Icons.refresh),
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}