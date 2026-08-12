import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Kamu akan keluar dari akun ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Keluar', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );

    // Dummy: belum ada auth beneran, jadi cuma balik ke splash.
    // Nanti diisi clear session token setelah integrasi backend Go.
    if (confirmed == true && context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lainnya', style: AppTypography.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Profile Card (dummy, belum dari backend) ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.person, color: AppColors.primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pengguna Sellora', style: AppTypography.body),
                      const SizedBox(height: 2),
                      Text('user@sellora.app', style: AppTypography.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Preferensi', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            title: 'Tema Gelap',
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          _SettingsTile(
            icon: Icons.category_outlined,
            title: 'Kategori Produk',
            onTap: () => context.push('/settings/categories'),
          ),

          const SizedBox(height: 20),
          Text('Akun', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Keluar',
            titleColor: AppColors.danger,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
        title: Text(
          title,
          style: AppTypography.body.copyWith(color: titleColor),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
      ),
    );
  }
}