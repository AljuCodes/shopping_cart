// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/providers/product.dart';
import 'package:shopping_cart/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  EditProductScreenState createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
      id: 'i',
      title: 'title',
      description: 'description',
      price: 0,
      imageUrl: 'imageUrl');
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isLoading = false;
  var _isInit = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void didChangeDependencies() {
    if (_isInit == true) {
      var productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != "i") {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              (!_imageUrlController.text.startsWith('https') ||
                  (!_imageUrlController.text.endsWith('.png') &&
                      (!_imageUrlController.text.endsWith('jpg') &&
                          !_imageUrlController.text.endsWith('jpeg')))))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editProduct.id != "i") {
      try {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editProduct.id, _editProduct);
      } catch (error) {
        print(error);
        shodailog();
      }
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await shodailog();
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> shodailog() async {
    await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error occured !'),
              content: const Text("something went wrong"),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: _form,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please provides a value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: value as String,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a place';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a  number greater than zero.';
                          }
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: double.parse(value!),
                              imageUrl: _editProduct.imageUrl);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              isFavorite: _editProduct.isFavorite,
                              title: _editProduct.title,
                              description: value as String,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter a description..';
                          }
                          if (value.length < 10) {
                            return 'should be at least 10 characters long.';
                          }
                          return null;
                        },
                      ),
                      // ignore: avoid_unnecessary_containers
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: FittedBox(
                                  child: _imageUrlController.text.isEmpty
                                      ? const Text('Enter a Url')
                                      : Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 8, right: 10),
                            ),
                            Expanded(
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Image URL'),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  controller: _imageUrlController,
                                  focusNode: _imageUrlFocusNode,
                                  onSaved: (value) {
                                    _editProduct = Product(
                                        id: _editProduct.id,
                                        isFavorite: _editProduct.isFavorite,
                                        title: _editProduct.title,
                                        description: _editProduct.description,
                                        price: _editProduct.price,
                                        imageUrl: value as String);
                                  },
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                  onFieldSubmitted: (_) {
                                    _saveForm();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter a url';
                                    } else if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return 'please enter a valid url';
                                    } else if (!value.endsWith('.png') &&
                                        !value.endsWith('jpg') &&
                                        !value.endsWith('jpeg')) {
                                      return 'please enter a valid url';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
