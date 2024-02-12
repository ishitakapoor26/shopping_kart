import 'dart:convert';
import 'package:shoppingkart/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      debugShowCheckedModeBanner: false,
      home: ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];
  List<String?> _categories = [];
  String? _selectedCategory;
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    String jsonString = await rootBundle.loadString('assets/products.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    print(jsonList);
    setState(() {
      _products = jsonList.map((json) => Product.fromJson(json)).toList();
      _categories =
          _products.map((product) => product.category).toSet().toList();
      _selectedCategory = null;
    });
    print(_products);
    print(_categories);
    print(_selectedCategory);
  }

  List<Product> getFilteredProducts() {
    return _selectedCategory == null || _selectedCategory!.isEmpty
        ? _products
        : _products
            .where((product) => product.category == _selectedCategory)
            .toList();
  }

  void _showDetailsDialog(Product product) {
    showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
          );
        });
  }

  void _onSubmit() {
    String quantity = _quantityController.text.trim();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submitted'),
          content: Text('Quantity: $quantity'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void onPressed(String newValue) {
    setState(() {
      _selectedCategory = newValue;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Shopping App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  focusColor: Colors.teal,
                  hintText: 'Search...',

                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  ),

                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {

                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.asset("assets/images/download.jpeg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.asset(
                            "assets/images/fresh-mango-1635589838-6060262.jpeg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.asset(
                            "assets/images/51ebZJ+DR4L._AC_UF1000,1000_QL80_.jpg"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Image.asset("assets/images/orange.jpg",),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (newValue) => onPressed(newValue!),
                  items: _categories
                      .map<DropdownMenuItem<String>>((String? category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category!),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              itemCount: getFilteredProducts().length,
              itemBuilder: (BuildContext context, int index) {
                Product product = getFilteredProducts()[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: ListTile(
                    minVerticalPadding: 20,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.grey.shade300),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    // style: ListTileStyle,
                    leading: Image.asset(product.image.toString()),
                    title: Text(product.name.toString()),
                    subtitle: Text('Cost: \$${product.cost}'),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      child: Text('Add to Cart'),
                      onPressed: () => _showDetailsDialog(product),
                    ),
                    onTap: () {
                      _quantityController.clear();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter Quantity'),
                            content: TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Quantity'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _onSubmit();
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
