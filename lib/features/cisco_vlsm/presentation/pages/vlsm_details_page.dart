import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/cisco_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

/// Full-Screen Detailed VLSM Subnet Plan Report Screen.
class VlsmDetailsPage extends StatelessWidget {
  final String baseIp;
  final int baseCidr;
  final List<VlsmAllocation> allocations;

  const VlsmDetailsPage({
    super.key,
    required this.baseIp,
    required this.baseCidr,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext   = theme.extension<AppThemeExtension>()!;

    final totalRequested = allocations.fold<int>(0, (sum, item) => sum + item.requestedHosts);
    final totalAllocated = allocations.fold<int>(0, (sum, item) => sum + item.allocatedHosts);
    final totalWasted    = allocations.fold<int>(0, (sum, item) => sum + item.wastedHosts);
    final efficiencyRatio = totalAllocated > 0 ? (totalRequested / totalAllocated).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('vlsmReportTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded),
            tooltip: tr.translate('copy'),
            onPressed: () => _copyVlsmPlan(context, tr),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Plan Overview Banner ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ext.gradientVlsm,
                  begin : Alignment.topLeft,
                  end   : Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: ext.gradientVlsm.last.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _BadgeChip(label: '$baseIp/$baseCidr', icon: Icons.lan),
                      _BadgeChip(label: '${allocations.length} ${tr.translate("subnets")}', icon: Icons.alt_route),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    tr.translate('vlsmReportTitle'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${tr.translate("requestedHosts")}: $totalRequested  |  ${tr.translate("allocatedHosts")}: $totalAllocated  |  ${tr.translate("wastedHosts")}: $totalWasted',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Allocation Efficiency Gauge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Subnet Efficiency',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(efficiencyRatio * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        child: LinearProgressIndicator(
                          value: efficiencyRatio,
                          minHeight: 8,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── 2. Department Breakdown Cards ────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                tr.translate('departmentBreakdown'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allocations.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final item = allocations[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subnet Header
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                item.name,
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              ),
                              child: Text(
                                '${item.networkAddress}/${item.cidr}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: Divider(height: 1),
                        ),
                        // Requirements & Allocations Badge Row
                        Row(
                          children: [
                            _StatItem(label: tr.translate('requestedHosts'), value: '${item.requestedHosts}', color: theme.colorScheme.primary),
                            const SizedBox(width: AppSpacing.xs),
                            _StatItem(label: tr.translate('allocatedHosts'), value: '${item.allocatedHosts}', color: const Color(0xFF10B981)),
                            const SizedBox(width: AppSpacing.xs),
                            _StatItem(label: tr.translate('wastedHosts'), value: '${item.wastedHosts}', color: const Color(0xFFF59E0B)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Network Details
                        _VlsmDetailRow(label: tr.translate('networkAddress'), value: item.networkAddress),
                        _VlsmDetailRow(label: tr.translate('broadcastAddress'), value: item.broadcastAddress),
                        _VlsmDetailRow(label: tr.translate('netmask'), value: item.netmask),
                        _VlsmDetailRow(label: tr.translate('wildcardMask'), value: item.wildcardMask),
                        _VlsmDetailRow(label: tr.translate('firstUsableIp'), value: item.firstUsableIp),
                        _VlsmDetailRow(label: tr.translate('lastUsableIp'), value: item.lastUsableIp),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _copyVlsmPlan(BuildContext context, AppLocalizations tr) {
    final text = [
      '=== ${tr.translate("vlsmReportTitle")} ===',
      'Base Subnet: $baseIp/$baseCidr',
      'Total Subnets: ${allocations.length}',
      '',
      ...allocations.map((a) =>
          '[${a.name}] -> CIDR: ${a.networkAddress}/${a.cidr} | Mask: ${a.netmask} | Net: ${a.networkAddress} | Broad: ${a.broadcastAddress} | Usable: ${a.firstUsableIp} - ${a.lastUsableIp} (Req: ${a.requestedHosts}, Alloc: ${a.allocatedHosts}, Unused: ${a.wastedHosts})')
    ].join('\n');

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr.translate('copiedToClipboard'))),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _BadgeChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _VlsmDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _VlsmDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
