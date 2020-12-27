import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'dart:core';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String link;

  @override
  WebViewExampleState createState() => WebViewExampleState(link);
  WebViewExample(this.link);
}

class WebViewExampleState extends State<WebViewExample> {
  Completer<WebViewController> _completer = Completer<WebViewController>();
  final String link;
  final key = UniqueKey();

  WebViewExampleState(this.link);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(link);
                })
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: WebView(
                key: key,
                initialUrl: link.toString(),
                onWebViewCreated: (WebViewController webViewController) {
                  _completer.complete(webViewController);
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ));
  }
}
