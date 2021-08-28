import 'package:flutter/material.dart';
import 'package:hackerkernel/model/album.dart';

class GridDetails extends StatefulWidget {
  final Album curAlbum;
  GridDetails({required this.curAlbum});

  @override
  GridDetailsState createState() => GridDetailsState();
}

class GridDetailsState extends State<GridDetails> {
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: 'assets/img.png',
              image: widget.curAlbum.url,
            ),
          ],
        ),
      ),
    );
  }
}