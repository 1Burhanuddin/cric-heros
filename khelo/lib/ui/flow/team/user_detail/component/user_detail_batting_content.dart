import 'package:cricheros_data/api/user/user_models.dart';
import 'package:flutter/material.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';

import 'stat_display.dart';

class UserDetailBattingContent extends StatelessWidget {
  final int matchesCount;
  final Batting? battingStats;

  const UserDetailBattingContent({
    super.key,
    this.matchesCount = 0,
    this.battingStats,
  });

  @override
  Widget build(BuildContext context) {
    final stats = battingStats ?? const Batting();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        StatHeroGrid(tiles: [
          StatHeroTile(
            accent: true,
            value: stats.run_scored.toString(),
            label: context.l10n.user_detail_runs_title,
          ),
          StatHeroTile(
            value: stats.average.toStringAsFixed(1),
            label: context.l10n.user_detail_average_title,
          ),
          StatHeroTile(
            value: stats.strike_rate.toStringAsFixed(1),
            label: context.l10n.user_detail_strike_rate_title,
          ),
          StatHeroTile(
            value: stats.hundreds.toString(),
            pairValue: stats.fifties.toString(),
            label: '${context.l10n.user_detail_hundreds_title} / ${context.l10n.user_detail_fifties_title}',
          ),
        ]),
        const SizedBox(height: 20),
        Text(
          context.l10n.common_batting,
          style: AppTextStyle.header4.copyWith(color: context.colorScheme.textPrimary),
        ),
        const SizedBox(height: 10),
        StatList(rows: [
          (context.l10n.user_detail_matches_title, matchesCount.toString()),
          (context.l10n.user_detail_innings_title, stats.innings.toString()),
          (context.l10n.user_detail_runs_title, stats.run_scored.toString()),
          (context.l10n.user_detail_balls_title, stats.ball_faced.toString()),
          (context.l10n.user_detail_average_title, stats.average.toStringAsFixed(1)),
          (context.l10n.user_detail_strike_rate_title, stats.strike_rate.toStringAsFixed(1)),
          (context.l10n.user_detail_fours_title, stats.fours.toString()),
          (context.l10n.user_detail_sixes_title, stats.sixes.toString()),
          (context.l10n.user_detail_fifties_title, stats.fifties.toString()),
          (context.l10n.user_detail_hundreds_title, stats.hundreds.toString()),
          (context.l10n.user_detail_ducks_title, stats.ducks.toString()),
        ]),
      ],
    );
  }
}
