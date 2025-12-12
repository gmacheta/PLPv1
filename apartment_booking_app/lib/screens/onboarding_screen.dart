import 'package:flutter/material.dart';
import '../ui/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background image (buildings looking up)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF87CEEB).withOpacity(0.6), // Sky blue
                    const Color(0xFFB0E0E6).withOpacity(0.4),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Building silhouettes
                  Positioned(
                    top: 0,
                    left: 20,
                    child: _BuildingShape(
                      height: size.height * 0.35,
                      width: 80,
                      color: const Color(0xFF4A5D6A).withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 20,
                    child: _BuildingShape(
                      height: size.height * 0.38,
                      width: 90,
                      color: const Color(0xFF5B7C8D).withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: size.width * 0.35,
                    child: _BuildingShape(
                      height: size.height * 0.42,
                      width: 70,
                      color: const Color(0xFF3D5A6B).withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.45,
                    right: size.width * 0.25,
                    child: _BuildingShape(
                      height: size.height * 0.3,
                      width: 75,
                      color: const Color(0xFF6A8EA0).withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    bottom: size.height * 0.45,
                    left: size.width * 0.6,
                    child: _BuildingShape(
                      height: size.height * 0.32,
                      width: 65,
                      color: const Color(0xFF527A8C).withOpacity(0.7),
                    ),
                  ),
                  // Decorative elements (windows)
                  ...List.generate(20, (index) {
                    return Positioned(
                      top: (index % 4) * 80.0 + 40,
                      left: ((index ~/ 4) * size.width / 5) + 30,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Curved bottom section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _CurvedTopClipper(),
              child: Container(
                height: size.height * 0.45,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4A7C8A), // Medium teal
                      Color(0xFF346B7A), // Dark teal
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        
                        // "Bayti" title
                        const Text(
                          'Bayti',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 2,
                            height: 1,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Subtitle
                        const Text(
                          'Find your\ndream home',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // "LET'S EXPLORE" button
                        Container(
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5FB1C4), // Light teal
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/role');
                              },
                              child: const Center(
                                child: Text(
                                  "LET'S EXPLORE",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Admin login link
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/admin-login');
                          },
                          icon: Icon(
                            Icons.admin_panel_settings,
                            size: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          label: Text(
                            'Admin login',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Building shape widget
class _BuildingShape extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const _BuildingShape({
    required this.height,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          (height / 25).floor(),
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }
}

// Curved top clipper for bottom section
class _CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    
    // Start from top-left with curve
    path.moveTo(0, 80);
    
    // Create smooth curve at top
    path.quadraticBezierTo(
      size.width * 0.25,
      20,
      size.width * 0.5,
      40,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75,
      60,
      size.width,
      20,
    );
    
    // Right side
    path.lineTo(size.width, size.height);
    
    // Bottom
    path.lineTo(0, size.height);
    
    // Close path
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
