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

import 'asset.pb.dart' as $5;
import 'asset.pbjson.dart';

export 'asset.pb.dart';

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$5.ImportAssetFromSourceResponse> importAssetFromSource(
      $pb.ServerContext ctx, $5.ImportAssetFromSourceRequest request);
  $async.Future<$5.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $5.ListAssetsRequest request);
  $async.Future<$5.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $5.GetAssetRequest request);
  $async.Future<$5.UpdateAssetResponse> updateAsset(
      $pb.ServerContext ctx, $5.UpdateAssetRequest request);
  $async.Future<$5.RetryPostprocessResponse> retryPostprocess(
      $pb.ServerContext ctx, $5.RetryPostprocessRequest request);
  $async.Future<$5.DeleteAssetResponse> deleteAsset(
      $pb.ServerContext ctx, $5.DeleteAssetRequest request);
  $async.Future<$5.ListDuplicateAssetsResponse> listDuplicateAssets(
      $pb.ServerContext ctx, $5.ListDuplicateAssetsRequest request);
  $async.Future<$5.ResolveDuplicateGroupResponse> resolveDuplicateGroup(
      $pb.ServerContext ctx, $5.ResolveDuplicateGroupRequest request);
  $async.Future<$5.MergeAssetsResponse> mergeAssets(
      $pb.ServerContext ctx, $5.MergeAssetsRequest request);
  $async.Future<$5.ListUploadFormatsResponse> listUploadFormats(
      $pb.ServerContext ctx, $5.ListUploadFormatsRequest request);
  $async.Future<$5.AttachAssetResponse> attachAsset(
      $pb.ServerContext ctx, $5.AttachAssetRequest request);
  $async.Future<$5.DetachAssetResponse> detachAsset(
      $pb.ServerContext ctx, $5.DetachAssetRequest request);
  $async.Future<$5.CreateCommentResponse> createComment(
      $pb.ServerContext ctx, $5.CreateCommentRequest request);
  $async.Future<$5.UpdateCommentResponse> updateComment(
      $pb.ServerContext ctx, $5.UpdateCommentRequest request);
  $async.Future<$5.ListCommentsResponse> listComments(
      $pb.ServerContext ctx, $5.ListCommentsRequest request);
  $async.Future<$5.DeleteCommentResponse> deleteComment(
      $pb.ServerContext ctx, $5.DeleteCommentRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return $5.ImportAssetFromSourceRequest();
      case 'ListAssets':
        return $5.ListAssetsRequest();
      case 'GetAsset':
        return $5.GetAssetRequest();
      case 'UpdateAsset':
        return $5.UpdateAssetRequest();
      case 'RetryPostprocess':
        return $5.RetryPostprocessRequest();
      case 'DeleteAsset':
        return $5.DeleteAssetRequest();
      case 'ListDuplicateAssets':
        return $5.ListDuplicateAssetsRequest();
      case 'ResolveDuplicateGroup':
        return $5.ResolveDuplicateGroupRequest();
      case 'MergeAssets':
        return $5.MergeAssetsRequest();
      case 'ListUploadFormats':
        return $5.ListUploadFormatsRequest();
      case 'AttachAsset':
        return $5.AttachAssetRequest();
      case 'DetachAsset':
        return $5.DetachAssetRequest();
      case 'CreateComment':
        return $5.CreateCommentRequest();
      case 'UpdateComment':
        return $5.UpdateCommentRequest();
      case 'ListComments':
        return $5.ListCommentsRequest();
      case 'DeleteComment':
        return $5.DeleteCommentRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return importAssetFromSource(
            ctx, request as $5.ImportAssetFromSourceRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $5.ListAssetsRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $5.GetAssetRequest);
      case 'UpdateAsset':
        return updateAsset(ctx, request as $5.UpdateAssetRequest);
      case 'RetryPostprocess':
        return retryPostprocess(ctx, request as $5.RetryPostprocessRequest);
      case 'DeleteAsset':
        return deleteAsset(ctx, request as $5.DeleteAssetRequest);
      case 'ListDuplicateAssets':
        return listDuplicateAssets(
            ctx, request as $5.ListDuplicateAssetsRequest);
      case 'ResolveDuplicateGroup':
        return resolveDuplicateGroup(
            ctx, request as $5.ResolveDuplicateGroupRequest);
      case 'MergeAssets':
        return mergeAssets(ctx, request as $5.MergeAssetsRequest);
      case 'ListUploadFormats':
        return listUploadFormats(ctx, request as $5.ListUploadFormatsRequest);
      case 'AttachAsset':
        return attachAsset(ctx, request as $5.AttachAssetRequest);
      case 'DetachAsset':
        return detachAsset(ctx, request as $5.DetachAssetRequest);
      case 'CreateComment':
        return createComment(ctx, request as $5.CreateCommentRequest);
      case 'UpdateComment':
        return updateComment(ctx, request as $5.UpdateCommentRequest);
      case 'ListComments':
        return listComments(ctx, request as $5.ListCommentsRequest);
      case 'DeleteComment':
        return deleteComment(ctx, request as $5.DeleteCommentRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}
