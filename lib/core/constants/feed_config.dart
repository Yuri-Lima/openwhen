/// Public feed (Destaques) — cost and scale controls.
///
/// Query uses [kFeedPublicMaxDocuments] plus a rolling window on [openedAt]
/// so the client never subscribes to an unbounded global sort.
class FeedConfig {
  FeedConfig._();

  /// Hard cap on documents read per feed subscription (pagination / “load more”
  /// can be added later with startAfter).
  static const int publicMaxDocuments = 100;

  /// Only letters opened within this many days appear in the global feed.
  /// Product decision: tune with analytics; increases index selectivity.
  static const int openedAtWindowDays = 30;
}
