class HomeModel {
  final int id;

  HomeModel({
    required this.id,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        id: json['id'] as int? ?? -1,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
      };
}
