import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/admin_service.dart';
import '../ui/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<PendingUser>> _pendingUsersFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPendingUsers();
  }

  void _loadPendingUsers() {
    setState(() {
      _pendingUsersFuture = adminService.getPendingRegistrations();
    });
  }

  Future<void> _handleApprove(PendingUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve User'),
        content: Text(
          'Approve ${user.firstName} ${user.lastName} as ${user.type}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await adminService.approveUser(user.id, user.type);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.firstName} ${user.lastName} approved!'),
          backgroundColor: Colors.green,
        ),
      );
      
      _loadPendingUsers();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReject(PendingUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject User'),
        content: Text(
          'Reject ${user.firstName} ${user.lastName}? This will delete their registration.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await adminService.rejectUser(user.id, user.type);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.firstName} ${user.lastName} rejected.'),
          backgroundColor: Colors.orange,
        ),
      );
      
      _loadPendingUsers();
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await adminService.logout();
      } catch (e) {
        // Ignore logout errors
      }
      
      // Clear any stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      if (!mounted) return;
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/onboarding',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _isLoading ? null : _loadPendingUsers,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: FutureBuilder<List<PendingUser>>(
        future: _pendingUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading pending users',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadPendingUsers,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pendingUsers = snapshot.data ?? [];

          if (pendingUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Pending Registrations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All user registrations have been processed.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Registrations',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pendingUsers.length} user${pendingUsers.length == 1 ? '' : 's'} waiting for approval',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pendingUsers.length,
                  itemBuilder: (context, index) {
                    final user = pendingUsers[index];
                    final isOwner = user.type == 'owner';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isOwner 
                                ? Colors.blue.shade100 
                                : Colors.purple.shade100,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: isOwner 
                                          ? Colors.blue.shade100 
                                          : Colors.purple.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isOwner 
                                          ? Icons.business 
                                          : Icons.person,
                                      color: isOwner 
                                          ? Colors.blue.shade700 
                                          : Colors.purple.shade700,
                                      size: 28,
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 16),
                                  
                                  // User info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isOwner 
                                                ? Colors.blue.shade50 
                                                : Colors.purple.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            user.type.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: isOwner 
                                                  ? Colors.blue.shade700 
                                                  : Colors.purple.shade700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              size: 14,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              user.phone,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.cake,
                                              size: 14,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              user.dateOfBirth,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Action buttons
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoading 
                                          ? null 
                                          : () => _handleApprove(user),
                                      icon: const Icon(Icons.check, size: 18),
                                      label: const Text('Approve'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _isLoading 
                                          ? null 
                                          : () => _handleReject(user),
                                      icon: const Icon(Icons.close, size: 18),
                                      label: const Text('Reject'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

