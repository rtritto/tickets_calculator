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
      title: 'Tickets Calculator',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Tickets Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double ticketPrice = 9.3;
  final List<Widget> items = [];
  final List<TextEditingController> controllers = [];
  final List<FocusNode> foci = [];
  double total = 0;
  double diff = 0;
  int ticketsNumberToUse = 0;

  void __addItem() {
    final newController = TextEditingController();
    controllers.add(newController);

    final FocusNode focusNode = FocusNode();
    foci.add(focusNode);

    final int index = items.length;
    items.add(TextField(
      focusNode: focusNode,
      controller: newController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: (value) => _handleOnChange(value, index),
      onTapOutside: (event) => {
        controllers[index].text =
            __fixDoubleNumToShow(double.parse(controllers[index].text))
      },
    ));

    focusNode.requestFocus();
  }

  void __updateVars() {
    total = _calculateTotal();
    ticketsNumberToUse = _calculateticketsNumberToUse();
    diff = _calculateDiff();
  }

  double __fixDoubleNum(double inputDoubleNum) {
    return double.parse(inputDoubleNum.toStringAsFixed(2));
  }

  String __fixDoubleNumToShow(double inputDoubleNum) {
    List<String> splittedNums = inputDoubleNum.toStringAsFixed(2).split('.');
    return '${splittedNums[0]}.${splittedNums[1].padRight(2, '0')}';
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

      foci[index].dispose();
      foci.removeAt(index);

      __updateVars();
    });
  }

  double _calculateTotal() {
    double sum = 0;
    controllers
        .map((controller) =>
            double.parse(controller.text == '' ? '0' : controller.text))
        .forEach((double? e) => sum += e!);
    return __fixDoubleNum(sum);
  }

  int _calculateticketsNumberToUse() {
    return (total / ticketPrice).floor();
  }

  double _calculateDiff() {
    return __fixDoubleNum(total - (ticketsNumberToUse * ticketPrice));
  }

  void _handleOnChange(String value, int index) {
    setState(() {
      __updateVars();
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
    for (var focus in foci) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
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
                    '${__fixDoubleNumToShow(total)} €',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  const Text('Diff: '),
                  Text(
                    '${__fixDoubleNumToShow(diff)} €',
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
                    '$ticketsNumberToUse x $ticketPrice €',
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
        tooltip: 'Add item',
        backgroundColor: Colors.lightBlue.shade900,
        shape: const CircleBorder(),
        onPressed: _addItem,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
