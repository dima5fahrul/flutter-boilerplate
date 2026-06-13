import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Tools')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: ChuckerFlutter.showChuckerScreen,
            child: const Text('Open HTTP Inspector'),
          ),
        ],
      ),
    );
  }
}
