import 'package:flutter/material.dart';

class PolicyDetailsScreen extends StatelessWidget {
  final String policyId;

  const PolicyDetailsScreen({super.key, required this.policyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Policy Details')),
      body: Center(
        child: Text('Policy Details for $policyId — Coming Soon'),
      ),
    );
  }
}
