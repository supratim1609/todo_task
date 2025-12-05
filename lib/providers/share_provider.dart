import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/share_repository.dart';
import '../services/share_service.dart';

final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  final shareService = ref.watch(shareServiceProvider);
  return ShareRepository(shareService);
});
