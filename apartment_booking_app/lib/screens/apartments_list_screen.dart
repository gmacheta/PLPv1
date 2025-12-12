import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/apartments_service.dart';
import '../services/auth_service.dart';
import '../ui/app_theme.dart';

class ApartmentsListScreen extends StatefulWidget {
  const ApartmentsListScreen({super.key});

  @override
  State<ApartmentsListScreen> createState() => _ApartmentsListScreenState();
}

class _ApartmentsListScreenState extends State<ApartmentsListScreen> {
  late Future<List<Apartment>> _future;

  @override
  void initState() {
    super.initState();
    _future = apartmentsService.fetchAll();
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home, color: AppColors.primary, size: 32),
            const SizedBox(width: 8),
            const Text(
              'Bayti',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Add listing button in app bar
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add-apartment');
            },
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text(
              'List property',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add-apartment');
        },
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'List your place',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 6,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Apartment>>(
          future: _future,
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
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading apartments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            final apartments = snapshot.data ?? [];
            if (apartments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apartment,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No apartments available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new listings',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Damascus',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${apartments.length} amazing places to stay',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid of apartments
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final apartment = apartments[index];
                        return _ApartmentCard(apartment: apartment);
                      },
                      childCount: apartments.length,
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const _ApartmentCard({required this.apartment});

  // Generate unique gradient based on apartment ID
  List<Color> _getGradientColors() {
    final colors = [
      [const Color(0xFF346B7A), const Color(0xFF5FB1C4)], // Teal
      [const Color(0xFF4A7C8A), const Color(0xFF6FCDDA)], // Light teal
      [const Color(0xFF2C5F6F), const Color(0xFF4A9BAC)], // Deep teal
      [const Color(0xFF5B8C9A), const Color(0xFF7FC8D9)], // Sky teal
      [const Color(0xFF3A6B7A), const Color(0xFF5AA8BC)], // Ocean teal
    ];
    return colors[apartment.id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/apartment-detail',
          arguments: apartment,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder image with unique gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _getGradientColors(),
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ApartmentPatternPainter(),
                          ),
                        ),
                        // Icon
                        Center(
                          child: Icon(
                            Icons.apartment,
                            size: 64,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Favorite button (top-right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location
                  Text(
                    '${apartment.city}, ${apartment.province}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Rooms
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${apartment.rooms} ${apartment.rooms == 1 ? 'room' : 'rooms'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Price
                  Row(
                    children: [
                      Text(
                        'SYP ${_formatPrice(apartment.monthlyPrice)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' /mo',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
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
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }
}

// Custom painter for decorative pattern on apartment cards
class _ApartmentPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw window-like rectangles
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 3; j++) {
        final rect = Rect.fromLTWH(
          size.width * 0.15 + (i * size.width * 0.2),
          size.height * 0.2 + (j * size.height * 0.25),
          size.width * 0.08,
          size.height * 0.08,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
