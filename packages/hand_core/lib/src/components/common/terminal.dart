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
  final ScrollController _scrollController = ScrollController();
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
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();

    /// add auto scroll state listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _shouldAutoScroll = true;
      } else {
        _shouldAutoScroll = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, terminalController, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_shouldAutoScroll) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });

        return Theme(
          data: widget.theme.themeData,
          child: Container(
            color:
                widget.theme.background, // Set background to theme background
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
                        terminalController
                            .updateFontSize(terminalController.fontSize + 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.text_decrease),
                      onPressed: () {
                        terminalController
                            .updateFontSize(terminalController.fontSize - 1);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: _scrollToBottom,
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: _isExpanded
                        ? double.infinity
                        : MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          terminalController.terminalData.textSpanList.length,
                      itemBuilder: (context, index) {
                        // Use the method to overwrite the fontSize while keeping other styles
                        return SelectableText.rich(
                          _applyFontSize(
                            terminalController.terminalData.textSpanList[index],
                            terminalController.fontSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
