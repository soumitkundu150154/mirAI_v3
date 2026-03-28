import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/content_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  final String? initialTopic;

  const GeneratorScreen({Key? key, this.initialTopic}) : super(key: key);

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  late TextEditingController _topicController;
  final List<Map<String, dynamic>> _platforms = [
    {'name': 'Instagram', 'icon': Icons.camera_alt_rounded, 'color': Colors.pink},
    {'name': 'LinkedIn', 'icon': Icons.work_rounded, 'color': const Color(0xFF0077B5)},
    {'name': 'Twitter', 'icon': Icons.alternate_email_rounded, 'color': const Color(0xFF1DA1F2)},
  ];
  String _selectedPlatform = 'Instagram';

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController(text: widget.initialTopic ?? '');
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _generateContent({String? additionalInstruction}) {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a topic'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    
    FocusScope.of(context).unfocus();

    ref.read(contentNotifierProvider.notifier).generatePost(
      topic: _topicController.text.trim(),
      platform: _selectedPlatform,
      additionalInstruction: additionalInstruction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Text('Create Post ✨', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Generate AI-powered content for your socials',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 28),

              // ─── Topic ───
              Text('Topic or Idea', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _topicController,
                hintText: 'E.g., Benefits of learning Flutter',
                prefixIcon: Icons.lightbulb_outline_rounded,
              ),
              
              const SizedBox(height: 24),

              // ─── Platform Selector ───
              Text('Platform', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Row(
                children: _platforms.map((p) {
                  final isSelected = _selectedPlatform == p['name'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlatform = p['name']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: p != _platforms.last ? 10 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor.withOpacity(isDark ? 0.15 : 0.08)
                              : cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? primaryColor.withOpacity(0.5)
                                : isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              p['icon'] as IconData,
                              color: isSelected ? primaryColor : (p['color'] as Color),
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p['name'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? primaryColor : textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // ─── Generate Button ───
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Generate Content',
                  icon: Icons.auto_awesome_rounded,
                  isLoading: contentState.isGenerating,
                  onPressed: _generateContent,
                ),
              ),

              // ─── Error ───
              if (contentState.error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(isDark ? 0.1 : 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          contentState.error!,
                          style: const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ─── Result ───
              if (contentState.generatedText != null && !contentState.isGenerating) ...[
                const SizedBox(height: 28),
                Divider(color: Theme.of(context).dividerColor),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Generated Result', style: Theme.of(context).textTheme.titleLarge),
                    if (contentState.sentiment != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getSentimentColor(contentState.sentiment!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _getSentimentColor(contentState.sentiment!).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          contentState.sentiment!,
                          style: TextStyle(
                            color: _getSentimentColor(contentState.sentiment!),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: isDark
                        ? Border.all(color: Colors.white.withOpacity(0.06))
                        : Border.all(color: Colors.grey.shade200),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: SelectableText(
                    contentState.generatedText!,
                    style: TextStyle(fontSize: 14, height: 1.6, color: textColor),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: contentState.generatedText!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy_rounded, size: 16, color: primaryColor),
                    label: Text(
                      'Copy',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Refine it', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildRefineChip('Funnier 😆', primaryColor, isDark),
                    _buildRefineChip('Professional 👔', primaryColor, isDark),
                    _buildRefineChip('Emotional ❤️', primaryColor, isDark),
                    _buildRefineChip('Shorter ✂️', primaryColor, isDark),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefineChip(String label, Color primaryColor, bool isDark) {
    return InkWell(
      onTap: () => _generateContent(
        additionalInstruction: 'more ${label.split(' ')[0].toLowerCase()}',
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(isDark ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    if (sentiment.contains('Positive')) return const Color(0xFF4CD97B);
    if (sentiment.contains('Negative')) return const Color(0xFFFF6B8A);
    return const Color(0xFFFFB84D);
  }
}
