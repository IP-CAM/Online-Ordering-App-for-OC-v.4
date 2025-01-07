import 'package:flutter/material.dart';

class ImageUtils {
  static Widget buildPlaceholderImage({
    double size = 40, 
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: size,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  static Widget buildNetworkImage({
    required String? imageUrl,
    required BoxFit fit,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Widget Function()? placeholderBuilder,
    double placeholderSize = 50,
  }) {
    debugPrint('Attempting to load image URL: "$imageUrl"');

    // Handle null, empty or whitespace-only URL
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      debugPrint('Image URL is null or empty');
      return _buildDefaultPlaceholder(
        width: width,
        height: height,
        placeholderSize: placeholderSize,
        fit: fit,
        placeholderBuilder: placeholderBuilder,
      );
    }

    final trimmedUrl = imageUrl.trim();
    debugPrint('Trimmed URL: "$trimmedUrl"');

    // Handle file:/// URLs
    if (trimmedUrl.startsWith('file:///')) {
      debugPrint('Detected file:/// URL - not supported');
      return _buildDefaultPlaceholder(
        width: width,
        height: height,
        placeholderSize: placeholderSize,
        fit: fit,
        placeholderBuilder: placeholderBuilder,
      );
    }

    // Handle URLs without protocol
    if (!trimmedUrl.startsWith('http://') && !trimmedUrl.startsWith('https://')) {
      debugPrint('URL missing protocol - attempting to add https://');
      // Remove any leading slashes and add https://
      final cleanUrl = trimmedUrl.replaceAll(RegExp(r'^/*'), '');
      final urlWithProtocol = 'https://$cleanUrl';
      debugPrint('Converted URL: $urlWithProtocol');

      try {
        return Image.network(
          urlWithProtocol,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image with protocol: $error');
            return _buildDefaultPlaceholder(
              width: width,
              height: height,
              placeholderSize: placeholderSize,
              fit: fit,
              placeholderBuilder: placeholderBuilder,
            );
          },
          loadingBuilder: _buildLoadingIndicator,
        );
      } catch (e) {
        debugPrint('Exception while loading image with protocol: $e');
        return _buildDefaultPlaceholder(
          width: width,
          height: height,
          placeholderSize: placeholderSize,
          fit: fit,
          placeholderBuilder: placeholderBuilder,
        );
      }
    }

    // Handle regular http(s) URLs
    try {
      return Image.network(
        trimmedUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $error');
          return _buildDefaultPlaceholder(
            width: width,
            height: height,
            placeholderSize: placeholderSize,
            fit: fit,
            placeholderBuilder: placeholderBuilder,
          );
        },
        loadingBuilder: _buildLoadingIndicator,
      );
    } catch (e) {
      debugPrint('Exception while loading image: $e');
      return _buildDefaultPlaceholder(
        width: width,
        height: height,
        placeholderSize: placeholderSize,
        fit: fit,
        placeholderBuilder: placeholderBuilder,
      );
    }
  }

  static Widget _buildDefaultPlaceholder({
    double? width,
    double? height,
    double placeholderSize = 50,
    BoxFit fit = BoxFit.cover,
    Widget Function()? placeholderBuilder,
  }) {
    return placeholderBuilder?.call() ?? 
           buildPlaceholderImage(
             size: placeholderSize,
             width: width,
             height: height,
             fit: fit,
           );
  }

  static Widget _buildLoadingIndicator(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
        strokeWidth: 2,
      ),
    );
  }
}