import 'package:flutter/material.dart';
import '../services/admin_service.dart';
import '../ui/app_theme.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  String? _error;

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
      await adminService.login(
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Admin Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Admin icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.darkTeal,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  'Administrator',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Login to manage user registrations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 32),

                // Phone field
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 16),

                // Password field
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onSubmitted: (_) => _handleLogin(),
                ),
                
                const SizedBox(height: 24),

                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkTeal,
                      foregroundColor: Colors.white,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Back button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

