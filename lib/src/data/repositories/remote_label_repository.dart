import 'package:connectrpc/connect.dart';

import '../../domain/entities/label_vocab.dart';
import '../../domain/repositories/label_repository.dart';
import '../datasources/remote/media_tag_data_source.dart';
import 'label_requests.dart';

class RemoteLabelRepository implements LabelRepository {
  RemoteLabelRepository(this._mediaTag);

  final MediaTagDataSource _mediaTag;

  @override
  Future<List<LabelNode>> listLabels() {
    return _call(
      emptyMessage: '라벨 목록을 불러오지 못했습니다.',
      call: () async {
        final response = await _mediaTag.labelService.listLabels(
          buildListLabelsRequest(),
        );
        return labelNodesFrom(response.labels);
      },
    );
  }

  @override
  Future<LabelNode> createValue({
    required String name,
    String parentValueId = '',
  }) {
    return _call(
      emptyMessage: '라벨을 만들지 못했습니다.',
      call: () async {
        final response = await _mediaTag.labelService.createLabelValue(
          buildCreateLabelValueRequest(
            name: name,
            parentValueId: parentValueId,
          ),
        );
        final node = labelNodeFrom(response.value);
        if (node == null) {
          throw const LabelException('라벨을 만들지 못했습니다.');
        }
        return node;
      },
    );
  }

  @override
  Future<LabelNode> renameValue({
    required String valueId,
    required String name,
  }) {
    return _call(
      emptyMessage: '라벨 이름을 바꾸지 못했습니다.',
      call: () async {
        final response = await _mediaTag.labelService.updateLabelValue(
          buildRenameLabelValueRequest(valueId: valueId, name: name),
        );
        final node = labelNodeFrom(response.value);
        if (node == null) {
          throw const LabelException('라벨 이름을 바꾸지 못했습니다.');
        }
        return node;
      },
    );
  }

  @override
  Future<void> deprecateValue({required String valueId}) {
    return _call(
      emptyMessage: '라벨을 숨기지 못했습니다.',
      call: () async {
        await _mediaTag.labelService.updateLabelValue(
          buildDeprecateLabelValueRequest(valueId),
        );
      },
    );
  }

  Future<T> _call<T>({
    required String emptyMessage,
    required Future<T> Function() call,
  }) async {
    try {
      return await call();
    } on ConnectException catch (error) {
      final message = error.message.trim();
      throw LabelException(message.isEmpty ? emptyMessage : message);
    } on LabelException {
      rethrow;
    }
  }
}
