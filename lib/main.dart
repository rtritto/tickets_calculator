import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Tickets Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double ticketPrice = 9.3;
  List<Item> items = [Item()];
  double total = 0;
  int ticketNum = 0;

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _addItem() {
    setState(() {
      items.add(Item());
    });
  }

  double _calculateTotal() {
    double sum = 0;
    items
        .map((item) => item.price)
        .where((price) => price != null)
        .forEach((double? e) => sum += e!);
    return sum;
  }

  int _calculateTicketNum() {
    return (total / ticketPrice).floor();
  }

  double _calculateDiff() {
    return double.parse((total - (ticketNum * ticketPrice)).toStringAsFixed(2));
  }

  void _handleOnChange(String value, int index) {
    setState(() {
      items[index].price = value.isEmpty == true ? null : double.parse(value);
      total = _calculateTotal();
      ticketNum = _calculateTicketNum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(213, 15, 88, 147),
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // GridView.count(
            //   shrinkWrap: true,
            //   crossAxisCount: 2,
            //   childAspectRatio: 2.0,
            //   children: List.generate(items.length, (index) {
            //     return ListTile(
            //       leading: const Icon(Icons.radio_button_unchecked),
            //       title: TextField(
            //           keyboardType:
            //               const TextInputType.numberWithOptions(decimal: true),
            //           inputFormatters: [
            //             FilteringTextInputFormatter.allow(
            //                 RegExp(r'^\d+\.?\d{0,2}')),
            //           ],
            //           onChanged: (value) {
            //             items[index].price =
            //                 value.isEmpty == true ? null : double.parse(value);
            //             total = _calculateTotal();
            //             ticketNum = _calculateTicketNum();
            //             setState(() {});
            //           }),
            //       trailing: IconButton(
            //         onPressed: () {
            //           _removeItem(index);
            //         },
            //         tooltip: 'Delete item',
            //         icon: const Icon(Icons.delete),
            //       ),
            //     );
            //   }),
            // ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.radio_button_unchecked),
                  title: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: (value) => _handleOnChange(value, index),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _removeItem(index);
                    },
                    tooltip: 'Delete item',
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
            const Text('Totale:'),
            Text(
              '$total€',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text('Differenza:'),
            Text(
              '${_calculateDiff().toString()}€',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text('# ticket:'),
            Text(
              '$ticketNum',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
