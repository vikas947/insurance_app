import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../services/policy_service.dart';
import '../widgets/app_widgets.dart';

class PolicyDetailsScreen extends StatefulWidget {
  final String policyId;

  const PolicyDetailsScreen({super.key, required this.policyId});

  @override
  State<PolicyDetailsScreen> createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _policy;
  bool _isLoading = true;
  String? _error;

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
    _fetchPolicyDetails();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _fetchPolicyDetails() async {
    try {
      final policy = await PolicyService.getPolicyById(widget.policyId);
      if (!mounted) return;
      setState(() {
        _policy = policy;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to load policy details';
      });
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const AppBackButton(),
        ),
        body: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    if (_policy == null || _error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const AppBackButton(),
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Something went wrong',
                style: AppTextStyles.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    final type = _policy!['type'] as String?;
    final typeColor = getPolicyTypeColor(type);
    final typeIcon = getPolicyTypeIcon(type);
    final isActive = _policy!['status'] == 'Active';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero header ──
            SliverToBoxAdapter(
              child: _buildHeroHeader(typeColor, typeIcon, isActive),
            ),

            // ── Details card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildDetailsCard(),
              ),
            ),

            // ── Benefits ──
            if (_policy!['benefits'] != null &&
                (_policy!['benefits'] as List).isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: _buildBenefitsCard(typeColor),
                ),
              ),

            // ── Actions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                child: _buildActions(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero header ──
  Widget _buildHeroHeader(Color typeColor, IconData typeIcon, bool isActive) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 20,
        right: 20,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            typeColor,
            typeColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar ──
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      size: 16, color: Colors.white),
                ),
              ),
              const Spacer(),
              AppStatusChip(
                label: _policy!['status'] ?? 'Active',
                color: Colors.white,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Policy icon + name ──
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(typeIcon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            _policy!['name'] ?? '',
            style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            _policy!['provider'] ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: 24),

          // ── Quick stats ──
          Row(
            children: [
              _buildHeroStat(
                '₹${_policy!['coverageAmount'] ?? 0}',
                'Coverage',
              ),
              const SizedBox(width: 32),
              _buildHeroStat(
                '₹${_policy!['premium'] ?? 0}/yr',
                'Premium',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ── Details card ──
  Widget _buildDetailsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
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
          Text('Policy Details', style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          AppDetailRow(
            label: 'Type',
            value: '${_policy!['type'] ?? 'N/A'}',
          ),
          const Divider(color: AppColors.divider),
          AppDetailRow(
            label: 'Premium',
            value: '₹${_policy!['premium'] ?? 0}/yr',
          ),
          const Divider(color: AppColors.divider),
          AppDetailRow(
            label: 'Sum Insured',
            value: '₹${_policy!['coverageAmount'] ?? 0}',
          ),
          const Divider(color: AppColors.divider),
          AppDetailRow(
            label: 'Start Date',
            value: _formatDate(_policy!['startDate']),
          ),
          const Divider(color: AppColors.divider),
          AppDetailRow(
            label: 'End Date',
            value: _formatDate(_policy!['endDate']),
          ),
        ],
      ),
    );
  }

  // ── Benefits card ──
  Widget _buildBenefitsCard(Color typeColor) {
    final benefits = _policy!['benefits'] as List;

    return Container(
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
          Text('Benefits', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppRadius.full),
                      ),
                      child: Icon(Icons.check,
                          size: 14, color: typeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        benefit.toString(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Action buttons ──
  Widget _buildActions() {
    return Column(
      children: [
        AppPrimaryButton(
          label: 'Download Policy Document',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloading document...')),
            );
          },
          icon: Icons.download,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 54,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.headset_mic_outlined, size: 20),
            label: const Text('Contact Support'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border, width: 1.5),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              textStyle: AppTextStyles.buttonText.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr.toString());
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr.toString().substring(0, 10);
    }
  }
}
