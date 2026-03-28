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
  final List<String> _platforms = ['Instagram', 'LinkedIn', 'Twitter'];
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
        const SnackBar(content: Text('Please enter a topic')),
      );
      return;
    }
    
    // Hide keyboard
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Topic or Idea',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _topicController,
                hintText: 'E.g., Benefits of learning Flutter',
                prefixIcon: Icons.lightbulb_outline,
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Platform',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPlatform,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                    items: _platforms.map((platform) {
                      return DropdownMenuItem(
                        value: platform,
                        child: Text(platform, style: const TextStyle(fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPlatform = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Generate Content',
                  icon: Icons.auto_awesome,
                  isLoading: contentState.isGenerating,
                  onPressed: _generateContent,
                ),
              ),

              if (contentState.error != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    contentState.error!,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ],

              if (contentState.generatedText != null && !contentState.isGenerating) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Generated Result',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (contentState.sentiment != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getSentimentColor(contentState.sentiment!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getSentimentColor(contentState.sentiment!).withOpacity(0.5)),
                        ),
                        child: Text(
                          contentState.sentiment!,
                          style: TextStyle(
                            color: _getSentimentColor(contentState.sentiment!),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    contentState.generatedText!,
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: contentState.generatedText!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy to Clipboard'),
                    style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Make it better?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildRegenerateButton('Funnier 😆'),
                    _buildRegenerateButton('More professional 👔'),
                    _buildRegenerateButton('More emotional ❤️'),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegenerateButton(String label) {
    return InkWell(
      onTap: () => _generateContent(additionalInstruction: "more ${label.split(' ')[0].toLowerCase()}"),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepPurple.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.deepPurple.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    if (sentiment.contains('Positive')) return Colors.green;
    if (sentiment.contains('Negative')) return Colors.red;
    return Colors.amber.shade700;
  }
}
