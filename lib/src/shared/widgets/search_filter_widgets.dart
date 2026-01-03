import 'package:flutter/material.dart';

/// Reusable Search Bar Widget
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchBar({
    Key? key,
    required this.controller,
    this.hintText = 'بحث...',
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: () {
                    controller.clear();
                    if (onClear != null) onClear!();
                    if (onChanged != null) onChanged!('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

/// Filter Chip Widget
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.green : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : Colors.grey.shade700,
              ),
              SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade700,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter Bottom Sheet
class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<FilterOption> options;
  final Function(List<String>) onApply;
  final List<String> selectedValues;

  const FilterBottomSheet({
    Key? key,
    required this.title,
    required this.options,
    required this.onApply,
    this.selectedValues = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = List<String>.from(selectedValues);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ...options.map((option) {
                final isSelected = selected.contains(option.value);
                return CheckboxListTile(
                  title: Text(option.label),
                  subtitle: option.subtitle != null ? Text(option.subtitle!, style: TextStyle(fontSize: 11)) : null,
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selected.add(option.value);
                      } else {
                        selected.remove(option.value);
                      }
                    });
                  },
                  activeColor: Colors.green,
                );
              }).toList(),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        onApply([]);
                        Navigator.pop(context);
                      },
                      child: Text('مسح الكل'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        onApply(selected);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('تطبيق', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterOption {
  final String label;
  final String value;
  final String? subtitle;

  FilterOption({
    required this.label,
    required this.value,
    this.subtitle,
  });
}

/// Sort Options Bottom Sheet
class SortBottomSheet extends StatelessWidget {
  final List<SortOption> options;
  final String? selectedValue;
  final Function(String) onSelect;

  const SortBottomSheet({
    Key? key,
    required this.options,
    this.selectedValue,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ترتيب حسب',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...options.map((option) {
            final isSelected = selectedValue == option.value;
            return ListTile(
              leading: Icon(option.icon, color: isSelected ? Colors.green : Colors.grey),
              title: Text(
                option.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green : Colors.black,
                ),
              ),
              trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                onSelect(option.value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class SortOption {
  final String label;
  final String value;
  final IconData icon;

  SortOption({
    required this.label,
    required this.value,
    required this.icon,
  });
}
