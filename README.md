# oauth_manager

An easy-to-use OAuth2 manager for Dart applications.

## Usage

### Authorization Code Grant

To use the Authorization Code Grant flow, first create an instance of the `OAuth2`class and pass in the configuration OAuth2Configuration:

```dart
import 'package:oauth2_manager/oauth2_manager.dart';

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
```

Then call the `login` method and pass in the redirect URI, and redirect page:

```dart
final credentials = await oauth.login(
  redirectUri: (Uri uri) async {
    // Open the authorization URL in the user's browser
    // Example: await launch('$uri');
  },
  redirectPage: '<the page to display after authorization>',
  contentType:  '<content type of redirectPage>',
);
```

### Refresh Token Grant

To use the Refresh Token Grant flow, call the `getRefreshToken` method and pass parameters:

```dart
final newCredentials = await oauth.getRefreshToken('<accessToken>','<refreshToken>','<idToken>',['<new scope>']);
```
## Installation

To use this package, add `oauth2_manager` as a [dependency in your `pubspec.yaml` file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).
