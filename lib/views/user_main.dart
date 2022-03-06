import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

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

class UserMain extends StatefulWidget {
  final token;
  final user_id;
  const UserMain(this.token, this.user_id, {Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<UserMain> {
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
          title: const Text('사용자 정보수정'),
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
              onWillPop: () => _goBack(context),
              child: WebView(
                //initialUrl:
                //    'https://miraefactory2000.cafe24.com/custom/main_and.php?site=A',
                // initialUrl: 'https://youzan.github.io/vant/mobile.html#/zh-CN/uploader',
                javascriptMode: JavascriptMode.unrestricted,

                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                  webViewController.loadUrl(
                      'https://miraefactory2000.cafe24.com/custom/user/user_and.php?site=M',
                      headers: {
                        'x-auth-token': widget.token,
                        'x-request-id': widget.user_id
                      });
                  // _controller.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                javascriptChannels: <JavascriptChannel>{
                  _toasterJavascriptChannel(context),
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
                geolocationEnabled: true,
              ));
        }));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  geolocation
}
