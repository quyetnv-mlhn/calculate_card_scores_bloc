import 'dart:async';

import 'package:calculate_card_score/data/models/player_model.dart';
import 'package:calculate_card_score/data/models/score_board_model.dart';
import 'package:calculate_card_score/data/models/round_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_detail_event.dart';
part 'game_detail_state.dart';

class GameDetailBloc extends Bloc<GameDetailEvent, GameDetailState> {
  GameDetailBloc({required this.scoreBoard})
      : super(GameDetailState(scoreBoard: scoreBoard)) {
    on<GameDetailAddRound>(_onGameDetailAddRound);
    on<GameDetailChangeWinner>(_onGameDetailChangeWinner);
  }

  final ScoreBoard scoreBoard;

  Future<void> _onGameDetailAddRound(
    GameDetailAddRound event,
    Emitter<GameDetailState> emit,
  ) async {
    final newRound = event.round;
    final rounds = List.of(state.rounds);
    rounds.add(newRound);

    ScoreBoard scoreBoard = state.scoreBoard;
    final currentScore = scoreBoard.currentScore;
    final players = scoreBoard.players;

    if (currentScore == null) return;

    for (int i = 0; i < currentScore.length; ++i) {
      if (newRound.players[i].isWinner == true) {
        for (int j = 0; j < currentScore[i].length; ++j) {
          currentScore[i][j] += newRound.players[j].score ?? 0;
        }
      }
      int currentScoreOfPlayer = scoreBoard.players[i].score ?? 0;
      currentScoreOfPlayer += newRound.players[i].score ?? 0;
      players[i] = players[i].copyWith(score: currentScoreOfPlayer);
    }

    final newScoreBoard =
        scoreBoard.copyWith(currentScore: currentScore, players: players);
    emit(GameDetailState(scoreBoard: newScoreBoard, rounds: rounds));
  }

  Future<void> _onGameDetailChangeWinner(
    GameDetailChangeWinner event,
    Emitter<GameDetailState> emit,
  ) async {
    final players = state.scoreBoard.players;
    final newPlayers = players
        .map((player) =>
            player.copyWith(isWinner: player.name == event.player.name))
        .toList();
    emit(GameDetailState(
      scoreBoard: state.scoreBoard.copyWith(players: newPlayers),
      rounds: state.rounds,
    ));
  }
}