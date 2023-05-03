/// This class represents the configuration for an OAuth2 server.
/// It contains the client ID, authorization endpoint, token endpoint, secret, and scopes required for authentication.
/// And contains the methods fromJson,toJson for fetching and sending data.
class OAuth2Model {
  /// The client ID for the OAuth2 server. This is a unique identifier for the client that is provided by the server.
  final String clientID;

  /// The endpoint for obtaining authorization from the user. This is the endpoint where the user is redirected to grant permission for the client to access their resources.
  final String authorizationEndpoint;

  /// The endpoint for obtaining access tokens. This is the endpoint where the client can exchange the authorization grant for an access token that can be used to access protected resources.
  final String tokenEndpoint;

  /// The client secret for the OAuth2 server. This is a secret key that is used to authenticate the client when requesting access tokens.
  final String? clientSecret;

  /// The scopes that the client is requesting. Scopes define the level of access that the client is requesting to the user's resources.
  final List<String> scopes;

  OAuth2Model({
    required this.clientID,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    this.clientSecret,
    required this.scopes,
  });

  factory OAuth2Model.fromJson(Map<String, dynamic> json) {
    return OAuth2Model(
      clientID: json['client_id'],
      authorizationEndpoint: json['authorizationEndpoint'],
      tokenEndpoint: json['tokenEndpoint'],
      clientSecret: json['clientSecret'],
      scopes: List<String>.from(json['scopes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientID,
      'authorizationEndpoint': authorizationEndpoint,
      'tokenEndpoint': tokenEndpoint,
      'clientSecret': clientSecret,
      'scopes': scopes,
    };
  }
}
