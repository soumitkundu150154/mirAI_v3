import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSocialDialog(context, ref),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── Header ───
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
              ),
              const SizedBox(height: 28),

              // ─── Avatar + Name ───
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name.isEmpty ? 'Creator' : user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'mirAI Creator',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ─── Connected Profiles ───
              if (user.instaLink.isNotEmpty ||
                  user.youtubeLink.isNotEmpty ||
                  user.customSocials.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Connected Profiles', style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 12),
                if (user.instaLink.isNotEmpty)
                  _buildSocialCard(
                    context: context,
                    icon: FontAwesomeIcons.instagram,
                    title: 'Instagram',
                    subtitle: user.instaLink,
                    color: Colors.pink,
                    cardColor: cardColor,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                if (user.youtubeLink.isNotEmpty)
                  _buildSocialCard(
                    context: context,
                    icon: FontAwesomeIcons.youtube,
                    title: 'YouTube',
                    subtitle: user.youtubeLink,
                    color: Colors.red,
                    cardColor: cardColor,
                    textColor: textColor,
                    isDark: isDark,
                  ),
                ...user.customSocials.asMap().entries.map((entry) {
                  final social = entry.value;
                  return _buildSocialCard(
                    context: context,
                    icon: Icons.link_rounded,
                    title: social['platform'] ?? 'Other',
                    subtitle: social['account'] ?? '',
                    color: const Color(0xFF4EA8FF),
                    cardColor: cardColor,
                    textColor: textColor,
                    isDark: isDark,
                    onDelete: () {
                      ref.read(userProvider.notifier).removeCustomSocial(entry.key);
                    },
                  );
                }),
                const SizedBox(height: 28),
              ],

              // ─── Settings ───
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: isDark
                      ? Border.all(color: Colors.white.withOpacity(0.06))
                      : null,
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: isDark ? const Color(0xFFFFB84D) : Colors.orange,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Dark Theme',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: isDark,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
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

  Widget _buildSocialCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required bool isDark,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? const Color(0xFF7A7A98) : Colors.grey.shade500,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: isDark ? const Color(0xFF5A5A78) : Colors.grey.shade400,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  void _showAddSocialDialog(BuildContext context, WidgetRef ref) {
    final platformController = TextEditingController();
    final accountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
        final textColor = isDark ? const Color(0xFFE8E8F0) : const Color(0xFF1A1A2E);
        final primaryColor = Theme.of(ctx).colorScheme.primary;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Add Social Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: platformController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Platform Name',
                    labelStyle: TextStyle(
                      color: isDark ? const Color(0xFF5A5A78) : Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(Icons.apps_rounded, color: primaryColor, size: 20),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0D0D14) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: accountController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Account / Link',
                    labelStyle: TextStyle(
                      color: isDark ? const Color(0xFF5A5A78) : Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(Icons.link_rounded, color: primaryColor, size: 20),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0D0D14) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final platform = platformController.text.trim();
                      final account = accountController.text.trim();
                      if (platform.isNotEmpty && account.isNotEmpty) {
                        ref.read(userProvider.notifier).addCustomSocial(platform, account);
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add Account',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
