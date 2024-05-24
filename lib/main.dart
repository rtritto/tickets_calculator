import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<Widget> items = [];
  List<TextEditingController> controllers = [];
  double total = 0;
  int ticketNum = 0;
  double diff = 0;

  void __addItem() {
    final newController = TextEditingController();
    controllers.add(newController);
    items.add(TextField(
      controller: newController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: (value) => _handleOnChange(value, items.length),
    ));
  }

  void _addItem() {
    setState(() {
      __addItem();
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
      controllers[index].dispose();
      controllers.removeAt(index);
    });
  }

  double _calculateTotal() {
    double sum = 0;
    controllers
        .map((controller) =>
            double.parse(controller.text == '' ? '0' : controller.text))
        .forEach((double? e) => sum += e!);
    return double.parse(sum.toStringAsFixed(2));
  }

  int _calculateTicketNum() {
    return (total / ticketPrice).floor();
  }

  double _calculateDiff() {
    return double.parse((total - (ticketNum * ticketPrice)).toStringAsFixed(2));
  }

  void _handleOnChange(String value, int index) {
    setState(() {
      total = _calculateTotal();
      ticketNum = _calculateTicketNum();
      diff = _calculateDiff();
    });
  }

  @override
  void initState() {
    super.initState();
    __addItem();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(213, 15, 88, 147),
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 3,
                children: List.generate(items.length, (int index) {
                  return ListTile(
                    leading: const Icon(Icons.radio_button_unchecked),
                    title: items[index],
                    trailing: IconButton(
                      onPressed: () {
                        _removeItem(index);
                      },
                      tooltip: 'Delete item',
                      icon: const Icon(Icons.clear),
                    ),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Tot: '),
                  Text(
                    '$total €',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  const Text('Diff: '),
                  Text(
                    '$diff €',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  const Text('# tickets: '),
                  Text(
                    '$ticketNum x $ticketPrice €',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
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
