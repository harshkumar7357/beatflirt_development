import 'package:flutter/material.dart';
import 'package:beatflirt/Api_services/api_services.dart';

Widget buildUserImage(String path, {double? height, double? width, BoxFit fit = BoxFit.cover}) {
  if (path.isEmpty) return _buildPlaceholder(height, width);
  
  if (path.startsWith('http') || path.startsWith('https')) {
    return Image.network(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
    );
  } else if (path.contains('uploads/')) {
    final baseUrl = ApiServices.baseUrl;
    return Image.network(
      '$baseUrl/$path',
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
    );
  } else if (path.startsWith('assets/')) {
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
    );
  } else {
    // Fallback for relative paths that might be local or needs base URL
    final baseUrl = ApiServices.baseUrl;
     return Image.network(
      '$baseUrl/$path',
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width),
    );
  }
}

Widget _buildPlaceholder(double? height, double? width) {
  return Container(
    height: height,
    width: width,
    color: Colors.grey[900],
    child: const Icon(Icons.person, color: Colors.white24),
  );
}
