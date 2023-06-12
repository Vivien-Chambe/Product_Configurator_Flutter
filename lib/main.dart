// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:money_converter/money_converter.dart';
import 'package:money_converter/Currency.dart';

import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, rootBundle;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ProductApp());
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadProducts();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    });
  }

  Future<void> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/products.json');
    final jsonData = json.decode(jsonString);

    List<Product> loadedProducts = [];

    for (var productData in jsonData) {
      Product product = Product.fromJson(productData);
      loadedProducts.add(product);
    }

    setState(() {
      products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Siemens Configurator'),
          actions: [
            IconButton(
              icon: const ImageIcon(
                AssetImage('images/hp_logo.png'),
              ),
              onPressed: () async {
                String url = "https://www.hp.com/fr-fr/home.html";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            IconButton(
              icon: const ImageIcon(
                AssetImage('images/Siemens_logo.png'),
              ),
              onPressed: () async {
                String url = "https://new.siemens.com/fr/fr.html";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                title: product.title,
                imagePath: product.imagePath,
                link: product.link,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfiguratorPage(
                            title: product.title,
                            categories: product.categories,
                            product: product)),
                  );
                },
              );
            },
          ),
        ])));
  }
}

class ProductItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final String link;

  final VoidCallback onTap;

  const ProductItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(imagePath),
      title: Text(title),
      trailing: Wrap(
        spacing: 12.0,
        children: [
          ElevatedButton(
              onPressed: () async {
                String url = link;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Quick Specs')),
          ElevatedButton(
            onPressed: onTap,
            child: const Text('Configure'),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String title;
  final String imagePath;
  final String link;
  List<Screen> screens;
  List<Category> categories;

  Product({
    required this.title,
    required this.imagePath,
    required this.link,
    required this.screens,
    required this.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        title: json['title'],
        imagePath: json['imagePath'],
        link: json['link'],
        categories: List<Category>.from(
            json['categories'].map((category) => Category.fromJson(category))),
        screens: List<Screen>.from(
            json['screens'].map((screen) => Screen.fromJson(screen))));
  }
}

class Category {
  String name;
  String description;
  List<Option> options;

  Category({
    required this.name,
    required this.description,
    required this.options,
  });

  static fromJson(category) {
    return Category(
        name: category['name'],
        description: category['description'],
        options: List<Option>.from(
            category['options'].map((option) => Option.fromJson(option))));
  }
}

class Option {
  String name;
  double price;

  Option({
    required this.name,
    required this.price,
  });

  static fromJson(option) {
    return Option(name: option['name'], price: option['price']);
  }
}

class ConfiguratorPage extends StatefulWidget {
  final String title;
  final List<Category> categories;
  final Product product;

  const ConfiguratorPage(
      {super.key,
      required this.title,
      required this.product,
      required this.categories});

  @override
  // ignore: library_private_types_in_public_api
  _ConfiguratorPageState createState() => _ConfiguratorPageState();
}

class _ConfiguratorPageState extends State<ConfiguratorPage> {
  double totalPrice = 0.0;

  void updateTotalPrice(double price) {
    setState(() {
      totalPrice += price;
      totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    });
  }

  void decrementTotalPrice(double price) {
    setState(() {
      totalPrice -= price;
      totalPrice = double.parse(totalPrice.toStringAsFixed(2));
    });
  }

  // Set orientation to landscape only
  @override
  void initState() {
    super.initState();
    // Init total price
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        totalPrice = widget.product.categories[0].options[0].price;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Row with just text
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // I want my text to be bold
                Divider(
                  height: 50,
                  thickness: 20,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.blueGrey,
                ),
                Text(
                  "Category/Specification",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 100),
                Text('Description',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 100),
                Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            //Insert a sperator line
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
              color: Colors.blue,
            ),
            // ListView.builder with CategoryItems
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  widget.categories.length + widget.product.screens.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: Color.fromARGB(255, 3, 124, 130),
              ),
              itemBuilder: (context, index) {
                if (index < widget.categories.length) {
                  final category = widget.categories[index];
                  return CategoryItem(
                    name: category.name,
                    description: category.description,
                    options: category.options,
                    updateTotalPrice: updateTotalPrice,
                    decrementTotalPrice: decrementTotalPrice,
                  );
                } else {
                  final screenIndex = index - widget.categories.length;
                  final screen = widget.product.screens[screenIndex];
                  return ScreenItem(
                    name: screen.name,
                    number: screen.number,
                    price: screen.price,
                    updateTotalPrice: updateTotalPrice,
                    decrementTotalPrice: decrementTotalPrice,
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Total Price: '),
              Text("\$ $totalPrice"),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Turn Into PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String name;
  final String description;
  final List<Option> options;
  final Function(double) updateTotalPrice;
  final Function(double) decrementTotalPrice;

  const CategoryItem({
    super.key,
    required this.name,
    required this.description,
    required this.options,
    required this.updateTotalPrice,
    required this.decrementTotalPrice,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CategoryItemStateV2 createState() => _CategoryItemStateV2();
}

class _CategoryItemStateV2 extends State<CategoryItem> {
  // I want the default option to be the first option in the list
  Option? selectedOption;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        selectedOption = widget.options[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (widget.options.length > 1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 400,
          child: ExpansionTile(
            title: Text(widget.name),
            subtitle: Text(selectedOption?.name ?? widget.description),
            key: GlobalKey(),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return RadioListTile<Option>(
                    title: Text(option.name),
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (Option? value) {
                      setState(() {
                        widget
                            .decrementTotalPrice(selectedOption?.price ?? 0.0);
                        selectedOption = value;
                        widget.updateTotalPrice(selectedOption?.price ?? 0.0);
                        // collapse the expansion tile
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        // Display description and price of selected option
        Container(
          width: 400,
          child: Text(widget.description),
        ),

        const SizedBox(width: 100),
        Text("\$ ${selectedOption?.price}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class Screen {
  final String name;
  final int number;
  final double price;

  Screen({
    required this.name,
    required this.number,
    required this.price,
  });

  static Screen fromJson(screen) {
    return Screen(
        name: screen['name'], number: screen['number'], price: screen['price']);
  }
}

class ScreenItem extends StatefulWidget {
  final String name;
  final int number;
  final double price;
  final Function(double) updateTotalPrice;
  final Function(double) decrementTotalPrice;

  const ScreenItem({
    super.key,
    required this.name,
    required this.number,
    required this.price,
    required this.updateTotalPrice,
    required this.decrementTotalPrice,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ScreenItemState createState() => _ScreenItemState();
}

class _ScreenItemState extends State<ScreenItem> {
  bool isSelected = false;
  int nbScreens = 0;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
        width: 400.0,
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Number of Screens'),
          onChanged: (value) {
            widget.decrementTotalPrice(widget.price * nbScreens);
            final selectedNumberOfScreens = int.tryParse(value) ?? 0;
            setState(() {
              widget.updateTotalPrice(widget.price * selectedNumberOfScreens);
              nbScreens = selectedNumberOfScreens;
            });
          },
        ),
      ),
      Container(
        width: 400,
        child: Text(widget.name),
      ),
      SizedBox(width: 100),
      Text("\$${widget.price * nbScreens}",
          style: const TextStyle(fontWeight: FontWeight.bold)),
    ]);
  }
}
