import 'package:flutter/widgets.dart';

import 'authenticated_media.dart';

/// http(s) 이미지는 Bearer `readBytes` 후 [MemoryImage]. asset은 [AssetImage].
class AuthenticatedNetworkImage extends StatefulWidget {
  const AuthenticatedNetworkImage({
    super.key,
    this.networkUrl,
    this.assetPath,
    required this.builder,
    required this.loading,
    required this.error,
  });

  final String? networkUrl;
  final String? assetPath;
  final Widget Function(BuildContext context, ImageProvider provider) builder;
  final Widget loading;
  final Widget error;

  @override
  State<AuthenticatedNetworkImage> createState() =>
      _AuthenticatedNetworkImageState();
}

class _AuthenticatedNetworkImageState extends State<AuthenticatedNetworkImage> {
  ImageProvider? _provider;
  Object? _error;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant AuthenticatedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.networkUrl != widget.networkUrl ||
        oldWidget.assetPath != widget.assetPath) {
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_loadGeneration;
    final networkUrl = widget.networkUrl?.trim() ?? '';
    final assetPath = widget.assetPath?.trim() ?? '';
    setState(() {
      _provider = null;
      _error = null;
    });
    if (networkUrl.startsWith('http://') || networkUrl.startsWith('https://')) {
      try {
        final bytes = await readAuthenticatedMediaBytes(networkUrl);
        if (!mounted || generation != _loadGeneration) {
          return;
        }
        setState(() {
          _provider = MemoryImage(bytes);
        });
      } catch (error) {
        if (!mounted || generation != _loadGeneration) {
          return;
        }
        setState(() {
          _error = error;
        });
      }
      return;
    }
    if (assetPath.isNotEmpty) {
      setState(() {
        _provider = AssetImage(assetPath);
      });
      return;
    }
    setState(() {
      _error = StateError('이미지 주소가 없습니다');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.error;
    }
    final provider = _provider;
    if (provider == null) {
      return widget.loading;
    }
    return widget.builder(context, provider);
  }
}
