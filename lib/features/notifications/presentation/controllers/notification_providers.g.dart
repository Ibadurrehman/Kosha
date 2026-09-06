// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inbox)
final inboxProvider = InboxProvider._();

final class InboxProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationEntry>>,
          List<NotificationEntry>,
          Stream<List<NotificationEntry>>
        >
    with
        $FutureModifier<List<NotificationEntry>>,
        $StreamProvider<List<NotificationEntry>> {
  InboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationEntry>> create(Ref ref) {
    return inbox(ref);
  }
}

String _$inboxHash() => r'11a22583fcb556c57bafcf8437d2806814d8af64';

/// Feeds Home's bell badge.

@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = UnreadNotificationCountProvider._();

/// Feeds Home's bell badge.

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Feeds Home's bell badge.
  UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return unreadNotificationCount(ref);
  }
}

String _$unreadNotificationCountHash() =>
    r'c75a2ba68b5c86886505e6f74fe1f4b93204ee01';
