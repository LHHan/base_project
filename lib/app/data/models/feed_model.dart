class FeedModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;
  final int userId;

  const FeedModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
    required this.userId,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] as Map<String, dynamic>? ?? {};
    return FeedModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String? ?? '')
              .where((t) => t.isNotEmpty)
              .toList() ??
          [],
      likes: reactions['likes'] as int? ?? 0,
      dislikes: reactions['dislikes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
    );
  }
}
