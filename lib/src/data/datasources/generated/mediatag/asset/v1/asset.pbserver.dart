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

import 'asset.pb.dart' as $3;
import 'asset.pbjson.dart';

export 'asset.pb.dart';

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$3.ImportAssetFromSourceResponse> importAssetFromSource(
      $pb.ServerContext ctx, $3.ImportAssetFromSourceRequest request);
  $async.Future<$3.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $3.ListAssetsRequest request);
  $async.Future<$3.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $3.GetAssetRequest request);
  $async.Future<$3.UpdateAssetResponse> updateAsset(
      $pb.ServerContext ctx, $3.UpdateAssetRequest request);
  $async.Future<$3.DeleteAssetResponse> deleteAsset(
      $pb.ServerContext ctx, $3.DeleteAssetRequest request);
  $async.Future<$3.ListDuplicateAssetsResponse> listDuplicateAssets(
      $pb.ServerContext ctx, $3.ListDuplicateAssetsRequest request);
  $async.Future<$3.ResolveDuplicateGroupResponse> resolveDuplicateGroup(
      $pb.ServerContext ctx, $3.ResolveDuplicateGroupRequest request);
  $async.Future<$3.MergeAssetsResponse> mergeAssets(
      $pb.ServerContext ctx, $3.MergeAssetsRequest request);
  $async.Future<$3.ListUploadFormatsResponse> listUploadFormats(
      $pb.ServerContext ctx, $3.ListUploadFormatsRequest request);
  $async.Future<$3.AttachAssetResponse> attachAsset(
      $pb.ServerContext ctx, $3.AttachAssetRequest request);
  $async.Future<$3.DetachAssetResponse> detachAsset(
      $pb.ServerContext ctx, $3.DetachAssetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return $3.ImportAssetFromSourceRequest();
      case 'ListAssets':
        return $3.ListAssetsRequest();
      case 'GetAsset':
        return $3.GetAssetRequest();
      case 'UpdateAsset':
        return $3.UpdateAssetRequest();
      case 'DeleteAsset':
        return $3.DeleteAssetRequest();
      case 'ListDuplicateAssets':
        return $3.ListDuplicateAssetsRequest();
      case 'ResolveDuplicateGroup':
        return $3.ResolveDuplicateGroupRequest();
      case 'MergeAssets':
        return $3.MergeAssetsRequest();
      case 'ListUploadFormats':
        return $3.ListUploadFormatsRequest();
      case 'AttachAsset':
        return $3.AttachAssetRequest();
      case 'DetachAsset':
        return $3.DetachAssetRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return importAssetFromSource(
            ctx, request as $3.ImportAssetFromSourceRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $3.ListAssetsRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $3.GetAssetRequest);
      case 'UpdateAsset':
        return updateAsset(ctx, request as $3.UpdateAssetRequest);
      case 'DeleteAsset':
        return deleteAsset(ctx, request as $3.DeleteAssetRequest);
      case 'ListDuplicateAssets':
        return listDuplicateAssets(
            ctx, request as $3.ListDuplicateAssetsRequest);
      case 'ResolveDuplicateGroup':
        return resolveDuplicateGroup(
            ctx, request as $3.ResolveDuplicateGroupRequest);
      case 'MergeAssets':
        return mergeAssets(ctx, request as $3.MergeAssetsRequest);
      case 'ListUploadFormats':
        return listUploadFormats(ctx, request as $3.ListUploadFormatsRequest);
      case 'AttachAsset':
        return attachAsset(ctx, request as $3.AttachAssetRequest);
      case 'DetachAsset':
        return detachAsset(ctx, request as $3.DetachAssetRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}
