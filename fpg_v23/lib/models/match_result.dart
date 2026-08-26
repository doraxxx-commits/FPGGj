// ==========================================================
// WYDARZENIE ZAWODNIKA W MECZU
// ==========================================================

class PlayerMatchEvent {
  final String playerId;

  final int minute;

  final String type;

  final double? rating;

  PlayerMatchEvent({
    required this.playerId,
    required this.minute,
    required this.type,
    this.rating,
  });
}

// ==========================================================
// STATYSTYKI ZAWODNIKA W MECZU
// ==========================================================

class PlayerMatchPerformance {
  final String playerId;

  final int minutes;
  final bool started;

  final double rating;

  final int goals;
  final int assists;

  final int shots;
  final int shotsOnTarget;

  final int keyPasses;
  final int successfulDribbles;

  final int yellowCards;
  final int redCards;

  PlayerMatchPerformance({
    required this.playerId,
    required this.minutes,
    required this.started,
    required this.rating,
    this.goals = 0,
    this.assists = 0,
    this.shots = 0,
    this.shotsOnTarget = 0,
    this.keyPasses = 0,
    this.successfulDribbles = 0,
    this.yellowCards = 0,
    this.redCards = 0,
  });
}

// ==========================================================
// WYNIK MECZU
// ==========================================================

class MatchResult {
  final String homeClubId;
  final String awayClubId;

  final int homeGoals;
  final int awayGoals;

  // ==========================================================
  // WYDARZENIA MECZOWE
  // ==========================================================

  final List<PlayerMatchEvent> events;

  // ==========================================================
  // STATYSTYKI ZAWODNIKÓW
  // ==========================================================

  final List<PlayerMatchPerformance> playerPerformances;

  // Match-level statistics used by the world engine, career history and UI.
  final int homeShots;
  final int awayShots;
  final int homeShotsOnTarget;
  final int awayShotsOnTarget;
  final int homeCorners;
  final int awayCorners;
  final int homeFouls;
  final int awayFouls;
  final int homeYellowCards;
  final int awayYellowCards;
  final int homeRedCards;
  final int awayRedCards;
  final int possessionHome;


  // ==========================================================
  // KONSTRUKTOR
  // ==========================================================

  MatchResult({
    required this.homeClubId,
    required this.awayClubId,
    required this.homeGoals,
    required this.awayGoals,
    this.events = const [],
    this.playerPerformances = const [],
    this.homeShots = 0,
    this.awayShots = 0,
    this.homeShotsOnTarget = 0,
    this.awayShotsOnTarget = 0,
    this.homeCorners = 0,
    this.awayCorners = 0,
    this.homeFouls = 0,
    this.awayFouls = 0,
    this.homeYellowCards = 0,
    this.awayYellowCards = 0,
    this.homeRedCards = 0,
    this.awayRedCards = 0,
    this.possessionHome = 50,
  });

  // ==========================================================
  // CZY BYŁ REMIS
  // ==========================================================

  bool get isDraw {
    return homeGoals == awayGoals;
  }

  // ==========================================================
  // CZY WYGRAŁ GOSPODARZ
  // ==========================================================

  bool get homeWon {
    return homeGoals > awayGoals;
  }

  // ==========================================================
  // CZY WYGRAŁ GOŚĆ
  // ==========================================================

  bool get awayWon {
    return awayGoals > homeGoals;
  }

  // ==========================================================
  // ŁĄCZNA LICZBA GOLI
  // ==========================================================

  int get totalGoals {
    return homeGoals + awayGoals;
  }

  // ==========================================================
  // WYSZUKIWANIE WYSTĘPU ZAWODNIKA
  // ==========================================================

  PlayerMatchPerformance? performanceForPlayer(
    String playerId,
  ) {
    for (final performance
        in playerPerformances) {
      if (performance.playerId == playerId) {
        return performance;
      }
    }

    return null;
  }

  // ==========================================================
  // CZY ZAWODNIK ZDOBYŁ GOLA
  // ==========================================================

  bool playerScored(
    String playerId,
  ) {
    final performance =
        performanceForPlayer(playerId);

    if (performance == null) {
      return false;
    }

    return performance.goals > 0;
  }

  // ==========================================================
  // CZY ZAWODNIK ZALICZYŁ ASYSTĘ
  // ==========================================================

  bool playerAssisted(
    String playerId,
  ) {
    final performance =
        performanceForPlayer(playerId);

    if (performance == null) {
      return false;
    }

    return performance.assists > 0;
  }

  // ==========================================================
  // CZY ZAWODNIK WYSTĄPIŁ
  // ==========================================================

  bool playerAppeared(
    String playerId,
  ) {
    final performance =
        performanceForPlayer(playerId);

    if (performance == null) {
      return false;
    }

    return performance.minutes > 0;
  }
}
