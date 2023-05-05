import 'package:oauth2_manager/oauth_manager.dart';
import 'package:oauth2_manager/src/oauth2_manager.dart';
import 'package:oauth2_manager/src/typedef.dart';

class OAuth2 {
  final OAuth2Manager _oauth;

  OAuth2(this._oauth);

  Future<Credentials> getRefreshToken(
    String accessToken,
    String refreshToken,
    String idToken, {
    List<String>? newScopes,
  }) async {
    return await _oauth.getRefreshToken(
      accessToken,
      refreshToken,
      idToken,
      newScopes: newScopes,
    );
  }

  Future<Credentials> login({
    required RedirectUri redirect,
    required String redirectPage,
    String? contentType,
  }) async {
    return await _oauth.login(
      redirect: redirect,
      redirectPage: redirectPage,
      contentType: contentType,
    );
  }
}
