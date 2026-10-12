// This is a generated file - do not edit.
//
// Generated from tacittag/rag/v2/rag.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use askQuestionRequestDescriptor instead')
const AskQuestionRequest$json = {
  '1': 'AskQuestionRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'question', '3': 2, '4': 1, '5': 9, '10': 'question'},
    {'1': 'top_k', '3': 3, '4': 1, '5': 5, '10': 'topK'},
    {'1': 'media_id', '3': 4, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'session_id', '3': 5, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `AskQuestionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List askQuestionRequestDescriptor = $convert.base64Decode(
    'ChJBc2tRdWVzdGlvblJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEhoKCH'
    'F1ZXN0aW9uGAIgASgJUghxdWVzdGlvbhITCgV0b3BfaxgDIAEoBVIEdG9wSxIZCghtZWRpYV9p'
    'ZBgEIAEoCVIHbWVkaWFJZBIdCgpzZXNzaW9uX2lkGAUgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use askQuestionResponseDescriptor instead')
const AskQuestionResponse$json = {
  '1': 'AskQuestionResponse',
  '2': [
    {'1': 'answer', '3': 1, '4': 1, '5': 9, '10': 'answer'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'media_id', '3': 3, '4': 1, '5': 9, '10': 'mediaId'},
    {
      '1': 'citations',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.tacittag.rag.v2.Citation',
      '10': 'citations'
    },
    {'1': 'session_id', '3': 5, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `AskQuestionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List askQuestionResponseDescriptor = $convert.base64Decode(
    'ChNBc2tRdWVzdGlvblJlc3BvbnNlEhYKBmFuc3dlchgBIAEoCVIGYW5zd2VyEh0KCnByb2plY3'
    'RfaWQYAiABKAlSCXByb2plY3RJZBIZCghtZWRpYV9pZBgDIAEoCVIHbWVkaWFJZBI3CgljaXRh'
    'dGlvbnMYBCADKAsyGS50YWNpdHRhZy5yYWcudjIuQ2l0YXRpb25SCWNpdGF0aW9ucxIdCgpzZX'
    'NzaW9uX2lkGAUgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use citationDescriptor instead')
const Citation$json = {
  '1': 'Citation',
  '2': [
    {'1': 'start_sec', '3': 1, '4': 1, '5': 1, '10': 'startSec'},
    {'1': 'end_sec', '3': 2, '4': 1, '5': 1, '10': 'endSec'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'score', '3': 4, '4': 1, '5': 1, '10': 'score'},
    {'1': 'layer_id', '3': 5, '4': 1, '5': 9, '10': 'layerId'},
    {'1': 'segment_id', '3': 6, '4': 1, '5': 9, '10': 'segmentId'},
  ],
};

/// Descriptor for `Citation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List citationDescriptor = $convert.base64Decode(
    'CghDaXRhdGlvbhIbCglzdGFydF9zZWMYASABKAFSCHN0YXJ0U2VjEhcKB2VuZF9zZWMYAiABKA'
    'FSBmVuZFNlYxISCgR0ZXh0GAMgASgJUgR0ZXh0EhQKBXNjb3JlGAQgASgBUgVzY29yZRIZCghs'
    'YXllcl9pZBgFIAEoCVIHbGF5ZXJJZBIdCgpzZWdtZW50X2lkGAYgASgJUglzZWdtZW50SWQ=');

@$core.Deprecated('Use getSessionHistoryRequestDescriptor instead')
const GetSessionHistoryRequest$json = {
  '1': 'GetSessionHistoryRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `GetSessionHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSessionHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRTZXNzaW9uSGlzdG9yeVJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbk'
        'lk');

@$core.Deprecated('Use getSessionHistoryResponseDescriptor instead')
const GetSessionHistoryResponse$json = {
  '1': 'GetSessionHistoryResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {
      '1': 'messages',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.tacittag.rag.v2.ChatMessage',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `GetSessionHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSessionHistoryResponseDescriptor = $convert.base64Decode(
    'ChlHZXRTZXNzaW9uSGlzdG9yeVJlc3BvbnNlEh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb2'
    '5JZBIdCgpwcm9qZWN0X2lkGAIgASgJUglwcm9qZWN0SWQSOAoIbWVzc2FnZXMYAyADKAsyHC50'
    'YWNpdHRhZy5yYWcudjIuQ2hhdE1lc3NhZ2VSCG1lc3NhZ2Vz');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'citations',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.tacittag.rag.v2.Citation',
      '10': 'citations'
    },
    {'1': 'created_at', '3': 5, '4': 1, '5': 9, '10': 'createdAt'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIOCgJpZBgBIAEoCVICaWQSEgoEcm9sZRgCIAEoCVIEcm9sZRIYCgdjb2'
    '50ZW50GAMgASgJUgdjb250ZW50EjcKCWNpdGF0aW9ucxgEIAMoCzIZLnRhY2l0dGFnLnJhZy52'
    'Mi5DaXRhdGlvblIJY2l0YXRpb25zEh0KCmNyZWF0ZWRfYXQYBSABKAlSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use indexProjectRequestDescriptor instead')
const IndexProjectRequest$json = {
  '1': 'IndexProjectRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'rebuild', '3': 3, '4': 1, '5': 8, '10': 'rebuild'},
    {'1': 'text_layer', '3': 4, '4': 1, '5': 9, '10': 'textLayer'},
    {'1': 'project_dir', '3': 5, '4': 1, '5': 9, '10': 'projectDir'},
    {'1': 'data_dir', '3': 6, '4': 1, '5': 9, '10': 'dataDir'},
  ],
};

/// Descriptor for `IndexProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indexProjectRequestDescriptor = $convert.base64Decode(
    'ChNJbmRleFByb2plY3RSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIZCg'
    'htZWRpYV9pZBgCIAEoCVIHbWVkaWFJZBIYCgdyZWJ1aWxkGAMgASgIUgdyZWJ1aWxkEh0KCnRl'
    'eHRfbGF5ZXIYBCABKAlSCXRleHRMYXllchIfCgtwcm9qZWN0X2RpchgFIAEoCVIKcHJvamVjdE'
    'RpchIZCghkYXRhX2RpchgGIAEoCVIHZGF0YURpcg==');

@$core.Deprecated('Use indexProjectResponseDescriptor instead')
const IndexProjectResponse$json = {
  '1': 'IndexProjectResponse',
  '2': [
    {'1': 'indexed_chunks', '3': 1, '4': 1, '5': 5, '10': 'indexedChunks'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'media_id', '3': 3, '4': 1, '5': 9, '10': 'mediaId'},
  ],
};

/// Descriptor for `IndexProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indexProjectResponseDescriptor = $convert.base64Decode(
    'ChRJbmRleFByb2plY3RSZXNwb25zZRIlCg5pbmRleGVkX2NodW5rcxgBIAEoBVINaW5kZXhlZE'
    'NodW5rcxIdCgpwcm9qZWN0X2lkGAIgASgJUglwcm9qZWN0SWQSGQoIbWVkaWFfaWQYAyABKAlS'
    'B21lZGlhSWQ=');

const $core.Map<$core.String, $core.dynamic> RagServiceBase$json = {
  '1': 'RagService',
  '2': [
    {
      '1': 'AskQuestion',
      '2': '.tacittag.rag.v2.AskQuestionRequest',
      '3': '.tacittag.rag.v2.AskQuestionResponse'
    },
    {
      '1': 'GetSessionHistory',
      '2': '.tacittag.rag.v2.GetSessionHistoryRequest',
      '3': '.tacittag.rag.v2.GetSessionHistoryResponse'
    },
    {
      '1': 'IndexProject',
      '2': '.tacittag.rag.v2.IndexProjectRequest',
      '3': '.tacittag.rag.v2.IndexProjectResponse'
    },
  ],
};

@$core.Deprecated('Use ragServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RagServiceBase$messageJson = {
  '.tacittag.rag.v2.AskQuestionRequest': AskQuestionRequest$json,
  '.tacittag.rag.v2.AskQuestionResponse': AskQuestionResponse$json,
  '.tacittag.rag.v2.Citation': Citation$json,
  '.tacittag.rag.v2.GetSessionHistoryRequest': GetSessionHistoryRequest$json,
  '.tacittag.rag.v2.GetSessionHistoryResponse': GetSessionHistoryResponse$json,
  '.tacittag.rag.v2.ChatMessage': ChatMessage$json,
  '.tacittag.rag.v2.IndexProjectRequest': IndexProjectRequest$json,
  '.tacittag.rag.v2.IndexProjectResponse': IndexProjectResponse$json,
};

/// Descriptor for `RagService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List ragServiceDescriptor = $convert.base64Decode(
    'CgpSYWdTZXJ2aWNlElgKC0Fza1F1ZXN0aW9uEiMudGFjaXR0YWcucmFnLnYyLkFza1F1ZXN0aW'
    '9uUmVxdWVzdBokLnRhY2l0dGFnLnJhZy52Mi5Bc2tRdWVzdGlvblJlc3BvbnNlEmoKEUdldFNl'
    'c3Npb25IaXN0b3J5EikudGFjaXR0YWcucmFnLnYyLkdldFNlc3Npb25IaXN0b3J5UmVxdWVzdB'
    'oqLnRhY2l0dGFnLnJhZy52Mi5HZXRTZXNzaW9uSGlzdG9yeVJlc3BvbnNlElsKDEluZGV4UHJv'
    'amVjdBIkLnRhY2l0dGFnLnJhZy52Mi5JbmRleFByb2plY3RSZXF1ZXN0GiUudGFjaXR0YWcucm'
    'FnLnYyLkluZGV4UHJvamVjdFJlc3BvbnNl');
