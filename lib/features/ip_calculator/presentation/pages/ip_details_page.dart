import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';
import '../widgets/subnet_result_card.dart';

/// Dedicated Full-Screen Technical Report for an IP Network Calculation.
class IpDetailsPage extends StatelessWidget {
  final IpAddress ipAddress;

  const IpDetailsPage({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr     = AppLocalizations.of(context);
    final theme  = Theme.of(context);
    final ext    = theme.extension<AppThemeExtension>()!;
    final details = IpNetworkEngine.calculateDetails(
      ipAddress.address, ipAddress.subnetMask,
    );

    final totalCapacity = ipAddress.totalHosts;
    final usableRatio   = totalCapacity > 0 ? (ipAddress.usableHosts / totalCapacity).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${ipAddress.address}/${ipAddress.subnetMask}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded),
            tooltip: tr.translate('copy'),
            onPressed: () => _copyFullReport(context, tr, details),
          ),
        ],
      ),
      body: ResponsiveLayout(
        maxWidth: 1000.0,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Hero Overview Header Card ─────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ext.gradientIpCalc,
                  begin : Alignment.topLeft,
                  end   : Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: ext.gradientIpCalc.last.withValues(alpha: 0.35),
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
                      _HeaderBadge(
                        label: 'Class ${ipAddress.networkClass}',
                        icon: Icons.military_tech_rounded,
                      ),
                      _HeaderBadge(
                        label: ipAddress.isPrivate
                            ? tr.translate('privateScope')
                            : tr.translate('publicScope'),
                        icon: ipAddress.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${ipAddress.address}/${ipAddress.subnetMask}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Netmask: ${ipAddress.netmask}  |  Wildcard: ${ipAddress.wildcardMask}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Host Capacity Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tr.translate('networkCapacity'),
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${ipAddress.usableHosts} / $totalCapacity h',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        child: LinearProgressIndicator(
                          value: usableRatio,
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

            // ── 2. Bit Grid Visualization ────────────────────────────
            BitGridWidget(
              binaryIp: ipAddress.binaryAddress,
              cidr    : ipAddress.subnetMask,
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── 3. Primary Address Breakdown Card ────────────────────
            _DetailCard(
              title: tr.translate('networkAddress'),
              icon : Icons.hub_rounded,
              color: theme.colorScheme.primary,
              items: [
                _DetailRow(label: tr.translate('networkAddress'), value: ipAddress.networkAddress),
                _DetailRow(label: tr.translate('broadcastAddress'), value: ipAddress.broadcastAddress),
                _DetailRow(label: tr.translate('firstUsableIp'), value: ipAddress.firstUsableIp),
                _DetailRow(label: tr.translate('lastUsableIp'), value: ipAddress.lastUsableIp),
                _DetailRow(label: tr.translate('netmask'), value: ipAddress.netmask),
                _DetailRow(label: tr.translate('wildcardMask'), value: ipAddress.wildcardMask),
                _DetailRow(label: tr.translate('usableHosts'), value: '${ipAddress.usableHosts}'),
                _DetailRow(label: tr.translate('totalHosts'), value: '${ipAddress.totalHosts}'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── 4. Advanced Identifiers Card ─────────────────────────
            _DetailCard(
              title: tr.translate('advancedIdentifiers'),
              icon : Icons.code_rounded,
              color: theme.colorScheme.secondary,
              items: [
                _DetailRow(label: tr.translate('binaryIp'), value: ipAddress.binaryAddress, monospace: true),
                _DetailRow(label: tr.translate('integerId'), value: '${details.integerId}'),
                _DetailRow(label: tr.translate('hexId'), value: details.hexId, monospace: true),
                _DetailRow(label: tr.translate('reverseDnsArpa'), value: details.inAddrArpa),
                _DetailRow(label: tr.translate('ipv4MappedIpv6'), value: details.ipv4MappedIpv6, monospace: true),
                _DetailRow(label: tr.translate('sixToFourPrefix'), value: details.sixToFourPrefix, monospace: true),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            SubnetResultCard(ipAddress: ipAddress),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    ),
    );
  }

  void _copyFullReport(BuildContext context, AppLocalizations tr, IpNetworkDetails d) {
    final text = [
      '=== ${tr.translate("appTitle")} ===',
      'IP/CIDR: ${ipAddress.address}/${ipAddress.subnetMask}',
      '${tr.translate("ipClass")}: Class ${ipAddress.networkClass}',
      '${tr.translate("ipType")}: ${ipAddress.isPrivate ? "Private" : "Public"}',
      '${tr.translate("networkAddress")}: ${ipAddress.networkAddress}',
      '${tr.translate("broadcastAddress")}: ${ipAddress.broadcastAddress}',
      '${tr.translate("firstUsableIp")}: ${ipAddress.firstUsableIp}',
      '${tr.translate("lastUsableIp")}: ${ipAddress.lastUsableIp}',
      '${tr.translate("netmask")}: ${ipAddress.netmask}',
      '${tr.translate("wildcardMask")}: ${ipAddress.wildcardMask}',
      '${tr.translate("usableHosts")}: ${ipAddress.usableHosts}',
      '${tr.translate("totalHosts")}: ${ipAddress.totalHosts}',
      '${tr.translate("binaryIp")}: ${ipAddress.binaryAddress}',
      'Integer ID: ${d.integerId}',
      'Hex ID: ${d.hexId}',
      'in-addr.arpa: ${d.inAddrArpa}',
      'IPv4 Mapped IPv6: ${d.ipv4MappedIpv6}',
      '6to4 Prefix: ${d.sixToFourPrefix}',
    ].join('\n');

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr.translate('copiedToClipboard'))),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _HeaderBadge({required this.label, required this.icon});

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

class _DetailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<_DetailRow> items;

  const _DetailCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: AppSpacing.iconSm, color: color),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
            ...items,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;

  const _DetailRow({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr    = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('$label ${tr.translate("copiedToClipboard")}'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: monospace ? 'monospace' : null,
                  fontSize: monospace ? 11 : null,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.copy_rounded, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
