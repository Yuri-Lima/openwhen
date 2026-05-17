import 'package:cloud_firestore/cloud_firestore.dart';

/// Sort options for the Waiting tab (letters to open as receiver).
enum VaultWaitingSort {
  openDateAsc,
  openDateDesc,
  createdAtDesc,
  createdAtAsc,
  titleAsc,
}

/// Sort options for Opened letters.
enum VaultOpenedSort {
  openedAtDesc,
  openedAtAsc,
  openDateDesc,
  openDateAsc,
  titleAsc,
}

enum VaultOpenedDirection { all, received, sent }

/// Sort options for Sent letters (locked, as sender).
enum VaultSentSort {
  openDateAsc,
  openDateDesc,
  createdAtDesc,
  createdAtAsc,
  titleAsc,
}

/// Sort options for Capsules tab.
enum VaultCapsulesSort {
  openDateAsc,
  openDateDesc,
  createdAtDesc,
  createdAtAsc,
  titleAsc,
}

class WaitingTabFilters {
  final String query;
  final VaultWaitingSort sort;
  final DateTime? openDateFrom;
  final DateTime? openDateTo;

  const WaitingTabFilters({
    this.query = '',
    this.sort = VaultWaitingSort.openDateAsc,
    this.openDateFrom,
    this.openDateTo,
  });

  static const WaitingTabFilters initial = WaitingTabFilters();

  bool get isActive =>
      query.trim().isNotEmpty ||
      openDateFrom != null ||
      openDateTo != null ||
      sort != VaultWaitingSort.openDateAsc;

  WaitingTabFilters copyWith({
    String? query,
    VaultWaitingSort? sort,
    DateTime? openDateFrom,
    DateTime? openDateTo,
    bool clearOpenDateFrom = false,
    bool clearOpenDateTo = false,
  }) {
    return WaitingTabFilters(
      query: query ?? this.query,
      sort: sort ?? this.sort,
      openDateFrom: clearOpenDateFrom ? null : (openDateFrom ?? this.openDateFrom),
      openDateTo: clearOpenDateTo ? null : (openDateTo ?? this.openDateTo),
    );
  }
}

class OpenedTabFilters {
  final String query;
  final VaultOpenedSort sort;
  final VaultOpenedDirection direction;

  const OpenedTabFilters({
    this.query = '',
    this.sort = VaultOpenedSort.openedAtDesc,
    this.direction = VaultOpenedDirection.all,
  });

  static const OpenedTabFilters initial = OpenedTabFilters();

  bool get isActive =>
      query.trim().isNotEmpty ||
      direction != VaultOpenedDirection.all ||
      sort != VaultOpenedSort.openedAtDesc;

  OpenedTabFilters copyWith({
    String? query,
    VaultOpenedSort? sort,
    VaultOpenedDirection? direction,
  }) {
    return OpenedTabFilters(
      query: query ?? this.query,
      sort: sort ?? this.sort,
      direction: direction ?? this.direction,
    );
  }
}

class SentTabFilters {
  final String query;
  final VaultSentSort sort;
  final bool pendingOnly;

  const SentTabFilters({
    this.query = '',
    this.sort = VaultSentSort.openDateAsc,
    this.pendingOnly = false,
  });

  static const SentTabFilters initial = SentTabFilters();

  bool get isActive =>
      query.trim().isNotEmpty || pendingOnly || sort != VaultSentSort.openDateAsc;

  SentTabFilters copyWith({
    String? query,
    VaultSentSort? sort,
    bool? pendingOnly,
  }) {
    return SentTabFilters(
      query: query ?? this.query,
      sort: sort ?? this.sort,
      pendingOnly: pendingOnly ?? this.pendingOnly,
    );
  }
}

class CapsulesTabFilters {
  final String query;
  final VaultCapsulesSort sort;
  /// Empty = all themes.
  final Set<String> themes;

  const CapsulesTabFilters({
    this.query = '',
    this.sort = VaultCapsulesSort.openDateAsc,
    this.themes = const {},
  });

  static const CapsulesTabFilters initial = CapsulesTabFilters();

  bool get isActive =>
      query.trim().isNotEmpty ||
      themes.isNotEmpty ||
      sort != VaultCapsulesSort.openDateAsc;

  CapsulesTabFilters copyWith({
    String? query,
    VaultCapsulesSort? sort,
    Set<String>? themes,
  }) {
    return CapsulesTabFilters(
      query: query ?? this.query,
      sort: sort ?? this.sort,
      themes: themes ?? this.themes,
    );
  }
}

class VaultFiltersState {
  final WaitingTabFilters waiting;
  final OpenedTabFilters opened;
  final SentTabFilters sent;
  final CapsulesTabFilters capsules;

  const VaultFiltersState({
    this.waiting = WaitingTabFilters.initial,
    this.opened = OpenedTabFilters.initial,
    this.sent = SentTabFilters.initial,
    this.capsules = CapsulesTabFilters.initial,
  });

  static const VaultFiltersState initial = VaultFiltersState();

  bool isActiveForTab(int index) {
    switch (index) {
      case 0:
        return waiting.isActive;   // Recebidas
      case 1:
        return sent.isActive;      // Enviadas
      case 2:
        return capsules.isActive;  // Cápsulas
      default:
        return false;
    }
  }

  VaultFiltersState copyWith({
    WaitingTabFilters? waiting,
    OpenedTabFilters? opened,
    SentTabFilters? sent,
    CapsulesTabFilters? capsules,
  }) {
    return VaultFiltersState(
      waiting: waiting ?? this.waiting,
      opened: opened ?? this.opened,
      sent: sent ?? this.sent,
      capsules: capsules ?? this.capsules,
    );
  }

  VaultFiltersState clearTab(int index) {
    switch (index) {
      case 0:
        return copyWith(waiting: WaitingTabFilters.initial);   // Recebidas
      case 1:
        return copyWith(sent: SentTabFilters.initial);         // Enviadas
      case 2:
        return copyWith(capsules: CapsulesTabFilters.initial); // Cápsulas
      default:
        return this;
    }
  }
}

DateTime _openDate(Map<String, dynamic> m) {
  final o = m['openDate'];
  if (o is Timestamp) return o.toDate();
  return DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime _createdAt(Map<String, dynamic> m) {
  final c = m['createdAt'];
  if (c is Timestamp) return c.toDate();
  return DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime _openedAtOrOpenDate(Map<String, dynamic> m) {
  final oa = m['openedAt'];
  if (oa is Timestamp) return oa.toDate();
  return _openDate(m);
}

String _title(Map<String, dynamic> m) =>
    (m['title'] ?? '').toString().toLowerCase();

/// Letters: waiting tab — receiver, locked.
List<QueryDocumentSnapshot> filterAndSortWaiting(
  List<QueryDocumentSnapshot> docs,
  WaitingTabFilters f,
) {
  var list = List<QueryDocumentSnapshot>.from(docs);
  final q = f.query.trim().toLowerCase();
  if (q.isNotEmpty) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      final title = _title(m);
      final sender = (m['senderName'] ?? '').toString().toLowerCase();
      return title.contains(q) || sender.contains(q);
    }).toList();
  }
  if (f.openDateFrom != null) {
    final from = DateTime(
      f.openDateFrom!.year,
      f.openDateFrom!.month,
      f.openDateFrom!.day,
    );
    list = list.where((d) {
      final t = DateTime(
        _openDate(d.data() as Map<String, dynamic>).year,
        _openDate(d.data() as Map<String, dynamic>).month,
        _openDate(d.data() as Map<String, dynamic>).day,
      );
      return !t.isBefore(from);
    }).toList();
  }
  if (f.openDateTo != null) {
    final to = DateTime(
      f.openDateTo!.year,
      f.openDateTo!.month,
      f.openDateTo!.day,
    );
    list = list.where((d) {
      final t = DateTime(
        _openDate(d.data() as Map<String, dynamic>).year,
        _openDate(d.data() as Map<String, dynamic>).month,
        _openDate(d.data() as Map<String, dynamic>).day,
      );
      return !t.isAfter(to);
    }).toList();
  }

  int cmp(QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
    final ma = a.data() as Map<String, dynamic>;
    final mb = b.data() as Map<String, dynamic>;
    switch (f.sort) {
      case VaultWaitingSort.openDateAsc:
        return _openDate(ma).compareTo(_openDate(mb));
      case VaultWaitingSort.openDateDesc:
        return _openDate(mb).compareTo(_openDate(ma));
      case VaultWaitingSort.createdAtDesc:
        return _createdAt(mb).compareTo(_createdAt(ma));
      case VaultWaitingSort.createdAtAsc:
        return _createdAt(ma).compareTo(_createdAt(mb));
      case VaultWaitingSort.titleAsc:
        return _title(ma).compareTo(_title(mb));
    }
  }

  list.sort(cmp);
  return list;
}

/// Opened letters — merged received + sent.
List<QueryDocumentSnapshot> filterAndSortOpened(
  List<QueryDocumentSnapshot> docs,
  OpenedTabFilters f,
  String uid,
) {
  var list = List<QueryDocumentSnapshot>.from(docs);
  switch (f.direction) {
    case VaultOpenedDirection.received:
      list = list
          .where((d) => (d.data() as Map<String, dynamic>)['receiverUid'] == uid)
          .toList();
      break;
    case VaultOpenedDirection.sent:
      list = list
          .where((d) => (d.data() as Map<String, dynamic>)['senderUid'] == uid)
          .toList();
      break;
    case VaultOpenedDirection.all:
      break;
  }

  final q = f.query.trim().toLowerCase();
  if (q.isNotEmpty) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      final title = _title(m);
      final message = (m['message'] ?? '').toString().toLowerCase();
      final sender = (m['senderName'] ?? '').toString().toLowerCase();
      final receiver = (m['receiverName'] ?? '').toString().toLowerCase();
      return title.contains(q) ||
          message.contains(q) ||
          sender.contains(q) ||
          receiver.contains(q);
    }).toList();
  }

  int cmp(QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
    final ma = a.data() as Map<String, dynamic>;
    final mb = b.data() as Map<String, dynamic>;
    switch (f.sort) {
      case VaultOpenedSort.openedAtDesc:
        return _openedAtOrOpenDate(mb).compareTo(_openedAtOrOpenDate(ma));
      case VaultOpenedSort.openedAtAsc:
        return _openedAtOrOpenDate(ma).compareTo(_openedAtOrOpenDate(mb));
      case VaultOpenedSort.openDateDesc:
        return _openDate(mb).compareTo(_openDate(ma));
      case VaultOpenedSort.openDateAsc:
        return _openDate(ma).compareTo(_openDate(mb));
      case VaultOpenedSort.titleAsc:
        return _title(ma).compareTo(_title(mb));
    }
  }

  list.sort(cmp);
  return list;
}

/// Sent letters — sender, locked.
List<QueryDocumentSnapshot> filterAndSortSent(
  List<QueryDocumentSnapshot> docs,
  SentTabFilters f,
) {
  var list = List<QueryDocumentSnapshot>.from(docs);
  if (f.pendingOnly) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      return (m['requestStatus'] ?? 'accepted') == 'pending';
    }).toList();
  }
  final q = f.query.trim().toLowerCase();
  if (q.isNotEmpty) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      final title = _title(m);
      final receiver = (m['receiverName'] ?? '').toString().toLowerCase();
      return title.contains(q) || receiver.contains(q);
    }).toList();
  }

  int cmp(QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
    final ma = a.data() as Map<String, dynamic>;
    final mb = b.data() as Map<String, dynamic>;
    switch (f.sort) {
      case VaultSentSort.openDateAsc:
        return _openDate(ma).compareTo(_openDate(mb));
      case VaultSentSort.openDateDesc:
        return _openDate(mb).compareTo(_openDate(ma));
      case VaultSentSort.createdAtDesc:
        return _createdAt(mb).compareTo(_createdAt(ma));
      case VaultSentSort.createdAtAsc:
        return _createdAt(ma).compareTo(_createdAt(mb));
      case VaultSentSort.titleAsc:
        return _title(ma).compareTo(_title(mb));
    }
  }

  list.sort(cmp);
  return list;
}

DateTime _capsuleOpenOrCreated(Map<String, dynamic> m) {
  final o = m['openDate'];
  if (o is Timestamp) return o.toDate();
  return _createdAt(m);
}

/// Capsules — sender, locked.
List<QueryDocumentSnapshot> filterAndSortCapsules(
  List<QueryDocumentSnapshot> docs,
  CapsulesTabFilters f,
) {
  var list = List<QueryDocumentSnapshot>.from(docs);
  if (f.themes.isNotEmpty) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      final theme = (m['theme'] ?? 'memories').toString();
      return f.themes.contains(theme);
    }).toList();
  }
  final q = f.query.trim().toLowerCase();
  if (q.isNotEmpty) {
    list = list.where((d) {
      final m = d.data() as Map<String, dynamic>;
      return _title(m).contains(q);
    }).toList();
  }

  int cmp(QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
    final ma = a.data() as Map<String, dynamic>;
    final mb = b.data() as Map<String, dynamic>;
    switch (f.sort) {
      case VaultCapsulesSort.openDateAsc:
        return _capsuleOpenOrCreated(ma).compareTo(_capsuleOpenOrCreated(mb));
      case VaultCapsulesSort.openDateDesc:
        return _capsuleOpenOrCreated(mb).compareTo(_capsuleOpenOrCreated(ma));
      case VaultCapsulesSort.createdAtDesc:
        return _createdAt(mb).compareTo(_createdAt(ma));
      case VaultCapsulesSort.createdAtAsc:
        return _createdAt(ma).compareTo(_createdAt(mb));
      case VaultCapsulesSort.titleAsc:
        return _title(ma).compareTo(_title(mb));
    }
  }

  list.sort(cmp);
  return list;
}
