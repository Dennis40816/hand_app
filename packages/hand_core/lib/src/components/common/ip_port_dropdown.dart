import 'package:flutter/material.dart';

class IpPort {
  final String ip;
  final int port;

  IpPort(this.ip, this.port);

  @override
  String toString() {
    return '$ip:$port';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IpPort) return false;
    return ip == other.ip && port == other.port;
  }

  @override
  int get hashCode => ip.hashCode ^ port.hashCode;
}

class IpPortDropdown extends StatefulWidget {
  final List<IpPort> ipPortList;

  const IpPortDropdown({super.key, required this.ipPortList});

  @override
  State<IpPortDropdown> createState() => _IpPortDropdownState();
}

class _IpPortDropdownState extends State<IpPortDropdown> {
  IpPort? selectedIpPort;

  IpPort? getCurrentIpPort() {
    return selectedIpPort;
  }

  void appendIpPort(String ip, int port) {
    IpPort newIpPort = IpPort(ip, port);
    if (!widget.ipPortList.contains(newIpPort)) {
      setState(() {
        widget.ipPortList.add(newIpPort);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP and Port combination already exists')),
      );
    }
  }

  void removeIpPortByIndex(int index) {
    if (index >= 0 && index < widget.ipPortList.length) {
      setState(() {
        widget.ipPortList.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Index out of range')),
      );
    }
  }

  void removeIpPortByValue(String ip, int port) {
    int index = widget.ipPortList
        .indexWhere((element) => element.ip == ip && element.port == port);
    if (index != -1) {
      setState(() {
        widget.ipPortList.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('IP and Port combination not found')),
      );
    }
  }

  int searchIpPort(String ip, int port) {
    return widget.ipPortList
        .indexWhere((element) => element.ip == ip && element.port == port);
  }

  void _showAddDialog(BuildContext context) {
    String ip = '';
    int port = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add IP and Port'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'IP Address'),
                onChanged: (value) {
                  ip = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  port = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                appendIpPort(ip, port);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context, IpPort ipPort) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Removal'),
          content: Text(
              'Are you sure you want to remove ${ipPort.ip}:${ipPort.port}?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                removeIpPortByValue(ipPort.ip, ipPort.port);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<IpPort>(
                  value: selectedIpPort,
                  hint: Text(
                    widget.ipPortList.isEmpty
                        ? 'Add IP address...'
                        : 'Select IP and Port',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  dropdownColor: Colors.blue,
                  onChanged: widget.ipPortList.isEmpty
                      ? null
                      : (IpPort? newValue) {
                          setState(() {
                            selectedIpPort = newValue;
                          });
                        },
                  items: widget.ipPortList
                      .map<DropdownMenuItem<IpPort>>((IpPort value) {
                    return DropdownMenuItem<IpPort>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${value.ip}:${value.port}',
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              _showRemoveDialog(context, value);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.grey),
              onPressed: () {
                _showAddDialog(context);
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Selected IP and Port: ${getCurrentIpPort()?.toString() ?? 'No available item!'}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 16),
  //               decoration: BoxDecoration(
  //                 color: Colors.blue,
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: DropdownButton<IpPort>(
  //                 value: selectedIpPort,
  //                 hint: Text(
  //                   widget.ipPortList.isEmpty
  //                       ? 'Add IP address...'
  //                       : 'Select IP and Port',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //                 icon: Icon(Icons.arrow_drop_down, color: Colors.white),
  //                 dropdownColor: Colors.blue,
  //                 underline: Container(),
  //                 onChanged: widget.ipPortList.isEmpty
  //                     ? null
  //                     : (IpPort? newValue) {
  //                         setState(() {
  //                           selectedIpPort = newValue;
  //                         });
  //                       },
  //                 items: widget.ipPortList
  //                     .map<DropdownMenuItem<IpPort>>((IpPort value) {
  //                   return DropdownMenuItem<IpPort>(
  //                     value: value,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           '${value.ip}:${value.port}',
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         IconButton(
  //                           icon: Icon(Icons.close, color: Colors.white),
  //                           onPressed: () {
  //                             _showRemoveDialog(context, value);
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.add_circle, color: Colors.grey),
  //             onPressed: () {
  //               _showAddDialog(context);
  //             },
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 20),
  //       Text(
  //         'Selected IP and Port: ${getCurrentIpPort()?.toString() ?? 'No available item!'}',
  //         style: TextStyle(fontSize: 16),
  //       )
  //     ],
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Text(
  //     "Test",
  //     style: TextStyle(
  //       color: Colors.white,
  //     ),
  //   );
  // }
}
