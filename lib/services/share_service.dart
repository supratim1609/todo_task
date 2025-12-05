import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import '../models/task_model.dart';
import '../models/task_share_model.dart';

class ShareService {
  Future<void> shareTaskViaEmail(TaskModel task) async {
    final shareText = '''
Check out this task:

Title: ${task.title}
Description: ${task.description}
Status: ${task.isCompleted ? 'Completed' : 'Pending'}

Shared from TODO App
''';

    await Share.share(
      shareText,
      subject: 'Task: ${task.title}',
    );
  }

  String generateShareLink(TaskModel task) {
    final taskData = task.toJson();
    final encodedData = base64Url.encode(utf8.encode(json.encode(taskData)));
    
    return 'todoapp://share?data=$encodedData';
  }

  TaskModel? parseShareLink(String link) {
    try {
      final uri = Uri.parse(link);
      
      if (uri.scheme != 'todoapp' || uri.host != 'share') {
        return null;
      }

      final encodedData = uri.queryParameters['data'];
      if (encodedData == null) return null;

      final decodedData = utf8.decode(base64Url.decode(encodedData));
      final taskJson = json.decode(decodedData);

      return TaskModel.fromJson(taskJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> shareTaskLink(TaskModel task) async {
    final shareLink = generateShareLink(task);
    
    final shareText = '''
${task.title}

${task.description}

Open this link to view the task:
$shareLink
''';

    await Share.share(shareText, subject: 'Shared Task: ${task.title}');
  }

  TaskShareModel createShareModel(TaskModel task, List<String> emails) {
    return TaskShareModel(
      taskId: task.id,
      shareLink: generateShareLink(task),
      sharedWithEmails: emails,
      sharedAt: DateTime.now(),
      ownerId: task.ownerId,
    );
  }

  Future<void> shareTaskWithUsers(
    TaskModel task,
    List<String> emails,
  ) async {
    final shareLink = generateShareLink(task);
    
    final shareText = '''
You've been invited to collaborate on a task:

Title: ${task.title}
Description: ${task.description}

Click the link below to view and edit:
$shareLink

Shared via TODO App
''';

    await Share.share(
      shareText,
      subject: 'Task Shared: ${task.title}',
    );
  }
}
