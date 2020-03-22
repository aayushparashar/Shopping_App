import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products.dart';

class EditInputScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditInputState();
  }
}

class EditInputState extends State<EditInputScreen> {
  final _focusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  var _form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isInit = true;
  String appBarText;
  var initValues = {
    'price': '',
    'title': '',
    'imageUrl': '',
    'description': ''
  };

  product _currpro = product(
    title: null,
    id: null,
    price: null,
    description: null,
    imageUrl: null,
  );

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageId);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      var product = Provider.of<Products>(context).searchById(productId);
      appBarText = 'Edit Product';
      initValues['price'] = product.price.toString();
      initValues['title'] = product.title;
      _currpro.id = productId;
      initValues['description'] = product.description;
      _imageUrlController.text = product.imageUrl;
      _currpro.isFavourite = product.isFavourite;
    } else {
      appBarText = 'Add  Product';
    }
    isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _saveProduct() async {
    bool valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_currpro.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_currpro.id, _currpro);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_currpro);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured!'),
                  content: Text('Something Went Wrong!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Ok'),
                    )
                  ],
                ));
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void _updateImageId() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageId);
    _imageFocusNode.dispose();
    _imageUrlController.dispose();

    _focusNode.dispose();
    _descFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  _saveProduct();
                })
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(children: <Widget>[
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter the title of the product',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Title can not be Empty!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _currpro = product(
                            imageUrl: _currpro.imageUrl,
                            description: _currpro.description,
                            price: _currpro.price,
                            id: _currpro.id,
                            isFavourite: _currpro.isFavourite,
                            title: value,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'Enter the price of the product',
                        ),
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        focusNode: _focusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price can not be Empty!';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Number should be greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _currpro = product(
                            imageUrl: _currpro.imageUrl,
                            description: _currpro.description,
                            price: double.parse(value),
                            id: _currpro.id,
                            isFavourite: _currpro.isFavourite,
                            title: _currpro.title,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter the decription of the product',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descFocusNode,
                        onFieldSubmitted: (_) {
                          Focus.of(context).requestFocus(_imageFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description can not be Empty!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _currpro = product(
                            imageUrl: _currpro.imageUrl,
                            description: value,
                            price: _currpro.price,
                            id: _currpro.id,
                            isFavourite: _currpro.isFavourite,
                            title: _currpro.title,
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, left: 5),
                            decoration:
                                BoxDecoration(border: Border.all(width: 2)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter URL')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              width: 200,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'URL can not be Empty!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _currpro = product(
                                    imageUrl: value,
                                    description: _currpro.description,
                                    price: _currpro.price,
                                    id: _currpro.id,
                                    isFavourite: _currpro.isFavourite,
                                    title: _currpro.title,
                                  );
                                },
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                  hintText: 'Enter Image URL',
                                ),
                                controller: _imageUrlController,
                                focusNode: _imageFocusNode,
                                keyboardType: TextInputType.url,
                                onFieldSubmitted: (_) {
                                  _saveProduct();
                                },
                              ))
                        ],
                      )
                    ])),
              ));
  }
}
