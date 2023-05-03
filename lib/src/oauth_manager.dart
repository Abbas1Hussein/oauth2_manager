import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

import 'oauth_model.dart';
import 'typedef.dart';

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
  final OAuth2Model _configuration;
  final RedirectUri _redirect;
  final String _redirectPage;
  final String? _contentType;

  OAuth2Manager({
    required OAuth2Model configuration,
    required RedirectUri redirect,
    required String redirectPage,
    String? contentType = 'text/html',
  })  : _contentType = contentType,
        _redirectPage = redirectPage,
        _redirect = redirect,
        _configuration = configuration;

  /// This method initiates the OAuth2 flow by creating a HttpServer to receive the authorization code,
  /// opening the authorization page in the user's browser, and handling the authorization response to obtain an OAuth2 token.

  Future<oauth2.Credentials> login() async {
    await _redirectServer?.close();
    try {
      _redirectServer = await HttpServer.bind('localhost', 0);
      final redirectURL = 'http://localhost:${_redirectServer!.port}/auth';

      final authenticatedHttpClient = await _getOAuth2Client(
        redirectUrl: Uri.parse(redirectURL),
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
  }) async {
    try {
      var grant = oauth2.AuthorizationCodeGrant(
        _configuration.clientID,
        Uri.parse(_configuration.authorizationEndpoint),
        Uri.parse(_configuration.tokenEndpoint),
        httpClient: JsonAcceptingHttpClient(),
        secret: _configuration.clientSecret,
      );

      final authorizationUrl = grant.getAuthorizationUrl(
        redirectUrl,
        scopes: _configuration.scopes,
      );

      await _redirect(authorizationUrl);

      final responseQueryParameters = await _listen(
        redirectPage: _redirectPage,
        contentType: _contentType,
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

  Future<void> getRefreshToken(
    List<String> newScopes,
  ) async {
    await _redirectServer?.close();
    _redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${_redirectServer!.port}/auth';

    var grant = oauth2.AuthorizationCodeGrant(
      _configuration.clientID,
      Uri.parse(_configuration.authorizationEndpoint),
      Uri.parse(_configuration.tokenEndpoint),
      httpClient: JsonAcceptingHttpClient(),
      secret: _configuration.clientSecret,
    );

    var authorizationUrl = grant.getAuthorizationUrl(
      Uri.parse(redirectURL),
      scopes: _configuration.scopes,
    );

    // ADD THIS:
    authorizationUrl = authorizationUrl.replace(
      queryParameters: {
        ...authorizationUrl.queryParameters,
        "access_type": "offline",
      },
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
