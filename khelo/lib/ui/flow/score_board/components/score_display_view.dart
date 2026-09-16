import 'package:collection/collection.dart';
import 'package:cricheros_data/api/ball_score/ball_score_model.dart';
import 'package:cricheros_data/api/match/match_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros/ui/flow/score_board/score_board_view_model.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';
import 'package:cricheros_style/theme/colors.dart';

class ScoreDisplayView extends ConsumerWidget {
  final List<BallScoreModel> currentOverBall;
  final String? battingTeamName;
  final String? bowlingTeamName;
  final String overCountString;

  const ScoreDisplayView({
    super.key,
    required this.currentOverBall,
    required this.battingTeamName,
    required this.bowlingTeamName,
    required this.overCountString,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreBoardStateProvider);

    // The Expanded(flex:...) sizing this panel against the keypad lives at
    // the call site (score_board_screen.dart), so both shares can be tuned
    // together. SingleChildScrollView is a fallback so nothing overflows if
    // the share ends up too small for the content (e.g. landscape).
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _scoreHero(context, state),
          const SizedBox(height: 10),
          _statsTable(
            context,
            headers: const ['R', 'B', '4s', '6s', 'SR'],
            rows: [
              _batsmanRowValues(state, state.batsMans?.firstOrNull),
              _batsmanRowValues(state, state.batsMans?.elementAtOrNull(1)),
            ],
          ),
          const SizedBox(height: 8),
          _statsTable(
            context,
            headers: const ['O', 'M', 'R', 'W', 'Econ'],
            rows: [_bowlerRowValues(state)],
          ),
          const SizedBox(height: 8),
          _ballHistoryListView(context),
        ],
      ),
    );
  }

  String _teamLabel(
    BuildContext context, {
    required bool isBatting,
    String? inningString,
  }) {
    return isBatting
        ? (battingTeamName ?? "") +
            (inningString != null ? " - $inningString" : "")
        : bowlingTeamName ?? "";
  }

  Widget _scoreHero(
    BuildContext context,
    ScoreBoardViewState state,
  ) {
    final inningString = state.match?.match_type == MatchType.testMatch
        ? (state.currentInning?.index == 1 || state.currentInning?.index == 2)
            ? context.l10n.common_first_inning_title
            : context.l10n.common_second_inning_title
        : null;

    final powerPlayText = _getPowerPlayText(context, state);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      decoration: BoxDecoration(
        color: scoreCardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _teamLabel(context, isBatting: true, inningString: inningString)
                .toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.65),
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${state.currentInning?.total_runs ?? 0}/${state.otherInning?.total_wickets ?? 0}',
                  style: AppTextStyle.header1
                      .copyWith(fontSize: 40, color: Colors.white),
                ),
                TextSpan(
                  text:
                      ' ($overCountString/${state.match?.revised_target?.overs ?? state.match?.number_of_over})',
                  style: AppTextStyle.body1
                      .copyWith(color: Colors.white.withValues(alpha: 0.65)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (powerPlayText != null) ...[
                _heroTag(context, powerPlayText),
                const SizedBox(width: 8),
              ],
              Expanded(child: _runNeededText(context, state)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: AppTextStyle.caption
            .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  String? _getPowerPlayText(BuildContext context, ScoreBoardViewState state) {
    if (state.match?.power_play_overs1.contains(state.overCount) ?? false) {
      return context.l10n.power_play_text(1);
    } else if (state.match?.power_play_overs2.contains(state.overCount) ??
        false) {
      return context.l10n.power_play_text(2);
    } else if (state.match?.power_play_overs3.contains(state.overCount) ??
        false) {
      return context.l10n.power_play_text(3);
    }
    return null;
  }

  Widget _runNeededText(
    BuildContext context,
    ScoreBoardViewState state,
  ) {
    if (state.nextInning != null) return const SizedBox();

    final requiredRun = getRequiredRun(state);
    final pendingOver = (state.match?.revised_target?.overs.toInt() ??
            state.match?.number_of_over ??
            0) -
        state.overCount;
    final pendingBall = (pendingOver * 6) + (6 - state.ballCount);
    final text = state.match?.match_type == MatchType.testMatch
        ? context.l10n
            .score_board_need_run_text(requiredRun < 0 ? 0 : requiredRun)
        : context.l10n.score_board_run_need_in_ball_text(
            requiredRun < 0 ? 0 : requiredRun,
            pendingBall < 0 ? 0 : pendingBall);

    return Text(
      text,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.caption
          .copyWith(color: Colors.white.withValues(alpha: 0.75)),
    );
  }

  int getRequiredRun(ScoreBoardViewState state) {
    final currentPlayingTeam = state.match?.teams.firstWhereOrNull(
        (element) => element.team.id == state.currentInning?.team_id);
    final otherTeam = state.match?.teams.firstWhereOrNull(
        (element) => element.team.id != currentPlayingTeam?.team.id);

    final revisedRun = state.match?.revised_target?.runs;

    return ((revisedRun ?? ((otherTeam?.run ?? 0) + 1))) -
        (currentPlayingTeam?.run ?? 0);
  }

  // (label, value, highlight) for one batsman - name column plus R/B/4s/6s/SR.
  ({String name, bool onStrike, List<String> values}) _batsmanRowValues(
    ScoreBoardViewState state,
    MatchPlayer? player,
  ) {
    if (player == null) {
      return (
        name: '',
        onStrike: false,
        values: const ['-', '-', '-', '-', '-'],
      );
    }
    final stats = state.currentScoresList.calculateBattingStats(player.id);
    return (
      name: player.player.name ?? '',
      onStrike: state.strikerId == player.player.id,
      values: [
        stats.run_scored.toString(),
        stats.ball_faced.toString(),
        stats.fours.toString(),
        stats.sixes.toString(),
        stats.strike_rate.toStringAsFixed(1),
      ],
    );
  }

  ({String name, bool onStrike, List<String> values}) _bowlerRowValues(
    ScoreBoardViewState state,
  ) {
    final bowler = state.bowler;
    if (bowler == null) {
      return (
        name: '',
        onStrike: false,
        values: const ['-', '-', '-', '-', '-'],
      );
    }
    final stats = state.currentScoresList.calculateBowlingStats(bowler.id);
    final overs = stats.balls ~/ 6;
    final ballsIntoOver = stats.balls % 6;
    return (
      name: bowler.player.name ?? '',
      onStrike: false,
      values: [
        '$overs.$ballsIntoOver',
        stats.maiden.toString(),
        stats.runs_conceded.toString(),
        stats.wicket_taken.toString(),
        stats.economy_rate.toStringAsFixed(2),
      ],
    );
  }

  // Shared card+table shell for the batting/bowling breakdowns below the
  // hero - a header row of column labels, then one row per player.
  Widget _statsTable(
    BuildContext context, {
    required List<String> headers,
    required List<({String name, bool onStrike, List<String> values})> rows,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              for (final header in headers)
                Expanded(
                  child: Text(
                    header,
                    textAlign: TextAlign.right,
                    style: AppTextStyle.caption
                        .copyWith(color: context.colorScheme.textDisabled),
                  ),
                ),
            ],
          ),
          for (final row in rows) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    row.name.isEmpty
                        ? context.l10n.score_board_player_title
                        : row.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.subtitle3.copyWith(
                        color: row.onStrike
                            ? context.colorScheme.secondary
                            : context.colorScheme.textPrimary,
                        fontWeight:
                            row.onStrike ? FontWeight.w700 : FontWeight.w600),
                  ),
                ),
                for (final value in row.values)
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTextStyle.body2
                          .copyWith(color: context.colorScheme.textSecondary),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _ballHistoryListView(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final ball in currentOverBall) ...[
            _ballView(context, ball),
            const SizedBox(width: 8)
          ]
        ],
      ),
    );
  }

  Widget _ballView(BuildContext context, BallScoreModel ball) {
    bool showCircle = ball.wicket_type != WicketType.retired &&
        ball.wicket_type != WicketType.retiredHurt &&
        ball.wicket_type != WicketType.timedOut;
    final (bgColor, tintColor) = _getBackGroundColorBasedOnBall(context, ball);
    if (!showCircle) {
      return Text(_getTextBasedOnBall(context, ball),
          style: AppTextStyle.body2
              .copyWith(color: context.colorScheme.textPrimary));
    }
    return Container(
      height: 32,
      width: 32,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Text(
        _getTextBasedOnBall(context, ball),
        style: AppTextStyle.caption.copyWith(color: tintColor),
      ),
    );
  }

  String _getTextBasedOnBall(BuildContext context, BallScoreModel ball) {
    if (ball.wicket_type != null) {
      if (ball.wicket_type == WicketType.retired) {
        return context.l10n.wicket_type_short_retired_title;
      } else if (ball.wicket_type == WicketType.retiredHurt) {
        return context.l10n.wicket_type_short_retired_hurt_title;
      } else if (ball.wicket_type == WicketType.timedOut) {
        return context.l10n.wicket_type_short_timed_out_title;
      } else {
        return context.l10n.score_board_wicket_short_text;
      }
    } else if (ball.extras_type != null) {
      switch (ball.extras_type!) {
        case ExtrasType.wide:
          return context.l10n.score_board_wide_ball_short_text;
        case ExtrasType.noBall:
          return context.l10n.score_board_no_ball_short_text;
        case ExtrasType.bye:
          return context.l10n.score_board_run_sup_script_text(
              "${ball.extras_awarded ?? 0}",
              context.l10n.score_board_bye_short_text);
        case ExtrasType.legBye:
          return context.l10n.score_board_run_sup_script_text(
              "${ball.extras_awarded ?? 0}",
              context.l10n.score_board_leg_bye_short_text);
        case ExtrasType.penaltyRun:
          return "P";
      }
    } else if (ball.wicket_type == null && ball.extras_type == null) {
      return "${ball.runs_scored}";
    } else {
      return "";
    }
  }

  (Color, Color) _getBackGroundColorBasedOnBall(
      BuildContext context, BallScoreModel ball) {
    if (ball.wicket_type != null) {
      if (ball.wicket_type == WicketType.retired ||
          ball.wicket_type == WicketType.retiredHurt ||
          ball.wicket_type == WicketType.timedOut) {
        return (Colors.transparent, context.colorScheme.textPrimary);
      } else {
        return (context.colorScheme.alert, context.colorScheme.onPrimary);
      }
    } else if (ball.is_six || ball.is_four) {
      return (
        ball.is_four
            ? context.colorScheme.secondary
            : context.colorScheme.primary,
        context.colorScheme.onPrimary
      );
    } else if (ball.extras_type != null) {
      return (
        context.colorScheme.containerHigh,
        context.colorScheme.textPrimary
      );
    } else {
      return (
        context.colorScheme.containerLow,
        context.colorScheme.textPrimary
      );
    }
  }
}
