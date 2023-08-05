import 'package:oauth2_manager/oauth2_manager.dart';

main() async {
  /// Google
  final googleConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://accounts.google.com/o/oauth2/v2/auth',
    tokenEndpoint: 'https://oauth2.googleapis.com/token',
    scopes: ['<scope>'],
  );

  /// Facebook
  final facebookConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://www.facebook.com/v12.0/dialog/oauth',
    tokenEndpoint: 'https://graph.facebook.com/v12.0/oauth/access_token',
    scopes: ['<scope>'],
  );

  /// Twitter
  final twitterConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://api.twitter.com/oauth/authenticate',
    tokenEndpoint: 'https://api.twitter.com/oauth/access_token',
    scopes: ['<scope>'],
  );

  /// Github
  final githubConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://github.com/login/oauth/authorize',
    tokenEndpoint: 'https://github.com/login/oauth/access_token',
    scopes: ['<scope>'],
  );

  /// LinkedIn
  final linkedInConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://www.linkedin.com/oauth/v2/authorization',
    tokenEndpoint: 'https://www.linkedin.com/oauth/v2/accessToken',
    scopes: ['<scope>'],
  );

  /// Microsoft
  final microsoftConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint:
        'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
    tokenEndpoint: 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
    scopes: ['<scope>'],
  );

  /// Amazon
  final amazonConfiguration = OAuth2Configuration(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: 'https://www.amazon.com/ap/oa',
    tokenEndpoint: 'https://api.amazon.com/auth/o2/token',
    scopes: ['<scope>'],
  );


  String authorizationSuccessHtml = '''
<!DOCTYPE html>
<html>
<head>
  <title>Authorization Success</title>
</head>
<body>
  <h1>Authorization Successful</h1>
  <p>You have successfully authorized the application.</p>
  <!-- You can add more content or elements here as needed -->
</body>
</html>
''';

  await OAuth2.login(
    googleConfiguration,
    redirect: (uri) async {
      print(uri.toString());
      // Open the authorization URL in the user's browser
      // Example: await launch('$uri');
    },
    redirectPage: authorizationSuccessHtml,
    contentType: 'text/html',
  );


}
