import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedLocation = AppConstants.defaultLocation;

  @override
  void initState() {
    super.initState();
    _controller.text = _selectedLocation;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter or pick your delivery address',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Delivery address',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Suggested addresses',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: AppConstants.sahiwalLocations.map((address) {
                  return ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(address),
                    onTap: () {
                      _controller.text = address;
                      setState(() {
                        _selectedLocation = address;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _selectedLocation.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(_selectedLocation),
              icon: const Icon(Icons.check),
              label: const Text('Use this location'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
