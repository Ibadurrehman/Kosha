import '../../../core/utils/formatters.dart';
import '../../documents/domain/document_repository.dart';
import '../../documents/domain/entities/document.dart';
import '../domain/entities/home_item_kind.dart';
import '../domain/entities/needs_attention_item.dart';
import '../domain/entities/recent_item.dart';
import '../domain/entities/upcoming_item.dart';
import '../domain/needs_attention_source.dart';
import '../domain/recent_source.dart';
import '../domain/upcoming_source.dart';

/// Documents' contributions to Home's three aggregated sections.
///
/// Pure additions alongside the Tasks and Bills adapters, which is what
/// §12.1.3 predicted adding a source would cost: nothing about the existing
/// sources changed, and Home's providers gained one list entry each.
class DocumentNeedsAttentionSource implements NeedsAttentionSource {
  DocumentNeedsAttentionSource(this._documents);

  final DocumentRepository _documents;

  @override
  Stream<List<NeedsAttentionItem>> watch({required DateTime today}) {
    return _documents.watchNeedingAttention(today: today).map(
          (documents) => [
            for (final document in documents)
              NeedsAttentionItem(
                id: document.id,
                kind: HomeItemKind.document,
                title: document.name,
                subtitle: _subtitle(document, today),
                // "Renew" rather than "View": an expiring passport needs an
                // action outside the app, and the word is the reminder of it.
                ctaLabel: 'Renew',
              ),
          ],
        );
  }

  String _subtitle(Document document, DateTime today) {
    final days = daysUntilExpiry(document, today);
    if (days == null) return document.category.label;
    final when = switch (days) {
      0 => 'Expires today',
      1 => 'Expires tomorrow',
      -1 => 'Expired yesterday',
      < 0 => 'Expired ${-days} days ago',
      _ => 'Expires in $days days',
    };
    return '${document.category.label} · $when';
  }
}

/// Documents expiring inside Home's window.
class DocumentUpcomingSource implements UpcomingSource {
  DocumentUpcomingSource(this._documents);

  final DocumentRepository _documents;

  @override
  Stream<List<UpcomingItem>> watch({
    required DateTime from,
    required DateTime to,
  }) {
    return _documents.watchExpiringBetween(from, to).map(
          (documents) => [
            for (final document in documents)
              UpcomingItem(
                id: document.id,
                kind: HomeItemKind.document,
                title: document.name,
                date: document.expiresOn!,
              ),
          ],
        );
  }
}

/// Recently added or edited documents. Attaching a file bumps `updatedAt`, so
/// scanning something surfaces here the same way renaming it would.
class DocumentRecentSource implements RecentSource {
  DocumentRecentSource(this._documents);

  final DocumentRepository _documents;

  @override
  Stream<List<RecentItem>> watch({required int limit}) {
    return _documents.watchRecent(limit: limit).map(
          (documents) => [
            for (final document in documents)
              RecentItem(
                id: document.id,
                kind: HomeItemKind.document,
                title: document.name,
                subtitle: document.expiresOn == null
                    ? document.category.label
                    : 'Expires ${Dates.dayMonth(document.expiresOn!)}',
                at: document.updatedAt,
              ),
          ],
        );
  }
}
