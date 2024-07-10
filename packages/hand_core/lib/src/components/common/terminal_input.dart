import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'terminal_controller.dart';
import '../../themes/theme_interface.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

import '../../../globals.dart' as globals;

class TerminalInput<T extends TerminalController> extends StatefulWidget {
  final ThemeInterface theme;

  TerminalInput({super.key, required this.theme});

  @override
  State<TerminalInput<T>> createState() => _TerminalInputState<T>();
}

/// TODO: make this class with ChangeNotifier
class _TerminalInputState<T extends TerminalController>
    extends State<TerminalInput<T>> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _prefix = "> ";

  void changePrefix(String newPrefix) {
    setState(() {
      _prefix = newPrefix;
    });
  }

  void _handleSubmit(String input) {
    if (input.isNotEmpty) {
      final textSpan = TextSpan(
        text: [_prefix, input].join(),
        style: TextStyle(color: widget.theme.foreground),
      );

      /// this function will call notify
      context.read<T>().addTerminalInput(textSpan);

      /// TODO: Remove this after Implement functionality to navigate through
      /// command history using the up and down arrow keys.
      _inputController.clear();
    }

    /// require focus after submit
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _inputController,
      decoration: InputDecoration(
        /// This would compact the height
        isDense: true,
        border: NonUniformOutlineInputBorder(
          hideLeftSide: true,
          hideRightSide: true,
          hideBottomSide: true,
          borderSide: BorderSide(
            color: widget.theme.foreground,
          ),
          borderRadius: BorderRadius.zero,
        ),
        contentPadding: const EdgeInsets.all(8.0),
        hintText: 'Enter command...',
        fillColor: Colors.transparent,
        filled: true,
      ),
      style: TextStyle(color: widget.theme.foreground),
      focusNode: _focusNode,
      onSubmitted: _handleSubmit,
    );
  }
}
