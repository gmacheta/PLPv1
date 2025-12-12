import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../ui/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _picker = ImagePicker();
  XFile? _personalPhoto;
  XFile? _idPhoto;

  late UserRole _role;
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    _role = (args as UserRole?) ?? UserRole.renter;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickPersonalPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _personalPhoto = file);
    }
  }

  Future<void> _pickIdPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _idPhoto = file);
    }
  }

  Future<void> _handleRegister() async {
    if (_personalPhoto == null || _idPhoto == null) {
      setState(() {
        _error = 'Please select both personal and ID photos.';
        _success = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    try {
      await authService.register(
        role: _role,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        personalPhoto: _personalPhoto!,
        idPhoto: _idPhoto!,
      );

      if (!mounted) return;

      setState(() {
        _success =
            'Registered successfully. OTP sent via WhatsApp. Wait for admin approval.';
      });
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
                    const Text(
                      'Create\nAccount',
                      style: TextStyle(
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
                            controller: _firstNameController,
                            hint: 'first name',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _lastNameController,
                            hint: 'last name',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _dobController,
                            hint: 'your birthday',
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 24),

                          // Photo upload buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildPhotoButton(
                                  label: 'your pic',
                                  hasImage: _personalPhoto != null,
                                  onTap: _pickPersonalPhoto,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildPhotoButton(
                                  label: 'your id pic',
                                  hasImage: _idPhoto != null,
                                  onTap: _pickIdPhoto,
                                ),
                              ),
                            ],
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

                          if (_success != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _success!,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Sign up button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign Up',
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
                                    onTap: _loading ? null : _handleRegister,
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
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

  Widget _buildPhotoButton({
    required String label,
    required bool hasImage,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF0E1D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: hasImage
                  ? const Icon(
                      Icons.check_circle,
                      size: 40,
                      color: Color(0xFF346B7A),
                    )
                  : const Icon(
                      Icons.add,
                      size: 40,
                      color: Color(0xFF1E1B18),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E1B18),
          ),
        ),
      ],
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
