import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

/// Mock AuthenticationRepository that doesn't require Firebase
class MockAuthenticationRepository implements AuthenticationRepository {
  MockAuthenticationRepository() : _userController = StreamController<User>.broadcast() {
    // Emit a mock user immediately
    _userController.add(const User(id: 'mock-user-123'));
  }

  final StreamController<User> _userController;

  @override
  Stream<User> get user => _userController.stream;

  @override
  Stream<String?> get idToken => Stream.value('mock-token');

  @override
  Future<String?> refreshIdToken() async => 'mock-token';

  @override
  Future<void> signInAnonymously() async {
    _userController.add(const User(id: 'mock-user-123'));
  }

  @override
  void dispose() {
    _userController.close();
  }
}

/// Mock LeaderboardRepository that doesn't require Firebase
class MockLeaderboardRepository implements LeaderboardRepository {
  final List<LeaderboardEntryData> _mockData = [
    const LeaderboardEntryData(playerInitials: 'AAA', score: 10000),
    const LeaderboardEntryData(playerInitials: 'BBB', score: 9000),
    const LeaderboardEntryData(playerInitials: 'CCC', score: 8000),
    const LeaderboardEntryData(playerInitials: 'DDD', score: 7000),
    const LeaderboardEntryData(playerInitials: 'EEE', score: 6000),
  ];

  @override
  Future<List<LeaderboardEntryData>> fetchTop10Leaderboard() async {
    return _mockData;
  }

  @override
  Future<void> addLeaderboardEntry(LeaderboardEntryData entry) async {
    _mockData.add(entry);
    _mockData.sort((a, b) => b.score.compareTo(a.score));
    if (_mockData.length > 10) {
      _mockData.removeLast();
    }
  }
}
