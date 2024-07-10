import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';
import 'terminal_controller.dart';
import 'terminal_input.dart';
import '../../themes/theme_interface.dart';

import '../../../globals.dart' as globals;

class Terminal<T extends TerminalController> extends StatefulWidget {
  final ThemeInterface theme;

  const Terminal({super.key, required this.theme});

  @override
  State<Terminal<T>> createState() => _TerminalState<T>();
}

class _TerminalState<T extends TerminalController> extends State<Terminal<T>> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;
  bool _isExpanded = false;
  bool _isScrollToBottomAction = false;
  ScrollDirection _lastScrollDirection = ScrollDirection.idle;

  static const double _minChildSizeValue = 0.4;
  static const double _maxChildSizeValue = 1.0;

  double _minChildSize = _minChildSizeValue;
  double _currentChildSize = _minChildSizeValue;
  double _maxChildSize = _maxChildSizeValue;

  TextSpan _applyFontSize(TextSpan originalTextSpan, double fontSize) {
    return TextSpan(
      text: originalTextSpan.text,
      style: originalTextSpan.style?.copyWith(fontSize: fontSize) ??
          TextStyle(fontSize: fontSize),
      children: originalTextSpan.children?.map((child) {
        if (child is TextSpan) {
          return _applyFontSize(child, fontSize);
        }
        return child;
      }).toList(),
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _currentChildSize = _isExpanded ? _maxChildSize : _minChildSize;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      setState(() {
        _isScrollToBottomAction = true;
      });
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      )
          .then((_) {
        setState(() {
          _isScrollToBottomAction = false;
          _shouldAutoScroll = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal):
            const IncreaseFontSizeIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus):
            const DecreaseFontSizeIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.backquote):
            const ToggleExpandIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          IncreaseFontSizeIntent: CallbackAction<IncreaseFontSizeIntent>(
            onInvoke: (IncreaseFontSizeIntent intent) => _increaseFontSize(),
          ),
          DecreaseFontSizeIntent: CallbackAction<DecreaseFontSizeIntent>(
            onInvoke: (DecreaseFontSizeIntent intent) => _decreaseFontSize(),
          ),
          ToggleExpandIntent: CallbackAction<ToggleExpandIntent>(
            onInvoke: (ToggleExpandIntent intent) => _toggleExpand(),
          ),
        },
        child: DraggableScrollableActuator(
          child: Consumer<T>(
            builder: (context, terminalController, child) {
              return Theme(
                data: widget.theme.themeData,
                child: DraggableScrollableSheet(
                  initialChildSize: _currentChildSize,
                  minChildSize: _minChildSize,
                  maxChildSize: _maxChildSize,
                  builder: (context, sheetScrollController) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_shouldAutoScroll && _scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      }
                    });

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (_isScrollToBottomAction) {
                          return true;
                        }
                        if (scrollNotification is UserScrollNotification) {
                          if (scrollNotification.direction ==
                              ScrollDirection.forward) {
                            /// cancel _shouldAutoScroll if moving forward
                            _shouldAutoScroll = false;
                          } else if (scrollNotification.direction ==
                              ScrollDirection.idle) {
                            /// idle
                            if (_lastScrollDirection ==
                                    ScrollDirection.reverse &&
                                _scrollController.position.pixels ==
                                    _scrollController
                                        .position.maxScrollExtent) {
                              _shouldAutoScroll = true;
                            }
                          }

                          /// update _lastScrollDirection
                          _lastScrollDirection = scrollNotification.direction;
                        }
                        return true;
                      },
                      child: Container(
                        color: widget.theme.background,
                        child: Column(
                          children: [
                            _buildTerminalToolbar(context, terminalController),
                            _buildTerminalOutput(terminalController),
                            TerminalInput<T>(theme: widget.theme),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _increaseFontSize() {
    final terminalController = context.read<T>();
    terminalController.updateFontSize(terminalController.fontSize + 1);
  }

  void _decreaseFontSize() {
    final terminalController = context.read<T>();
    terminalController.updateFontSize(terminalController.fontSize - 1);
  }

  Widget _buildTerminalToolbar(BuildContext context, T terminalController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(_isExpanded ? Icons.fullscreen_exit : Icons.fullscreen),
          onPressed: _toggleExpand,
          tooltip: _isExpanded ? 'Collapse' : 'Expand',
        ),
        IconButton(
          icon: const Icon(Icons.text_increase),
          onPressed: _increaseFontSize,
          tooltip: 'Increase Font Size',
        ),
        IconButton(
          icon: const Icon(Icons.text_decrease),
          onPressed: _decreaseFontSize,
          tooltip: 'Decrease Font Size',
        ),
        IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: _scrollToBottom,
          tooltip: 'Scroll to Bottom',
        ),
        IconButton(
          icon: const Icon(Icons.playlist_remove),
          onPressed: () => terminalController.clear(),
          tooltip: 'Clear all data',
        ),
      ],
    );
  }

  Widget _buildTerminalOutput(T terminalController) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: terminalController.terminalData.length,
          itemBuilder: (context, index) {
            return SelectableText.rich(
              _applyFontSize(
                terminalController.terminalData.data[index],
                terminalController.fontSize,
              ),
            );
          },
        ),
      ),
    );
  }
}

class IncreaseFontSizeIntent extends Intent {
  const IncreaseFontSizeIntent();
}

class DecreaseFontSizeIntent extends Intent {
  const DecreaseFontSizeIntent();
}

class ToggleExpandIntent extends Intent {
  const ToggleExpandIntent();
}
