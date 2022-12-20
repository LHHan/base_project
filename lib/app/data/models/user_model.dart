class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int? ?? -1,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
      };

  String get localKey => 'keyUser';
}
