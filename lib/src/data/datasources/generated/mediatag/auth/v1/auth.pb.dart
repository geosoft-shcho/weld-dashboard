// This is a generated file - do not edit.
//
// Generated from mediatag/auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../google/protobuf/field_mask.pb.dart' as $1;
import '../../../google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// 역할 = 권한 묶음.
class Role extends $pb.GeneratedMessage {
  factory Role({
    $fixnum.Int64? roleId,
    $core.String? roleName,
    $core.String? description,
    $core.Iterable<$core.String>? permissions,
  }) {
    final result = create();
    if (roleId != null) result.roleId = roleId;
    if (roleName != null) result.roleName = roleName;
    if (description != null) result.description = description;
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  Role._();

  factory Role.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Role.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Role',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'roleId')
    ..aOS(2, _omitFieldNames ? '' : 'roleName')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..pPS(4, _omitFieldNames ? '' : 'permissions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Role clone() => Role()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Role copyWith(void Function(Role) updates) =>
      super.copyWith((message) => updates(message as Role)) as Role;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Role create() => Role._();
  @$core.override
  Role createEmptyInstance() => create();
  static $pb.PbList<Role> createRepeated() => $pb.PbList<Role>();
  @$core.pragma('dart2js:noInline')
  static Role getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Role>(create);
  static Role? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get roleId => $_getI64(0);
  @$pb.TagNumber(1)
  set roleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roleName => $_getSZ(1);
  @$pb.TagNumber(2)
  set roleName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoleName() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoleName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get permissions => $_getList(3);
}

/// 만든 · 고친 사람. 다른 서비스의 응답(공사 · 작업 · Asset · 클립 등의 created_by · updated_by)에 실린다.
/// 칸이 비어 있으면(null) 사람이 아닌 일이다 — 업로드 뒤 후처리, 도구 결과, 성적서 추출, 로그인 도입 전에 만든 행.
class Author extends $pb.GeneratedMessage {
  factory Author({
    $fixnum.Int64? accountId,
    $core.String? displayName,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  Author._();

  factory Author.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Author.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Author',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author clone() => Author()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author copyWith(void Function(Author) updates) =>
      super.copyWith((message) => updates(message as Author)) as Author;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Author create() => Author._();
  @$core.override
  Author createEmptyInstance() => create();
  static $pb.PbList<Author> createRepeated() => $pb.PbList<Author>();
  @$core.pragma('dart2js:noInline')
  static Author getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Author>(create);
  static Author? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);
}

class Permission extends $pb.GeneratedMessage {
  factory Permission({
    $core.String? key,
    $core.String? description,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (description != null) result.description = description;
    return result;
  }

  Permission._();

  factory Permission.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Permission.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Permission',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Permission clone() => Permission()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Permission copyWith(void Function(Permission) updates) =>
      super.copyWith((message) => updates(message as Permission)) as Permission;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Permission create() => Permission._();
  @$core.override
  Permission createEmptyInstance() => create();
  static $pb.PbList<Permission> createRepeated() => $pb.PbList<Permission>();
  @$core.pragma('dart2js:noInline')
  static Permission getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Permission>(create);
  static Permission? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);
}

class Account extends $pb.GeneratedMessage {
  factory Account({
    $fixnum.Int64? accountId,
    $core.String? loginName,
    $core.String? displayName,
    $fixnum.Int64? roleId,
    $core.bool? inactive,
    $0.Timestamp? createdAt,
    $core.String? roleName,
    $core.Iterable<$core.String>? permissions,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (loginName != null) result.loginName = loginName;
    if (displayName != null) result.displayName = displayName;
    if (roleId != null) result.roleId = roleId;
    if (inactive != null) result.inactive = inactive;
    if (createdAt != null) result.createdAt = createdAt;
    if (roleName != null) result.roleName = roleName;
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  Account._();

  factory Account.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Account.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Account',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'loginName')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aInt64(4, _omitFieldNames ? '' : 'roleId')
    ..aOB(5, _omitFieldNames ? '' : 'inactive')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'roleName')
    ..pPS(8, _omitFieldNames ? '' : 'permissions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account copyWith(void Function(Account) updates) =>
      super.copyWith((message) => updates(message as Account)) as Account;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  @$core.override
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get loginName => $_getSZ(1);
  @$pb.TagNumber(2)
  set loginName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLoginName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoginName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get roleId => $_getI64(3);
  @$pb.TagNumber(4)
  set roleId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get inactive => $_getBF(4);
  @$pb.TagNumber(5)
  set inactive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInactive() => $_has(4);
  @$pb.TagNumber(5)
  void clearInactive() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get roleName => $_getSZ(6);
  @$pb.TagNumber(7)
  set roleName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRoleName() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoleName() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get permissions => $_getList(7);
}

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? loginName,
    $core.String? password,
  }) {
    final result = create();
    if (loginName != null) result.loginName = loginName;
    if (password != null) result.password = password;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loginName')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => LoginRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => create();
  static $pb.PbList<LoginRequest> createRepeated() =>
      $pb.PbList<LoginRequest>();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loginName => $_getSZ(0);
  @$pb.TagNumber(1)
  set loginName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginName() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    Account? account,
    $core.String? token,
    $0.Timestamp? expiresAt,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (token != null) result.token = token;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => LoginResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  static $pb.PbList<LoginResponse> createRepeated() =>
      $pb.PbList<LoginResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get expiresAt => $_getN(2);
  @$pb.TagNumber(3)
  set expiresAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureExpiresAt() => $_ensure(2);
}

class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => create();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => LogoutRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => create();
  static $pb.PbList<LogoutRequest> createRepeated() =>
      $pb.PbList<LogoutRequest>();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse() => create();

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => LogoutResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  static $pb.PbList<LogoutResponse> createRepeated() =>
      $pb.PbList<LogoutResponse>();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;
}

class GetCurrentAccountRequest extends $pb.GeneratedMessage {
  factory GetCurrentAccountRequest() => create();

  GetCurrentAccountRequest._();

  factory GetCurrentAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentAccountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentAccountRequest clone() =>
      GetCurrentAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentAccountRequest copyWith(
          void Function(GetCurrentAccountRequest) updates) =>
      super.copyWith((message) => updates(message as GetCurrentAccountRequest))
          as GetCurrentAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentAccountRequest create() => GetCurrentAccountRequest._();
  @$core.override
  GetCurrentAccountRequest createEmptyInstance() => create();
  static $pb.PbList<GetCurrentAccountRequest> createRepeated() =>
      $pb.PbList<GetCurrentAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentAccountRequest>(create);
  static GetCurrentAccountRequest? _defaultInstance;
}

class GetCurrentAccountResponse extends $pb.GeneratedMessage {
  factory GetCurrentAccountResponse({
    Account? account,
  }) {
    final result = create();
    if (account != null) result.account = account;
    return result;
  }

  GetCurrentAccountResponse._();

  factory GetCurrentAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCurrentAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentAccountResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentAccountResponse clone() =>
      GetCurrentAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentAccountResponse copyWith(
          void Function(GetCurrentAccountResponse) updates) =>
      super.copyWith((message) => updates(message as GetCurrentAccountResponse))
          as GetCurrentAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCurrentAccountResponse create() => GetCurrentAccountResponse._();
  @$core.override
  GetCurrentAccountResponse createEmptyInstance() => create();
  static $pb.PbList<GetCurrentAccountResponse> createRepeated() =>
      $pb.PbList<GetCurrentAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCurrentAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentAccountResponse>(create);
  static GetCurrentAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class ChangePasswordRequest extends $pb.GeneratedMessage {
  factory ChangePasswordRequest({
    $core.String? currentPassword,
    $core.String? newPassword,
  }) {
    final result = create();
    if (currentPassword != null) result.currentPassword = currentPassword;
    if (newPassword != null) result.newPassword = newPassword;
    return result;
  }

  ChangePasswordRequest._();

  factory ChangePasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'currentPassword')
    ..aOS(2, _omitFieldNames ? '' : 'newPassword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordRequest clone() =>
      ChangePasswordRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordRequest copyWith(
          void Function(ChangePasswordRequest) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordRequest))
          as ChangePasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordRequest create() => ChangePasswordRequest._();
  @$core.override
  ChangePasswordRequest createEmptyInstance() => create();
  static $pb.PbList<ChangePasswordRequest> createRepeated() =>
      $pb.PbList<ChangePasswordRequest>();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordRequest>(create);
  static ChangePasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currentPassword => $_getSZ(0);
  @$pb.TagNumber(1)
  set currentPassword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPassword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPassword => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPassword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPassword() => $_clearField(2);
}

class ChangePasswordResponse extends $pb.GeneratedMessage {
  factory ChangePasswordResponse() => create();

  ChangePasswordResponse._();

  factory ChangePasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResponse clone() =>
      ChangePasswordResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResponse copyWith(
          void Function(ChangePasswordResponse) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordResponse))
          as ChangePasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordResponse create() => ChangePasswordResponse._();
  @$core.override
  ChangePasswordResponse createEmptyInstance() => create();
  static $pb.PbList<ChangePasswordResponse> createRepeated() =>
      $pb.PbList<ChangePasswordResponse>();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordResponse>(create);
  static ChangePasswordResponse? _defaultInstance;
}

class ListAccountsRequest extends $pb.GeneratedMessage {
  factory ListAccountsRequest() => create();

  ListAccountsRequest._();

  factory ListAccountsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAccountsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAccountsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountsRequest clone() => ListAccountsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountsRequest copyWith(void Function(ListAccountsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAccountsRequest))
          as ListAccountsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAccountsRequest create() => ListAccountsRequest._();
  @$core.override
  ListAccountsRequest createEmptyInstance() => create();
  static $pb.PbList<ListAccountsRequest> createRepeated() =>
      $pb.PbList<ListAccountsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAccountsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAccountsRequest>(create);
  static ListAccountsRequest? _defaultInstance;
}

class ListAccountsResponse extends $pb.GeneratedMessage {
  factory ListAccountsResponse({
    $core.Iterable<Account>? accounts,
  }) {
    final result = create();
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  ListAccountsResponse._();

  factory ListAccountsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAccountsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAccountsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..pc<Account>(1, _omitFieldNames ? '' : 'accounts', $pb.PbFieldType.PM,
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountsResponse clone() =>
      ListAccountsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountsResponse copyWith(void Function(ListAccountsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAccountsResponse))
          as ListAccountsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAccountsResponse create() => ListAccountsResponse._();
  @$core.override
  ListAccountsResponse createEmptyInstance() => create();
  static $pb.PbList<ListAccountsResponse> createRepeated() =>
      $pb.PbList<ListAccountsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAccountsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAccountsResponse>(create);
  static ListAccountsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Account> get accounts => $_getList(0);
}

class CreateAccountRequest extends $pb.GeneratedMessage {
  factory CreateAccountRequest({
    Account? account,
    $core.String? password,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    return result;
  }

  CreateAccountRequest._();

  factory CreateAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAccountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAccountRequest clone() =>
      CreateAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAccountRequest copyWith(void Function(CreateAccountRequest) updates) =>
      super.copyWith((message) => updates(message as CreateAccountRequest))
          as CreateAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAccountRequest create() => CreateAccountRequest._();
  @$core.override
  CreateAccountRequest createEmptyInstance() => create();
  static $pb.PbList<CreateAccountRequest> createRepeated() =>
      $pb.PbList<CreateAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAccountRequest>(create);
  static CreateAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
}

class CreateAccountResponse extends $pb.GeneratedMessage {
  factory CreateAccountResponse({
    Account? account,
  }) {
    final result = create();
    if (account != null) result.account = account;
    return result;
  }

  CreateAccountResponse._();

  factory CreateAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateAccountResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAccountResponse clone() =>
      CreateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAccountResponse copyWith(
          void Function(CreateAccountResponse) updates) =>
      super.copyWith((message) => updates(message as CreateAccountResponse))
          as CreateAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAccountResponse create() => CreateAccountResponse._();
  @$core.override
  CreateAccountResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAccountResponse> createRepeated() =>
      $pb.PbList<CreateAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateAccountResponse>(create);
  static CreateAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class UpdateAccountRequest extends $pb.GeneratedMessage {
  factory UpdateAccountRequest({
    Account? account,
    $1.FieldMask? updateMask,
    $core.String? password,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (updateMask != null) result.updateMask = updateMask;
    if (password != null) result.password = password;
    return result;
  }

  UpdateAccountRequest._();

  factory UpdateAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAccountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAccountRequest clone() =>
      UpdateAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAccountRequest copyWith(void Function(UpdateAccountRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateAccountRequest))
          as UpdateAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAccountRequest create() => UpdateAccountRequest._();
  @$core.override
  UpdateAccountRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAccountRequest> createRepeated() =>
      $pb.PbList<UpdateAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAccountRequest>(create);
  static UpdateAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);
}

class UpdateAccountResponse extends $pb.GeneratedMessage {
  factory UpdateAccountResponse({
    Account? account,
  }) {
    final result = create();
    if (account != null) result.account = account;
    return result;
  }

  UpdateAccountResponse._();

  factory UpdateAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAccountResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAccountResponse clone() =>
      UpdateAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAccountResponse copyWith(
          void Function(UpdateAccountResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateAccountResponse))
          as UpdateAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAccountResponse create() => UpdateAccountResponse._();
  @$core.override
  UpdateAccountResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateAccountResponse> createRepeated() =>
      $pb.PbList<UpdateAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAccountResponse>(create);
  static UpdateAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class ListPermissionsRequest extends $pb.GeneratedMessage {
  factory ListPermissionsRequest() => create();

  ListPermissionsRequest._();

  factory ListPermissionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPermissionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPermissionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPermissionsRequest clone() =>
      ListPermissionsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPermissionsRequest copyWith(
          void Function(ListPermissionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPermissionsRequest))
          as ListPermissionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPermissionsRequest create() => ListPermissionsRequest._();
  @$core.override
  ListPermissionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListPermissionsRequest> createRepeated() =>
      $pb.PbList<ListPermissionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPermissionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPermissionsRequest>(create);
  static ListPermissionsRequest? _defaultInstance;
}

class ListPermissionsResponse extends $pb.GeneratedMessage {
  factory ListPermissionsResponse({
    $core.Iterable<Permission>? permissions,
  }) {
    final result = create();
    if (permissions != null) result.permissions.addAll(permissions);
    return result;
  }

  ListPermissionsResponse._();

  factory ListPermissionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPermissionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPermissionsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..pc<Permission>(
        1, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.PM,
        subBuilder: Permission.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPermissionsResponse clone() =>
      ListPermissionsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPermissionsResponse copyWith(
          void Function(ListPermissionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPermissionsResponse))
          as ListPermissionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPermissionsResponse create() => ListPermissionsResponse._();
  @$core.override
  ListPermissionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListPermissionsResponse> createRepeated() =>
      $pb.PbList<ListPermissionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPermissionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPermissionsResponse>(create);
  static ListPermissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Permission> get permissions => $_getList(0);
}

class ListRolesRequest extends $pb.GeneratedMessage {
  factory ListRolesRequest() => create();

  ListRolesRequest._();

  factory ListRolesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRolesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRolesRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRolesRequest clone() => ListRolesRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRolesRequest copyWith(void Function(ListRolesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRolesRequest))
          as ListRolesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRolesRequest create() => ListRolesRequest._();
  @$core.override
  ListRolesRequest createEmptyInstance() => create();
  static $pb.PbList<ListRolesRequest> createRepeated() =>
      $pb.PbList<ListRolesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRolesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRolesRequest>(create);
  static ListRolesRequest? _defaultInstance;
}

class ListRolesResponse extends $pb.GeneratedMessage {
  factory ListRolesResponse({
    $core.Iterable<Role>? roles,
  }) {
    final result = create();
    if (roles != null) result.roles.addAll(roles);
    return result;
  }

  ListRolesResponse._();

  factory ListRolesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRolesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRolesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..pc<Role>(1, _omitFieldNames ? '' : 'roles', $pb.PbFieldType.PM,
        subBuilder: Role.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRolesResponse clone() => ListRolesResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRolesResponse copyWith(void Function(ListRolesResponse) updates) =>
      super.copyWith((message) => updates(message as ListRolesResponse))
          as ListRolesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRolesResponse create() => ListRolesResponse._();
  @$core.override
  ListRolesResponse createEmptyInstance() => create();
  static $pb.PbList<ListRolesResponse> createRepeated() =>
      $pb.PbList<ListRolesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRolesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRolesResponse>(create);
  static ListRolesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Role> get roles => $_getList(0);
}

class CreateRoleRequest extends $pb.GeneratedMessage {
  factory CreateRoleRequest({
    Role? role,
  }) {
    final result = create();
    if (role != null) result.role = role;
    return result;
  }

  CreateRoleRequest._();

  factory CreateRoleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoleRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Role>(1, _omitFieldNames ? '' : 'role', subBuilder: Role.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoleRequest clone() => CreateRoleRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoleRequest copyWith(void Function(CreateRoleRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRoleRequest))
          as CreateRoleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoleRequest create() => CreateRoleRequest._();
  @$core.override
  CreateRoleRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRoleRequest> createRepeated() =>
      $pb.PbList<CreateRoleRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRoleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoleRequest>(create);
  static CreateRoleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);
  @$pb.TagNumber(1)
  Role ensureRole() => $_ensure(0);
}

class CreateRoleResponse extends $pb.GeneratedMessage {
  factory CreateRoleResponse({
    Role? role,
  }) {
    final result = create();
    if (role != null) result.role = role;
    return result;
  }

  CreateRoleResponse._();

  factory CreateRoleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoleResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Role>(1, _omitFieldNames ? '' : 'role', subBuilder: Role.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoleResponse clone() => CreateRoleResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoleResponse copyWith(void Function(CreateRoleResponse) updates) =>
      super.copyWith((message) => updates(message as CreateRoleResponse))
          as CreateRoleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoleResponse create() => CreateRoleResponse._();
  @$core.override
  CreateRoleResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRoleResponse> createRepeated() =>
      $pb.PbList<CreateRoleResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRoleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoleResponse>(create);
  static CreateRoleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);
  @$pb.TagNumber(1)
  Role ensureRole() => $_ensure(0);
}

class UpdateRoleRequest extends $pb.GeneratedMessage {
  factory UpdateRoleRequest({
    Role? role,
    $1.FieldMask? updateMask,
  }) {
    final result = create();
    if (role != null) result.role = role;
    if (updateMask != null) result.updateMask = updateMask;
    return result;
  }

  UpdateRoleRequest._();

  factory UpdateRoleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoleRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Role>(1, _omitFieldNames ? '' : 'role', subBuilder: Role.create)
    ..aOM<$1.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $1.FieldMask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoleRequest clone() => UpdateRoleRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoleRequest copyWith(void Function(UpdateRoleRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoleRequest))
          as UpdateRoleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoleRequest create() => UpdateRoleRequest._();
  @$core.override
  UpdateRoleRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateRoleRequest> createRepeated() =>
      $pb.PbList<UpdateRoleRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateRoleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoleRequest>(create);
  static UpdateRoleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);
  @$pb.TagNumber(1)
  Role ensureRole() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($1.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldMask ensureUpdateMask() => $_ensure(1);
}

class UpdateRoleResponse extends $pb.GeneratedMessage {
  factory UpdateRoleResponse({
    Role? role,
  }) {
    final result = create();
    if (role != null) result.role = role;
    return result;
  }

  UpdateRoleResponse._();

  factory UpdateRoleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoleResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<Role>(1, _omitFieldNames ? '' : 'role', subBuilder: Role.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoleResponse clone() => UpdateRoleResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoleResponse copyWith(void Function(UpdateRoleResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateRoleResponse))
          as UpdateRoleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoleResponse create() => UpdateRoleResponse._();
  @$core.override
  UpdateRoleResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateRoleResponse> createRepeated() =>
      $pb.PbList<UpdateRoleResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateRoleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoleResponse>(create);
  static UpdateRoleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Role get role => $_getN(0);
  @$pb.TagNumber(1)
  set role(Role value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRole() => $_has(0);
  @$pb.TagNumber(1)
  void clearRole() => $_clearField(1);
  @$pb.TagNumber(1)
  Role ensureRole() => $_ensure(0);
}

class DeleteRoleRequest extends $pb.GeneratedMessage {
  factory DeleteRoleRequest({
    $fixnum.Int64? roleId,
  }) {
    final result = create();
    if (roleId != null) result.roleId = roleId;
    return result;
  }

  DeleteRoleRequest._();

  factory DeleteRoleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoleRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'roleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoleRequest clone() => DeleteRoleRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoleRequest copyWith(void Function(DeleteRoleRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRoleRequest))
          as DeleteRoleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoleRequest create() => DeleteRoleRequest._();
  @$core.override
  DeleteRoleRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteRoleRequest> createRepeated() =>
      $pb.PbList<DeleteRoleRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteRoleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoleRequest>(create);
  static DeleteRoleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get roleId => $_getI64(0);
  @$pb.TagNumber(1)
  set roleId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoleId() => $_clearField(1);
}

class DeleteRoleResponse extends $pb.GeneratedMessage {
  factory DeleteRoleResponse() => create();

  DeleteRoleResponse._();

  factory DeleteRoleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoleResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoleResponse clone() => DeleteRoleResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoleResponse copyWith(void Function(DeleteRoleResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteRoleResponse))
          as DeleteRoleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoleResponse create() => DeleteRoleResponse._();
  @$core.override
  DeleteRoleResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteRoleResponse> createRepeated() =>
      $pb.PbList<DeleteRoleResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteRoleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoleResponse>(create);
  static DeleteRoleResponse? _defaultInstance;
}

/// 서버 연동 토큰. 사람 계정과 따로 — 비밀번호 · 역할 · 만료가 없다.
class ServiceToken extends $pb.GeneratedMessage {
  factory ServiceToken({
    $fixnum.Int64? tokenId,
    $core.String? name,
    $0.Timestamp? createdAt,
    $0.Timestamp? revokedAt,
    $0.Timestamp? lastUsedAt,
  }) {
    final result = create();
    if (tokenId != null) result.tokenId = tokenId;
    if (name != null) result.name = name;
    if (createdAt != null) result.createdAt = createdAt;
    if (revokedAt != null) result.revokedAt = revokedAt;
    if (lastUsedAt != null) result.lastUsedAt = lastUsedAt;
    return result;
  }

  ServiceToken._();

  factory ServiceToken.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceToken.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceToken',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'tokenId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'revokedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastUsedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceToken clone() => ServiceToken()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceToken copyWith(void Function(ServiceToken) updates) =>
      super.copyWith((message) => updates(message as ServiceToken))
          as ServiceToken;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceToken create() => ServiceToken._();
  @$core.override
  ServiceToken createEmptyInstance() => create();
  static $pb.PbList<ServiceToken> createRepeated() =>
      $pb.PbList<ServiceToken>();
  @$core.pragma('dart2js:noInline')
  static ServiceToken getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceToken>(create);
  static ServiceToken? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get tokenId => $_getI64(0);
  @$pb.TagNumber(1)
  set tokenId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTokenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTokenId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get revokedAt => $_getN(3);
  @$pb.TagNumber(4)
  set revokedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRevokedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevokedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureRevokedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get lastUsedAt => $_getN(4);
  @$pb.TagNumber(5)
  set lastUsedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastUsedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastUsedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastUsedAt() => $_ensure(4);
}

class ListServiceTokensRequest extends $pb.GeneratedMessage {
  factory ListServiceTokensRequest() => create();

  ListServiceTokensRequest._();

  factory ListServiceTokensRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListServiceTokensRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListServiceTokensRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceTokensRequest clone() =>
      ListServiceTokensRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceTokensRequest copyWith(
          void Function(ListServiceTokensRequest) updates) =>
      super.copyWith((message) => updates(message as ListServiceTokensRequest))
          as ListServiceTokensRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListServiceTokensRequest create() => ListServiceTokensRequest._();
  @$core.override
  ListServiceTokensRequest createEmptyInstance() => create();
  static $pb.PbList<ListServiceTokensRequest> createRepeated() =>
      $pb.PbList<ListServiceTokensRequest>();
  @$core.pragma('dart2js:noInline')
  static ListServiceTokensRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListServiceTokensRequest>(create);
  static ListServiceTokensRequest? _defaultInstance;
}

class ListServiceTokensResponse extends $pb.GeneratedMessage {
  factory ListServiceTokensResponse({
    $core.Iterable<ServiceToken>? tokens,
  }) {
    final result = create();
    if (tokens != null) result.tokens.addAll(tokens);
    return result;
  }

  ListServiceTokensResponse._();

  factory ListServiceTokensResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListServiceTokensResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListServiceTokensResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..pc<ServiceToken>(1, _omitFieldNames ? '' : 'tokens', $pb.PbFieldType.PM,
        subBuilder: ServiceToken.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceTokensResponse clone() =>
      ListServiceTokensResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServiceTokensResponse copyWith(
          void Function(ListServiceTokensResponse) updates) =>
      super.copyWith((message) => updates(message as ListServiceTokensResponse))
          as ListServiceTokensResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListServiceTokensResponse create() => ListServiceTokensResponse._();
  @$core.override
  ListServiceTokensResponse createEmptyInstance() => create();
  static $pb.PbList<ListServiceTokensResponse> createRepeated() =>
      $pb.PbList<ListServiceTokensResponse>();
  @$core.pragma('dart2js:noInline')
  static ListServiceTokensResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListServiceTokensResponse>(create);
  static ListServiceTokensResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceToken> get tokens => $_getList(0);
}

class CreateServiceTokenRequest extends $pb.GeneratedMessage {
  factory CreateServiceTokenRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  CreateServiceTokenRequest._();

  factory CreateServiceTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateServiceTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateServiceTokenRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateServiceTokenRequest clone() =>
      CreateServiceTokenRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateServiceTokenRequest copyWith(
          void Function(CreateServiceTokenRequest) updates) =>
      super.copyWith((message) => updates(message as CreateServiceTokenRequest))
          as CreateServiceTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateServiceTokenRequest create() => CreateServiceTokenRequest._();
  @$core.override
  CreateServiceTokenRequest createEmptyInstance() => create();
  static $pb.PbList<CreateServiceTokenRequest> createRepeated() =>
      $pb.PbList<CreateServiceTokenRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateServiceTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateServiceTokenRequest>(create);
  static CreateServiceTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class CreateServiceTokenResponse extends $pb.GeneratedMessage {
  factory CreateServiceTokenResponse({
    ServiceToken? serviceToken,
    $core.String? token,
  }) {
    final result = create();
    if (serviceToken != null) result.serviceToken = serviceToken;
    if (token != null) result.token = token;
    return result;
  }

  CreateServiceTokenResponse._();

  factory CreateServiceTokenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateServiceTokenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateServiceTokenResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceToken>(1, _omitFieldNames ? '' : 'serviceToken',
        subBuilder: ServiceToken.create)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateServiceTokenResponse clone() =>
      CreateServiceTokenResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateServiceTokenResponse copyWith(
          void Function(CreateServiceTokenResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateServiceTokenResponse))
          as CreateServiceTokenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateServiceTokenResponse create() => CreateServiceTokenResponse._();
  @$core.override
  CreateServiceTokenResponse createEmptyInstance() => create();
  static $pb.PbList<CreateServiceTokenResponse> createRepeated() =>
      $pb.PbList<CreateServiceTokenResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateServiceTokenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateServiceTokenResponse>(create);
  static CreateServiceTokenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceToken get serviceToken => $_getN(0);
  @$pb.TagNumber(1)
  set serviceToken(ServiceToken value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceToken() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceToken ensureServiceToken() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class RevokeServiceTokenRequest extends $pb.GeneratedMessage {
  factory RevokeServiceTokenRequest({
    $fixnum.Int64? tokenId,
  }) {
    final result = create();
    if (tokenId != null) result.tokenId = tokenId;
    return result;
  }

  RevokeServiceTokenRequest._();

  factory RevokeServiceTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevokeServiceTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeServiceTokenRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'tokenId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeServiceTokenRequest clone() =>
      RevokeServiceTokenRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeServiceTokenRequest copyWith(
          void Function(RevokeServiceTokenRequest) updates) =>
      super.copyWith((message) => updates(message as RevokeServiceTokenRequest))
          as RevokeServiceTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeServiceTokenRequest create() => RevokeServiceTokenRequest._();
  @$core.override
  RevokeServiceTokenRequest createEmptyInstance() => create();
  static $pb.PbList<RevokeServiceTokenRequest> createRepeated() =>
      $pb.PbList<RevokeServiceTokenRequest>();
  @$core.pragma('dart2js:noInline')
  static RevokeServiceTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeServiceTokenRequest>(create);
  static RevokeServiceTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get tokenId => $_getI64(0);
  @$pb.TagNumber(1)
  set tokenId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTokenId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTokenId() => $_clearField(1);
}

class RevokeServiceTokenResponse extends $pb.GeneratedMessage {
  factory RevokeServiceTokenResponse({
    ServiceToken? serviceToken,
  }) {
    final result = create();
    if (serviceToken != null) result.serviceToken = serviceToken;
    return result;
  }

  RevokeServiceTokenResponse._();

  factory RevokeServiceTokenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevokeServiceTokenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeServiceTokenResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'mediatag.auth.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceToken>(1, _omitFieldNames ? '' : 'serviceToken',
        subBuilder: ServiceToken.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeServiceTokenResponse clone() =>
      RevokeServiceTokenResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeServiceTokenResponse copyWith(
          void Function(RevokeServiceTokenResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RevokeServiceTokenResponse))
          as RevokeServiceTokenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeServiceTokenResponse create() => RevokeServiceTokenResponse._();
  @$core.override
  RevokeServiceTokenResponse createEmptyInstance() => create();
  static $pb.PbList<RevokeServiceTokenResponse> createRepeated() =>
      $pb.PbList<RevokeServiceTokenResponse>();
  @$core.pragma('dart2js:noInline')
  static RevokeServiceTokenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeServiceTokenResponse>(create);
  static RevokeServiceTokenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceToken get serviceToken => $_getN(0);
  @$pb.TagNumber(1)
  set serviceToken(ServiceToken value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceToken() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceToken ensureServiceToken() => $_ensure(0);
}

class AuthServiceApi {
  final $pb.RpcClient _client;

  AuthServiceApi(this._client);

  /// 로그인. 아이디나 비밀번호가 틀리면 Unauthenticated(어느 쪽이 틀렸는지는 알려주지 않는다), 막힌 계정도 같다.
  /// 같은 아이디로 5번 연달아 틀리면 1분 동안 ResourceExhausted. 응답과 함께 세션 쿠키를 심는다.
  $async.Future<LoginResponse> login(
          $pb.ClientContext? ctx, LoginRequest request) =>
      _client.invoke<LoginResponse>(
          ctx, 'AuthService', 'Login', request, LoginResponse());

  /// 로그아웃 — 지금 세션을 지우고 쿠키를 비운다. 로그인하지 않았어도 성공한다.
  $async.Future<LogoutResponse> logout(
          $pb.ClientContext? ctx, LogoutRequest request) =>
      _client.invoke<LogoutResponse>(
          ctx, 'AuthService', 'Logout', request, LogoutResponse());

  /// 지금 로그인한 계정. 화면이 처음 뜰 때 로그인 여부 · 역할을 알아내는 용도 — 로그인하지 않았으면 Unauthenticated.
  $async.Future<GetCurrentAccountResponse> getCurrentAccount(
          $pb.ClientContext? ctx, GetCurrentAccountRequest request) =>
      _client.invoke<GetCurrentAccountResponse>(ctx, 'AuthService',
          'GetCurrentAccount', request, GetCurrentAccountResponse());

  /// 내 비밀번호 바꾸기. 지금 비밀번호가 틀리면 PermissionDenied. 바꾸면 이 계정의 다른 세션은 모두 끊긴다.
  $async.Future<ChangePasswordResponse> changePassword(
          $pb.ClientContext? ctx, ChangePasswordRequest request) =>
      _client.invoke<ChangePasswordResponse>(ctx, 'AuthService',
          'ChangePassword', request, ChangePasswordResponse());
}

/// 계정 · 역할 관리 — account.manage 권한이 있어야 부를 수 있다.
class AccountServiceApi {
  final $pb.RpcClient _client;

  AccountServiceApi(this._client);

  /// 계정 전부(막힌 계정 포함), 아이디 순.
  $async.Future<ListAccountsResponse> listAccounts(
          $pb.ClientContext? ctx, ListAccountsRequest request) =>
      _client.invoke<ListAccountsResponse>(ctx, 'AccountService',
          'ListAccounts', request, ListAccountsResponse());

  /// 계정을 만든다. account.login_name · account.role_id · password 필수. 같은 아이디가 있으면 AlreadyExists.
  $async.Future<CreateAccountResponse> createAccount(
          $pb.ClientContext? ctx, CreateAccountRequest request) =>
      _client.invoke<CreateAccountResponse>(ctx, 'AccountService',
          'CreateAccount', request, CreateAccountResponse());

  /// 계정을 고친다(update_mask: display_name, role_id, inactive, password). account.account_id 필수. 아이디는 못 바꾼다.
  /// password를 바꾸면 그 계정의 세션이 모두 끊긴다. 자기 계정의 role_id · inactive는 못 바꾼다(FailedPrecondition) —
  /// 관리자가 하나도 남지 않는 일을 막는다. 계정은 지우지 않고 inactive로 막는다.
  $async.Future<UpdateAccountResponse> updateAccount(
          $pb.ClientContext? ctx, UpdateAccountRequest request) =>
      _client.invoke<UpdateAccountResponse>(ctx, 'AccountService',
          'UpdateAccount', request, UpdateAccountResponse());

  /// 서버가 아는 권한 전부(이름과 설명) — 역할 편집 화면의 체크 목록.
  $async.Future<ListPermissionsResponse> listPermissions(
          $pb.ClientContext? ctx, ListPermissionsRequest request) =>
      _client.invoke<ListPermissionsResponse>(ctx, 'AccountService',
          'ListPermissions', request, ListPermissionsResponse());

  /// 역할 전부, 번호 순.
  $async.Future<ListRolesResponse> listRoles(
          $pb.ClientContext? ctx, ListRolesRequest request) =>
      _client.invoke<ListRolesResponse>(
          ctx, 'AccountService', 'ListRoles', request, ListRolesResponse());

  /// 역할을 만든다. role.role_name 필수. 같은 이름이 있으면 AlreadyExists, 목록에 없는 권한은 InvalidArgument.
  $async.Future<CreateRoleResponse> createRole(
          $pb.ClientContext? ctx, CreateRoleRequest request) =>
      _client.invoke<CreateRoleResponse>(
          ctx, 'AccountService', 'CreateRole', request, CreateRoleResponse());

  /// 역할을 고친다(update_mask: role_name, description, permissions — permissions는 통째로 바꾼다). role.role_id 필수.
  /// 그 역할의 계정들에게 다음 요청부터 바로 먹는다. 자기 역할에서 account.manage는 뺄 수 없다(FailedPrecondition).
  $async.Future<UpdateRoleResponse> updateRole(
          $pb.ClientContext? ctx, UpdateRoleRequest request) =>
      _client.invoke<UpdateRoleResponse>(
          ctx, 'AccountService', 'UpdateRole', request, UpdateRoleResponse());

  /// 역할을 지운다. 그 역할을 쓰는 계정이 있으면 FailedPrecondition — 계정들의 역할을 먼저 바꾼다.
  $async.Future<DeleteRoleResponse> deleteRole(
          $pb.ClientContext? ctx, DeleteRoleRequest request) =>
      _client.invoke<DeleteRoleResponse>(
          ctx, 'AccountService', 'DeleteRole', request, DeleteRoleResponse());

  /// 서버 연동 토큰 전부(폐기한 것 포함), 번호 순. 토큰 원문은 없다.
  $async.Future<ListServiceTokensResponse> listServiceTokens(
          $pb.ClientContext? ctx, ListServiceTokensRequest request) =>
      _client.invoke<ListServiceTokensResponse>(ctx, 'AccountService',
          'ListServiceTokens', request, ListServiceTokensResponse());

  /// 토큰을 발급한다. name 필수(예: "ai-server"). 원문(token)은 이 응답에서 한 번만 준다 — 다시 볼 수 없다.
  /// 같은 이름으로 여럿을 둘 수 있다: 교체는 새로 발급 → 상대 서버에 넣기 → 옛 토큰의 last_used_at이 멈춘 것을 보고 폐기.
  $async.Future<CreateServiceTokenResponse> createServiceToken(
          $pb.ClientContext? ctx, CreateServiceTokenRequest request) =>
      _client.invoke<CreateServiceTokenResponse>(ctx, 'AccountService',
          'CreateServiceToken', request, CreateServiceTokenResponse());

  /// 토큰을 폐기한다(다음 요청부터 401). 되살리지 못한다 — 새로 발급한다. 없는 번호면 NotFound.
  /// 토큰을 한 번도 발급하지 않았으면 서버는 X-Internal-Token을 검사하지 않는다(처음 붙일 때의 전환용).
  /// 한 번이라도 발급했으면 전부 폐기해도 검사한다 — 통지 · 파일 받기는 401(새로 발급해 넣을 때까지 멈춤).
  $async.Future<RevokeServiceTokenResponse> revokeServiceToken(
          $pb.ClientContext? ctx, RevokeServiceTokenRequest request) =>
      _client.invoke<RevokeServiceTokenResponse>(ctx, 'AccountService',
          'RevokeServiceToken', request, RevokeServiceTokenResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
