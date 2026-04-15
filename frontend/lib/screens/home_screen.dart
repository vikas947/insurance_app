import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStickyOffer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("My Policies", "Active", "Expired"),
                  const SizedBox(height: 12),
                  _buildPolicyCard(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildDoMoreSection(),
                  const SizedBox(height: 24),
                  _buildExploreProducts(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF4A1010), // Matching the dark maroon/brown in image
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi, Vikas", 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
              Stack(
                children: [
                  IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: const Text("1", style: TextStyle(color: Colors.white, fontSize: 8), textAlign: TextAlign.center),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15)),
                child: const Text("TSS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildBannerText(),
        ],
      ),
    );
  }

  Widget _buildBannerText() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars, color: Color(0xFFB4833E), size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text("Renew your car insurance and enjoy the best offers!", 
              style: TextStyle(color: Color(0xFF4A1010), fontSize: 12)
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A1010)),
        ],
      ),
    );
  }

  Widget _buildStickyOffer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.white]),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Insurance Score", style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text("766/900", style: TextStyle(color: Color(0xFF4A1010), fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(20)),
            child: const Text("View Details", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(value: 0.85, strokeWidth: 8, color: Colors.green.shade400, backgroundColor: Colors.grey.shade200),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String activeLabel, String expiredLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildSmallTab(activeLabel, true),
              _buildSmallTab(expiredLabel, false),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSmallTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPolicyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
            child: const Icon(Icons.shield_outlined, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Health Gain", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("POLICY #1223334444555", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Expiry", style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text("20/12/26", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.5,
          children: [
            _buildActionItem("Renew", "assets/icons/renew.png", Colors.blue.shade50),
            _buildActionItem("Claim", "assets/icons/claim.png", Colors.red.shade50),
            _buildActionItem("Service Request", "assets/icons/service.png", Colors.green.shade50),
            _buildActionItem("Add Policy", "assets/icons/add.png", Colors.orange.shade50),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(String title, String iconPath, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildDoMoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Do More With Self-i", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: [
            _buildDoMoreItem("Health Tools", "Explore", Icons.health_and_safety_outlined),
            _buildDoMoreItem("Connect to Google Fit", "Connect", Icons.fitness_center),
            _buildDoMoreItem("Vehicle Information", "Check Now", Icons.directions_car_outlined),
            _buildDoMoreItem("Check Your Credit Score", "Check Now", Icons.credit_score_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildDoMoreItem(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 8)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildExploreProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Explore Our Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildProductCard("Health Plans", "Starting at ₹500/month", Icons.health_and_safety_outlined, Colors.red.shade50),
            _buildProductCard("Motor Plans", "Starting at ₹100/month", Icons.directions_car_outlined, Colors.blue.shade50),
            _buildProductCard("Travel Plans", "Travel safely to 175+ destinations", Icons.flight_takeoff, Colors.green.shade50),
            _buildProductCard("Other Plans", "Home, Marine, etc.", Icons.more_horiz, Colors.orange.shade50),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard(String title, String subtitle, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 28),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A1010),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Policies"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: "Locator"),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: "Help"),
        ],
      ),
    );
  }
}
