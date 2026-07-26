import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../network/ip_network_engine.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extension.dart';
import 'responsive_layout.dart';

/// Full-Screen CIDR & Subnet Mask Reference Lookup Page.
///
/// Features:
/// - Search & Filter by prefix length, mask, wildcard, or host capacity.
/// - Class A, B, C preset filter chips.
/// - Hero Banner with address capacity metrics.
/// - Copy full CIDR specs on tap.
class CidrLookupPage extends StatefulWidget {
  const CidrLookupPage({super.key});

  @override
  State<CidrLookupPage> createState() => _CidrLookupPageState();
}

class _CidrLookupPageState extends State<CidrLookupPage> {
  String _searchQuery = '';
  String _filterClass = 'all'; // 'all', 'a', 'b', 'c', 'slash24'

  @override
  Widget build(BuildContext context) {
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext   = theme.extension<AppThemeExtension>()!;

    // Build data for all /0 to /32 prefixes
    final allEntries = List.generate(33, (cidr) {
      final maskInt     = IpNetworkEngine.cidrToMaskInt(cidr);
      final maskStr     = IpNetworkEngine.intToIp(maskInt);
      final wildcardStr = IpNetworkEngine.intToIp((~maskInt) & 0xFFFFFFFF);
      final details     = IpNetworkEngine.calculateDetails('192.168.1.1', cidr);
      return _CidrEntryData(
        cidr       : cidr,
        netmask    : maskStr,
        wildcard   : wildcardStr,
        usableHosts: details.usableHosts,
        totalHosts : details.totalHosts,
        netClass   : _getClassForCidr(cidr),
      );
    });

    final filteredEntries = allEntries.where((entry) {
      final q = _searchQuery.toLowerCase().trim();
      final matchesSearch = q.isEmpty ||
          '/${entry.cidr}'.contains(q) ||
          entry.cidr.toString() == q ||
          entry.netmask.contains(q) ||
          entry.wildcard.contains(q) ||
          entry.usableHosts.toString().contains(q) ||
          entry.netClass.toLowerCase().contains(q);

      if (!matchesSearch) return false;

      if (_filterClass == 'a') return entry.cidr <= 8;
      if (_filterClass == 'b') return entry.cidr > 8 && entry.cidr <= 16;
      if (_filterClass == 'c') return entry.cidr > 16 && entry.cidr <= 24;
      if (_filterClass == 'subnetting') return entry.cidr > 24;

      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('cidrReferenceTable')),
      ),
      body: ResponsiveLayout(
        maxWidth: 1000.0,
        child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── 1. Hero Overview Header Card ─────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
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
                      _Badge(label: 'IPv4 32-Bit CIDR', icon: Icons.table_chart_rounded),
                      _Badge(label: '33 Prefixes (/0 - /32)', icon: Icons.format_list_numbered_rounded),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    tr.translate('cidrReferenceTable'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Quick reference for IPv4 Subnet Masks, Wildcards, and Host Capacities',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Search & Filter Bar ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: tr.translate('searchHint'),
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All (/0 - /32)',
                          isSelected: _filterClass == 'all',
                          onTap: () => setState(() => _filterClass = 'all'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _FilterChip(
                          label: 'Class A (/0 - /8)',
                          isSelected: _filterClass == 'a',
                          onTap: () => setState(() => _filterClass = 'a'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _FilterChip(
                          label: 'Class B (/9 - /16)',
                          isSelected: _filterClass == 'b',
                          onTap: () => setState(() => _filterClass = 'b'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _FilterChip(
                          label: 'Class C (/17 - /24)',
                          isSelected: _filterClass == 'c',
                          onTap: () => setState(() => _filterClass = 'c'),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _FilterChip(
                          label: 'Subnets (/25 - /32)',
                          isSelected: _filterClass == 'subnetting',
                          onTap: () => setState(() => _filterClass = 'subnetting'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

          // ── 3. CIDR Table Items List ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filteredEntries[index];
                  final isCommon = (item.cidr == 24 || item.cidr == 16 || item.cidr == 8 || item.cidr == 30);

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: isCommon
                          ? theme.colorScheme.primary.withValues(alpha: 0.08)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: isCommon
                            ? theme.colorScheme.primary.withValues(alpha: 0.3)
                            : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        final text = '/${item.cidr}\n${tr.translate("netmask")}: ${item.netmask}\n${tr.translate("wildcardMask")}: ${item.wildcard}\n${tr.translate("usableHosts")}: ${item.usableHosts}\n${tr.translate("totalHosts")}: ${item.totalHosts}';
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                        );
                      },
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            // CIDR Prefix Badge
                            Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isCommon ? theme.colorScheme.primary : theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Text(
                                '/${item.cidr}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            // Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${tr.translate("netmask")}: ${item.netmask}',
                                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceContainerHighest,
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                        ),
                                        child: Text(
                                          item.netClass,
                                          style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tr.translate("wildcardMask")}: ${item.wildcard}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.devices_rounded, size: 14, color: Color(0xFF10B981)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${item.usableHosts} ${tr.translate("usableHosts")}',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: const Color(0xFF10B981),
                                            fontWeight: FontWeight.w800,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.copy_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredEntries.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ],
      ),
    ),
    );
  }

  String _getClassForCidr(int cidr) {
    if (cidr <= 8) return 'Class A';
    if (cidr <= 16) return 'Class B';
    if (cidr <= 24) return 'Class C';
    return 'Subnet';
  }
}

class _CidrEntryData {
  final int cidr;
  final String netmask;
  final String wildcard;
  final int usableHosts;
  final int totalHosts;
  final String netClass;

  const _CidrEntryData({
    required this.cidr,
    required this.netmask,
    required this.wildcard,
    required this.usableHosts,
    required this.totalHosts,
    required this.netClass,
  });
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Badge({required this.label, required this.icon});

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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}
