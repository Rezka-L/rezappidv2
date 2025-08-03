import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/game.dart';

class TopUpPage extends StatefulWidget {
  final Game game;

  const TopUpPage({super.key, required this.game});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _idController = TextEditingController();
  String? _selectedDiamond;
  String? _selectedPayment;

  List<String> getDiamondOptions() {
    switch (widget.game.id) {
      case 'ml':
        return ['86 ð', '172 ð', '257 ð', '344 ð'];
      case 'ff':
        return ['100 ð', '210 ð', '530 ð', '720 ð'];
      case 'pubgm':
        return ['60 UC', '180 UC', '600 UC', '960 UC'];
      default:
        return ['100', '200', '500'];
    }
  }

  List<String> paymentMethods = [
    'QRIS',
    'Dana',
    'OVO',
    'Gopay',
    'ShopeePay',
    'Transfer Bank',
  ];

  void _goToCheckout() {
    if (_idController.text.isEmpty ||
        _selectedDiamond == null ||
        _selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data dulu ya!')),
      );
      return;
    }

    context.go('/checkout', extra: {
      'game': widget.game,
      'playerId': _idController.text,
      'diamond': _selectedDiamond,
      'payment': _selectedPayment,
    });
  }

  @override
  Widget build(BuildContext context) {
    final diamondOptions = getDiamondOptions();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up ${widget.game.name}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(widget.game.image, height: 180),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Player ID',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Pilih Nominal', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: diamondOptions.map((option) {
                final selected = _selectedDiamond == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _selectedDiamond = option;
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                  backgroundColor: Colors.grey.shade200,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Metode Pembayaran',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              value: _selectedPayment,
              items: paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _goToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Lanjut Checkout', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
   