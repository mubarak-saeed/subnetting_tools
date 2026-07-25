import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';

/// Displays sibling subnets for the IP's parent network.
///
/// Each subnet item shows CIDR, usable hosts, network, broadcast, and host range.
class SubnetResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const SubnetResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (ipAddress.subnets.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color       : theme.colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.alt_route_rounded,
                    size : AppSpacing.iconSm,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${tr.translate("subnets")} (${ipAddress.subnets.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color     : theme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child  : Divider(height: 1),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics   : const NeverScrollableScrollPhysics(),
              itemCount : ipAddress.subnets.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = ipAddress.subnets[index];
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color       : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border      : Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subnet header
                      Row(
                        children: [
                          Container(
                            width : 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${item.index}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color     : theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              item.cidrNotation,
                              style   : theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color       : theme.colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              '${item.usableHosts}h',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color     : theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Network / Broadcast row
                      Row(
                        children: [
                          _SubnetDetail(
                            label: tr.translate('networkAddress'),
                            value: item.networkAddress,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _SubnetDetail(
                            label: tr.translate('broadcastAddress'),
                            value: item.broadcastAddress,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Host range
                      Text(
                        '${item.firstUsableIp} — ${item.lastUsableIp}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubnetDetail extends StatelessWidget {
  final String label;
  final String value;

  const _SubnetDetail({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          Text(
            value,
            style   : theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
