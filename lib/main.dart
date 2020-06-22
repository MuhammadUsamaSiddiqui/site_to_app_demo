import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  String url = "http://www.dukeagainsthumanity.com/";

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      print("navigating to...$url");
      if (url.startsWith("mailto") || url.startsWith("tel")) {
        await flutterWebViewPlugin.stopLoading();
        await flutterWebViewPlugin.goBack();
        await flutterWebViewPlugin.reload();
        if (await canLaunch(url)) {
          await launch(url);
          return;
        }
        print("couldn't launch $url");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WebviewScaffold(
      url: url,
      withJavascript: true,
      mediaPlaybackRequiresUserGesture: false,
      withZoom: false,
      scrollBar: false,
      hidden: true,
      useWideViewPort: false,
      withLocalStorage: true,
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.arrow_back_ios),
      //         onPressed: () {
      //           flutterWebViewPlugin.goBack();
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.arrow_forward_ios),
      //         onPressed: () {
      //           flutterWebViewPlugin.goForward();
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.autorenew),
      //         onPressed: () {
      //           flutterWebViewPlugin.reload();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
  }
}
