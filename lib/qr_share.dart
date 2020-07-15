import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:esys_flutter_share/esys_flutter_share.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
// import 'package:share/share.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; var image;

  GlobalKey globalKey = GlobalKey();

  void _incrementCounter() async {
    try{
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      image = await boundary.toImage(pixelRatio: 5.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File("${tempDir.path}/image.png").create();
      await file.writeAsBytes(pngBytes);
      ShareExtend.share(
        file.path, 
        "image",
        subject: "Hi ! i'm daveat",
      );
      // Share.file(title, name, bytes, mimeType)
      // Share.file(title, name, bytes, mimeType)
      // multi("Zeetomic QR", "image", pngBytes, "My image");
      // Share.share(text)
    } catch (e) {
      print(e);
      print("helllo");
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 200,
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  data: "Hello world",
                  embeddedImage: AssetImage("assets/zee_for_qr.png"),
                  size: 50,
                  version: 2,
                ),
              ),
            ),

            image == null ? Container() : image
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
