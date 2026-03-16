import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final int lettersSentCount;
  final int lettersReceivedCount;
  final int lockedLettersCount;
  final int openedLettersCount;
  final String language;
  final String? country;

  AppUser({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.lettersSentCount = 0,
    this.lettersReceivedCount = 0,
    this.lockedLettersCount = 0,
    this.openedLettersCount = 0,
    this.language = 'pt-BR',
    this.country,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lettersSentCount: data['lettersSentCount'] ?? 0,
      lettersReceivedCount: data['lettersReceivedCount'] ?? 0,
      lockedLettersCount: data['lockedLettersCount'] ?? 0,
      openedLettersCount: data['openedLettersCount'] ?? 0,
      language: data['language'] ?? 'pt-BR',
      country: data['country'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': Timestamp.fromDate(createdAt),
      'lettersSentCount': lettersSentCount,
      'lettersReceivedCount': lettersReceivedCount,
      'lockedLettersCount': lockedLettersCount,
      'openedLettersCount': openedLettersCount,
      'language': language,
      'country': country,
    };
  }
}
