import 'package:flutter/material.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onSystemBackPressed,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Order Status'),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Orders',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('No active orders.'),
                      SizedBox(height: 6),
                      Text(
                        'Track the live status of your ongoing orders here.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
