import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'dart:ui' as ui;

class ScreenShotPage extends StatefulWidget {
  @override
  _ScreenShotPageState createState() => _ScreenShotPageState();
}

class _ScreenShotPageState extends State<ScreenShotPage> {
  IjkMediaController mediaController = IjkMediaController();

  ImageProvider provider;

  @override
  void initState() {
    super.initState();
    mediaController.setDataSource(
        DataSource.network(
            "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4"),
        autoPlay: true);
  }

  @override
  void dispose() {
    mediaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.screenshotTitle),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1280 / 720,
            child: IjkPlayer(
              mediaController: mediaController,
            ),
          ),
          FlatButton(
            child: Text(currentI18n.screenshotTitle),
            onPressed: () async {
              var uint8List = await mediaController.screenShot();
              provider = MemoryImage(uint8List);
              setState(() {});

              var size = await getImageForUint8List(uint8List);
              print("width = ${size.width} , height = ${size.height}");
            },
          ),
          provider == null
              ? Container()
              : Image(
                  image: provider,
                ),
        ],
      ),
    );
  }
}

Future<Size> getImageForUint8List(Uint8List imageSrc) {
  Completer<Size> completer = Completer();
  ui.decodeImageFromList(imageSrc, (img) {
    completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
    img.dispose();
  });
  return completer.future;
}
