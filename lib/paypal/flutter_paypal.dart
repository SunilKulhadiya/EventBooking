library flutter_paypal;

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:goevent2/paypal/src/screens/complete_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'src/PaypalServices.dart';
import 'src/errors/network_error.dart';

class UsePaypalScreen extends StatefulWidget {
  final Function onSuccess, onCancel, onError;
  final String returnURL, cancelURL, note, clientId, secretKey;
  final List transactions;
  final bool sandboxMode;
  const UsePaypalScreen({
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
    required this.returnURL,
    required this.cancelURL,
    required this.transactions,
    required this.clientId,
    required this.secretKey,
    this.sandboxMode = false,
    this.note = '',
  });

  @override
  State<StatefulWidget> createState() {
    return UsePaypalScreenState();
  }
}

class UsePaypalScreenState extends State<UsePaypalScreen> {
  late final WebViewController _controller;
  String checkoutUrl = '';
  String navUrl = '';
  String executeUrl = '';
  String accessToken = '';
  bool loading = true;
  bool pageLoading = true;
  bool loadingError = false;
  late PaypalServices services;
  int pressed = 0;

  Map getOrderParams() {
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": widget.transactions,
      "note_to_payer": widget.note,
      "redirect_urls": {
        "return_url": widget.returnURL,
        "cancel_url": widget.cancelURL
      }
    };
    return temp;
  }

  loadPayment() async {
    setState(() {
      loading = true;
    });
    try {
      Map getToken = await services.getAccessToken();
      if (getToken['token'] != null) {
        accessToken = getToken['token'];
        final transactions = getOrderParams();
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        if (res["approvalUrl"] != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"].toString();
            navUrl = res["approvalUrl"].toString();
            executeUrl = res["executeUrl"].toString();
            loading = false;
            pageLoading = false;
            loadingError = false;
          });
          _controller.loadRequest(Uri.parse(checkoutUrl));
        } else {
          widget.onError(res);
          setState(() {
            loading = false;
            pageLoading = false;
            loadingError = true;
          });
        }
      } else {
        widget.onError("${getToken['message']}");

        setState(() {
          loading = false;
          pageLoading = false;
          loadingError = true;
        });
      }
    } catch (e) {
      widget.onError(e);
      setState(() {
        loading = false;
        pageLoading = false;
        loadingError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    services = PaypalServices(
      sandboxMode: widget.sandboxMode,
      clientId: widget.clientId,
      secretKey: widget.secretKey,
    );
    if (mounted) {
      setState(() {
      navUrl = widget.sandboxMode
          ? 'https://api.sandbox.paypal.com'
          : 'https://www.api.paypal.com';
    });
    }
    if (mounted) {
      loadPayment();
    }

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
              pageLoading = true;
              loadingError = false;
            });
            }
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
              navUrl = url;
              pageLoading = false;
            });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            if (mounted) {
              if (request.url.contains(widget.returnURL)) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompletePayment(
                          url: request.url,
                          services: services,
                          executeUrl: executeUrl,
                          accessToken: accessToken,
                          onSuccess: widget.onSuccess,
                          onCancel: widget.onCancel,
                          onError: widget.onError)),
                );
              }
            }
            if (request.url.contains(widget.cancelURL)) {
              final uri = Uri.parse(request.url);
              await widget.onCancel(uri.queryParameters);
              Navigator.of(context).pop();
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pressed < 2) {
          setState(() {
            pressed++;
          });
          final snackBar = SnackBar(
              content: Text(
                  'Press back ${3 - pressed} more times to cancel transaction'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF272727),
            leading: GestureDetector(
              child: const Icon(Icons.arrow_back_ios),
              onTap: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Expanded(
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Uri.parse(navUrl).hasScheme
                                ? Colors.green
                                : Colors.blue,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              navUrl,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(width: pageLoading ? 5 : 0),
                          pageLoading
                              ? const SpinKitFadingCube(
                            color: Color(0xFFEB920D),
                            size: 10.0,
                          )
                              : const SizedBox()
                        ],
                      ),
                    ))
              ],
            ),
            elevation: 0,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: loading
                ? const Column(
              children: [
                Expanded(
                  child: Center(
                    child: SpinKitFadingCube(
                      color: Color(0xFFEB920D),
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            )
                : loadingError
                ? Column(
              children: [
                Expanded(
                  child: Center(
                    child: NetworkError(
                        loadData: loadPayment,
                        message: "Something went wrong,"),
                  ),
                ),
              ],
            )
                : Column(
              children: [
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
          )),
    );
  }
}