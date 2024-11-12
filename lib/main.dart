import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://yjqrdetdhkgxawvebwvl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqcXJkZXRkaGtneGF3dmVid3ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAzMzk2MTYsImV4cCI6MjA0NTkxNTYxNn0.Ga_cmCZnNpFp0decEEMzsBg1OKXAaBRnhu38VvnKpHU',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

const primaryColor = Color.fromARGB(255, 68, 16, 240);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MainAppState();
}

class _MainAppState extends State<MyApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  Future<List<dynamic>> fetchData() async {
    final response = await supabase.from('food').select('*');
    return response as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('First Screen'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        body: Form(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = _titleController.text;
                  final description = _descriptionController.text;
                  final price = _priceController.text;
                  final qty = _qtyController.text;

                  await supabase.from('food').insert({
                    'name': name,
                    'description': description,
                    'price': price,
                    'qty': qty,
                  });
                  setState(() {});
                  _titleController.clear();
                  _descriptionController.clear();
                  _priceController.clear();
                  _qtyController.clear();
                },
                child: const Text('Submit'),
              ),
              FutureBuilder<List<dynamic>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No data found');
                  } else {
                    final data = snapshot.data!;
                    return DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('price')),
                        DataColumn(label: Text('qty')),
                      ],
                      rows: data.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['name'])),
                          DataCell(Text(item['description'])),
                          DataCell(Text(item['price'].toString())),
                          DataCell(Text(item['qty'].toString())),
                        ]);
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
