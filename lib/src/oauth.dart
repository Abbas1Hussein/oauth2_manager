import 'package:oauth2/oauth2.dart';

import '../oauth_manager.dart';

class OAuth2 {
  final OAuth2Manager _oauth;

  OAuth2(this._oauth);

  Future<void> getRefreshToken(List<String> newScopes) async {
    await _oauth.getRefreshToken(newScopes);
  }

  Future<Credentials> login() async => await _oauth.login();

}
