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

import 'asset.pb.dart' as $2;
import 'asset.pbjson.dart';

export 'asset.pb.dart';

abstract class AssetServiceBase extends $pb.GeneratedService {
  $async.Future<$2.ImportAssetFromSourceResponse> importAssetFromSource(
      $pb.ServerContext ctx, $2.ImportAssetFromSourceRequest request);
  $async.Future<$2.ListAssetsResponse> listAssets(
      $pb.ServerContext ctx, $2.ListAssetsRequest request);
  $async.Future<$2.GetAssetResponse> getAsset(
      $pb.ServerContext ctx, $2.GetAssetRequest request);
  $async.Future<$2.DeleteAssetResponse> deleteAsset(
      $pb.ServerContext ctx, $2.DeleteAssetRequest request);
  $async.Future<$2.ListDuplicateAssetsResponse> listDuplicateAssets(
      $pb.ServerContext ctx, $2.ListDuplicateAssetsRequest request);
  $async.Future<$2.ListUploadFormatsResponse> listUploadFormats(
      $pb.ServerContext ctx, $2.ListUploadFormatsRequest request);
  $async.Future<$2.ListJobAssetsResponse> listJobAssets(
      $pb.ServerContext ctx, $2.ListJobAssetsRequest request);
  $async.Future<$2.AttachAssetResponse> attachAsset(
      $pb.ServerContext ctx, $2.AttachAssetRequest request);
  $async.Future<$2.DetachAssetResponse> detachAsset(
      $pb.ServerContext ctx, $2.DetachAssetRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return $2.ImportAssetFromSourceRequest();
      case 'ListAssets':
        return $2.ListAssetsRequest();
      case 'GetAsset':
        return $2.GetAssetRequest();
      case 'DeleteAsset':
        return $2.DeleteAssetRequest();
      case 'ListDuplicateAssets':
        return $2.ListDuplicateAssetsRequest();
      case 'ListUploadFormats':
        return $2.ListUploadFormatsRequest();
      case 'ListJobAssets':
        return $2.ListJobAssetsRequest();
      case 'AttachAsset':
        return $2.AttachAssetRequest();
      case 'DetachAsset':
        return $2.DetachAssetRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ImportAssetFromSource':
        return importAssetFromSource(
            ctx, request as $2.ImportAssetFromSourceRequest);
      case 'ListAssets':
        return listAssets(ctx, request as $2.ListAssetsRequest);
      case 'GetAsset':
        return getAsset(ctx, request as $2.GetAssetRequest);
      case 'DeleteAsset':
        return deleteAsset(ctx, request as $2.DeleteAssetRequest);
      case 'ListDuplicateAssets':
        return listDuplicateAssets(
            ctx, request as $2.ListDuplicateAssetsRequest);
      case 'ListUploadFormats':
        return listUploadFormats(ctx, request as $2.ListUploadFormatsRequest);
      case 'ListJobAssets':
        return listJobAssets(ctx, request as $2.ListJobAssetsRequest);
      case 'AttachAsset':
        return attachAsset(ctx, request as $2.AttachAssetRequest);
      case 'DetachAsset':
        return detachAsset(ctx, request as $2.DetachAssetRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => AssetServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => AssetServiceBase$messageJson;
}
