import 'package:flutter/material.dart';

void main() => runApp(const BookOrderApp());

class BookOrderApp extends StatelessWidget {
  const BookOrderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const BookCounterPage(),
    );
  }
}

class BookCounterPage extends StatefulWidget {
  const BookCounterPage({super.key});
  @override
  State<BookCounterPage> createState() => _BookCounterPageState();
}

class _BookCounterPageState extends State<BookCounterPage> {
  final List<String> _books = [
    'Introduction to Flutter Development',
    'Clean Code & Mobile Architecture',
    'Database Systems Concepts',
    'Systems Analysis and Design'
  ];

  final Map<int, int> _qty = {};
  final double _pricePerBook = 45.00;

  void _changeQuantity(int index, int delta) {
    setState(() {
      final currentQty = _qty[index] ?? 0;
      final nextQty = currentQty + delta;
      if (nextQty <= 0) {
        _qty.remove(index);
      } else {
        _qty[index] = nextQty;
      }
    });
  }

  void _clearOrder() {
    setState(() {
      _qty.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = _qty.values.fold(0, (sum, item) => sum + item);
    double totalPrice = totalItems * _pricePerBook;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Order Counter'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12.0),
            child: Badge(
              label: Text('$totalItems'),
              child: const Icon(Icons.shopping_basket),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final currentQty = _qty[index] ?? 0;
                return ListTile(
                  title: Text(_books[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('GHS ${_pricePerBook.toStringAsFixed(2)} each'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => _changeQuantity(index, -1),
                      ),
                      Text('$currentQty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                        onPressed: () => _changeQuantity(index, 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Items: $totalItems', style: const TextStyle(fontSize: 16)),
                    Text('Total Due: GHS ${totalPrice.toStringAsFixed(2)}', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: totalItems > 0 ? _clearOrder : null,
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Clear Basket'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
