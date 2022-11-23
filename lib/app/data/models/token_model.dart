class Token {
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  Token({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        tokenType: json['token_type'] as String? ?? '',
        expiresIn: json['expires_in'] as int? ?? -1,
        accessToken: json['access_token'] as String? ?? '',
        refreshToken: json['refresh_token'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token_type': tokenType,
        'expires_in': expiresIn,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}
