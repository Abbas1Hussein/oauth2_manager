# oauth_manager

An easy-to-use OAuth2 manager for Dart applications.

## Usage

### Authorization Code Grant

To use the Authorization Code Grant flow, first create an instance of the `OAuth2Configuration` class and pass in the parameters:

```dart
import 'package:oauth2_manager/oauth_manager.dart';

final oauth2Configuration = OAuth2Configuration(
  clientID: '<client ID>',
  clientSecret: '<client secret>',
  authorizationEndpoint: '<authorization endpoint>',
  tokenEndpoint: '<token endpoint>',
  scopes: ['<scope>'],
);

```

call the `login` method and pass in the oauth2Configuration, redirect, redirectPage, contentType:

```dart
final credentials = await OAuth2.login(
  oauth2Configuration,
  redirect: (uri) async {
    // Open the authorization URL in the user's browser
    // Example: await launch('$uri');
  },
  redirectPage: '<the page to display after authorization>',
  contentType: '<content type of redirectPage>',
);
```

### Refresh Token Grant

To use the Refresh Token Grant flow, call the `getRefreshToken` method and pass in the refresh token and other parameters:

```dart
final newCredentials = await OAuth2.getRefreshToken(
  refreshToken,
  newScopes: ['<new scope>'],
  clientID: oauth2Configuration.clientID,
  clientSecret: oauth2Configuration.clientSecret!,
  tokenEndpoint: oauth2Configuration.tokenEndpoint,
);
```

The `Credentials` class returned by `login` and `getRefreshToken` has the following properties:

- `accessToken`: the access token
- `refreshToken`: the refresh token
- `idToken`: the ID token type [jwt]
- `expiration`: the expiration date/time of the access token
- `isExpired`: a boolean indicating whether the access token has expired
- `canRefresh`: a boolean indicating whether the access token can be refreshed

## Installation

To use this package, add `oauth2_manager` as a [dependency in your `pubspec.yaml` file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).