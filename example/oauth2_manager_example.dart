import 'package:oauth2_manager/oauth_manager.dart';

main() async {

  final oauth2Configuration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    tokenEndpoint: '<token endpoint>',
    authorizationEndpoint: '<authorization endpoint>',
    scopes: ['<scope>'],
  );

  final credentials = await OAuth2.login(
    oauth2Configuration,
    redirect: (uri) async {
      // Open the authorization URL in the user's browser
      // Example: await launch('$uri');
    },
    redirectPage: '<the page to display after authorization>',
    contentType: '<content type of redirectPage>',
  );

  // credentials.accessToken
  // credentials.refreshToken,
  // credentials.idToken,
  // credentials.expiration
  // credentials.isExpired
  // credentials.canRefresh

  final newCredentials = await OAuth2.getRefreshToken(
    credentials.refreshToken!,
    newScopes: ['<scope>'],
    clientID: oauth2Configuration.clientID,
    clientSecret: oauth2Configuration.clientSecret!,
    tokenEndpoint: oauth2Configuration.authorizationEndpoint,
  );
}