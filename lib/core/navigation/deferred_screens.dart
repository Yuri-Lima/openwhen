import 'package:flutter/material.dart';

import '../../features/capsules/presentation/screens/create_capsule_screen.dart'
    deferred as create_capsule;
import '../../features/letters/presentation/screens/write_letter_screen.dart'
    deferred as write_letter;
import '../../features/profile/presentation/screens/search_screen.dart'
    deferred as search_screen;

/// Shell que carrega o chunk deferido de [write_letter] antes de montar a UI.
class DeferredWriteLetterPage extends StatelessWidget {
  const DeferredWriteLetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: write_letter.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return write_letter.WriteLetterScreen();
      },
    );
  }
}

/// Shell que carrega o chunk deferido de [create_capsule] antes de montar a UI.
class DeferredCreateCapsulePage extends StatelessWidget {
  const DeferredCreateCapsulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: create_capsule.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return create_capsule.CreateCapsuleScreen();
      },
    );
  }
}

/// Shell que carrega o chunk deferido de [search_screen] antes de montar a UI.
class DeferredSearchPage extends StatelessWidget {
  const DeferredSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: search_screen.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return search_screen.SearchScreen();
      },
    );
  }
}
