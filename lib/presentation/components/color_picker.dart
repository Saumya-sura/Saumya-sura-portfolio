import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';
import '../../providers/phone_state_provider.dart';
import 'color_picker_circle.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, this.isPopup = false});

  final bool isPopup;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  int _activeTab = 0; // 0: Curated, 1: Classic

  // Curated Aesthetic Palettes tailored for modern dark mode portfolios
  final List<Map<String, dynamic>> _curatedPalettes = [
    {'name': 'Electric Blue', 'color': const Color(0xFF2563EB)},
    {'name': 'Cyber Purple', 'color': const Color(0xFF8B5CF6)},
    {'name': 'Neon Cyan', 'color': const Color(0xFF06B6D4)},
    {'name': 'Emerald Matrix', 'color': const Color(0xFF10B981)},
    {'name': 'Sunset Amber', 'color': const Color(0xFFF59E0B)},
    {'name': 'Crimson Rose', 'color': const Color(0xFFF43F5E)},
    {'name': 'Deep Space', 'color': const Color(0xFF4F46E5)},
    {'name': 'Mystic Violet', 'color': const Color(0xFFA855F7)},
    {'name': 'Midnight Slate', 'color': const Color(0xFF334155)},
    {'name': 'Tangerine Glow', 'color': const Color(0xFFEA580C)},
    {'name': 'Toxic Lime', 'color': const Color(0xFF84CC16)},
    {'name': 'Hot Magenta', 'color': const Color(0xFFEC4899)},
  ];

  // The 12 Original Classic Material Colors preserved
  final List<Map<String, dynamic>> _classicColors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Cyan', 'color': Colors.cyan},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Indigo', 'color': Colors.indigo},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Brown', 'color': Colors.brown},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'Black', 'color': Colors.black},
  ];

  void _selectColor(Color color, String name) {
    context.read<ColorProvider>().setColor(color, name);

    // Announce the theme change via the Interactive Dynamic Island!
    try {
      context.read<PhoneStateProvider>().triggerNotification(
            title: '🎨 Theme Changed',
            subtitle: '$name palette applied',
            icon: Icons.palette_rounded,
            iconColor: color,
            duration: const Duration(seconds: 4),
          );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = context.watch<ColorProvider>().color;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: !widget.isPopup
              ? MediaQuery.of(context).size.width * 0.22
              : MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.color_lens_rounded,
                  size: 20,
                  color: currentColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Theme Studio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Segmented Tab Switcher (Curated vs Classic)
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      label: "Curated",
                      isSelected: _activeTab == 0,
                      onTap: () => setState(() => _activeTab = 0),
                    ),
                  ),
                  Expanded(
                    child: _buildTabButton(
                      label: "Classic",
                      isSelected: _activeTab == 1,
                      onTap: () => setState(() => _activeTab = 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Color Grid
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _activeTab == 0
                  ? _buildColorGrid(_curatedPalettes, currentColor)
                  : _buildColorGrid(_classicColors, currentColor),
            ),
            const SizedBox(height: 8),

            // Active Theme Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: currentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: currentColor.withOpacity(0.4)),
              ),
              child: Text(
                context.watch<ColorProvider>().colorName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? context.watch<ColorProvider>().color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? (context.watch<ColorProvider>().color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)
                : Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildColorGrid(List<Map<String, dynamic>> colorsList, Color currentColor) {
    return GridView.builder(
      key: ValueKey<int>(_activeTab),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: colorsList.length,
      itemBuilder: (context, index) {
        final item = colorsList[index];
        final Color col = item['color'];
        final String name = item['name'];
        final isSelected = currentColor.value == col.value;

        return Tooltip(
          message: name,
          child: ColorPickerCircle(
            color: col,
            isSelected: isSelected,
            onTap: () => _selectColor(col, name),
          ),
        );
      },
    );
  }
}
