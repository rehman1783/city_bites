import 'package:flutter/material.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> _notifications = [];

  @override
  void initState() {
    super.initState();
    // placeholder notifications
    _notifications = List.generate(
      6,
      (i) => {
        'title': 'Notification ${i + 1}',
        'body': 'This is a sample notification message #${i + 1}.'
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onSystemBackPressed() async {
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

  Future<void> _refresh() async {
    // simulate refresh
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _onSystemBackPressed,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Notifications', showBackButton: true),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = _notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.notifications, color: Colors.white),
                ),
                title: Text(item['title'] ?? ''),
                subtitle: Text(item['body'] ?? ''),
                onTap: () {},
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: _notifications.length,
          ),
        ),
      ),
    );
  }
}
