import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RatingDialog extends StatefulWidget {
  final String orderId;
  final Function(int rating, String comment) onSubmit;

  const RatingDialog({
    super.key,
    required this.orderId,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.ratingGold.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_rounded,
              color: AppColors.ratingGold,
              size: 44,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Rate Your Meal',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Order #${widget.orderId}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'How was your food experience in Sahiwal?',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 1 to 5 Star Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _selectedRating;

              return IconButton(
                icon: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled ? AppColors.ratingGold : theme.disabledColor,
                  size: 36,
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = starIndex;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Add comments or feedback (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_selectedRating, _commentController.text);
            Navigator.pop(context);
          },
          child: const Text('Submit Rating'),
        ),
      ],
    );
  }
}
