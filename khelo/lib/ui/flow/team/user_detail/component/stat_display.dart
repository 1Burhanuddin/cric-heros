import 'package:flutter/material.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';

/// One headline number, e.g. career runs or economy rate. [pairValue] shows
/// a second, smaller number after a slash (100s/50s) for stats that read
/// better paired than standalone.
class StatHeroTile extends StatelessWidget {
  final String value;
  final String? pairValue;
  final String label;
  final bool accent;

  const StatHeroTile({
    super.key,
    required this.value,
    required this.label,
    this.pairValue,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = accent ? context.colorScheme.onPrimary : context.colorScheme.textPrimary;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: accent ? context.colorScheme.primary : context.colorScheme.containerLowOnSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: AppTextStyle.header1.copyWith(fontSize: 28, color: fg),
              children: [
                TextSpan(text: value),
                if (pairValue != null)
                  TextSpan(
                    text: ' / $pairValue',
                    style: AppTextStyle.subtitle2.copyWith(
                      color: fg.withValues(alpha: 0.75),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyle.caption.copyWith(
              color: accent ? context.colorScheme.onPrimary.withValues(alpha: 0.8) : context.colorScheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A 2-column grid of [StatHeroTile]s - the headline numbers for whichever
/// role tab (batting/bowling/fielding) is active.
class StatHeroGrid extends StatelessWidget {
  final List<StatHeroTile> tiles;

  const StatHeroGrid({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: tiles,
    );
  }
}

/// The full stat breakdown as a single rounded card of label/value rows,
/// replacing the old bare divided list.
class StatList extends StatelessWidget {
  final List<(String label, String value)> rows;

  const StatList({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.containerLowOnSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: i == rows.length - 1
                  ? null
                  : BoxDecoration(
                      border: Border(bottom: BorderSide(color: context.colorScheme.outline.withValues(alpha: 0.5))),
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rows[i].$1,
                    style: AppTextStyle.body2.copyWith(color: context.colorScheme.textSecondary),
                  ),
                  Text(
                    rows[i].$2,
                    style: AppTextStyle.subtitle2.copyWith(color: context.colorScheme.textPrimary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
