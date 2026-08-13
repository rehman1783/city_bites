import 'dart:convert';

import 'package:city_bites/src/core/constants/app_constants.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final List<String> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList('saved_user_addresses') ?? [];
      final addresses = raw
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .whereType<Map<String, dynamic>>()
          .map((item) => (item['label'] ?? '') as String)
          .where((item) => item.trim().isNotEmpty)
          .toList();

      setState(() {
        _addresses
          ..clear()
          ..addAll(addresses.isNotEmpty ? addresses : [AppConstants.defaultLocation]);
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _addresses
          ..clear()
          ..add(AppConstants.defaultLocation);
        _isLoading = false;
      });
    }
  }

  Future<void> _addAddress() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new address'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter Sahiwal address',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_user_addresses') ?? [];
    final updated = List<String>.from(saved);
    updated.add(jsonEncode({'label': result.trim()}));
    await prefs.setStringList('saved_user_addresses', updated);

    setState(() {
      _addresses.add(result.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved Addresses',
        actions: [
          IconButton(
            onPressed: _addAddress,
            icon: const Icon(Icons.add_location_alt_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? const Center(child: Text('No saved addresses found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(28),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(address),
                        subtitle: const Text('Saved from your local device storage'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final raw = prefs.getStringList('saved_user_addresses') ?? [];
                            final remaining = raw.where((item) {
                              final decoded = jsonDecode(item) as Map<String, dynamic>;
                              return (decoded['label'] ?? '') != address;
                            }).toList();

                            await prefs.setStringList('saved_user_addresses', remaining);
                            setState(() {
                              _addresses.removeAt(index);
                              if (_addresses.isEmpty) {
                                _addresses.add(AppConstants.defaultLocation);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
