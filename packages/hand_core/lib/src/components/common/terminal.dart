import 'package:flutter/material.dart';
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
  bool _shouldAutoScroll = true;
  bool _isExpanded = false;

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
      // 更新 DraggableScrollableSheet 的大小
      DraggableScrollableActuator.reset(context);
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      child: Consumer<T>(
        builder: (context, terminalController, child) {
          return Theme(
            data: widget.theme.themeData,
            child: DraggableScrollableSheet(
              initialChildSize: _isExpanded ? 1.0 : 0.3,
              minChildSize: 0.1,
              maxChildSize: 1.0,
              builder: (context, sheetScrollController) {
                sheetScrollController.addListener(() {
                  if (sheetScrollController.position.pixels ==
                      sheetScrollController.position.maxScrollExtent) {
                    _shouldAutoScroll = true;
                  } else {
                    _shouldAutoScroll = false;
                  }
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_shouldAutoScroll && sheetScrollController.hasClients) {
                    sheetScrollController.animateTo(
                      sheetScrollController.position.maxScrollExtent,
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
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_increase),
                            onPressed: () {
                              terminalController.updateFontSize(
                                  terminalController.fontSize + 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_decrease),
                            onPressed: () {
                              terminalController.updateFontSize(
                                  terminalController.fontSize - 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_downward),
                            onPressed: () =>
                                _scrollToBottom(sheetScrollController),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: sheetScrollController,
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
