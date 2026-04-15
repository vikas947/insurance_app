import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../widgets/app_widgets.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _panController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _nomineeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  int _currentStep = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _panController.dispose();
    _aadhaarController.dispose();
    _nomineeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        setState(() => _errorMessage = 'Please enter your full name');
        return;
      }
    } else if (_currentStep == 1) {
      if (_panController.text.trim().isEmpty) {
        setState(() => _errorMessage = 'Please enter your PAN number');
        return;
      }
      if (_aadhaarController.text.trim().isEmpty) {
        setState(() => _errorMessage = 'Please enter your Aadhaar number');
        return;
      }
    }

    setState(() {
      _errorMessage = null;
      _currentStep++;
    });
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _errorMessage = null;
        _currentStep--;
      });
    }
  }

  void _submit() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'panNumber': _panController.text.trim(),
        'aadhaarNumber': _aadhaarController.text.trim(),
      };

      if (_nomineeController.text.trim().isNotEmpty) {
        data['nominee'] = {'name': _nomineeController.text.trim()};
      }

      await UserService.updateProfile(data);

      if (!mounted) return;
      await Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Failed to submit KYC. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                key: const ValueKey('back'),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                onPressed: _prevStep,
              )
            : null,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── Progress bar ──
                _buildProgressBar(),

                const SizedBox(height: 32),

                // ── Header ──
                Text(_getStepTitle(), style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(_getStepSubtitle(), style: AppTextStyles.bodyLarge),

                const SizedBox(height: 36),

                // ── Form content ──
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildStepContent(),
                    ),
                  ),
                ),

                // ── Error ──
                if (_errorMessage != null) ...[
                  AppInfoBanner(message: _errorMessage!),
                  const SizedBox(height: 16),
                ],

                // ── Action button ──
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AppPrimaryButton(
                    label: _currentStep < 2 ? 'Continue' : 'Submit KYC',
                    isLoading: _isLoading,
                    onPressed: _currentStep < 2 ? _nextStep : _submit,
                    icon: _currentStep < 2
                        ? Icons.arrow_forward
                        : Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Progress bar ──
  Widget _buildProgressBar() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  // ── Step content ──
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          key: const ValueKey('step0'),
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Full name (as per PAN)',
              hintText: 'Enter your legal name',
              prefixIcon: Icons.person_outline,
              onChanged: (_) => _clearError(),
            ),
          ],
        );
      case 1:
        return Column(
          key: const ValueKey('step1'),
          children: [
            AppTextField(
              controller: _panController,
              label: 'PAN number',
              hintText: 'ABCDE1234F',
              prefixIcon: Icons.credit_card_outlined,
              textCapitalization: TextCapitalization.characters,
              maxLength: 10,
              onChanged: (_) => _clearError(),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _aadhaarController,
              label: 'Aadhaar number',
              hintText: '1234 5678 9012',
              prefixIcon: Icons.fingerprint,
              keyboardType: TextInputType.number,
              maxLength: 12,
              onChanged: (_) => _clearError(),
            ),
          ],
        );
      case 2:
        return Column(
          key: const ValueKey('step2'),
          children: [
            AppTextField(
              controller: _nomineeController,
              label: 'Nominee name (optional)',
              hintText: 'Enter nominee\'s full name',
              prefixIcon: Icons.people_outline,
              onChanged: (_) => _clearError(),
            ),
            const SizedBox(height: 24),
            // Document upload placeholder
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Icon(Icons.cloud_upload_outlined,
                        color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(height: 16),
                  const Text('Upload documents',
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  const Text(
                    'PAN card, Aadhaar card (front & back)',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Basic details';
      case 1:
        return 'Identity verification';
      case 2:
        return 'Nominee & documents';
      default:
        return '';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Tell us your name to get started';
      case 1:
        return 'We need your PAN & Aadhaar for KYC';
      case 2:
        return 'Add a nominee and upload documents';
      default:
        return '';
    }
  }
}
