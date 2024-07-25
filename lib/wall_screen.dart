import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wallpaper_app/fullscreenImage_page.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({super.key});

  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  late StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpaperList = [];
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("wallpaper");

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpaperList = datasnapshot.docs;
      });
    }, onError: (error) {
      // Handle error appropriately
      print("Error occurred: $error");
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WallPaperBruhhh"),
      ),
      body: wallpaperList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 4,
        itemCount: wallpaperList.length,
         itemBuilder: (context,i){
          String imgPath = wallpaperList[i]['url']as String;
          return Material(
            elevation: 8.0,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: InkWell(
              onTap: ()=>Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context)=>FullscreenimagePage(imgPath)
                )
              ),
              child: Hero(
                tag: imgPath,
                child: FadeInImage(
                  image: NetworkImage(imgPath),
                  fit: BoxFit.cover,
                  placeholder: AssetImage("assets/image1.jpg"),
                ),
              ),
            ),
          );
         },
        staggeredTileBuilder: (i)=>StaggeredTile.count(2,i.isEven?2:3),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}
