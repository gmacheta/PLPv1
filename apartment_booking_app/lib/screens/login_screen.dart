import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;
  late UserRole _role;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    _role = (args as UserRole?) ?? UserRole.renter;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await authService.login(
        role: _role,
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/apartments');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(
      context,
      '/register',
      arguments: _role,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleText = roleLabel(_role);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // Cream background
      body: Stack(
        children: [
          // Curved top background with waves
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: size.height * 0.35,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    
                    // Title
                    Text(
                      'Welcome\nBack',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    
                    const SizedBox(height: 40),

                    // Form container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _phoneController,
                            hint: 'phone number',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'password',
                            obscureText: true,
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Login button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1B18),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF346B7A),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF346B7A).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: _loading ? null : _handleLogin,
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      alignment: Alignment.center,
                                      child: _loading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Register link
                          TextButton(
                            onPressed: _goToRegister,
                            child: Text(
                              "Don't have an account? Register",
                              style: TextStyle(
                                color: const Color(0xFF346B7A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          
          // Back button (positioned last to be on top)
          Positioned(
            top: 50,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0E1D9), // Light beige
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1E1B18),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF1E1B18),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

// Custom clipper for wave effect
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.7);
    
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.85);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.75);
    var secondEndPoint = Offset(size.width, size.height * 0.85);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
