class Languages {
  final int? id;
  final String? langCode;
  final String? langName;
  final String? langFlag;

  Languages({
    this.id,
    this.langCode,
    this.langName,
    this.langFlag,
  });

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
        id: json['id'] as int? ?? -1,
        langCode: json['langCode'] as String? ?? '',
        langName: json['langName'] as String? ?? '',
        langFlag: json['langFlag'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'langCode': langCode,
        'langName': langName,
        'langFlag': langFlag,
      };

  String get localKey => 'keyLanguages';
}
