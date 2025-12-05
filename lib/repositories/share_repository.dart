import '../models/task_model.dart';
import '../models/task_share_model.dart';
import '../services/share_service.dart';

class ShareRepository {
  final ShareService _shareService;

  ShareRepository(this._shareService);

  Future<void> shareViaEmail(TaskModel task) async {
    try {
      await _shareService.shareTaskViaEmail(task);
    } catch (e) {
      throw Exception('Failed to share via email: ${e.toString()}');
    }
  }

  Future<void> shareViaLink(TaskModel task) async {
    try {
      await _shareService.shareTaskLink(task);
    } catch (e) {
      throw Exception('Failed to share link: ${e.toString()}');
    }
  }

  String generateShareLink(TaskModel task) {
    try {
      return _shareService.generateShareLink(task);
    } catch (e) {
      throw Exception('Failed to generate share link: ${e.toString()}');
    }
  }

  TaskModel? parseShareLink(String link) {
    try {
      return _shareService.parseShareLink(link);
    } catch (e) {
      return null;
    }
  }

  Future<void> shareWithUsers(TaskModel task, List<String> emails) async {
    try {
      await _shareService.shareTaskWithUsers(task, emails);
    } catch (e) {
      throw Exception('Failed to share with users: ${e.toString()}');
    }
  }

  TaskShareModel createShareModel(TaskModel task, List<String> emails) {
    try {
      return _shareService.createShareModel(task, emails);
    } catch (e) {
      throw Exception('Failed to create share model: ${e.toString()}');
    }
  }
}
