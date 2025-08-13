import 'package:flutter/material.dart';
import 'package:portfolio_website/presentation/components/color_picker_circle.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, this.isPopup = false});

  final bool isPopup;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ColorProvider>().setColor(Colors.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: !widget.isPopup
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.5,
        ),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
          ),
          shrinkWrap: true,
          children: [
            ColorPickerCircle(
              color: Colors.red,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.red);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.red,
            ),
            ColorPickerCircle(
              color: Colors.orange,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.orange);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.orange,
            ),
            ColorPickerCircle(
              color: Colors.yellow,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.yellow);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.yellow,
            ),
            ColorPickerCircle(
              color: Colors.green,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.green);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.green,
            ),
            ColorPickerCircle(
              color: Colors.cyan,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.cyan);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.cyan,
            ),
            ColorPickerCircle(
              color: Colors.blue,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.blue);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.blue,
            ),
            ColorPickerCircle(
              color: Colors.indigo,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.indigo);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.indigo,
            ),
            ColorPickerCircle(
              color: Colors.purple,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.purple);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.purple,
            ),
            ColorPickerCircle(
              color: Colors.pink,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.pink);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.pink,
            ),
            ColorPickerCircle(
              color: Colors.brown,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.brown);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.brown,
            ),
            ColorPickerCircle(
              color: Colors.grey,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.grey);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.grey,
            ),
            ColorPickerCircle(
              color: Colors.black,
              onTap: () {
                setState(() {
                  context.read<ColorProvider>().setColor(Colors.black);
                });
              },
              isSelected: context.watch<ColorProvider>().color == Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
