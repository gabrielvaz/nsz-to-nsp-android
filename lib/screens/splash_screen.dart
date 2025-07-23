import 'package:flutter/material.dart';
import '../services/preferences_manager.dart';
import 'onboarding_screen.dart';
import 'file_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Simular um pequeno delay para splash screen
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final bool hasSeenOnboarding = await PreferencesManager.isOnboardingCompleted();
    
    if (mounted) {
      if (hasSeenOnboarding) {
        // Usuário já viu o onboarding, vai direto para seleção de arquivo
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FileSelectionScreen(),
          ),
        );
      } else {
        // Primeira vez do usuário, mostrar onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'NSZ2NSP Converter',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Convertendo seus backups...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}