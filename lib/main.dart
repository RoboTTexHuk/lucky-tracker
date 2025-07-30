import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MaterialApp(
    home: InAppWebViewExample(),
    debugShowCheckedModeBanner: false,
  ));
}

class InAppWebViewExample extends StatefulWidget {
  const InAppWebViewExample({Key? key}) : super(key: key);

  @override
  State<InAppWebViewExample> createState() => _InAppWebViewExampleState();
}

class _InAppWebViewExampleState extends State<InAppWebViewExample> {
  InAppWebViewController? webViewController;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final double safeTop = MediaQuery.of(context).padding.top-10;

    bool isIPhone(BuildContext context) {
      // Только для iOS
      if (kIsWeb || !Platform.isIOS) return false;
      // Обычно iPad имеет ширину больше 600 логических пикселей
      final double width = MediaQuery.of(context).size.shortestSide;
      return width < 600;
    }

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          left: true,
          right: true,
          top: true,
          bottom: false,
          child: Stack(
            children: [
              // WebView без padding
              Positioned.fill(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri('https://close-river-4184.glide.page/dl/63325b'),
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    disableDefaultErrorPage: true,

                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                    allowsPictureInPictureMediaPlayback: true,
                    useOnDownloadStart: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
              // Показывать цветную плашку только на iPhone/iPad
              if (isIPhone(context))
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  height: safeTop,
                  child: Container(
                    color: const Color(0xFF00826D),
                  ),
                ),
              // Лоадер по центру
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}