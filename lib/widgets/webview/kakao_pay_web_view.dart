import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groundjp/api/api_service.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/open_app.dart';
import 'package:groundjp/domain/cash/kakao_ready_response.dart';
import 'package:groundjp/notifier/user_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class KakaoPayWebView extends ConsumerStatefulWidget {
  final KakaoReady kakao;
  final Function(bool data) loading;
  final VoidCallback onSuccess;

  const KakaoPayWebView({super.key, required this.kakao, required this.loading, required this.onSuccess});

  @override
  _KakaoPayWebViewState createState() => _KakaoPayWebViewState();
}

class _KakaoPayWebViewState extends ConsumerState<KakaoPayWebView> {
  late WebViewController _webViewController;
  late final PlatformWebViewControllerCreationParams params;

  _webViewInit() async {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    WebViewCookieManager cookieManager = WebViewCookieManager();
    cookieManager.setCookie(WebViewCookie(name: 'tid', value: widget.kakao.tid, domain: ApiService.domain, path: '/api/charge/kakao/completed'));
    cookieManager.setCookie(WebViewCookie(name: 'partner_order_id', value: widget.kakao.partner_order_id, domain: ApiService.domain, path: '/api/charge/kakao/completed'));
    cookieManager.setCookie(WebViewCookie(name: 'partner_user_id', value: widget.kakao.partner_user_id, domain: ApiService.domain, path: '/api/charge/kakao/completed'));
    cookieManager.setCookie(WebViewCookie(name: 'userId', value: '${ref.read(loginProvider.notifier).getId()}', domain: ApiService.domain, path: '/api/charge/kakao/completed'));

    _webViewController = WebViewController.fromPlatformCreationParams(params);

    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) {
        String url = request.url;
        print('url : $url');
        if (!url.startsWith('http')) {
          OpenApp.instance.kakaoOpenUrl(context, widget.kakao);
          return NavigationDecision.prevent;
        }
        if (url.contains('/api/charge/done')) {
          widget.onSuccess();
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onHttpError: (error) {
        print('error code : ${error.response?.statusCode}');
        if (error.response?.statusCode == 400) {
          Alert.of(context).message(
            message: '잘못된 요청입니다.',
            onPressed: () {
              widget.loading(false);
              Navigator.pop(context);
            },
          );
        } else if (error.response?.statusCode == 401) {
          Alert.of(context).message(
            message: '사용자를 찾을 수 없습니다.',
            onPressed: () {
              widget.loading(false);
              Navigator.pop(context);
            },
          );
        // 요청 시간 초과
        } else if (error.response?.statusCode == 404) {
          Navigator.pop(context);
        }
      },
    ));

    _webViewController.loadRequest(Uri.parse(widget.kakao.next_redirect_app_url),);
    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  void initState() {
    _webViewInit();
    super.initState();
  }

  @override
  void dispose() {
    widget.loading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결제 요청'),
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }

}
