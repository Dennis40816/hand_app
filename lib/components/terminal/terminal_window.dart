import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hand_core/hand_core.dart';

import 'package:hand_app/states/log/log_data_state.dart';
import 'package:hand_app/components/terminal/terminal_window_settings_interface.dart';
import 'package:hand_app/states/terminal/terminal_window_settings_state.dart';
import 'package:hand_app/themes/theme_interface.dart';

class TerminalWindow extends StatefulWidget {
  final ThemeInterface theme;

  const TerminalWindow({super.key, required this.theme});

  @override
  State<TerminalWindow> createState() => _TerminalWindowState();
}

class _TerminalWindowState extends State<TerminalWindow> {
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;
  double _initialChildSize = 0.5;
  double _lineHeight = 3.0;
  final double _expandedLineHeight = 6.0;
  bool _autoScroll = true;
  double _fontSize = 16.0; // 管理字體大小

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _autoScroll = true;
        });
      } else {
        setState(() {
          _autoScroll = false;
        });
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _initialChildSize = _isExpanded ? 1.0 : 0.5;
      DraggableScrollableActuator.reset(context);
    });
  }

  void _setChildSize(double size) {
    setState(() {
      _initialChildSize = size;
      DraggableScrollableActuator.reset(context);
    });
  }

  void _showSettingsDialog() {
    /// XXX: LogDataState<LogMessage, LogLevel>
    final logDataState =
        context.read<LogDataState<HandMainLogMessage, HandMainLogLevel>>();
    final settingsParameters = TerminalWindowSettingsParameters(
      maxLines: logDataState.maxLines,
      fontSize: _fontSize,
    );

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TerminalWindowSettingsInterface(
          initialParameters: settingsParameters,
        ),
      ),
    )
        .then((value) {
      if (value is TerminalWindowSettingsParameters) {
        setState(() {
          _fontSize = value.fontSize;
          logDataState.setMaxLines(value.maxLines);
        });
      }
    });
  }

  Color _getColor(String levelString) {
    switch (levelString) {
      case 'ERROR':
        return widget.theme.red;
      case 'WARN':
        return widget.theme.yellow;
      case 'INFO':
        return widget.theme.green;
      case 'DEBUG':
        return widget.theme.blue;
      case 'VERBOSE':
        return widget.theme.cyan;
      default:
        return widget.theme.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableActuator(
      child: DraggableScrollableSheet(
        initialChildSize: _initialChildSize,
        minChildSize: 0.3,
        maxChildSize: 1.0,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.black,
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    _setChildSize((_initialChildSize -
                            details.primaryDelta! /
                                MediaQuery.of(context).size.height)
                        .clamp(0.3, 1.0));
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    onEnter: (_) {
                      setState(() {
                        _lineHeight = _expandedLineHeight;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _lineHeight = 2.0;
                      });
                    },
                    child: Container(
                      height: _lineHeight,
                      alignment: Alignment.bottomCenter,
                      color: Colors.transparent,
                      child: Container(
                        height: _lineHeight,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'Expand/Collapse',
                      child: IconButton(
                        icon: Icon(
                          _isExpanded
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Colors.white,
                        ),
                        onPressed: _toggleExpand,
                      ),
                    ),
                    Tooltip(
                      message: 'Scroll to Bottom',
                      child: IconButton(
                        icon: Icon(Icons.vertical_align_bottom_rounded,
                            color: widget.theme.white),
                        onPressed: _scrollToBottom,
                      ),
                    ),
                    Tooltip(
                      message: 'Settings',
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: _showSettingsDialog,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  /// XXX: Change to Consumer<LogDataState<LogMessage, LogLevel>>
                  child: Consumer<
                      LogDataState<HandMainLogMessage, HandMainLogLevel>>(
                    builder: (context, logDataState, child) {
                      if (_autoScroll) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: logDataState.logMessages.length,
                        itemBuilder: (context, index) {
                          final logMessage = logDataState.logMessages[index];
                          return SelectableText.rich(
                            TextSpan(
                              text: logMessage.toString(),
                              style: TextStyle(
                                color: _getColor(logMessage.getLevelString()),
                                fontSize: _fontSize,
                              ),
                            ),
                          );
                        },
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
  }
}
