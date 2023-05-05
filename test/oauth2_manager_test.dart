import 'package:oauth2_manager/oauth_manager.dart';
import 'package:oauth2_manager/src/oauth2_manager.dart';

main() async {
  final oauth2Configuration = OAuth2Configuration(
    clientID: '922985719831-tp1qj0f3ajp9hunk9sb0mhbph85mft6b.apps.googleusercontent.com',
    clientSecret: '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',
    authorizationEndpoint: 'https://accounts.google.com/o/oauth2/auth',
    tokenEndpoint: 'https://oauth2.googleapis.com/token',
    scopes: [
      'https://www.googleapis.com/auth/blogger',
      'https://www.googleapis.com/auth/userinfo.profile'
    ],
  );

  final oauth2Manager = OAuth2Manager(
    configuration: oauth2Configuration,
    redirectPage: '<html><body><h1>Welcome to my app!</h1></body></html>',
    contentType: 'text/html',
    redirect: (uri) async => print(uri.toString()),
  );

  final oauth2 = OAuth2(oauth2Manager);

  final credentialsRefreshToken = await oauth2.getRefreshToken(accessToken, refreshToken, idToken, newScopes: []);
  print(credentialsRefreshToken.accessToken);
  print(credentialsRefreshToken.idToken);
  print(credentialsRefreshToken.refreshToken);
}
