import 'package:collection/collection.dart';
import 'package:cricheros_data/api/match/match_model.dart';
import 'package:cricheros_data/api/user/user_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cricheros/components/error_screen.dart';
import 'package:cricheros/components/image_avatar.dart';
import 'package:cricheros/domain/extensions/context_extensions.dart';
import 'package:cricheros/domain/extensions/enum_extensions.dart';
import 'package:cricheros/domain/formatter/date_formatter.dart';
import 'package:cricheros/ui/flow/matches/match_detail/match_detail_tab_view_model.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/indicator/progress_indicator.dart';
import 'package:cricheros_style/text/app_text_style.dart';

class MatchDetailInfoView extends ConsumerWidget {
  const MatchDetailInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchDetailTabStateProvider);
    final notifier = ref.watch(matchDetailTabStateProvider.notifier);
    return _body(context, notifier, state);
  }

  Widget _body(BuildContext context, MatchDetailTabViewNotifier notifier,
      MatchDetailTabState state) {
    if (state.loading) {
      return const Center(child: AppProgressIndicator());
    }

    if (state.error != null) {
      return ErrorScreen(
        error: state.error,
        onRetryTap: notifier.onResume,
      );
    }

    final match = state.match!;
    final officialRows = [
      (
        context.l10n.add_match_officials_umpires_title,
        match.umpires?.map((e) => e.name).join(", ")
      ),
      (
        context.l10n.add_match_officials_referee_title,
        match.referee?.name,
      ),
      (
        context.l10n.add_match_officials_commentators_title,
        match.commentators?.map((e) => e.name).join(", ")
      ),
      (
        context.l10n.add_match_officials_scorers_title,
        match.scorers?.map((e) => e.name).join(", ")
      ),
    ].where((row) => row.$2 != null && row.$2!.isNotEmpty).toList();

    return ListView(
      padding: context.mediaQueryPadding +
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        _manOfTheMatchCard(context, match),
        _card(context, title: context.l10n.match_detail_match_info_tab_title, rows: [
          (
            CupertinoIcons.sportscourt,
            context.l10n.match_info_match_title,
            match.teams
                .map((e) => e.team.name)
                .join(" ${context.l10n.common_versus_short_title} "),
          ),
          (
            CupertinoIcons.calendar,
            context.l10n.match_info_date_and_time_title,
            (match.start_at ?? match.start_time)
                ?.format(context, DateFormatType.shortDateTime),
          ),
          _tossRow(context, match),
          (
            CupertinoIcons.location,
            context.l10n.match_info_venue_title,
            match.ground,
          ),
        ]),
        if (officialRows.isNotEmpty) ...[
          const SizedBox(height: 16),
          _card(
            context,
            title: context.l10n.add_match_officials_screen_title,
            rows: officialRows
                .map((row) => (CupertinoIcons.person, row.$1, row.$2))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _manOfTheMatchCard(BuildContext context, MatchModel match) {
    if (match.match_status != MatchStatus.finish ||
        match.man_of_the_match_id == null) {
      return const SizedBox();
    }
    UserModel? player;
    for (final team in match.teams) {
      final found = team.squad
          .firstWhereOrNull((e) => e.id == match.man_of_the_match_id);
      if (found != null) {
        player = found.player;
        break;
      }
    }
    if (player == null || player.name == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MediaQuery.withNoTextScaling(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ImageAvatar(
                initial: player.nameInitial,
                imageUrl: player.profile_img_url,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.match_detail_man_of_the_match_title,
                      style: AppTextStyle.caption
                          .copyWith(color: context.colorScheme.secondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      player.name!,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subtitle1
                          .copyWith(color: context.colorScheme.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required List<(IconData, String, String?)> rows,
  }) {
    final visibleRows =
        rows.where((row) => row.$3 != null && row.$3!.isNotEmpty).toList();
    if (visibleRows.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.subtitle2
              .copyWith(color: context.colorScheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < visibleRows.length; i++) ...[
                _dataRow(context,
                    icon: visibleRows[i].$1,
                    label: visibleRows[i].$2,
                    value: visibleRows[i].$3!),
                if (i != visibleRows.length - 1)
                  Divider(height: 1, color: context.colorScheme.outline),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _dataRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.colorScheme.textDisabled),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.body2
                  .copyWith(color: context.colorScheme.textSecondary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyle.subtitle3
                  .copyWith(color: context.colorScheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String, String?) _tossRow(BuildContext context, MatchModel match) {
    String? teamName = match.teams
        .firstWhereOrNull((element) => element.team.id == match.toss_winner_id)
        ?.team
        .name;
    String? decision = match.toss_decision?.getString(context);
    final detail = (teamName != null &&
            teamName.isNotEmpty &&
            decision != null &&
            decision.isNotEmpty)
        ? context.l10n.match_info_toss_detail_text(teamName, decision)
        : null;
    return (CupertinoIcons.circle_grid_hex, context.l10n.match_info_toss_title, detail);
  }
}
