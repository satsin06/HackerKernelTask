import 'package:flutter/material.dart';
import 'package:hackerkernel/widget/side_menu.dart';


class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('DashBoard'),
      ),
      body: Center(child: Text('Dashboard')),
    );
  }
}
