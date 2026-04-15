import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../widgets/app_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _user;

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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _user = authProvider.userProfile;
    if (_user != null) {
      _nameController.text = _user!['name'] ?? '';
      _emailController.text = _user!['email'] ?? '';
    }
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      await UserService.updateProfile({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });
      if (!mounted) return;
      await Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('User not found', style: AppTextStyles.bodyLarge),
        ),
      );
    }

    final name = _user!['name'] ?? 'User';
    final kycStatus = _user!['kycStatus'] ?? 'pending';
    final mobile = _user!['mobile'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const AppBackButton(),
        title: const Text('Profile'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Avatar + info header ──
              _buildProfileHeader(name, mobile, kycStatus),

              const SizedBox(height: 32),

              // ── Edit form ──
              AppTextField(
                controller: _nameController,
                label: 'Full name',
                hintText: 'Enter your full name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                label: 'Email address',
                hintText: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 32),

              // ── KYC info card ──
              _buildKycInfoCard(kycStatus),

              const SizedBox(height: 32),

              // ── Save button ──
              AppPrimaryButton(
                label: 'Save Changes',
                isLoading: _isLoading,
                onPressed: _updateProfile,
                icon: Icons.check,
              ),

              const SizedBox(height: 16),

              // ── Logout button ──
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.3),
                        width: 1.5),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String mobile, String kycStatus) {
    return Column(
      children: [
        // ── Avatar ──
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A6CF7), Color(0xFF7C5CFC)],
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontSize: 36,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(name, style: AppTextStyles.titleLarge),
        const SizedBox(height: 4),
        if (mobile.isNotEmpty)
          Text(
            '+91 $mobile',
            style: AppTextStyles.bodyMedium,
          ),
        const SizedBox(height: 12),

        // ── KYC status chip ──
        AppStatusChip(
          label: 'KYC: ${kycStatus.toUpperCase()}',
          color: kycStatus == 'verified'
              ? AppColors.success
              : kycStatus == 'submitted'
                  ? AppColors.warning
                  : AppColors.textHint,
        ),
      ],
    );
  }

  Widget _buildKycInfoCard(String kycStatus) {
    final isVerified = kycStatus == 'verified';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isVerified ? AppColors.successBg : AppColors.warningBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: (isVerified ? AppColors.success : AppColors.warning)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isVerified ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              isVerified ? Icons.verified_outlined : Icons.pending_outlined,
              color: isVerified ? AppColors.success : AppColors.warning,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified ? 'KYC Verified' : 'KYC Pending',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isVerified ? AppColors.success : AppColors.warning,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isVerified
                      ? 'Your identity has been verified successfully.'
                      : 'Complete your KYC to access all features.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
