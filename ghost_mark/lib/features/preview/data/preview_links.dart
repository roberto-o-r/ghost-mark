/// Returns a safe web URI, or `null` for relative links and unsupported
/// schemes. GhostMark intentionally launches only HTTP(S) links.
Uri? externalWebUri(String? href) {
  if (href == null) return null;
  final uri = Uri.tryParse(href);
  if (uri == null || uri.host.isEmpty) return null;
  if (uri.scheme != 'http' && uri.scheme != 'https') return null;
  return uri;
}

/// Returns the normalized fragment from an internal Markdown link.
String? internalAnchorId(String? href) {
  if (href == null || !href.startsWith('#')) return null;
  final uri = Uri.tryParse(href);
  if (uri == null || uri.fragment.isEmpty) return null;
  try {
    return Uri.decodeComponent(uri.fragment).toLowerCase();
  } on FormatException {
    return null;
  }
}

/// Matches the duplicate-ID convention used by Dart Markdown's GitHub Web
/// renderer: `section`, `section-2`, `section-3`, and so on.
class UniqueHeadingIds {
  final _counts = <String, int>{};

  String next(String generatedId) {
    final count = (_counts[generatedId] ?? 0) + 1;
    _counts[generatedId] = count;
    return count == 1 ? generatedId : '$generatedId-$count';
  }
}
