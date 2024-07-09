import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'terminal_controller.dart';
import '../../themes/theme_interface.dart';

class Terminal<T extends TerminalController> extends StatefulWidget {
  final ThemeInterface theme;

  const Terminal({super.key, required this.theme});

  @override
  State<Terminal<T>> createState() => _TerminalState<T>();
}

class _TerminalState<T extends TerminalController> extends State<Terminal<T>> {
  ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;
  bool _isExpanded = false;

  static const double minChildSizeValue = 0.3;
  static const double maxChildSizeValue = 1.0;

  double _minChildSize = minChildSizeValue;
  double _currentChildSize = minChildSizeValue;
  double _maxChildSize = maxChildSizeValue;

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

  /// TODO: Change _current, _min, _max child size when drag

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _currentChildSize = _maxChildSize;
      } else {
        _currentChildSize = _minChildSize;
      }
    });
  }

  void _scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      child: Consumer<T>(
        builder: (context, terminalController, child) {
          return Theme(
            data: widget.theme.themeData,
            child: DraggableScrollableSheet(
              initialChildSize: _currentChildSize,
              minChildSize: _minChildSize,
              maxChildSize: _maxChildSize,
              builder: (context, sheetScrollController) {
                _scrollController.addListener(() {
                  if (_scrollController.position.pixels ==
                      _scrollController.position.maxScrollExtent) {
                    _shouldAutoScroll = true;
                  } else {
                    _shouldAutoScroll = false;
                  }
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_shouldAutoScroll && _scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return Container(
                  color: widget
                      .theme.background, // Set background to theme background
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(_isExpanded
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen),
                            onPressed: _toggleExpand,
                            tooltip: _isExpanded ? 'Expand' : 'Collapse',
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_increase),
                            onPressed: () {
                              terminalController.updateFontSize(
                                  terminalController.fontSize + 1);
                            },
                            tooltip: 'Increase Font Size',
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_decrease),
                            onPressed: () {
                              terminalController.updateFontSize(
                                  terminalController.fontSize - 1);
                            },
                            tooltip: 'Decrease Font Size',
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_downward),
                            onPressed: () => _scrollToBottom(_scrollController),
                            tooltip: 'Scroll to Bottom',
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_remove),
                            onPressed: () => terminalController.clear(),
                            tooltip: 'Clear all data',
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          /// Resolve the issue where two-finger scrolling on a touchpad causes the
                          /// terminal's expanded controller to crash.
                          controller: _scrollController,
                          itemCount: terminalController
                              .terminalData.textSpanList.length,
                          itemBuilder: (context, index) {
                            // Use the method to overwrite the fontSize while keeping other styles
                            return SelectableText.rich(
                              _applyFontSize(
                                terminalController
                                    .terminalData.textSpanList[index],
                                terminalController.fontSize,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
