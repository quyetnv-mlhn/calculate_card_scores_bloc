import 'package:equatable/equatable.dart';

import 'package:calculate_card_score/data/models/player_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'score_board_model.g.dart';

// ignore: must_be_immutable
@JsonSerializable()
@HiveType(typeId: 0)
// ignore: must_be_immutable
class ScoreBoard extends Equatable {
  @HiveField(0)
  int? id;

  @HiveField(1)
  List<Player> players;

  @HiveField(2)
  List<List<int>>? currentScore;

  ScoreBoard({
    this.id,
    required this.players,
    this.currentScore,
  });

  ScoreBoard copyWith({
    int? id,
    List<Player>? players,
    List<List<int>>? currentScore,
  }) {
    return ScoreBoard(
      id: id ?? this.id,
      players: players ?? this.players,
      currentScore: currentScore ?? this.currentScore,
    );
  }

  factory ScoreBoard.fromJson(Map<String, dynamic> json) =>
      _$ScoreBoardFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreBoardToJson(this);

  @override
  List<Object> get props => [id!, players, currentScore!];
}