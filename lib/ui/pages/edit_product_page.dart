part of 'pages.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  static const routeName = '/edit-product';

  EditProductPage({this.id});
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: null, imageURL: '', title: '', price: 0.0, description: '');

  var initvalue = {'title': '', 'description': '', 'price': '', 'imageURL': ''};

  bool _isInit = true;
  bool _isLoading = false;

  TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    _imageUrlFocusNode.addListener((updateImageUrl));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context).findById(productId);

        initvalue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageURL': '',
        };

        _imageUrlController.text = _editedProduct.imageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener((updateImageUrl));
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http:') &&
              !_imageUrlController.text.startsWith('https:')) ||
          ((_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')))) setState(() {});
    }
  }

  Future<void> _saveForm() async {
   
    final isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      // update product
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: (context),
            builder: (ctx) => AlertDialog(
                  title: Text('An occured error'),
                  content: Text(e.toString()),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Get.back();
    // print(_editedProduct.title);
    // print(_editedProduct.price);
    // print(_editedProduct.description);
    // print(_editedProduct.imageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () async {
              await _saveForm();
              Get.showSnackbar(GetBar(
                  duration: Duration(seconds: 2),
                  snackPosition: SnackPosition.BOTTOM,
                  messageText: Text("Save form",
                      style: TextStyle(color: Colors.white))));
            },
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      TextFormField(
                        initialValue: initvalue['title'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the title";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Title",
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageURL: _editedProduct.imageURL);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalue['price'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter valid number";
                          }
                          if (double.tryParse(value) <= 0) {
                            return "Please enter number than zero";
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        decoration: InputDecoration(
                          labelText: "Price",
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              imageURL: _editedProduct.imageURL);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalue['description'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter the description";
                          }
                          if (value.length < 10) {
                            return "Please enter max 10 character";
                          }
                          return null;
                        },
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value,
                              imageURL: _editedProduct.imageURL);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                              child: _imageUrlController.text.isEmpty
                                  ? Center(child: Text("No Image"))
                                  : FittedBox(
                                      child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ))),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter the URL Page";
                                }
                                if (!value.startsWith('http:') &&
                                    !value.startsWith('https:')) {
                                  return "Please enter the valid URl";
                                }
                                if (value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return "Please enter valid image URL";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Image URL",
                              ),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    imageURL: value);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
      ),
    );
  }
}
