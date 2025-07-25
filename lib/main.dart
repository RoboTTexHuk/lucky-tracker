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

  // Фиксированная высота белого контейнера
  final double whiteBarHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    final double safeTop = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          // SafeArea только по бокам, верх перекроем вручную
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
              // Белый контейнер перекрывает WebView сверху
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: safeTop,
                child: Container(
                  color: Color(0xFF00826D),
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