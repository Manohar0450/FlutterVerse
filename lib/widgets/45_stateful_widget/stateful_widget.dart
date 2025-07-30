import 'package:flutter/material.dart';
import 'first_page.dart';

class MyStatufulWidget extends StatefulWidget {
  final int number;
  const MyStatufulWidget({super.key, required this.number});

  @override
  State<MyStatufulWidget> createState() => _MyStatufulWidgetState();
}

class _MyStatufulWidgetState extends State<MyStatufulWidget> {
  int number = 0;
  // first lifecycle
  @override
  void initState() {
    super.initState();
    number = widget.number;
    debugPrint('Number: ${widget.number} InitState');
  }

  // second lifecycle
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('Number: ${widget.number} DidChangeDependencies');
  }

  // check update done in previous page
  @override
  void didUpdateWidget(MyStatufulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('Number: ${widget.number} DidUpdateWidget');

    if (oldWidget.number != widget.number) {
      debugPrint('Number has changed');
    }
  }

  // rarely used
  @override
  void deactivate() {
    debugPrint('Number: ${widget.number} Deactivate');
    super.deactivate();
  }

  // dispose method
  @override
  void dispose() {
    debugPrint('Number: ${widget.number} Dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Number: $number Build');
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Widget')),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: 350,
              child: TextButton(
                child: Text(
                  number.toString(),
                  style: const TextStyle(fontSize: 80),
                ),
                onPressed: () {
                  setState(() {
                    debugPrint('Number: ${widget.number} SetState');
                    number++;
                  });
                },
              ),
            ),
            ElevatedButton(
              child: const Text('First Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FirstPage(numberFirst: number)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
