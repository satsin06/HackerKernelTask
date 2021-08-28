import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackerkernel/model/album.dart';
import 'package:hackerkernel/services/photos_service.dart';
import 'package:hackerkernel/widget/grid_details.dart';
import 'package:hackerkernel/widget/photos_cell.dart';
import 'package:hackerkernel/widget/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../services/authentication_service.dart';


Future <List<Data>> fetchData() async {
  final response =
  await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final int userId;
  final int id;
  final String title;

  Data({required this.userId, required this.id, required this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future <List<Data>> futureData;

  StreamController<int> streamController = new StreamController<int>();

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  
  /// For Photos
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
                child: PhotosCell(album),
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
  
  ///For Posts
  // tileView(AsyncSnapshot<List<Post>> snapshot) {
  //   return ListView.builder(
  //       itemBuilder: (BuildContext context, int index) {
  //         if (snapshot.hasData) {
  //           List<Post> post = snapshot.post;
  //           return
  //         }
  //       }
  //   );
  // }

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
                  future: PhotosServices.getPhotos(),
                  builder: (context, snapshot) {
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
              Center(
                child: FutureBuilder <List<Data>>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Data>? data = snapshot.data;
                      return
                        ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 75,
                                    color: Colors.white,
                                    child: Center(child: Text(data[index].title),
                                    ),
                                  ),
                              Divider(thickness: 1.0,),
                                ],
                              );
                            },
                        );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          )),
    );
  }
}
