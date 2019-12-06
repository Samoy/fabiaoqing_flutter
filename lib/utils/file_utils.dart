bool isNetworkPath(String source) {
  return RegExp("^https?", caseSensitive: false).hasMatch(source);
}
