import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class LocationPickerScreen extends StatefulWidget {
  final String initialLocation;

  const LocationPickerScreen({super.key, this.initialLocation = ''});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _controller = TextEditingController();
  String _selectedLocation = '';
  late List<String> _filteredLocations;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _controller.text = _selectedLocation;
    _filteredLocations = AppConstants.sahiwalLocations;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Future<bool> onSystemBackPressed() async {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        FocusScope.of(context).unfocus();
        return false;
      }
      if (_scrollController.hasClients && _scrollController.offset > 0) {
        setState(() {});
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        return false;
      }
      return true;
    }

    return WillPopScope(
      onWillPop: onSystemBackPressed,
      child: Scaffold(
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
                hintText: 'Type a street, colony or landmark',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                  _filteredLocations = AppConstants.sahiwalLocations
                      .where(
                        (address) =>
                            address.toLowerCase().contains(value.toLowerCase()),
                      )
                      .toList();
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
              child: _filteredLocations.isEmpty
                  ? Center(
                      child: Text(
                        'No matching locations found.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView(
                      controller: _scrollController,
                      children: _filteredLocations.map((address) {
                        return ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text(address),
                          onTap: () {
                            _controller.text = address;
                            setState(() {
                              _selectedLocation = address;
                              _filteredLocations = AppConstants.sahiwalLocations
                                  .where(
                                    (item) => item.toLowerCase().contains(
                                      address.toLowerCase(),
                                    ),
                                  )
                                  .toList();
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
      ),
    );
  }
}
