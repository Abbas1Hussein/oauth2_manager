import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:oauth2_manager/oauth_manager.dart';
import 'package:oauth2_manager/src/typedef.dart';

/// An abstract class for managing OAuth2 authentication.
abstract class BaseOAuth2Manager {
  HttpServer? _redirectServer;

  /// Starts a local server and listens for the redirect URI.
  ///
  /// The `redirectPage` argument is the HTML page to display to the user after the redirect URI is received.
  /// The `contentType` argument is the content type of the response.
  ///
  /// Returns a `Map<String, String>` of the query parameters in the redirect URI.
  Future<Map<String, String>> _listen({
    required String redirectPage,
    String? contentType,
  }) async {
    var request = await _redirectServer!.first;
    var params = request.uri.queryParameters;

    request.response.statusCode = 200;
    request.response.headers.set('content-type', contentType ?? 'text/html');
    request.response.writeln(redirectPage);

    await request.response.close();
    await _redirectServer!.close();
    _redirectServer = null;
    return params;
  }
}

/// This class extends the BaseOAuth2Manager class and implements the OAuth2 Authorization Code Grant flow.
/// It uses a HttpServer to receive the authorization code and a redirect function to open the authorization page in the user's browser.
class OAuth2Manager extends BaseOAuth2Manager {
  /// The OAuth2 configuration.
  final OAuth2Configuration _configuration;

  OAuth2Manager({
    required OAuth2Configuration configuration,
  }) : _configuration = configuration;

  /// This method initiates the OAuth2 flow by creating a HttpServer to receive the authorization code,
  /// opening the authorization page in the user's browser, and handling the authorization response to obtain an OAuth2 token.
  ///
  /// [redirect] The function used to open the authorization page in the user's browser.
  /// [redirectPage] The page to display to the user after the redirect URI is received.
  /// [contentType] The content type of the redirectPage.
  Future<oauth2.Credentials> login({
    required RedirectUri redirect,
    required String redirectPage,
    String? contentType,
  }) async {
    await _redirectServer?.close();
    try {
      _redirectServer = await HttpServer.bind('localhost', 0);
      final redirectURL = 'http://localhost:${_redirectServer!.port}/auth';

      final authenticatedHttpClient = await _getOAuth2Client(
        redirectUrl: Uri.parse(redirectURL),
        redirect: redirect,
        redirectPage: redirectPage,
        contentType: contentType,
      );
      return authenticatedHttpClient.credentials;
    } catch (_) {
      rethrow;
    }
  }

  /// This method creates an OAuth2 client using the Authorization Code Grant flow.
  /// It first obtains an authorization URL from the authorization server and opens it in the user's browser using the redirect function.
  /// It then listens for the incoming request on the HttpServer to obtain the authorization code, and uses it to obtain an OAuth2 token.
  Future<oauth2.Client> _getOAuth2Client({
    required Uri redirectUrl,
    required RedirectUri redirect,
    required String redirectPage,
    String? contentType,
  }) async {
    try {
      var grant = oauth2.AuthorizationCodeGrant(
        _configuration.clientID,
        Uri.parse(_configuration.authorizationEndpoint),
        Uri.parse(_configuration.tokenEndpoint),
        httpClient: JsonAcceptingHttpClient(),
        secret: _configuration.clientSecret,
      );

      var authorizationUrl = grant.getAuthorizationUrl(
        redirectUrl,
        scopes: _configuration.scopes,
      );

      await redirect(authorizationUrl);

      final responseQueryParameters = await _listen(
        redirectPage: redirectPage,
        contentType: contentType,
      );

      final client = await grant.handleAuthorizationResponse(
        responseQueryParameters,
      );

      client.close();

      return client;
    } on oauth2.AuthorizationException catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<Credentials> getRefreshToken(
    String accessToken,
    String refreshToken,
    String idToken, {
    List<String>? newScopes,
  }) async {
    final credentials = Credentials(
      accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
      expiration: DateTime(3600),
      tokenEndpoint: Uri.parse(_configuration.tokenEndpoint),
    );
    return await credentials.refresh(
      newScopes: newScopes,
      identifier: _configuration.clientID,
      secret: _configuration.clientSecret,
    );
  }
}

/// An HTTP client that accepts JSON.
class JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();

  /// Overrides the send method to add a header to the request.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
