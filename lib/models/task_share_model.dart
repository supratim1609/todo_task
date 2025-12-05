class TaskShareModel {
  final String taskId;
  final String shareLink;
  final List<String> sharedWithEmails;
  final DateTime sharedAt;
  final String ownerId;

  TaskShareModel({
    required this.taskId,
    required this.shareLink,
    required this.sharedWithEmails,
    required this.sharedAt,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'shareLink': shareLink,
      'sharedWithEmails': sharedWithEmails,
      'sharedAt': sharedAt.toIso8601String(),
      'ownerId': ownerId,
    };
  }

  factory TaskShareModel.fromJson(Map<String, dynamic> json) {
    return TaskShareModel(
      taskId: json['taskId'] as String,
      shareLink: json['shareLink'] as String,
      sharedWithEmails: (json['sharedWithEmails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sharedAt: DateTime.parse(json['sharedAt'] as String),
      ownerId: json['ownerId'] as String,
    );
  }

  TaskShareModel copyWith({
    String? taskId,
    String? shareLink,
    List<String>? sharedWithEmails,
    DateTime? sharedAt,
    String? ownerId,
  }) {
    return TaskShareModel(
      taskId: taskId ?? this.taskId,
      shareLink: shareLink ?? this.shareLink,
      sharedWithEmails: sharedWithEmails ?? this.sharedWithEmails,
      sharedAt: sharedAt ?? this.sharedAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
