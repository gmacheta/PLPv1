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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // Cream background
      body: Stack(
        children: [
          // Curved top background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _RoleWaveClipper(),
              child: Container(
                height: size.height * 0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF346B7A), // Dark teal
                      Color(0xFF5FB1C4), // Light teal
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                
                // "who are you" title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'who are you',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const Spacer(),

                // Tenant button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _RoleButton(
                    icon: Icons.person_search,
                    label: 'Tenant',
                    onTap: () {
                      setState(() => _role = UserRole.renter);
                      _goNext();
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Landlord button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _RoleButton(
                    icon: Icons.home_work,
                    label: 'Landlord',
                    onTap: () {
                      setState(() => _role = UserRole.owner);
                      _goNext();
                    },
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Role button widget
class _RoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoleButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF7BADB8), // Medium teal
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              
              // Icon container
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(width: 24),
              
              // Label
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper for wave effect
class _RoleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // Start from top-left
    path.lineTo(0, size.height * 0.7);
    
    // Create large smooth curve
    var firstControlPoint = Offset(size.width * 0.3, size.height * 0.85);
    var firstEndPoint = Offset(size.width * 0.6, size.height * 0.75);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.8, size.height * 0.65);
    var secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Top-right corner
    path.lineTo(size.width, 0);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
