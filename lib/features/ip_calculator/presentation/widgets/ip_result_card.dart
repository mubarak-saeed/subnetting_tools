import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';

/// Displays the calculated IPv4 network result in a sectioned card layout.
///
/// Sections:
/// 1. Quick Stats (usable hosts, IP class, public/private)
/// 2. Bit Map Visualization (32-bit binary grid)
/// 3. Primary Network Info (netmask, wildcard, network, broadcast, hosts)
/// 4. Advanced Identifiers (Integer ID, Hex ID, Binary IP)
/// 5. Routing & Reverse DNS (in-addr.arpa, IPv4-mapped IPv6, 6to4)
class IpResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const IpResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr     = AppLocalizations.of(context);
    final theme  = Theme.of(context);
    final ext    = theme.extension<AppThemeExtension>()!;
    final details = IpNetworkEngine.calculateDetails(
      ipAddress.address, ipAddress.subnetMask,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Quick Stats Badges ──────────────────────────────────
        _QuickStatRow(ipAddress: ipAddress, ext: ext, tr: tr),
        const SizedBox(height: AppSpacing.md),

        // ── 2. Bit Map ────────────────────────────────────────────
        BitGridWidget(
          binaryIp: ipAddress.binaryAddress,
          cidr    : ipAddress.subnetMask,
        ),
        const SizedBox(height: AppSpacing.md),

        // ── 3. Primary Network Info ───────────────────────────────
        _ResultSection(
          title: tr.translate('networkAddress'),
          icon : Icons.hub_rounded,
          color: theme.colorScheme.primary,
          header: Row(
            children: [
              Expanded(
                child: Text(
                  '${ipAddress.address}/${ipAddress.subnetMask}',
                  style   : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _CopyAllButton(
                onTap: () => _copyAll(context, tr, details),
                tr   : tr,
              ),
            ],
          ),
          children: [
            _InfoRow(label: tr.translate('netmask'), value: ipAddress.netmask, icon: Icons.grid_4x4),
            _InfoRow(label: tr.translate('wildcardMask'), value: ipAddress.wildcardMask, icon: Icons.blur_on),
            _InfoRow(label: tr.translate('networkAddress'), value: ipAddress.networkAddress, icon: Icons.dns_rounded),
            _InfoRow(label: tr.translate('broadcastAddress'), value: ipAddress.broadcastAddress, icon: Icons.podcasts_rounded),
            _InfoRow(label: tr.translate('firstUsableIp'), value: ipAddress.firstUsableIp, icon: Icons.play_arrow_rounded),
            _InfoRow(label: tr.translate('lastUsableIp'), value: ipAddress.lastUsableIp, icon: Icons.stop_rounded),
            _InfoRow(label: tr.translate('usableHosts'), value: '${ipAddress.usableHosts}', icon: Icons.devices_rounded),
            _InfoRow(label: tr.translate('totalHosts'), value: '${ipAddress.totalHosts}', icon: Icons.format_list_numbered_rounded),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // ── 4. Advanced Identifiers ───────────────────────────────
        _ResultSection(
          title: tr.translate('advancedIdentifiers'),
          icon : Icons.code_rounded,
          color: theme.colorScheme.secondary,
          children: [
            _InfoRow(label: tr.translate('binaryIp'), value: ipAddress.binaryAddress, icon: Icons.code_rounded, monospace: true),
            _InfoRow(label: tr.translate('integerId'), value: '${details.integerId}', icon: Icons.tag_rounded),
            _InfoRow(label: tr.translate('hexId'), value: details.hexId, icon: Icons.numbers_rounded, monospace: true),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // ── 5. Routing & Reverse DNS ──────────────────────────────
        _ResultSection(
          title: tr.translate('routingAndDns'),
          icon : Icons.alt_route_rounded,
          color: const Color(0xFF10B981),
          children: [
            _InfoRow(label: tr.translate('reverseDnsArpa'), value: details.inAddrArpa, icon: Icons.find_in_page_rounded),
            _InfoRow(label: tr.translate('ipv4MappedIpv6'), value: details.ipv4MappedIpv6, icon: Icons.swap_calls_rounded, monospace: true),
            _InfoRow(label: tr.translate('sixToFourPrefix'), value: details.sixToFourPrefix, icon: Icons.alt_route_rounded, monospace: true),
          ],
        ),
      ],
    );
  }

  void _copyAll(BuildContext context, AppLocalizations tr, IpNetworkDetails d) {
    final text = [
      '${ipAddress.address}/${ipAddress.subnetMask}',
      '${tr.translate("netmask")}: ${ipAddress.netmask}',
      '${tr.translate("wildcardMask")}: ${ipAddress.wildcardMask}',
      '${tr.translate("networkAddress")}: ${ipAddress.networkAddress}',
      '${tr.translate("broadcastAddress")}: ${ipAddress.broadcastAddress}',
      '${tr.translate("firstUsableIp")}: ${ipAddress.firstUsableIp}',
      '${tr.translate("lastUsableIp")}: ${ipAddress.lastUsableIp}',
      '${tr.translate("usableHosts")}: ${ipAddress.usableHosts}',
      '${tr.translate("totalHosts")}: ${ipAddress.totalHosts}',
      '${tr.translate("ipClass")}: ${ipAddress.networkClass}',
      '${tr.translate("ipType")}: ${ipAddress.ipTypeDescription}',
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

// ─── Quick Stat Row ──────────────────────────────────────────────────────────

class _QuickStatRow extends StatelessWidget {
  final IpAddress ipAddress;
  final AppThemeExtension ext;
  final AppLocalizations tr;

  const _QuickStatRow({
    required this.ipAddress,
    required this.ext,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBadge(
          label: tr.translate('usableHosts'),
          value: '${ipAddress.usableHosts}',
          icon : Icons.devices_rounded,
          color: ext.statusSuccess,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatBadge(
          label: tr.translate('ipClass'),
          value: '${tr.translate("classLabel")} ${ipAddress.networkClass}',
          icon : Icons.military_tech_rounded,
          color: ext.statusInfo,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatBadge(
          label: tr.translate('ipType'),
          value: ipAddress.isPrivate ? tr.translate('privateScope') : tr.translate('publicScope'),
          icon : ipAddress.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
          color: ipAddress.isPrivate ? ext.statusWarning : const Color(0xFF06B6D4),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical  : AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color       : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border      : Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: AppSpacing.iconSm, color: color),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    label,
                    style   : theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style   : theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Result Section Card ─────────────────────────────────────────────────────

class _ResultSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget? header;
  final List<Widget> children;

  const _ResultSection({
    required this.title,
    required this.icon,
    required this.color,
    this.header,
    required this.children,
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
            // Section header
            if (header != null) ...[
              header!,
            ] else ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color       : color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: AppSpacing.iconSm, color: color),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color     : color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool monospace;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
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
            content : Text('$label ${tr.translate("copiedToClipboard")}'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical  : AppSpacing.sm - 2,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size : AppSpacing.iconSm,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 3,
              child: Text(
                label,
                style   : theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color     : theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                  fontSize  : monospace ? 11 : null,
                ),
                textAlign: TextAlign.end,
                overflow : TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.copy_rounded,
              size : 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Copy All Button ─────────────────────────────────────────────────────────

class _CopyAllButton extends StatelessWidget {
  final VoidCallback onTap;
  final AppLocalizations tr;

  const _CopyAllButton({required this.onTap, required this.tr});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize    : Size.zero,
        tapTargetSize  : MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.copy_all_rounded, size: 14),
          const SizedBox(width: 4),
          Text(tr.translate('copy'), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
