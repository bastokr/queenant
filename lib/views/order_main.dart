import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:queenant/views/image_view.dart';
import 'package:queenant/views/home.dart';
import 'package:queenant/views/ship_main.dart';
import 'package:queenant/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class OrderMain extends StatefulWidget {
  final token;
  final user_id;
  const OrderMain(this.token, this.user_id, {Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<OrderMain> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QUEEN ANT'),
        leading: Image(
          image: AssetImage('assets/icon/launcher_icon_main.png'),
          width: 30,
          height: 30,
        ),

        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        //  actions: <Widget>[
        //  NavigationControls(_controller.future),
        //   SampleMenu(_controller.future),
        //  ],
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        Future<bool> _goBack(BuildContext context) async {
          if (await _controller.canGoBack()) {
            _controller.goBack();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        }

        return WillPopScope(
            onWillPop: () => _goBack(context), child: Text('test'));
      }),
    );
  }
}
