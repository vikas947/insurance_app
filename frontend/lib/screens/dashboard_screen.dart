import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/policy_service.dart';
import '../widgets/app_widgets.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'profile_screen.dart';
import 'policy_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> _policies = [];
  List<dynamic> _recommendations = [];
  bool _isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkKycAndLoadData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _checkKycAndLoadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userProfile;

    if (user != null && user['kycStatus'] == 'pending') {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    try {
      final policies = await PolicyService.getUserPolicies();
      List<dynamic> recs = [];
      try {
        recs = await PolicyService.getRecommendations();
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _policies = policies;
        _recommendations = recs;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userProfile;

    if (_isLoading || user == null || user['kycStatus'] == 'pending') {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final firstName = (user['name'] ?? 'User').toString().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              try {
                final policies = await PolicyService.getUserPolicies();
                if (mounted) setState(() => _policies = policies);
              } catch (_) {}
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // ── Top bar ──
                SliverToBoxAdapter(
                  child: _buildTopBar(firstName, authProvider),
                ),

                // ── Greeting card ──
                SliverToBoxAdapter(child: _buildGreetingCard(firstName)),

                // ── Quick actions ──
                SliverToBoxAdapter(child: _buildQuickActions()),

                // ── Active policies ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: AppSectionHeader(
                      title: 'Your Policies',
                      actionLabel: _policies.isNotEmpty
                          ? '${_policies.length} active'
                          : null,
                    ),
                  ),
                ),

                if (_policies.isEmpty)
                  SliverToBoxAdapter(child: _buildEmptyPolicies())
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildPolicyCard(_policies[index]),
                      ),
                      childCount: _policies.length,
                    ),
                  ),

                // ── Recommendations ──
                if (_recommendations.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: const AppSectionHeader(
                        title: 'Recommended for You',
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildRecommendations()),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Top bar ──
  Widget _buildTopBar(String name, AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Brand
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'SecureLife',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),

          // Profile
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Logout
          GestureDetector(
            onTap: () async {
              await authProvider.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.logout,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Greeting card ──
  Widget _buildGreetingCard(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A6CF7), Color(0xFF7C5CFC)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_getGreeting()}, $name 👋',
              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'Your coverage is looking great today.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildGreetingStat(
                  '${_policies.length}',
                  'Active\nPolicies',
                  Colors.white,
                ),
                const SizedBox(width: 24),
                _buildGreetingStat(
                  '₹${_getTotalCoverage()}',
                  'Total\nCoverage',
                  Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingStat(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.headlineMedium.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ── Quick actions ──
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        children: [
          _buildQuickAction(
            Icons.add_circle_outline,
            'Buy Policy',
            AppColors.primary,
            AppColors.primaryLight,
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.receipt_long_outlined,
            'Claims',
            AppColors.healthPolicy,
            AppColors.successBg,
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.headset_mic_outlined,
            'Support',
            AppColors.accent,
            AppColors.accentLight,
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.history,
            'History',
            AppColors.warning,
            AppColors.warningBg,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color iconColor,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty state ──
  Widget _buildEmptyPolicies() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text('No active policies', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Secure your future by buying\na policy today.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: AppPrimaryButton(
                label: 'Explore Plans',
                onPressed: () {},
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Policy card ──
  Widget _buildPolicyCard(dynamic policy) {
    final type = policy['type'] as String?;
    final typeColor = getPolicyTypeColor(type);
    final typeIcon = getPolicyTypeIcon(type);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PolicyDetailsScreen(policyId: policy['_id'] ?? ''),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: icon + provider + status ──
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(typeIcon, size: 20, color: typeColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        policy['name'] ?? 'Policy',
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        policy['provider'] ?? 'Provider',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                AppStatusChip(
                  label: policy['status'] ?? 'Active',
                  color: policy['status'] == 'Active'
                      ? AppColors.success
                      : AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),
            // ── Bottom row: coverage + premium ──
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Coverage', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(
                        '₹${_formatAmount(policy['coverageAmount'])}',
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 36, color: AppColors.divider),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Premium', style: AppTextStyles.caption),
                      const SizedBox(height: 4),
                      Text(
                        '₹${_formatAmount(policy['premium'])}/yr',
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Recommendations ──
  Widget _buildRecommendations() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: _recommendations.length,
        itemBuilder: (context, index) {
          final rec = _recommendations[index];
          final type = rec['type'] as String?;
          final typeColor = getPolicyTypeColor(type);
          final typeIcon = getPolicyTypeIcon(type);

          return Container(
            width: 240,
            margin: EdgeInsets.only(
              right: index < _recommendations.length - 1 ? 12 : 0,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(typeIcon, size: 18, color: typeColor),
                ),
                const SizedBox(height: 14),
                Text(
                  rec['name'] ?? '',
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${rec['premium'] ?? 0}/yr',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ──
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _getTotalCoverage() {
    num total = 0;
    for (final p in _policies) {
      total += (p['coverageAmount'] ?? 0) as num;
    }
    return _formatAmount(total);
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final num val = amount is num
        ? amount
        : num.tryParse(amount.toString()) ?? 0;
    if (val >= 10000000) return '${(val / 10000000).toStringAsFixed(1)}Cr';
    if (val >= 100000) return '${(val / 100000).toStringAsFixed(1)}L';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(1)}K';
    return val.toStringAsFixed(0);
  }
}
