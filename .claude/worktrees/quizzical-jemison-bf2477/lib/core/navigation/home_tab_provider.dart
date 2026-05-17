import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index for [HomeScreen] body: 0 = Feed, 1 = Vault, 2 = Profile.
final homeTabIndexProvider =
    NotifierProvider<HomeTabIndexNotifier, int>(HomeTabIndexNotifier.new);

class HomeTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
  }
}
