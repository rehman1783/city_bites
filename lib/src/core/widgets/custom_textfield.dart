import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool isCompact;
  final double? height;
  final int? maxLines;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.isCompact = false,
    this.height,
    this.maxLines,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final compact = widget.isCompact;
    final fieldHeight = widget.height ?? (compact ? 36.0 : 50.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact) ...[
          Text(
            widget.labelText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          height: fieldHeight,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines ?? 1,
            validator: widget.validator,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            style: compact
                ? theme.textTheme.bodySmall
                : theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText: widget.hintText,
              hintStyle: compact ? theme.textTheme.bodySmall : null,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: compact ? 18 : 20)
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: compact ? 18 : 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(compact ? 8 : 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
