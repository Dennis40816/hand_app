import 'package:flutter/material.dart';
import 'package:hand_app/states/terminal/terminal_window_settings_state.dart';

class TerminalWindowSettingsInterface extends StatefulWidget {
  final TerminalWindowSettingsParameters initialParameters;
  const TerminalWindowSettingsInterface({
    super.key,
    required this.initialParameters,
  });

  @override
  State<TerminalWindowSettingsInterface> createState() =>
      _TerminalWindowSettingsInterfaceState();
}

class _TerminalWindowSettingsInterfaceState
    extends State<TerminalWindowSettingsInterface> {
  late TextEditingController _maxLinesController;
  late TextEditingController _fontSizeController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _maxLinesController = TextEditingController(
        text: widget.initialParameters.maxLines.toString());
    _fontSizeController = TextEditingController(
        text: widget.initialParameters.fontSize.toString());
  }

  void _validateInputs() {
    try {
      int maxLines = int.parse(_maxLinesController.text);
      double fontSize = double.parse(_fontSizeController.text);
      setState(() {
        _errorText = null;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Invalid number';
      });
    }
  }

  void _onConfirm() {
    try {
      int maxLines = int.parse(_maxLinesController.text);
      if (maxLines > 30000) {
        maxLines = 30000;
      }
      double fontSize = double.parse(_fontSizeController.text);

      Navigator.of(context).pop(
        TerminalWindowSettingsParameters(
          maxLines: maxLines,
          fontSize: fontSize,
        ),
      );
    } catch (e) {
      setState(() {
        _errorText = 'Invalid number';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Font Size'),
              subtitle: TextField(
                controller: _fontSizeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "Enter font size",
                ),
                onChanged: (value) {
                  _validateInputs();
                },
              ),
            ),
            ListTile(
              title: const Text('Max Lines'),
              subtitle: TextField(
                controller: _maxLinesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter max lines (up to 30000)",
                  errorText: _errorText,
                ),
                onChanged: (value) {
                  _validateInputs();
                },
              ),
            ),
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(_errorText!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: _onConfirm,
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
