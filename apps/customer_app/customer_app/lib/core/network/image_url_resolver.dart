/// Helper function to resolve image URLs returned by the backend or user input.
/// Supports absolute URLs (http/https), data URLs, and relative paths (e.g. /public/uploads/products/xyz.jpg).
String resolveImageUrl(String? path) {
  if (path == null || path.trim().isEmpty) return '';
  final trimmed = path.trim();
  if (trimmed.startsWith('http://') ||
      trimmed.startsWith('https://') ||
      trimmed.startsWith('data:')) {
    return trimmed;
  }

  const apiUrl = bool.hasEnvironment('API_URL')
      ? String.fromEnvironment('API_URL')
      : 'https://fresh-save-api.onrender.com/api/v1';

  final uri = Uri.tryParse(apiUrl);
  if (uri != null && uri.hasScheme && uri.hasAuthority) {
    final hostBase = '${uri.scheme}://${uri.authority}';
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$hostBase$cleanPath';
  }

  return trimmed;
}
