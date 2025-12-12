import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/app_theme.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  UserRole _role = UserRole.renter;

  void _goNext() {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: _role,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top header with teal blobs and title
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned(
                    left: -120,
                    top: -80,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        color: AppColors.darkTeal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -80,
                    top: -40,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        color: AppColors.lightTeal,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(180),
                          topLeft: Radius.circular(180),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 24,
                    bottom: 16,
                    child: Text(
                      'who are you',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _roleCard(
              icon: Icons.search,
              title: 'Tenant',
              selected: _role == UserRole.renter,
              onTap: () {
                setState(() => _role = UserRole.renter);
                _goNext();
              },
            ),
            const SizedBox(height: 20),
            _roleCard(
              icon: Icons.house_rounded,
              title: 'Landlord',
              selected: _role == UserRole.owner,
              onTap: () {
                setState(() => _role = UserRole.owner);
                _goNext();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.lightTeal,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              if (selected)
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
