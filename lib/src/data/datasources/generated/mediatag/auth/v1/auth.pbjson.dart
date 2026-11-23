// This is a generated file - do not edit.
//
// Generated from mediatag/auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../../google/protobuf/field_mask.pbjson.dart' as $1;
import '../../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use roleDescriptor instead')
const Role$json = {
  '1': 'Role',
  '2': [
    {'1': 'role_id', '3': 1, '4': 1, '5': 3, '10': 'roleId'},
    {'1': 'role_name', '3': 2, '4': 1, '5': 9, '10': 'roleName'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'permissions', '3': 4, '4': 3, '5': 9, '10': 'permissions'},
  ],
};

/// Descriptor for `Role`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roleDescriptor = $convert.base64Decode(
    'CgRSb2xlEhcKB3JvbGVfaWQYASABKANSBnJvbGVJZBIbCglyb2xlX25hbWUYAiABKAlSCHJvbG'
    'VOYW1lEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIgCgtwZXJtaXNzaW9ucxgE'
    'IAMoCVILcGVybWlzc2lvbnM=');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISHQoKYWNjb3VudF9pZBgBIAEoA1IJYWNjb3VudElkEiEKDGRpc3BsYXlfbmFtZR'
    'gCIAEoCVILZGlzcGxheU5hbWU=');

@$core.Deprecated('Use permissionDescriptor instead')
const Permission$json = {
  '1': 'Permission',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Permission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionDescriptor = $convert.base64Decode(
    'CgpQZXJtaXNzaW9uEhAKA2tleRgBIAEoCVIDa2V5EiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZX'
    'NjcmlwdGlvbg==');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
    {'1': 'login_name', '3': 2, '4': 1, '5': 9, '10': 'loginName'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'role_id', '3': 4, '4': 1, '5': 3, '10': 'roleId'},
    {'1': 'inactive', '3': 5, '4': 1, '5': 8, '10': 'inactive'},
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'role_name', '3': 7, '4': 1, '5': 9, '10': 'roleName'},
    {'1': 'permissions', '3': 8, '4': 3, '5': 9, '10': 'permissions'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eh0KCmFjY291bnRfaWQYASABKANSCWFjY291bnRJZBIdCgpsb2dpbl9uYW1lGA'
    'IgASgJUglsb2dpbk5hbWUSIQoMZGlzcGxheV9uYW1lGAMgASgJUgtkaXNwbGF5TmFtZRIXCgdy'
    'b2xlX2lkGAQgASgDUgZyb2xlSWQSGgoIaW5hY3RpdmUYBSABKAhSCGluYWN0aXZlEjkKCmNyZW'
    'F0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSGwoJ'
    'cm9sZV9uYW1lGAcgASgJUghyb2xlTmFtZRIgCgtwZXJtaXNzaW9ucxgIIAMoCVILcGVybWlzc2'
    'lvbnM=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'login_name', '3': 1, '4': 1, '5': 9, '10': 'loginName'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSHQoKbG9naW5fbmFtZRgBIAEoCVIJbG9naW5OYW1lEhoKCHBhc3N3b3'
    'JkGAIgASgJUghwYXNzd29yZA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'expires_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEjMKB2FjY291bnQYASABKAsyGS5tZWRpYXRhZy5hdXRoLnYxLkFjY2'
    '91bnRSB2FjY291bnQSFAoFdG9rZW4YAiABKAlSBXRva2VuEjkKCmV4cGlyZXNfYXQYAyABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQ=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor =
    $convert.base64Decode('Cg5Mb2dvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use getCurrentAccountRequestDescriptor instead')
const GetCurrentAccountRequest$json = {
  '1': 'GetCurrentAccountRequest',
};

/// Descriptor for `GetCurrentAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentAccountRequestDescriptor =
    $convert.base64Decode('ChhHZXRDdXJyZW50QWNjb3VudFJlcXVlc3Q=');

@$core.Deprecated('Use getCurrentAccountResponseDescriptor instead')
const GetCurrentAccountResponse$json = {
  '1': 'GetCurrentAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
  ],
};

/// Descriptor for `GetCurrentAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentAccountResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRDdXJyZW50QWNjb3VudFJlc3BvbnNlEjMKB2FjY291bnQYASABKAsyGS5tZWRpYXRhZy'
        '5hdXRoLnYxLkFjY291bnRSB2FjY291bnQ=');

@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = {
  '1': 'ChangePasswordRequest',
  '2': [
    {'1': 'current_password', '3': 1, '4': 1, '5': 9, '10': 'currentPassword'},
    {'1': 'new_password', '3': 2, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSKQoQY3VycmVudF9wYXNzd29yZBgBIAEoCVIPY3Vycm'
    'VudFBhc3N3b3JkEiEKDG5ld19wYXNzd29yZBgCIAEoCVILbmV3UGFzc3dvcmQ=');

@$core.Deprecated('Use changePasswordResponseDescriptor instead')
const ChangePasswordResponse$json = {
  '1': 'ChangePasswordResponse',
};

/// Descriptor for `ChangePasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordResponseDescriptor =
    $convert.base64Decode('ChZDaGFuZ2VQYXNzd29yZFJlc3BvbnNl');

@$core.Deprecated('Use listAccountsRequestDescriptor instead')
const ListAccountsRequest$json = {
  '1': 'ListAccountsRequest',
};

/// Descriptor for `ListAccountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountsRequestDescriptor =
    $convert.base64Decode('ChNMaXN0QWNjb3VudHNSZXF1ZXN0');

@$core.Deprecated('Use listAccountsResponseDescriptor instead')
const ListAccountsResponse$json = {
  '1': 'ListAccountsResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'accounts'
    },
  ],
};

/// Descriptor for `ListAccountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QWNjb3VudHNSZXNwb25zZRI1CghhY2NvdW50cxgBIAMoCzIZLm1lZGlhdGFnLmF1dG'
    'gudjEuQWNjb3VudFIIYWNjb3VudHM=');

@$core.Deprecated('Use createAccountRequestDescriptor instead')
const CreateAccountRequest$json = {
  '1': 'CreateAccountRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `CreateAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAccountRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVBY2NvdW50UmVxdWVzdBIzCgdhY2NvdW50GAEgASgLMhkubWVkaWF0YWcuYXV0aC'
    '52MS5BY2NvdW50UgdhY2NvdW50EhoKCHBhc3N3b3JkGAIgASgJUghwYXNzd29yZA==');

@$core.Deprecated('Use createAccountResponseDescriptor instead')
const CreateAccountResponse$json = {
  '1': 'CreateAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
  ],
};

/// Descriptor for `CreateAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAccountResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVBY2NvdW50UmVzcG9uc2USMwoHYWNjb3VudBgBIAEoCzIZLm1lZGlhdGFnLmF1dG'
    'gudjEuQWNjb3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use updateAccountRequestDescriptor instead')
const UpdateAccountRequest$json = {
  '1': 'UpdateAccountRequest',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `UpdateAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAccountRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVBY2NvdW50UmVxdWVzdBIzCgdhY2NvdW50GAEgASgLMhkubWVkaWF0YWcuYXV0aC'
    '52MS5BY2NvdW50UgdhY2NvdW50EjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLkZpZWxkTWFza1IKdXBkYXRlTWFzaxIaCghwYXNzd29yZBgDIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use updateAccountResponseDescriptor instead')
const UpdateAccountResponse$json = {
  '1': 'UpdateAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Account',
      '10': 'account'
    },
  ],
};

/// Descriptor for `UpdateAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAccountResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVBY2NvdW50UmVzcG9uc2USMwoHYWNjb3VudBgBIAEoCzIZLm1lZGlhdGFnLmF1dG'
    'gudjEuQWNjb3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use listPermissionsRequestDescriptor instead')
const ListPermissionsRequest$json = {
  '1': 'ListPermissionsRequest',
};

/// Descriptor for `ListPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsRequestDescriptor =
    $convert.base64Decode('ChZMaXN0UGVybWlzc2lvbnNSZXF1ZXN0');

@$core.Deprecated('Use listPermissionsResponseDescriptor instead')
const ListPermissionsResponse$json = {
  '1': 'ListPermissionsResponse',
  '2': [
    {
      '1': 'permissions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.auth.v1.Permission',
      '10': 'permissions'
    },
  ],
};

/// Descriptor for `ListPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPermissionsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGVybWlzc2lvbnNSZXNwb25zZRI+CgtwZXJtaXNzaW9ucxgBIAMoCzIcLm1lZGlhdG'
        'FnLmF1dGgudjEuUGVybWlzc2lvblILcGVybWlzc2lvbnM=');

@$core.Deprecated('Use listRolesRequestDescriptor instead')
const ListRolesRequest$json = {
  '1': 'ListRolesRequest',
};

/// Descriptor for `ListRolesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRolesRequestDescriptor =
    $convert.base64Decode('ChBMaXN0Um9sZXNSZXF1ZXN0');

@$core.Deprecated('Use listRolesResponseDescriptor instead')
const ListRolesResponse$json = {
  '1': 'ListRolesResponse',
  '2': [
    {
      '1': 'roles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.auth.v1.Role',
      '10': 'roles'
    },
  ],
};

/// Descriptor for `ListRolesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRolesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Um9sZXNSZXNwb25zZRIsCgVyb2xlcxgBIAMoCzIWLm1lZGlhdGFnLmF1dGgudjEuUm'
    '9sZVIFcm9sZXM=');

@$core.Deprecated('Use createRoleRequestDescriptor instead')
const CreateRoleRequest$json = {
  '1': 'CreateRoleRequest',
  '2': [
    {
      '1': 'role',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Role',
      '10': 'role'
    },
  ],
};

/// Descriptor for `CreateRoleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoleRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb2xlUmVxdWVzdBIqCgRyb2xlGAEgASgLMhYubWVkaWF0YWcuYXV0aC52MS5Sb2'
    'xlUgRyb2xl');

@$core.Deprecated('Use createRoleResponseDescriptor instead')
const CreateRoleResponse$json = {
  '1': 'CreateRoleResponse',
  '2': [
    {
      '1': 'role',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Role',
      '10': 'role'
    },
  ],
};

/// Descriptor for `CreateRoleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoleResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSb2xlUmVzcG9uc2USKgoEcm9sZRgBIAEoCzIWLm1lZGlhdGFnLmF1dGgudjEuUm'
    '9sZVIEcm9sZQ==');

@$core.Deprecated('Use updateRoleRequestDescriptor instead')
const UpdateRoleRequest$json = {
  '1': 'UpdateRoleRequest',
  '2': [
    {
      '1': 'role',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Role',
      '10': 'role'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateRoleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoleRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSb2xlUmVxdWVzdBIqCgRyb2xlGAEgASgLMhYubWVkaWF0YWcuYXV0aC52MS5Sb2'
    'xlUgRyb2xlEjsKC3VwZGF0ZV9tYXNrGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLkZpZWxkTWFz'
    'a1IKdXBkYXRlTWFzaw==');

@$core.Deprecated('Use updateRoleResponseDescriptor instead')
const UpdateRoleResponse$json = {
  '1': 'UpdateRoleResponse',
  '2': [
    {
      '1': 'role',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.Role',
      '10': 'role'
    },
  ],
};

/// Descriptor for `UpdateRoleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoleResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVSb2xlUmVzcG9uc2USKgoEcm9sZRgBIAEoCzIWLm1lZGlhdGFnLmF1dGgudjEuUm'
    '9sZVIEcm9sZQ==');

@$core.Deprecated('Use deleteRoleRequestDescriptor instead')
const DeleteRoleRequest$json = {
  '1': 'DeleteRoleRequest',
  '2': [
    {'1': 'role_id', '3': 1, '4': 1, '5': 3, '10': 'roleId'},
  ],
};

/// Descriptor for `DeleteRoleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoleRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVSb2xlUmVxdWVzdBIXCgdyb2xlX2lkGAEgASgDUgZyb2xlSWQ=');

@$core.Deprecated('Use deleteRoleResponseDescriptor instead')
const DeleteRoleResponse$json = {
  '1': 'DeleteRoleResponse',
};

/// Descriptor for `DeleteRoleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoleResponseDescriptor =
    $convert.base64Decode('ChJEZWxldGVSb2xlUmVzcG9uc2U=');

@$core.Deprecated('Use serviceTokenDescriptor instead')
const ServiceToken$json = {
  '1': 'ServiceToken',
  '2': [
    {'1': 'token_id', '3': 1, '4': 1, '5': 3, '10': 'tokenId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'created_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'revoked_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'revokedAt'
    },
    {
      '1': 'last_used_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUsedAt'
    },
  ],
};

/// Descriptor for `ServiceToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceTokenDescriptor = $convert.base64Decode(
    'CgxTZXJ2aWNlVG9rZW4SGQoIdG9rZW5faWQYASABKANSB3Rva2VuSWQSEgoEbmFtZRgCIAEoCV'
    'IEbmFtZRI5CgpjcmVhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJ'
    'Y3JlYXRlZEF0EjkKCnJldm9rZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUglyZXZva2VkQXQSPAoMbGFzdF91c2VkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIKbGFzdFVzZWRBdA==');

@$core.Deprecated('Use listServiceTokensRequestDescriptor instead')
const ListServiceTokensRequest$json = {
  '1': 'ListServiceTokensRequest',
};

/// Descriptor for `ListServiceTokensRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listServiceTokensRequestDescriptor =
    $convert.base64Decode('ChhMaXN0U2VydmljZVRva2Vuc1JlcXVlc3Q=');

@$core.Deprecated('Use listServiceTokensResponseDescriptor instead')
const ListServiceTokensResponse$json = {
  '1': 'ListServiceTokensResponse',
  '2': [
    {
      '1': 'tokens',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.mediatag.auth.v1.ServiceToken',
      '10': 'tokens'
    },
  ],
};

/// Descriptor for `ListServiceTokensResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listServiceTokensResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0U2VydmljZVRva2Vuc1Jlc3BvbnNlEjYKBnRva2VucxgBIAMoCzIeLm1lZGlhdGFnLm'
        'F1dGgudjEuU2VydmljZVRva2VuUgZ0b2tlbnM=');

@$core.Deprecated('Use createServiceTokenRequestDescriptor instead')
const CreateServiceTokenRequest$json = {
  '1': 'CreateServiceTokenRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateServiceTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createServiceTokenRequestDescriptor =
    $convert.base64Decode(
        'ChlDcmVhdGVTZXJ2aWNlVG9rZW5SZXF1ZXN0EhIKBG5hbWUYASABKAlSBG5hbWU=');

@$core.Deprecated('Use createServiceTokenResponseDescriptor instead')
const CreateServiceTokenResponse$json = {
  '1': 'CreateServiceTokenResponse',
  '2': [
    {
      '1': 'service_token',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.ServiceToken',
      '10': 'serviceToken'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CreateServiceTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createServiceTokenResponseDescriptor =
    $convert.base64Decode(
        'ChpDcmVhdGVTZXJ2aWNlVG9rZW5SZXNwb25zZRJDCg1zZXJ2aWNlX3Rva2VuGAEgASgLMh4ubW'
        'VkaWF0YWcuYXV0aC52MS5TZXJ2aWNlVG9rZW5SDHNlcnZpY2VUb2tlbhIUCgV0b2tlbhgCIAEo'
        'CVIFdG9rZW4=');

@$core.Deprecated('Use revokeServiceTokenRequestDescriptor instead')
const RevokeServiceTokenRequest$json = {
  '1': 'RevokeServiceTokenRequest',
  '2': [
    {'1': 'token_id', '3': 1, '4': 1, '5': 3, '10': 'tokenId'},
  ],
};

/// Descriptor for `RevokeServiceTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeServiceTokenRequestDescriptor =
    $convert.base64Decode(
        'ChlSZXZva2VTZXJ2aWNlVG9rZW5SZXF1ZXN0EhkKCHRva2VuX2lkGAEgASgDUgd0b2tlbklk');

@$core.Deprecated('Use revokeServiceTokenResponseDescriptor instead')
const RevokeServiceTokenResponse$json = {
  '1': 'RevokeServiceTokenResponse',
  '2': [
    {
      '1': 'service_token',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.mediatag.auth.v1.ServiceToken',
      '10': 'serviceToken'
    },
  ],
};

/// Descriptor for `RevokeServiceTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeServiceTokenResponseDescriptor =
    $convert.base64Decode(
        'ChpSZXZva2VTZXJ2aWNlVG9rZW5SZXNwb25zZRJDCg1zZXJ2aWNlX3Rva2VuGAEgASgLMh4ubW'
        'VkaWF0YWcuYXV0aC52MS5TZXJ2aWNlVG9rZW5SDHNlcnZpY2VUb2tlbg==');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {
      '1': 'Login',
      '2': '.mediatag.auth.v1.LoginRequest',
      '3': '.mediatag.auth.v1.LoginResponse'
    },
    {
      '1': 'Logout',
      '2': '.mediatag.auth.v1.LogoutRequest',
      '3': '.mediatag.auth.v1.LogoutResponse'
    },
    {
      '1': 'GetCurrentAccount',
      '2': '.mediatag.auth.v1.GetCurrentAccountRequest',
      '3': '.mediatag.auth.v1.GetCurrentAccountResponse'
    },
    {
      '1': 'ChangePassword',
      '2': '.mediatag.auth.v1.ChangePasswordRequest',
      '3': '.mediatag.auth.v1.ChangePasswordResponse'
    },
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AuthServiceBase$messageJson = {
  '.mediatag.auth.v1.LoginRequest': LoginRequest$json,
  '.mediatag.auth.v1.LoginResponse': LoginResponse$json,
  '.mediatag.auth.v1.Account': Account$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.auth.v1.LogoutRequest': LogoutRequest$json,
  '.mediatag.auth.v1.LogoutResponse': LogoutResponse$json,
  '.mediatag.auth.v1.GetCurrentAccountRequest': GetCurrentAccountRequest$json,
  '.mediatag.auth.v1.GetCurrentAccountResponse': GetCurrentAccountResponse$json,
  '.mediatag.auth.v1.ChangePasswordRequest': ChangePasswordRequest$json,
  '.mediatag.auth.v1.ChangePasswordResponse': ChangePasswordResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRJICgVMb2dpbhIeLm1lZGlhdGFnLmF1dGgudjEuTG9naW5SZXF1ZXN0Gh'
    '8ubWVkaWF0YWcuYXV0aC52MS5Mb2dpblJlc3BvbnNlEksKBkxvZ291dBIfLm1lZGlhdGFnLmF1'
    'dGgudjEuTG9nb3V0UmVxdWVzdBogLm1lZGlhdGFnLmF1dGgudjEuTG9nb3V0UmVzcG9uc2USbA'
    'oRR2V0Q3VycmVudEFjY291bnQSKi5tZWRpYXRhZy5hdXRoLnYxLkdldEN1cnJlbnRBY2NvdW50'
    'UmVxdWVzdBorLm1lZGlhdGFnLmF1dGgudjEuR2V0Q3VycmVudEFjY291bnRSZXNwb25zZRJjCg'
    '5DaGFuZ2VQYXNzd29yZBInLm1lZGlhdGFnLmF1dGgudjEuQ2hhbmdlUGFzc3dvcmRSZXF1ZXN0'
    'GigubWVkaWF0YWcuYXV0aC52MS5DaGFuZ2VQYXNzd29yZFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> AccountServiceBase$json = {
  '1': 'AccountService',
  '2': [
    {
      '1': 'ListAccounts',
      '2': '.mediatag.auth.v1.ListAccountsRequest',
      '3': '.mediatag.auth.v1.ListAccountsResponse'
    },
    {
      '1': 'CreateAccount',
      '2': '.mediatag.auth.v1.CreateAccountRequest',
      '3': '.mediatag.auth.v1.CreateAccountResponse'
    },
    {
      '1': 'UpdateAccount',
      '2': '.mediatag.auth.v1.UpdateAccountRequest',
      '3': '.mediatag.auth.v1.UpdateAccountResponse'
    },
    {
      '1': 'ListPermissions',
      '2': '.mediatag.auth.v1.ListPermissionsRequest',
      '3': '.mediatag.auth.v1.ListPermissionsResponse'
    },
    {
      '1': 'ListRoles',
      '2': '.mediatag.auth.v1.ListRolesRequest',
      '3': '.mediatag.auth.v1.ListRolesResponse'
    },
    {
      '1': 'CreateRole',
      '2': '.mediatag.auth.v1.CreateRoleRequest',
      '3': '.mediatag.auth.v1.CreateRoleResponse'
    },
    {
      '1': 'UpdateRole',
      '2': '.mediatag.auth.v1.UpdateRoleRequest',
      '3': '.mediatag.auth.v1.UpdateRoleResponse'
    },
    {
      '1': 'DeleteRole',
      '2': '.mediatag.auth.v1.DeleteRoleRequest',
      '3': '.mediatag.auth.v1.DeleteRoleResponse'
    },
    {
      '1': 'ListServiceTokens',
      '2': '.mediatag.auth.v1.ListServiceTokensRequest',
      '3': '.mediatag.auth.v1.ListServiceTokensResponse'
    },
    {
      '1': 'CreateServiceToken',
      '2': '.mediatag.auth.v1.CreateServiceTokenRequest',
      '3': '.mediatag.auth.v1.CreateServiceTokenResponse'
    },
    {
      '1': 'RevokeServiceToken',
      '2': '.mediatag.auth.v1.RevokeServiceTokenRequest',
      '3': '.mediatag.auth.v1.RevokeServiceTokenResponse'
    },
  ],
};

@$core.Deprecated('Use accountServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AccountServiceBase$messageJson = {
  '.mediatag.auth.v1.ListAccountsRequest': ListAccountsRequest$json,
  '.mediatag.auth.v1.ListAccountsResponse': ListAccountsResponse$json,
  '.mediatag.auth.v1.Account': Account$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mediatag.auth.v1.CreateAccountRequest': CreateAccountRequest$json,
  '.mediatag.auth.v1.CreateAccountResponse': CreateAccountResponse$json,
  '.mediatag.auth.v1.UpdateAccountRequest': UpdateAccountRequest$json,
  '.google.protobuf.FieldMask': $1.FieldMask$json,
  '.mediatag.auth.v1.UpdateAccountResponse': UpdateAccountResponse$json,
  '.mediatag.auth.v1.ListPermissionsRequest': ListPermissionsRequest$json,
  '.mediatag.auth.v1.ListPermissionsResponse': ListPermissionsResponse$json,
  '.mediatag.auth.v1.Permission': Permission$json,
  '.mediatag.auth.v1.ListRolesRequest': ListRolesRequest$json,
  '.mediatag.auth.v1.ListRolesResponse': ListRolesResponse$json,
  '.mediatag.auth.v1.Role': Role$json,
  '.mediatag.auth.v1.CreateRoleRequest': CreateRoleRequest$json,
  '.mediatag.auth.v1.CreateRoleResponse': CreateRoleResponse$json,
  '.mediatag.auth.v1.UpdateRoleRequest': UpdateRoleRequest$json,
  '.mediatag.auth.v1.UpdateRoleResponse': UpdateRoleResponse$json,
  '.mediatag.auth.v1.DeleteRoleRequest': DeleteRoleRequest$json,
  '.mediatag.auth.v1.DeleteRoleResponse': DeleteRoleResponse$json,
  '.mediatag.auth.v1.ListServiceTokensRequest': ListServiceTokensRequest$json,
  '.mediatag.auth.v1.ListServiceTokensResponse': ListServiceTokensResponse$json,
  '.mediatag.auth.v1.ServiceToken': ServiceToken$json,
  '.mediatag.auth.v1.CreateServiceTokenRequest': CreateServiceTokenRequest$json,
  '.mediatag.auth.v1.CreateServiceTokenResponse':
      CreateServiceTokenResponse$json,
  '.mediatag.auth.v1.RevokeServiceTokenRequest': RevokeServiceTokenRequest$json,
  '.mediatag.auth.v1.RevokeServiceTokenResponse':
      RevokeServiceTokenResponse$json,
};

/// Descriptor for `AccountService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List accountServiceDescriptor = $convert.base64Decode(
    'Cg5BY2NvdW50U2VydmljZRJdCgxMaXN0QWNjb3VudHMSJS5tZWRpYXRhZy5hdXRoLnYxLkxpc3'
    'RBY2NvdW50c1JlcXVlc3QaJi5tZWRpYXRhZy5hdXRoLnYxLkxpc3RBY2NvdW50c1Jlc3BvbnNl'
    'EmAKDUNyZWF0ZUFjY291bnQSJi5tZWRpYXRhZy5hdXRoLnYxLkNyZWF0ZUFjY291bnRSZXF1ZX'
    'N0GicubWVkaWF0YWcuYXV0aC52MS5DcmVhdGVBY2NvdW50UmVzcG9uc2USYAoNVXBkYXRlQWNj'
    'b3VudBImLm1lZGlhdGFnLmF1dGgudjEuVXBkYXRlQWNjb3VudFJlcXVlc3QaJy5tZWRpYXRhZy'
    '5hdXRoLnYxLlVwZGF0ZUFjY291bnRSZXNwb25zZRJmCg9MaXN0UGVybWlzc2lvbnMSKC5tZWRp'
    'YXRhZy5hdXRoLnYxLkxpc3RQZXJtaXNzaW9uc1JlcXVlc3QaKS5tZWRpYXRhZy5hdXRoLnYxLk'
    'xpc3RQZXJtaXNzaW9uc1Jlc3BvbnNlElQKCUxpc3RSb2xlcxIiLm1lZGlhdGFnLmF1dGgudjEu'
    'TGlzdFJvbGVzUmVxdWVzdBojLm1lZGlhdGFnLmF1dGgudjEuTGlzdFJvbGVzUmVzcG9uc2USVw'
    'oKQ3JlYXRlUm9sZRIjLm1lZGlhdGFnLmF1dGgudjEuQ3JlYXRlUm9sZVJlcXVlc3QaJC5tZWRp'
    'YXRhZy5hdXRoLnYxLkNyZWF0ZVJvbGVSZXNwb25zZRJXCgpVcGRhdGVSb2xlEiMubWVkaWF0YW'
    'cuYXV0aC52MS5VcGRhdGVSb2xlUmVxdWVzdBokLm1lZGlhdGFnLmF1dGgudjEuVXBkYXRlUm9s'
    'ZVJlc3BvbnNlElcKCkRlbGV0ZVJvbGUSIy5tZWRpYXRhZy5hdXRoLnYxLkRlbGV0ZVJvbGVSZX'
    'F1ZXN0GiQubWVkaWF0YWcuYXV0aC52MS5EZWxldGVSb2xlUmVzcG9uc2USbAoRTGlzdFNlcnZp'
    'Y2VUb2tlbnMSKi5tZWRpYXRhZy5hdXRoLnYxLkxpc3RTZXJ2aWNlVG9rZW5zUmVxdWVzdBorLm'
    '1lZGlhdGFnLmF1dGgudjEuTGlzdFNlcnZpY2VUb2tlbnNSZXNwb25zZRJvChJDcmVhdGVTZXJ2'
    'aWNlVG9rZW4SKy5tZWRpYXRhZy5hdXRoLnYxLkNyZWF0ZVNlcnZpY2VUb2tlblJlcXVlc3QaLC'
    '5tZWRpYXRhZy5hdXRoLnYxLkNyZWF0ZVNlcnZpY2VUb2tlblJlc3BvbnNlEm8KElJldm9rZVNl'
    'cnZpY2VUb2tlbhIrLm1lZGlhdGFnLmF1dGgudjEuUmV2b2tlU2VydmljZVRva2VuUmVxdWVzdB'
    'osLm1lZGlhdGFnLmF1dGgudjEuUmV2b2tlU2VydmljZVRva2VuUmVzcG9uc2U=');
