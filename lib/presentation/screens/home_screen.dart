import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/stat_card.dart';
import 'generator_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<String> trendingTopics = const [
    '🤖 AI tools',
    '🚀 Startup life',
    '💻 Coding memes',
    '📈 Growth hacks',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final user = ref.watch(userProvider);
    final userName = user.name.isNotEmpty ? user.name : 'Creator';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $userName 👋',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Here\'s your content overview',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => ref.read(analyticsProvider.notifier).generateNewStats(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: isDark
                            ? Border.all(color: Colors.white.withOpacity(0.06))
                            : null,
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Icon(Icons.refresh_rounded, color: primaryColor, size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─── Stats Grid ───
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Likes',
                      value: _formatNumber(analytics.likes),
                      icon: Icons.favorite_rounded,
                      accentColor: const Color(0xFFFF6B8A),
                      trend: '+${analytics.growthPercent.toStringAsFixed(0)}%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Comments',
                      value: _formatNumber(analytics.comments),
                      icon: Icons.chat_bubble_rounded,
                      accentColor: const Color(0xFF4EA8FF),
                      trend: '+12%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Shares',
                      value: _formatNumber(analytics.shares),
                      icon: Icons.share_rounded,
                      accentColor: const Color(0xFF4CD97B),
                      trend: '+8%',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'Sentiment',
                      value: '${analytics.positivePercent.toStringAsFixed(0)}%',
                      icon: Icons.emoji_emotions_rounded,
                      accentColor: const Color(0xFFFFB84D),
                      trend: 'Positive',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ─── Engagement Chart ───
              Text('Weekly Engagement', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: isDark
                      ? Border.all(color: Colors.white.withOpacity(0.06))
                      : null,
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 12,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => primaryColor,
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toStringAsFixed(1),
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (value.toInt() >= 0 && value.toInt() < days.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  days[value.toInt()],
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF5A5A78) : Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade200,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: analytics.weeklyEngagement.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            gradient: LinearGradient(
                              colors: [primaryColor, primaryColor.withOpacity(0.6)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            width: 14,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ─── Recent Posts ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Posts', style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    '${analytics.recentPosts.length} posts',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...analytics.recentPosts.map((post) => _buildPostCard(
                    context,
                    post,
                    cardColor,
                    textColor,
                    isDark,
                  )),

              const SizedBox(height: 28),

              // ─── Trending + Quick Action ───
              Text('Trending Topics 🔥', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: trendingTopics.map((topic) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GeneratorScreen(initialTopic: topic.replaceAll(RegExp(r'[^\w\s]'), '').trim()),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(isDark ? 0.12 : 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: primaryColor.withOpacity(isDark ? 0.2 : 0.15),
                        ),
                      ),
                      child: Text(
                        topic,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 80), // bottom nav clearance
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    RecentPost post,
    Color cardColor,
    Color textColor,
    bool isDark,
  ) {
    final sentimentColor = post.sentiment == 'Positive'
        ? const Color(0xFF4CD97B)
        : post.sentiment == 'Negative'
            ? const Color(0xFFFF6B8A)
            : const Color(0xFFFFB84D);

    IconData platformIcon;
    Color platformColor;
    switch (post.platform) {
      case 'Instagram':
        platformIcon = Icons.camera_alt_rounded;
        platformColor = Colors.pink;
        break;
      case 'LinkedIn':
        platformIcon = Icons.work_rounded;
        platformColor = const Color(0xFF0077B5);
        break;
      default:
        platformIcon = Icons.alternate_email_rounded;
        platformColor = const Color(0xFF1DA1F2);
    }

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
              color: platformColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(platformIcon, color: platformColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.favorite, size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 3),
                    Text(
                      _formatNumber(post.likes),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.chat_bubble, size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 3),
                    Text(
                      _formatNumber(post.comments),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.share, size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 3),
                    Text(
                      _formatNumber(post.shares),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: sentimentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              post.sentiment,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: sentimentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
