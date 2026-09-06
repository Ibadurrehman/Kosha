import 'entities/recent_item.dart';

/// One feature's contribution to Home's "Recent" section.
abstract interface class RecentSource {
  Stream<List<RecentItem>> watch({required int limit});
}
