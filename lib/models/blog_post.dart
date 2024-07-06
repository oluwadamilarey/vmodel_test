import 'package:intl/intl.dart';

class BlogPost {
  final String id;
  final String title;
  final String subTitle;
  final String body;
  final DateTime dateCreated;

  BlogPost({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      subTitle: json['subTitle'],
      body: json['body'],
      dateCreated: DateTime.parse(json['dateCreated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subTitle': subTitle,
      'body': body,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  String get formattedDate {
    return DateFormat('MMMM d, y').format(dateCreated);
  }

  BlogPost copyWith({
    String? id,
    String? title,
    String? subTitle,
    String? body,
    DateTime? dateCreated,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      body: body ?? this.body,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }
}