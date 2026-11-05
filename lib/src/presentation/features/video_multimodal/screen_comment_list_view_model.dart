import 'package:flutter/foundation.dart';

import '../../../domain/entities/asset_upload.dart';
import '../../../domain/entities/screen_comment.dart';
import '../../../domain/use_cases/delete_screen_comment_use_case.dart';
import '../../../domain/use_cases/list_screen_comments_use_case.dart';
import '../../../domain/use_cases/update_screen_comment_use_case.dart';

class ScreenCommentListViewModel extends ChangeNotifier {
  ScreenCommentListViewModel({
    required ListScreenCommentsUseCase listScreenCommentsUseCase,
    required UpdateScreenCommentUseCase updateScreenCommentUseCase,
    required DeleteScreenCommentUseCase deleteScreenCommentUseCase,
    required this.jobId,
  }) : _listScreenCommentsUseCase = listScreenCommentsUseCase,
       _updateScreenCommentUseCase = updateScreenCommentUseCase,
       _deleteScreenCommentUseCase = deleteScreenCommentUseCase;

  final ListScreenCommentsUseCase _listScreenCommentsUseCase;
  final UpdateScreenCommentUseCase _updateScreenCommentUseCase;
  final DeleteScreenCommentUseCase _deleteScreenCommentUseCase;
  final String jobId;

  List<ScreenComment> comments = const [];
  final Map<String, String> failureByCommentId = {};
  String busyCommentId = '';
  bool _isClosed = false;

  String failureText(String commentId) => failureByCommentId[commentId] ?? '';

  bool isBusy(String commentId) => busyCommentId == commentId;

  Future<void> loadComments() async {
    if (_isClosed) {
      return;
    }
    if (jobId.isEmpty) {
      comments = const [];
      notifyListeners();
      return;
    }
    try {
      comments = await _listScreenCommentsUseCase.execute(jobId: jobId);
    } catch (_) {
      comments = const [];
    }
    if (_isClosed) {
      return;
    }
    notifyListeners();
  }

  Future<void> updateBody({
    required String commentId,
    required String body,
  }) async {
    if (_isClosed || isBusy(commentId)) {
      return;
    }
    busyCommentId = commentId;
    notifyListeners();
    try {
      await _updateScreenCommentUseCase.execute(
        commentId: commentId,
        body: body,
      );
      failureByCommentId.remove(commentId);
      await loadComments();
    } on AssetUploadException {
      failureByCommentId[commentId] = '글을 고치지 못했습니다.';
    } catch (_) {
      failureByCommentId[commentId] = '글을 고치지 못했습니다.';
    } finally {
      if (busyCommentId == commentId) {
        busyCommentId = '';
      }
      if (!_isClosed) {
        notifyListeners();
      }
    }
  }

  Future<void> deleteComment({required String commentId}) async {
    if (_isClosed || isBusy(commentId)) {
      return;
    }
    busyCommentId = commentId;
    notifyListeners();
    try {
      await _deleteScreenCommentUseCase.execute(commentId: commentId);
      failureByCommentId.remove(commentId);
      await loadComments();
    } on AssetUploadException {
      failureByCommentId[commentId] = '코멘트를 지우지 못했습니다.';
    } catch (_) {
      failureByCommentId[commentId] = '코멘트를 지우지 못했습니다.';
    } finally {
      if (busyCommentId == commentId) {
        busyCommentId = '';
      }
      if (!_isClosed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isClosed = true;
    super.dispose();
  }
}
