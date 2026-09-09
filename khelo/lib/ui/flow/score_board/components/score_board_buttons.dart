import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cricheros/ui/flow/score_board/score_board_view_model.dart';
import 'package:cricheros_style/animations/on_tap_scale.dart';
import 'package:cricheros_style/extensions/context_extensions.dart';
import 'package:cricheros_style/text/app_text_style.dart';

/// "Grouped cards" keypad: runs, sheet-opening extras, and the two
/// destructive/high-stakes actions (undo/out) are visually distinct groups
/// instead of one uniform grid - the shape of a control now hints at what
/// kind of action it is. Every ScoreButton from the original grid is still
/// here (including five-or-seven, previously easy to miss since it lived
/// alone in the side column) and every button keeps its long-press
/// (used for "runs, not a boundary" on four/six, and for the fielding-
/// position wagon-wheel prompt on the rest - see
/// ScoreBoardViewNotifier._showFieldingPositionSheet).
class ScoreBoardButtons extends StatelessWidget {
  final Function(ScoreButton, bool) onTap;

  const ScoreBoardButtons({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: context.colorScheme.containerLow,
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).viewPadding.bottom + 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _runsCard(context),
            const SizedBox(height: 10),
            _extrasRow(context),
            const SizedBox(height: 10),
            _actionRow(context),
          ],
        ),
      ),
    );
  }

  Widget _runsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(children: [
            _runKey(context, ScoreButton.zero),
            _gap,
            _runKey(context, ScoreButton.one),
            _gap,
            _runKey(context, ScoreButton.two),
          ]),
          _rowGap,
          Row(children: [
            _runKey(context, ScoreButton.three),
            _gap,
            _runKey(context, ScoreButton.four,
                tintColor: context.colorScheme.secondary),
            _gap,
            _runKey(context, ScoreButton.six,
                tintColor: context.colorScheme.primary),
          ]),
        ],
      ),
    );
  }

  Widget get _gap => const SizedBox(width: 8);
  Widget get _rowGap => const SizedBox(height: 8);

  Widget _runKey(
    BuildContext context,
    ScoreButton btn, {
    Color? tintColor,
  }) {
    return Expanded(
      child: _tappable(
        btn: btn,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.colorScheme.containerLowOnSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            btn.getTitle(context),
            style: AppTextStyle.header4
                .copyWith(color: tintColor ?? context.colorScheme.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _extrasRow(BuildContext context) {
    final extras = [
      ScoreButton.wideBall,
      ScoreButton.noBall,
      ScoreButton.bye,
      ScoreButton.legBye,
      ScoreButton.fiveOrSeven,
    ];
    return Row(
      children: [
        for (final btn in extras) ...[
          Expanded(child: _extraPill(context, btn)),
          if (btn != extras.last) const SizedBox(width: 6),
        ],
      ],
    );
  }

  Widget _extraPill(BuildContext context, ScoreButton btn) {
    return _tappable(
      btn: btn,
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: context.colorScheme.outline),
        ),
        child: Text(
          btn.getTitle(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.caption
              .copyWith(color: context.colorScheme.textSecondary),
        ),
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _tappable(
            btn: ScoreButton.undo,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colorScheme.positive.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                ScoreButton.undo.getTitle(context),
                style: AppTextStyle.button
                    .copyWith(color: context.colorScheme.positive),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _tappable(
            btn: ScoreButton.out,
            child: Container(
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colorScheme.alert,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                ScoreButton.out.getTitle(context),
                style: AppTextStyle.button
                    .copyWith(color: context.colorScheme.onPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tappable({required ScoreButton btn, required Widget child}) {
    return OnTapScale(
      onTap: () => onTap(btn, false),
      onLongTap: () {
        HapticFeedback.mediumImpact();
        onTap(btn, true);
      },
      child: child,
    );
  }
}
