import 'dart:io';
import 'dart:math';

import 'package:fapp1/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;
import 'src/image_widget.dart';
import 'package:flutter/foundation.dart';

//TODO: Select ENV!
import 'package:fapp1/src/env/linux.dart' as environment;
// import 'package:fapp1/src/env/android.dart' as environment;

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  var result = await environment.checkPermissionReadExternalStorage();
  print("checkPermissionReadExternalStorage: ${result}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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

final _loaderWidget = Container(
  key: Key('loader'),
  child: Center(
    child: SizedBox(
      child: CircularProgressIndicator(),
      width: 60,
      height: 60,
    ),
  ),
);


class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool get isItemChanging => _currentWidget != _nextWidget;
  AnimationController _effectController;
  AnimationController _mediaItemLoopController;
  MediaSliderItemEffect _currentEffect = Effect.depthEffect.createEffect();
  final List<Effect> _effectPool = [];
  static const int transitionTimeMsValue = 1000;
  static const int displayTimeValue = 200;
  static const int repeatEffect = 2;

  final Directory _folder = new Directory(path.join(environment.externalStorage.path, 'images'));

  // Random _rnd = new Random();

  Widget _currentWidget = _loaderWidget;
  Widget _nextWidget = _loaderWidget;
  Widget _transitionWidget = _loaderWidget;
  String effectTitle = 'depthEffect';
  int _effectCountdown = repeatEffect;


  @override
  void initState() {
    super.initState();

    final transitionTimeMs = Duration(milliseconds: transitionTimeMsValue);
    final displayTime = Duration(milliseconds: displayTimeValue);

    _effectController = AnimationController(duration: transitionTimeMs, vsync: this);
    //Curves.easeOutQuad;
    _effectController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentWidget = _nextWidget;
        });
        imageCache.clear();
      }
    });

    _mediaItemLoopController = AnimationController(duration: displayTime, vsync: this);

    _mediaItemLoopController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fetchNextMediaItem();
      }
    });

    _mediaItemLoopController.forward();
  }

  @override
  void dispose() {
    _effectController.dispose();
    _mediaItemLoopController.dispose();
    super.dispose();
  }

  List<Uri> _mediaItems = [];

  Future<Uri> _getNextItem() async {
    if (_mediaItems.isEmpty) {
      final items = await _folder.listSync();
      if (items.length == 0) {
        return null;
      }
      _mediaItems = items.map((e) => e.uri).toList(growable: true);
      print('File cache has ${_mediaItems.length} file(s)');
    }
    return _mediaItems.removeLast();//removeAt(_rnd.nextInt(_mediaItems.length));
  }

  void _fetchNextMediaItem() async {
    print('Change image');
    var mediaItem = await _getNextItem();
    Widget itemWidget;
    if (mediaItem != null) {
      print('file: "${path.basename(mediaItem.toFilePath())}"');
      itemWidget = ImageWidget(mediaItem);
    } else {
      itemWidget = _loaderWidget;
    }
    print('imageCache.liveImageCount = ${imageCache.liveImageCount}, .currentSize = ${imageCache.currentSize}');

    if (itemWidget is ImageWidget) {
      await precacheImage(itemWidget.provider, context);
    }
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;
    _nextWidget = Container(width: screenW, height: screenH, child: itemWidget);
    _transitionWidget = AnimatedBuilder(
        key: Key('anim'),
        animation: _effectController,
        builder: (_, __) {
          return Stack(children: <Widget>[
            Transform.translate(
                offset: Offset(-_effectController.value * screenW, 0.0),
                child: _currentEffect.transform(context, _currentWidget, 0, 0, _effectController.value, 2)),
            Transform.translate(
                offset: Offset(screenW - _effectController.value * screenW, 0.0),
                child: _currentEffect.transform(context, _nextWidget, 1, 0, _effectController.value, 1))
          ]);
        },
        child: _loaderWidget);

    _effectController.reset();
    _mediaItemLoopController.reset();
    _effectCountdown--;
    if (_effectCountdown <= 0 ) {
       _changeEffect();
    }
    setState(() {});
    await _effectController.forward().orCancel;
    _mediaItemLoopController.forward();
  }

  _changeEffect(){
    _effectCountdown = repeatEffect;
    if (_effectPool.isEmpty) {
      _effectPool.addAll(Effect.values);
      //_effectPool.shuffle(_rnd);
    }
    var tmp =_effectPool.removeLast();
    effectTitle = tmp.name;
    _currentEffect = tmp.createEffect();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
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
        title: Text("$effectTitle ($_effectCountdown)"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
          children: <Widget>[
            Container(
              height: size.height,
              color: Colors.black,
              child: !isItemChanging ? _currentWidget : _transitionWidget,
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mediaItemLoopController.reset();
          _changeEffect();
          //_fetchNextMediaItem();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
