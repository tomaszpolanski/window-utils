import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_utils/window_frame.dart';
import 'package:window_utils/window_utils.dart';

void main() {
  if (!kIsWeb && debugDefaultTargetPlatformOverride == null) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => WindowUtils.hideTitleBar(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: WindowsFrame(
        active: Platform.isWindows,
        border: Border.all(color: Colors.grey),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (_) {
                      WindowUtils.startDrag();
                    },
                    onDoubleTap: () {
                      WindowUtils.windowTitleDoubleTap().then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                    child: Material(
                      elevation: 4,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Text(
                        'Window Utils Example',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.info_outline),
                          onPressed: () {
                            WindowUtils.getWindowSize()
                                // ignore: avoid_print
                                .then((val) => print('Window: $val'));
                            WindowUtils.getScreenSize()
                                // ignore: avoid_print
                                .then((val) => print('Screen: $val'));
                            WindowUtils.getWindowOffset()
                                // ignore: avoid_print
                                .then((val) => print('Offset: $val'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Max Window Size'),
                trailing: IconButton(
                  icon: Icon(Icons.desktop_windows),
                  onPressed: () {
                    WindowUtils.getScreenSize().then((val) async {
                      await WindowUtils.setSize(Size(val.width, val.height));
                      await WindowUtils.setPosition(const Offset(0, 0));
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Increase Window Size'),
                trailing: IconButton(
                  icon: Icon(Icons.desktop_windows),
                  onPressed: () {
                    WindowUtils.getWindowSize().then((val) {
                      WindowUtils.setSize(
                        Size(val.width + 20, val.height + 20),
                      );
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Move Window Position'),
                trailing: IconButton(
                  icon: Icon(Icons.drag_handle),
                  onPressed: () {
                    WindowUtils.getWindowOffset().then((val) {
                      WindowUtils.setPosition(
                        Offset(val.dx + 20, val.dy + 20),
                      );
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Center Window'),
                trailing: IconButton(
                  icon: Icon(Icons.vertical_align_center),
                  onPressed: WindowUtils.centerWindow,
                ),
              ),
              ListTile(
                title: const Text('Close Window'),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: WindowUtils.closeWindow,
                ),
              ),
              ListTile(
                title: const Text('Change Cursor'),
                // trailing: IconButton(
                //   icon: Icon(Icons.add),
                //   onPressed: () {
                //     final _size = CursorType.values.length;
                //     final _randomNum = Random.secure().nextInt(_size);
                //     final _newCursor = CursorType.values[_randomNum];
                //     WindowUtils.addCursorToStack(_newCursor);
                //   },
                // ),
                subtitle: DropdownButton<CursorType>(
                  value: CursorType.arrow,
                  items: CursorType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(describeEnum(t)),
                          ))
                      .toList(),
                  onChanged: WindowUtils.setCursor,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: WindowUtils.resetCursor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
