import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'app_shell.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instaController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your name 😄'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    ref.read(userProvider.notifier).saveProfile(
      name: _nameController.text.trim(),
      instaLink: _instaController.text.trim(),
      youtubeLink: _youtubeController.text.trim(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instaController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, size: 36, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Welcome to mirAI! 🎉',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tell us a little about yourself.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Your Name *',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _nameController,
                hintText: 'E.g., John Doe',
                prefixIcon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 24),
              Text(
                'Instagram Profile Link',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _instaController,
                hintText: 'https://instagram.com/yourhandle',
                prefixIcon: FontAwesomeIcons.instagram,
              ),

              const SizedBox(height: 24),
              Text(
                'YouTube Channel Link',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _youtubeController,
                hintText: 'https://youtube.com/@yourchannel',
                prefixIcon: FontAwesomeIcons.youtube,
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Get Started',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _saveProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
