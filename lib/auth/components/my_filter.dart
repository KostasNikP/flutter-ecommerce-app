import 'package:shop_app/auth/pages/shop_filter_Page.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CustomfilterBar extends StatelessWidget {
  const CustomfilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Dialog(
                insetPadding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  height: 400,
                  padding: const EdgeInsets.all(20),
                  child: const FilterOptions(),
                ),
              ),
            );
          },
        );
      },
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class FilterOptions extends StatefulWidget {
  const FilterOptions({super.key});

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;

  Widget _buildCheckRow(IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        Checkbox(
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
          checkColor: Theme.of(context).colorScheme.surface,  // tick
          side: BorderSide(         
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Filter options',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckRow(Icons.phone_iphone, _isChecked1, (v) => setState(() => _isChecked1 = v!)),
            const SizedBox(height: 10),
            _buildCheckRow(Icons.laptop_mac, _isChecked2, (v) => setState(() => _isChecked2 = v!)),
            const SizedBox(height: 10),
            _buildCheckRow(Icons.tablet_mac, _isChecked3, (v) => setState(() => _isChecked3 = v!)),
            const SizedBox(height: 10),
            _buildCheckRow(Icons.watch_sharp, _isChecked4, (v) => setState(() => _isChecked4 = v!)),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopFilterPage(
                    isChecked1: _isChecked1,
                    isChecked2: _isChecked2,
                    isChecked3: _isChecked3,
                    isChecked4: _isChecked4,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
              'Done',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
