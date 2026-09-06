/// Turns free-typed search text into a safe FTS5 `MATCH` expression.
///
/// Each whitespace-separated token is individually double-quoted (doubling
/// any embedded quote, the standard SQL escape) and given a trailing `*` for
/// prefix matching. Passing raw user text straight to `MATCH` is a real risk,
/// not just a bad-match one: text containing FTS5 operators (`AND`/`OR`/`NOT`),
/// parentheses, hyphens or an unbalanced quote is a SQL syntax error, and
/// quoting every token sidesteps that regardless of what was typed. Returns
/// the empty string for blank input.
String sanitizeSearchQuery(String raw) {
  final tokens = raw.trim().split(RegExp(r'\s+')).where((token) => token.isNotEmpty);
  return tokens.map((token) => '"${token.replaceAll('"', '""')}"*').join(' ');
}
