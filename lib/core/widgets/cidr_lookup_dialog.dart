import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../network/ip_network_engine.dart';
import '../theme/app_spacing.dart';

/// Quick CIDR to Subnet Mask & Host Capacity reference table dialog.
class CidrLookupDialog extends StatelessWidget {
  const CidrLookupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr    = AppLocalizations.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      title: Row(
        children: [
          Icon(Icons.table_chart_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              tr.translate('cidrReferenceTable'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 33, // /0 to /32
          itemBuilder: (context, cidr) {
            final maskInt = IpNetworkEngine.cidrToMaskInt(cidr);
            final maskStr = IpNetworkEngine.intToIp(maskInt);
            final wildcardStr = IpNetworkEngine.intToIp((~maskInt) & 0xFFFFFFFF);
            final details = IpNetworkEngine.calculateDetails('192.168.1.1', cidr);

            final isCommon = (cidr == 24 || cidr == 16 || cidr == 8 || cidr == 30);

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: isCommon
                    ? theme.colorScheme.primary.withValues(alpha: 0.12)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: isCommon ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isCommon ? theme.colorScheme.primary : theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '/$cidr',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tr.translate("netmask")}: $maskStr',
                          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${tr.translate("wildcardMask")}: $wildcardStr',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${details.usableHosts} ${tr.translate("hosts")}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () => Navigator.pop(context),
          child: Text(tr.translate('close')),
        ),
      ],
    );
  }
}
