import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackerkernel/model/album.dart';
import 'package:hackerkernel/services/photos_service.dart';
import 'package:hackerkernel/widget/grid_details.dart';
import 'package:hackerkernel/widget/grid_view.dart';
import 'package:hackerkernel/widget/side_menu.dart';
import 'package:provider/provider.dart';

import '../services/authentication_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  StreamController<int> streamController = new StreamController<int>();

  gridview(AsyncSnapshot<List<Album>> snapshot) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: snapshot.data!.map(
              (album) {
            return GestureDetector(
              child: GridTile(
                child: AlbumCell(album),
              ),
              onTap: () {
                goToDetailsPage(context, album);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  goToDetailsPage(BuildContext context, Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => GridDetails(
          curAlbum: album,
        ),
      ),
    );
  }

  circularProgress() {
    return Center(
        child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: SideMenu(),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Photos',
                ),
                Tab(
                  text: 'Posts',
                )
              ],
            ),
            title: const Text('Home'),
          ),
          body: TabBarView(
            children: [
              /// First Tab
              Flexible(
                child: FutureBuilder<List<Album>>(
                  future: Services.getPhotos(),
                  builder: (context, snapshot) {
                    // not setstate here
                    //
                    if (snapshot.hasError) {
                      return Text('Error ${snapshot.error}');
                    }
                    //
                    if (snapshot.hasData) {
                      streamController.sink.add(snapshot.data!.length);
                      return gridview(snapshot);
                    }

                    return circularProgress();
                  },
                ),
              ),

              /// Second Tab
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  Container(
                    child: Center(child: Text('Posts Here')),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
