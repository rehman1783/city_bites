import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/constants/asset_paths.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_button.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import '../bloc/owner_menu_bloc.dart';

class OwnerAddFoodScreen extends StatefulWidget {
  final VoidCallback onSaved;
  final VoidCallback? onBack;

  const OwnerAddFoodScreen({
    super.key,
    required this.onSaved,
    this.onBack,
  });

  @override
  State<OwnerAddFoodScreen> createState() => _OwnerAddFoodScreenState();
}

class _OwnerAddFoodScreenState extends State<OwnerAddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Fast Food';
  final List<Map<String, dynamic>> _variants = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Food Item',
        onBack: widget.onBack,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker Container Box Preview
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Image Selected from Gallery!')),
                  );
                },
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withAlpha(80),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to Upload Dish Banner Image',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Inputs
              CustomTextField(
                controller: _nameController,
                labelText: 'Item Name',
                hintText: 'e.g. Special Chicken Cheese Burger',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter dish name' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _descController,
                labelText: 'Description',
                hintText: 'Describe ingredients, preparation style...',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _priceController,
                labelText: 'Price (PKR)',
                hintText: 'e.g. 450',
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),

              Text(
                'Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(),
                items: ['Biryani', 'Fast Food', 'Pizza', 'Karahi', 'Desserts']
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Add-on Variants Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add-on Variants / Options',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _variants.add({'title': 'Extra Cheese', 'price': 80.0});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Variant'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._variants.map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CustomCard(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${v['title']} (+ PKR ${v['price']})'),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _variants.remove(v);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Bottom Save CTA
              CustomButton(
                text: 'Save Item to Menu',
                icon: Icons.save_outlined,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<OwnerMenuBloc>().addFoodItem({
                      'id': 'dish_${DateTime.now().millisecondsSinceEpoch}',
                      'name': _nameController.text.trim(),
                      'category': _selectedCategory,
                      'price': double.tryParse(_priceController.text) ?? 400.0,
                      'isAvailable': true,
                      'image': AssetPaths.zingerBurger,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item Saved to Menu!')),
                    );
                    widget.onSaved();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
