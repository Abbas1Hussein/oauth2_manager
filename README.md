# oauth_manager

An easy-to-use OAuth2 manager for Dart applications.

## Usage

### Authorization Code Grant

To use the Authorization Code Grant flow, first create an instance of the `OAuth2` class:

```dart
import 'package:oauth2_manager/oauth2_manager.dart';

// can used to handles all oauth2;
final oauth = OAuth2();

```

Then call the `login` method and pass in the `OAuth2Model` configuration, redirect URI, and redirect page:

```dart
final credentials = await oauth.login(
  configuration: OAuth2Model(
    clientID: '<client ID>',
    clientSecret: '<client secret>',
    authorizationEndpoint: '<authorization endpoint>',
    tokenEndpoint: '<token endpoint>',
    scopes: ['<scope>'],
  ),
  redirectUri: (Uri uri) async {
    // Open the authorization URL in the user's browser
    // Example: await launch('$uri');
  },
  redirectPage: '<the page to display after authorization>',
  contentType:  '<content type of redirectPage>',
);
```

### Refresh Token Grant

To use the Refresh Token Grant flow, call the `getRefreshToken` method and pass in the access token and scopes:

```dart
final newCredentials = await oauth.getRefreshToken('<accessToken>','<refreshToken>','<idToken>',['<new scope>']);
```
## Installation

To use this package, add `oauth2_manager` as a [dependency in your `pubspec.yaml` file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).
