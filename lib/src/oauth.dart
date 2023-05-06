import 'package:oauth2_manager/oauth_manager.dart';
import 'package:oauth2_manager/src/typedef.dart';

class OAuth2 {
  static OAuth2Manager? _oauth;

  OAuth2._();

  static Future<Credentials> getRefreshToken(
    String refreshToken, {
    required String clientID,
    required String clientSecret,
    required String tokenEndpoint,
    List<String>? newScopes,
  }) async {
    _oauth = OAuth2Manager(
      configuration: OAuth2Configuration(
        clientID: clientID,
        clientSecret: clientSecret,
        tokenEndpoint: tokenEndpoint,
        authorizationEndpoint: '',
        scopes: [],
      ),
    );
    return await _oauth!.getRefreshToken(refreshToken, newScopes: newScopes);
  }

  static Future<Credentials> login(
    OAuth2Configuration oauth2Configuration, {
    required RedirectUri redirect,
    required String redirectPage,
    String? contentType,
  }) async {
    _oauth = OAuth2Manager(configuration: oauth2Configuration);
    return await _oauth!.login(
      redirect: redirect,
      redirectPage: redirectPage,
      contentType: contentType,
    );
  }
}
