import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../ui/app_theme.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _priceController = TextEditingController();
  final _roomsController = TextEditingController();
  
  final _picker = ImagePicker();
  XFile? _apartmentImage;
  bool _loading = false;

  @override
  void dispose() {
    _cityController.dispose();
    _provinceController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _apartmentImage = file);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_apartmentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an apartment photo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    // TODO: Implement API call to add apartment
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apartment listed successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('List your place'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a new listing',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Share your space with renters',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Image picker
                const Text(
                  'Photos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _apartmentImage != null
                        ? Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 48,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _apartmentImage!.name,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() => _apartmentImage = null);
                                  },
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add photos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tap to upload',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // Location section
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Province',
                    hintText: 'e.g., Damascus',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City/Neighborhood',
                    hintText: 'e.g., Mazzeh',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Property details
                const Text(
                  'Property details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _roomsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of rooms',
                    hintText: 'e.g., 3',
                    prefixIcon: Icon(Icons.bed),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of rooms';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Pricing
                const Text(
                  'Pricing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Monthly rent (SYP)',
                    hintText: 'e.g., 450000',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter monthly rent';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 48),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _handleSubmit,
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Publish listing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

