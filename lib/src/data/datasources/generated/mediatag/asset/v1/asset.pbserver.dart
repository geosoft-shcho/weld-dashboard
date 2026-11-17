// This is a generated file - do not edit.
//
// Generated from mediatag/asset/v1/asset.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'asset.pb.dart' as $4;
import 'asset.pbjson.dart';

export 'asset.pb.dart';

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$4.ImportAssetFromSourceResponse> importAssetFromSource(
      $pb.ServerContext ctx, $4.ImportAssetFromSourceRequest request);
  $async.Future<$4.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $4.ListAssetsRequest request);
  $async.Future<$4.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $4.GetAssetRequest request);
  $async.Future<$4.UpdateAssetResponse> updateAsset(
      $pb.ServerContext ctx, $4.UpdateAssetRequest request);
  $async.Future<$4.RetryPostprocessResponse> retryPostprocess(
      $pb.ServerContext ctx, $4.RetryPostprocessRequest request);
  $async.Future<$4.DeleteAssetResponse> deleteAsset(
      $pb.ServerContext ctx, $4.DeleteAssetRequest request);
  $async.Future<$4.ListDuplicateAssetsResponse> listDuplicateAssets(
      $pb.ServerContext ctx, $4.ListDuplicateAssetsRequest request);
  $async.Future<$4.ResolveDuplicateGroupResponse> resolveDuplicateGroup(
      $pb.ServerContext ctx, $4.ResolveDuplicateGroupRequest request);
  $async.Future<$4.MergeAssetsResponse> mergeAssets(
      $pb.ServerContext ctx, $4.MergeAssetsRequest request);
  $async.Future<$4.ListUploadFormatsResponse> listUploadFormats(
      $pb.ServerContext ctx, $4.ListUploadFormatsRequest request);
  $async.Future<$4.AttachAssetResponse> attachAsset(
      $pb.ServerContext ctx, $4.AttachAssetRequest request);
  $async.Future<$4.DetachAssetResponse> detachAsset(
      $pb.ServerContext ctx, $4.DetachAssetRequest request);
  $async.Future<$4.CreateCommentResponse> createComment(
      $pb.ServerContext ctx, $4.CreateCommentRequest request);
  $async.Future<$4.UpdateCommentResponse> updateComment(
      $pb.ServerContext ctx, $4.UpdateCommentRequest request);
  $async.Future<$4.ListCommentsResponse> listComments(
      $pb.ServerContext ctx, $4.ListCommentsRequest request);
  $async.Future<$4.DeleteCommentResponse> deleteComment(
      $pb.ServerContext ctx, $4.DeleteCommentRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return $4.ImportAssetFromSourceRequest();
      case 'ListAssets':
        return $4.ListAssetsRequest();
      case 'GetAsset':
        return $4.GetAssetRequest();
      case 'UpdateAsset':
        return $4.UpdateAssetRequest();
      case 'RetryPostprocess':
        return $4.RetryPostprocessRequest();
      case 'DeleteAsset':
        return $4.DeleteAssetRequest();
      case 'ListDuplicateAssets':
        return $4.ListDuplicateAssetsRequest();
      case 'ResolveDuplicateGroup':
        return $4.ResolveDuplicateGroupRequest();
      case 'MergeAssets':
        return $4.MergeAssetsRequest();
      case 'ListUploadFormats':
        return $4.ListUploadFormatsRequest();
      case 'AttachAsset':
        return $4.AttachAssetRequest();
      case 'DetachAsset':
        return $4.DetachAssetRequest();
      case 'CreateComment':
        return $4.CreateCommentRequest();
      case 'UpdateComment':
        return $4.UpdateCommentRequest();
      case 'ListComments':
        return $4.ListCommentsRequest();
      case 'DeleteComment':
        return $4.DeleteCommentRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return importAssetFromSource(
            ctx, request as $4.ImportAssetFromSourceRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $4.ListAssetsRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $4.GetAssetRequest);
      case 'UpdateAsset':
        return updateAsset(ctx, request as $4.UpdateAssetRequest);
      case 'RetryPostprocess':
        return retryPostprocess(ctx, request as $4.RetryPostprocessRequest);
      case 'DeleteAsset':
        return deleteAsset(ctx, request as $4.DeleteAssetRequest);
      case 'ListDuplicateAssets':
        return listDuplicateAssets(
            ctx, request as $4.ListDuplicateAssetsRequest);
      case 'ResolveDuplicateGroup':
        return resolveDuplicateGroup(
            ctx, request as $4.ResolveDuplicateGroupRequest);
      case 'MergeAssets':
        return mergeAssets(ctx, request as $4.MergeAssetsRequest);
      case 'ListUploadFormats':
        return listUploadFormats(ctx, request as $4.ListUploadFormatsRequest);
      case 'AttachAsset':
        return attachAsset(ctx, request as $4.AttachAssetRequest);
      case 'DetachAsset':
        return detachAsset(ctx, request as $4.DetachAssetRequest);
      case 'CreateComment':
        return createComment(ctx, request as $4.CreateCommentRequest);
      case 'UpdateComment':
        return updateComment(ctx, request as $4.UpdateCommentRequest);
      case 'ListComments':
        return listComments(ctx, request as $4.ListCommentsRequest);
      case 'DeleteComment':
        return deleteComment(ctx, request as $4.DeleteCommentRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}
