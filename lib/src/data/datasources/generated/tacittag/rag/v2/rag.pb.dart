// This is a generated file - do not edit.
//
// Generated from tacittag/rag/v2/rag.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AskQuestionRequest extends $pb.GeneratedMessage {
  factory AskQuestionRequest({
    $core.String? projectId,
    $core.String? question,
    $core.int? topK,
    $core.String? mediaId,
    $core.String? sessionId,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (question != null) result.question = question;
    if (topK != null) result.topK = topK;
    if (mediaId != null) result.mediaId = mediaId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  AskQuestionRequest._();

  factory AskQuestionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AskQuestionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AskQuestionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'question')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'topK', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'mediaId')
    ..aOS(5, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AskQuestionRequest clone() => AskQuestionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AskQuestionRequest copyWith(void Function(AskQuestionRequest) updates) =>
      super.copyWith((message) => updates(message as AskQuestionRequest))
          as AskQuestionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AskQuestionRequest create() => AskQuestionRequest._();
  @$core.override
  AskQuestionRequest createEmptyInstance() => create();
  static $pb.PbList<AskQuestionRequest> createRepeated() =>
      $pb.PbList<AskQuestionRequest>();
  @$core.pragma('dart2js:noInline')
  static AskQuestionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AskQuestionRequest>(create);
  static AskQuestionRequest? _defaultInstance;

  /// 대상 프로젝트 ID (prj_*). 검색·필터 키. 권장.
  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  /// 사용자 질문 (예: "용접 장면이 몇 초에 나와?").
  @$pb.TagNumber(2)
  $core.String get question => $_getSZ(1);
  @$pb.TagNumber(2)
  set question($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuestion() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuestion() => $_clearField(2);

  /// 검색할 chunk 상한. 기본 5, 최대 20 (welding-pose REST와 동일).
  @$pb.TagNumber(3)
  $core.int get topK => $_getIZ(2);
  @$pb.TagNumber(3)
  set topK($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTopK() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopK() => $_clearField(3);

  /// legacy scope. project_id가 없을 때만 사용.
  @$pb.TagNumber(4)
  $core.String get mediaId => $_getSZ(3);
  @$pb.TagNumber(4)
  set mediaId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMediaId() => $_has(3);
  @$pb.TagNumber(4)
  void clearMediaId() => $_clearField(4);

  /// 기존 대화 세션 ID. 생략 시 새 세션 생성.
  @$pb.TagNumber(5)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionId() => $_clearField(5);
}

class AskQuestionResponse extends $pb.GeneratedMessage {
  factory AskQuestionResponse({
    $core.String? answer,
    $core.String? projectId,
    $core.String? mediaId,
    $core.Iterable<Citation>? citations,
    $core.String? sessionId,
  }) {
    final result = create();
    if (answer != null) result.answer = answer;
    if (projectId != null) result.projectId = projectId;
    if (mediaId != null) result.mediaId = mediaId;
    if (citations != null) result.citations.addAll(citations);
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  AskQuestionResponse._();

  factory AskQuestionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AskQuestionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AskQuestionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'answer')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'mediaId')
    ..pc<Citation>(4, _omitFieldNames ? '' : 'citations', $pb.PbFieldType.PM,
        subBuilder: Citation.create)
    ..aOS(5, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AskQuestionResponse clone() => AskQuestionResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AskQuestionResponse copyWith(void Function(AskQuestionResponse) updates) =>
      super.copyWith((message) => updates(message as AskQuestionResponse))
          as AskQuestionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AskQuestionResponse create() => AskQuestionResponse._();
  @$core.override
  AskQuestionResponse createEmptyInstance() => create();
  static $pb.PbList<AskQuestionResponse> createRepeated() =>
      $pb.PbList<AskQuestionResponse>();
  @$core.pragma('dart2js:noInline')
  static AskQuestionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AskQuestionResponse>(create);
  static AskQuestionResponse? _defaultInstance;

  /// LLM이 citations 기반으로 생성한 답변.
  @$pb.TagNumber(1)
  $core.String get answer => $_getSZ(0);
  @$pb.TagNumber(1)
  set answer($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAnswer() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnswer() => $_clearField(1);

  /// 요청과 동일한 프로젝트 ID.
  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  /// 표시용 legacy ID. 검색 키는 project_id.
  @$pb.TagNumber(3)
  $core.String get mediaId => $_getSZ(2);
  @$pb.TagNumber(3)
  set mediaId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaId() => $_clearField(3);

  /// 근거 구간 목록. UI에서 클릭 시 start_sec/end_sec으로 video seek.
  @$pb.TagNumber(4)
  $pb.PbList<Citation> get citations => $_getList(3);

  /// 대화 세션 ID. 후속 질문·히스토리 조회에 사용.
  @$pb.TagNumber(5)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set sessionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSessionId() => $_clearField(5);
}

/// STT segment 한 구간에 대한 검색 근거.
class Citation extends $pb.GeneratedMessage {
  factory Citation({
    $core.double? startSec,
    $core.double? endSec,
    $core.String? text,
    $core.double? score,
    $core.String? layerId,
    $core.String? segmentId,
  }) {
    final result = create();
    if (startSec != null) result.startSec = startSec;
    if (endSec != null) result.endSec = endSec;
    if (text != null) result.text = text;
    if (score != null) result.score = score;
    if (layerId != null) result.layerId = layerId;
    if (segmentId != null) result.segmentId = segmentId;
    return result;
  }

  Citation._();

  factory Citation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Citation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Citation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'startSec', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'endSec', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'layerId')
    ..aOS(6, _omitFieldNames ? '' : 'segmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Citation clone() => Citation()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Citation copyWith(void Function(Citation) updates) =>
      super.copyWith((message) => updates(message as Citation)) as Citation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Citation create() => Citation._();
  @$core.override
  Citation createEmptyInstance() => create();
  static $pb.PbList<Citation> createRepeated() => $pb.PbList<Citation>();
  @$core.pragma('dart2js:noInline')
  static Citation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Citation>(create);
  static Citation? _defaultInstance;

  /// 구간 시작(초). video player seek target.
  @$pb.TagNumber(1)
  $core.double get startSec => $_getN(0);
  @$pb.TagNumber(1)
  set startSec($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartSec() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartSec() => $_clearField(1);

  /// 구간 끝(초).
  @$pb.TagNumber(2)
  $core.double get endSec => $_getN(1);
  @$pb.TagNumber(2)
  set endSec($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndSec() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndSec() => $_clearField(2);

  /// 해당 구간 STT 텍스트(또는 chunk 텍스트).
  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  /// hybrid 검색 유사도 점수 (0~1 근처).
  @$pb.TagNumber(4)
  $core.double get score => $_getN(3);
  @$pb.TagNumber(4)
  set score($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScore() => $_clearField(4);

  /// TEXT layer ID (lyr_*).
  @$pb.TagNumber(5)
  $core.String get layerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set layerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayerId() => $_clearField(5);

  /// segment ID (seg_*).
  @$pb.TagNumber(6)
  $core.String get segmentId => $_getSZ(5);
  @$pb.TagNumber(6)
  set segmentId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSegmentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSegmentId() => $_clearField(6);
}

class GetSessionHistoryRequest extends $pb.GeneratedMessage {
  factory GetSessionHistoryRequest({
    $core.String? sessionId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  GetSessionHistoryRequest._();

  factory GetSessionHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSessionHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSessionHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionHistoryRequest clone() =>
      GetSessionHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionHistoryRequest copyWith(
          void Function(GetSessionHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetSessionHistoryRequest))
          as GetSessionHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSessionHistoryRequest create() => GetSessionHistoryRequest._();
  @$core.override
  GetSessionHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<GetSessionHistoryRequest> createRepeated() =>
      $pb.PbList<GetSessionHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSessionHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSessionHistoryRequest>(create);
  static GetSessionHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
}

class GetSessionHistoryResponse extends $pb.GeneratedMessage {
  factory GetSessionHistoryResponse({
    $core.String? sessionId,
    $core.String? projectId,
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (projectId != null) result.projectId = projectId;
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  GetSessionHistoryResponse._();

  factory GetSessionHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSessionHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSessionHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..pc<ChatMessage>(3, _omitFieldNames ? '' : 'messages', $pb.PbFieldType.PM,
        subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionHistoryResponse clone() =>
      GetSessionHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionHistoryResponse copyWith(
          void Function(GetSessionHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetSessionHistoryResponse))
          as GetSessionHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSessionHistoryResponse create() => GetSessionHistoryResponse._();
  @$core.override
  GetSessionHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<GetSessionHistoryResponse> createRepeated() =>
      $pb.PbList<GetSessionHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSessionHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSessionHistoryResponse>(create);
  static GetSessionHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ChatMessage> get messages => $_getList(2);
}

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? id,
    $core.String? role,
    $core.String? content,
    $core.Iterable<Citation>? citations,
    $core.String? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (role != null) result.role = role;
    if (content != null) result.content = content;
    if (citations != null) result.citations.addAll(citations);
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..pc<Citation>(4, _omitFieldNames ? '' : 'citations', $pb.PbFieldType.PM,
        subBuilder: Citation.create)
    ..aOS(5, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) =>
      super.copyWith((message) => updates(message as ChatMessage))
          as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// "user" | "assistant"
  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<Citation> get citations => $_getList(3);

  /// ISO8601 UTC (REST createdAt과 동일)
  @$pb.TagNumber(5)
  $core.String get createdAt => $_getSZ(4);
  @$pb.TagNumber(5)
  set createdAt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
}

class IndexProjectRequest extends $pb.GeneratedMessage {
  factory IndexProjectRequest({
    $core.String? projectId,
    $core.String? mediaId,
    $core.bool? rebuild,
    $core.String? textLayer,
    $core.String? projectDir,
    $core.String? dataDir,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    if (mediaId != null) result.mediaId = mediaId;
    if (rebuild != null) result.rebuild = rebuild;
    if (textLayer != null) result.textLayer = textLayer;
    if (projectDir != null) result.projectDir = projectDir;
    if (dataDir != null) result.dataDir = dataDir;
    return result;
  }

  IndexProjectRequest._();

  factory IndexProjectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndexProjectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndexProjectRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOB(3, _omitFieldNames ? '' : 'rebuild')
    ..aOS(4, _omitFieldNames ? '' : 'textLayer')
    ..aOS(5, _omitFieldNames ? '' : 'projectDir')
    ..aOS(6, _omitFieldNames ? '' : 'dataDir')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndexProjectRequest clone() => IndexProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndexProjectRequest copyWith(void Function(IndexProjectRequest) updates) =>
      super.copyWith((message) => updates(message as IndexProjectRequest))
          as IndexProjectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndexProjectRequest create() => IndexProjectRequest._();
  @$core.override
  IndexProjectRequest createEmptyInstance() => create();
  static $pb.PbList<IndexProjectRequest> createRepeated() =>
      $pb.PbList<IndexProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static IndexProjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndexProjectRequest>(create);
  static IndexProjectRequest? _defaultInstance;

  /// 인덱싱 대상 프로젝트. project_id 또는 media_id 중 하나 필수.
  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);

  /// true면 기존 project 인덱스 삭제 후 전체 재인덱싱.
  @$pb.TagNumber(3)
  $core.bool get rebuild => $_getBF(2);
  @$pb.TagNumber(3)
  set rebuild($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRebuild() => $_has(2);
  @$pb.TagNumber(3)
  void clearRebuild() => $_clearField(3);

  /// 아래는 welding-pose REST 고급 옵션. 일반 프론트/BFF 호출에서는 생략.
  @$pb.TagNumber(4)
  $core.String get textLayer => $_getSZ(3);
  @$pb.TagNumber(4)
  set textLayer($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTextLayer() => $_has(3);
  @$pb.TagNumber(4)
  void clearTextLayer() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get projectDir => $_getSZ(4);
  @$pb.TagNumber(5)
  set projectDir($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProjectDir() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectDir() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dataDir => $_getSZ(5);
  @$pb.TagNumber(6)
  set dataDir($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDataDir() => $_has(5);
  @$pb.TagNumber(6)
  void clearDataDir() => $_clearField(6);
}

class IndexProjectResponse extends $pb.GeneratedMessage {
  factory IndexProjectResponse({
    $core.int? indexedChunks,
    $core.String? projectId,
    $core.String? mediaId,
  }) {
    final result = create();
    if (indexedChunks != null) result.indexedChunks = indexedChunks;
    if (projectId != null) result.projectId = projectId;
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  IndexProjectResponse._();

  factory IndexProjectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IndexProjectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IndexProjectResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'tacittag.rag.v2'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1, _omitFieldNames ? '' : 'indexedChunks', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndexProjectResponse clone() =>
      IndexProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IndexProjectResponse copyWith(void Function(IndexProjectResponse) updates) =>
      super.copyWith((message) => updates(message as IndexProjectResponse))
          as IndexProjectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndexProjectResponse create() => IndexProjectResponse._();
  @$core.override
  IndexProjectResponse createEmptyInstance() => create();
  static $pb.PbList<IndexProjectResponse> createRepeated() =>
      $pb.PbList<IndexProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static IndexProjectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IndexProjectResponse>(create);
  static IndexProjectResponse? _defaultInstance;

  /// upsert된 chunk 개수.
  @$pb.TagNumber(1)
  $core.int get indexedChunks => $_getIZ(0);
  @$pb.TagNumber(1)
  set indexedChunks($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndexedChunks() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndexedChunks() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mediaId => $_getSZ(2);
  @$pb.TagNumber(3)
  set mediaId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaId() => $_clearField(3);
}

/// RagService — STT TEXT segment 검색 + LLM 답변.
///
/// Connect URL: {BFF_BASE_URL}/tacittag.rag.v2.RagService/{Method}
///
/// REST 매핑 (welding-pose):
///   AskQuestion       -> POST /api/v1/rag/ask
///   GetSessionHistory -> GET  /api/v1/rag/sessions/{sessionId}/messages
///   IndexProject      -> POST /api/v1/rag/index
class RagServiceApi {
  final $pb.RpcClient _client;

  RagServiceApi(this._client);

  /// 프로젝트 TEXT layer에서 관련 구간 검색 후 LLM 답변 + citations 반환.
  /// session_id 생략 시 새 세션 생성. 동일 session_id로 후속 질문 시 LLM 컨텍스트 유지.
  $async.Future<AskQuestionResponse> askQuestion(
          $pb.ClientContext? ctx, AskQuestionRequest request) =>
      _client.invoke<AskQuestionResponse>(
          ctx, 'RagService', 'AskQuestion', request, AskQuestionResponse());

  /// 세션 대화 기록 조회. 프론트가 화면에 지난 질문·답변을 렌더링할 때 사용.
  $async.Future<GetSessionHistoryResponse> getSessionHistory(
          $pb.ClientContext? ctx, GetSessionHistoryRequest request) =>
      _client.invoke<GetSessionHistoryResponse>(ctx, 'RagService',
          'GetSessionHistory', request, GetSessionHistoryResponse());

  /// TEXT layer를 Redis 벡터 인덱스에 upsert. watcher 자동 인덱싱 외 수동/재빌드용.
  $async.Future<IndexProjectResponse> indexProject(
          $pb.ClientContext? ctx, IndexProjectRequest request) =>
      _client.invoke<IndexProjectResponse>(
          ctx, 'RagService', 'IndexProject', request, IndexProjectResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
