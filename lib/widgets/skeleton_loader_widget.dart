import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

Widget buildLoader() {
  return new CustomScrollView(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      slivers: <Widget>[
        new SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            sliver: new SliverList(
              delegate: new SliverChildBuilderDelegate(
                (context, index) => SkeletonLoader(
    builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
            ),
          ],
        ),
      ),
      items: 5,
      period: Duration(seconds: 2),
      highlightColor: Colors.purple[300],
      direction: SkeletonDirection.ltr,
    ),
                childCount: 5,
              ),
            ))
      ]);
}
