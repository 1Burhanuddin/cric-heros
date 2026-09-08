import 'package:cricheros_data/api/user/user_models.dart';
import 'package:flutter/material.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';

import 'stat_display.dart';

class UserDetailFieldingContent extends StatefulWidget {
  final int testMatchesCount;
  final int otherMatchesCount;
  final Fielding? testStats;
  final Fielding? otherStats;

  const UserDetailFieldingContent({
    super.key,
    this.testMatchesCount = 0,
    this.otherMatchesCount = 0,
    this.testStats,
    this.otherStats,
  });

  @override
  State<UserDetailFieldingContent> createState() => _UserDetailFieldingContentState();
}

class _UserDetailFieldingContentState extends State<UserDetailFieldingContent> {
  StatFormat _format = StatFormat.other;

  @override
  Widget build(BuildContext context) {
    final isTest = _format == StatFormat.test;
    final stats = (isTest ? widget.testStats : widget.otherStats) ?? const Fielding();
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
            value: stats.catches.toString(),
            label: context.l10n.user_detail_catches_title,
          ),
          StatHeroTile(
            value: stats.runOut.toString(),
            label: context.l10n.user_detail_run_out_title,
          ),
          StatHeroTile(
            value: stats.stumping.toString(),
            label: context.l10n.user_detail_stumping_title,
          ),
          StatHeroTile(
            value: matches.toString(),
            label: context.l10n.user_detail_matches_title,
          ),
        ]),
        const SizedBox(height: 20),
        Text(
          context.l10n.common_fielding,
          style: AppTextStyle.header4.copyWith(color: context.colorScheme.textPrimary),
        ),
        const SizedBox(height: 10),
        StatList(rows: [
          (context.l10n.user_detail_matches_title, matches.toString()),
          (context.l10n.user_detail_catches_title, stats.catches.toString()),
          (context.l10n.user_detail_run_out_title, stats.runOut.toString()),
          (context.l10n.user_detail_stumping_title, stats.stumping.toString()),
        ]),
      ],
    );
  }
}
