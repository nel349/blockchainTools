import 'package:flutter/material.dart';

import 'package:smart_contract/constants/Theme.dart';
import 'package:smart_contract/widgets/navbar.dart';
import 'package:smart_contract/widgets/card-horizontal.dart';
import 'package:smart_contract/widgets/card-small.dart';
import 'package:smart_contract/widgets/card-square.dart';
import 'package:smart_contract/widgets/drawer.dart';


class DraftHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: NowUIColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: NowDrawer(currentPage: "Home"),
        body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
          ),
        ));
  }


}