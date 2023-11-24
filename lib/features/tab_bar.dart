
import 'package:flutter/material.dart';
import 'package:product/features/view_product.dart';

import 'add_product.dart';
import '../main.dart';

class tabBar extends StatefulWidget {
  const tabBar({super.key});

  @override
  State<tabBar> createState() => _tabBarState();
}

class _tabBarState extends State<tabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Product"),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: w*0.07
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Add",
              ),
              Tab(
                text: "View",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  children: [
                    addProduct(),
                    viewProduct()

                  ]),
            )
          ],
        ),
      ),

    );
  }
}
