import 'package:oauth2_manager/oauth_manager.dart';
import 'package:oauth2_manager/src/oauth2_manager.dart';

main() async {
  final oauth2Manager = OAuth2Manager(
    configuration: OAuth2Configuration(
      clientID: '<client ID>',
      clientSecret: '<client secret>',
      authorizationEndpoint: '<authorization endpoint>',
      tokenEndpoint: '<token endpoint>',
      scopes: ['<scope>'],
    ),
  );

  final oauth2 = OAuth2(oauth2Manager);

  final login = oauth2.login(
    redirectPage: '<html><body><h1> Welcome to my app! </h1></body></html>',
    contentType: 'text/html',
    redirect: (uri) async => print(uri.toString()),
  );

  final credentialsRefreshToken = await oauth2.getRefreshToken(
    '<accessToken>',
    '<refreshToken>',
    '<idToken>',
    newScopes: [],
  );
  print(credentialsRefreshToken.accessToken);
  print(credentialsRefreshToken.idToken);
  print(credentialsRefreshToken.refreshToken);
}
