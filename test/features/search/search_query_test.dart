import 'package:flutter_test/flutter_test.dart';
import 'package:kosha/features/search/domain/search_query.dart';

void main() {
  test('quotes a single word with a trailing prefix wildcard', () {
    expect(sanitizeSearchQuery('groceries'), '"groceries"*');
  });

  test('quotes each word of a multi-word query separately', () {
    expect(sanitizeSearchQuery('buy milk'), '"buy"* "milk"*');
  });

  test('collapses repeated whitespace and trims', () {
    expect(sanitizeSearchQuery('  buy   milk  '), '"buy"* "milk"*');
  });

  test('blank input sanitizes to an empty expression', () {
    expect(sanitizeSearchQuery(''), '');
    expect(sanitizeSearchQuery('   '), '');
  });

  test('FTS5 operators in the input are neutralised by quoting', () {
    expect(sanitizeSearchQuery('AND OR NOT'), '"AND"* "OR"* "NOT"*');
  });

  test('parentheses and hyphens do not break the expression', () {
    expect(sanitizeSearchQuery('(test)'), '"(test)"*');
    expect(sanitizeSearchQuery('well-known'), '"well-known"*');
  });

  test('an embedded quote is escaped by doubling it', () {
    expect(sanitizeSearchQuery('say "hi"'), '"say"* """hi"""*');
  });
}
