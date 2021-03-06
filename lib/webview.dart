import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'decider.dart';

final storage = FlutterSecureStorage();

class WebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Omniport Login'),
      ),
      body: Container(
        child: InAppWebView(
            initialUrl:
                'https://internet.channeli.in/oauth/authorise/?client_id=FpManHnDgfhdL2CxZseuB82cDBzsj9VY14QKILhn&redirect_url=http://127.0.0.1:8000/spuggy/oauth/&state=RANDOM_STATE_STRING',
            onLoadStart: (InAppWebViewController controller, String url) async {
              print(url);
              if (url.contains('?token=')) {
                String token = url.split('=')[1].split('&')[0];
                await storage.write(key: 'token', value: token);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Decider()));
              }
            }),
      ),
    );
  }
}
