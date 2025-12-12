import 'package:flutter/material.dart';
import '../services/apartments_service.dart';
import '../ui/app_theme.dart';

class ApartmentDetailScreen extends StatelessWidget {
  const ApartmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apartment = ModalRoute.of(context)!.settings.arguments as Apartment;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App bar with back button
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_border, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Image gallery
          SliverToBoxAdapter(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primaryLight.withOpacity(0.9),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.apartment,
                  size: 120,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and location
                  Text(
                    'Apartment in ${apartment.city}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${apartment.city}, ${apartment.province}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(),

                  const SizedBox(height: 24),

                  // Property details
                  Row(
                    children: [
                      _DetailChip(
                        icon: Icons.bed_outlined,
                        label: '${apartment.rooms} rooms',
                      ),
                      const SizedBox(width: 12),
                      _DetailChip(
                        icon: Icons.bathtub_outlined,
                        label: '${apartment.rooms} baths',
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Description section
                  const Text(
                    'About this place',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This beautiful apartment is located in the heart of ${apartment.city}, '
                    'one of Damascus\'s most sought-after neighborhoods. '
                    'Featuring ${apartment.rooms} spacious rooms with modern amenities, '
                    'this property offers comfortable living in a prime location. '
                    'Perfect for families or professionals seeking quality accommodation.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  const Divider(),

                  const SizedBox(height: 24),

                  // Amenities
                  const Text(
                    'What this place offers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AmenityItem(icon: Icons.wifi, label: 'WiFi'),
                  _AmenityItem(icon: Icons.kitchen, label: 'Kitchen'),
                  _AmenityItem(icon: Icons.local_parking, label: 'Free parking'),
                  _AmenityItem(icon: Icons.ac_unit, label: 'Air conditioning'),
                  _AmenityItem(icon: Icons.tv, label: 'TV'),
                  _AmenityItem(icon: Icons.elevator, label: 'Elevator'),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'SYP ${_formatPrice(apartment.monthlyPrice)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          ' / month',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking feature coming soon!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Reserve',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
