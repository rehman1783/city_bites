import 'package:flutter/material.dart';

enum UserRole { customer, owner, admin }

class RoleToggleButton extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onRoleChanged;

  const RoleToggleButton({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRoleItem(
            context,
            role: UserRole.customer,
            label: 'Customer',
            icon: Icons.person_outline,
          ),
          _buildRoleItem(
            context,
            role: UserRole.owner,
            label: 'Owner',
            icon: Icons.storefront_outlined,
          ),
          _buildRoleItem(
            context,
            role: UserRole.admin,
            label: 'Admin',
            icon: Icons.admin_panel_settings_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleItem(
    BuildContext context, {
    required UserRole role,
    required String label,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => onRoleChanged(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(80),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurfaceVariant,
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
