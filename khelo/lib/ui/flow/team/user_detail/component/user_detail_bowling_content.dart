import 'package:cricheros_data/api/user/user_models.dart';
import 'package:flutter/material.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';

import 'stat_display.dart';

class UserDetailBowlingContent extends StatefulWidget {
  final int testMatchesCount;
  final int otherMatchesCount;
  final Bowling? testStats;
  final Bowling? otherStats;

  const UserDetailBowlingContent({
    super.key,
    this.testMatchesCount = 0,
    this.otherMatchesCount = 0,
    this.testStats,
    this.otherStats,
  });

  @override
  State<UserDetailBowlingContent> createState() => _UserDetailBowlingContentState();
}

class _UserDetailBowlingContentState extends State<UserDetailBowlingContent> {
  StatFormat _format = StatFormat.other;

  @override
  Widget build(BuildContext context) {
    final isTest = _format == StatFormat.test;
    final stats = (isTest ? widget.testStats : widget.otherStats) ?? const Bowling();
    final matches = isTest ? widget.testMatchesCount : widget.otherMatchesCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FormatToggle(selected: _format, onChanged: (f) => setState(() => _format = f)),
        ),
        const SizedBox(height: 16),
        StatHeroGrid(tiles: [
          StatHeroTile(
            accent: true,
            value: stats.wicket_taken.toString(),
            label: context.l10n.user_detail_wickets_title,
          ),
          StatHeroTile(
            value: stats.economy_rate.toStringAsFixed(2),
            label: context.l10n.user_detail_eco_title,
          ),
          StatHeroTile(
            value: stats.average.toStringAsFixed(1),
            label: context.l10n.user_detail_average_title,
          ),
          StatHeroTile(
            value: stats.maiden.toString(),
            label: context.l10n.user_detail_maidens_title,
          ),
        ]),
        const SizedBox(height: 20),
        Text(
          context.l10n.common_bowling,
          style: AppTextStyle.header4.copyWith(color: context.colorScheme.textPrimary),
        ),
        const SizedBox(height: 10),
        StatList(rows: [
          (context.l10n.user_detail_matches_title, matches.toString()),
          (context.l10n.user_detail_innings_title, stats.innings.toString()),
          (context.l10n.user_detail_balls_title, stats.balls.toString()),
          (context.l10n.user_detail_runs_title, stats.runs_conceded.toString()),
          (context.l10n.user_detail_maidens_title, stats.maiden.toString()),
          (context.l10n.user_detail_wickets_title, stats.wicket_taken.toString()),
          (context.l10n.user_detail_eco_title, stats.economy_rate.toStringAsFixed(2)),
          (context.l10n.user_detail_average_title, stats.average.toStringAsFixed(1)),
          (context.l10n.user_detail_strike_rate_title, stats.strike_rate.toStringAsFixed(1)),
          (context.l10n.user_detail_no_ball_title, stats.no_balls.toString()),
          (context.l10n.user_detail_wide_ball_title, stats.wide_balls.toString()),
        ]),
      ],
    );
  }
}
