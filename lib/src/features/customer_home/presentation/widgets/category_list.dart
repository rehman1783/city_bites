import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_cubit.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.categories.length,
            itemBuilder: (context, index) {
              final cat = AppConstants.categories[index];
              final categoryName = cat['name']!;
              final icon = cat['icon']!;
              final isSelected = state.selectedCategory == categoryName;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  showCheckmark: false,
                  avatar: Text(icon, style: const TextStyle(fontSize: 16)),
                  label: Text(
                    categoryName,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.brightness == Brightness.dark
                      ? theme.colorScheme.surfaceContainerHighest.withAlpha(80)
                      : Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withAlpha(50),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<HomeCubit>().selectCategory(categoryName);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
