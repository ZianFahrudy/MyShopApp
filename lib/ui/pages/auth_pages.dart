part of 'pages.dart';

enum AutoMode { SIGN_UP, LOGIN }

class AuthPages extends StatefulWidget {
  @override
  _AuthPagesState createState() => _AuthPagesState();
}

class _AuthPagesState extends State<AuthPages> {
  AutoMode _autoMode = AutoMode.LOGIN;
  Map<String, String> _authData = {'email': '', 'password': ''};
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: (context),
        builder: (ctx) => AlertDialog(
              title: Text("An error occured"),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Okay'))
              ],
            ));
  }

  void _clearTextForm() {
    _passwordController.clear();
    _emailController.clear();
    _passwordConfirmController.clear();
  }

  Future<void> _save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_autoMode == AutoMode.LOGIN) {
        // await context
        //     .read<Auth>()
        //     .signIn(_authData['email'], _authData['password']);
        // login
        await Provider.of<Auth>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        // sign up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);

        _clearTextForm();
      }
      // Get.off(() => ProductPages());
    } on HttpExceptionz catch (error) {
      var errorMessage = "Authentication Failed";

      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'The email address is already in use by another account';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            "There is no user record corresponding to this identifier. The user may have been deleted.";
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage =
            'The password is invalid or the user does not have a password.';
      } else if (error.message.contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Password sign-in is disabled for this project.';
      } else if (error.message.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage =
            'We have blocked all requests from this device due to unusual activity. Try again later.';
      } else if (error.message.contains('USER_DISABLED')) {
        errorMessage =
            'The user account has been disabled by an administrator.';
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Authentication failed!!!!';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    if (_autoMode == AutoMode.LOGIN) {
      setState(() {
        _autoMode = AutoMode.SIGN_UP;
      });
    } else {
      setState(() {
        _autoMode = AutoMode.LOGIN;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(220, 210, 180, 1),
                      Color.fromARGB(240, 250, 116, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            margin: EdgeInsets.fromLTRB(20, 100, 20, 100),
            color: Colors.white,
            height: deviceSize.size.height,
            width: deviceSize.size.width,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                      child: Column(
                    children: [
                      TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          onChanged: (text) {},
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return "invalid email";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['email'] = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "E-Mail",
                              border: UnderlineInputBorder())),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          focusNode: _passwordFocusNode,
                          controller: _passwordController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordConfirmFocusNode);
                          },
                          onChanged: (text) {},
                          validator: (value) {
                            if (value.isEmpty || value.length < 6) {
                              return 'password invalid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: UnderlineInputBorder())),
                      SizedBox(height: 15),
                      (_autoMode == AutoMode.SIGN_UP)
                          ? TextFormField(
                              focusNode: _passwordConfirmFocusNode,
                              controller: _passwordConfirmController,
                              validator: _autoMode == AutoMode.SIGN_UP
                                  ? (value) {
                                      if (!(value ==
                                          _passwordController.text)) {
                                        return 'password does not match';
                                      }
                                      return null;
                                    }
                                  : null,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  border: UnderlineInputBorder()))
                          : Container()
                    ],
                  )),
                  (_autoMode == AutoMode.SIGN_UP)
                      ? SizedBox(height: 15)
                      : SizedBox(),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text(
                              _autoMode == AutoMode.LOGIN
                                  ? "LOG IN"
                                  : "SIGN UP",
                              style: GoogleFonts.lato(
                                  fontSize: 20, color: Colors.white)),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: _save),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: _switchMode,
                    child: Text(
                        (_autoMode == AutoMode.LOGIN)
                            ? "SIGN UP INSTEAD"
                            : "LOGIN INSTEAD",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor)),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
