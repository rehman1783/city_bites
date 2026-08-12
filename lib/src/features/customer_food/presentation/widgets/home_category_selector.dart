import 'package:flutter/material.dart';

class HomeCategorySelector extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const HomeCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 95,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = selectedCategory == cat['id'];
              return GestureDetector(
                onTap: () => onSelectCategory(cat['id']!),
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withAlpha(80),
                                    blurRadius: 8,
                                  )
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            cat['icon']!,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name']!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
