part of 'pages.dart';

enum AutoModes { SIGN_UP, LOGIN }

class AuthPages2 extends StatefulWidget {
  @override
  _AuthPages2State createState() => _AuthPages2State();
}

class _AuthPages2State extends State<AuthPages2> {
  // @override
  // void initState() {
  //   Provider.of<ThemeProvider>(context, listen: false).changeTheme(
  //       ThemeData(primarySwatch: Colors.purple, accentColor: Colors.white));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // context.read<ThemeProvider>().changeTheme(
    //     ThemeData(primarySwatch: Colors.pink, accentColor: Colors.white));

    // setState(() {
    //   Provider.of<ThemeProvider>(context, listen: false).changeTheme(
    //       ThemeData(primarySwatch: Colors.purple, accentColor: Colors.white));
    // });

    return Theme(
      data: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.white),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(212, 160, 210, 1),
                        Color.fromRGBO(190, 130, 170, 1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1])),
            ),
            SingleChildScrollView(
              child: Container(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //NOTE: logo
                    Flexible(
                      flex: 1,
                      child: Image.asset('assets/shop-logo.png',
                          fit: BoxFit.contain, width: 350, height: 170),
                    ),
                    SizedBox(height: 50),
                    // NOTE: form field
                    Flexible(
                        flex: deviceSize.width > 600 ? 2 : 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: AuthCard(),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
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

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.slowMiddle));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    // _animationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

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
      _animationController.forward();
    } else {
      setState(() {
        _autoMode = AutoMode.LOGIN;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        // height: _heightAnimation.value.height,
        height: _autoMode == AutoMode.SIGN_UP ? 320 : 260,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: [
                TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
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
                        labelText: "E-Mail", border: UnderlineInputBorder())),
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
                        labelText: "Password", border: UnderlineInputBorder())),
                SizedBox(height: 15),
                (_autoMode == AutoMode.SIGN_UP)
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
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
                                  border: UnderlineInputBorder())),
                        ),
                      )
                    : Container(),
                (_autoMode == AutoMode.SIGN_UP)
                    ? SizedBox(height: 15)
                    : SizedBox(),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.purple))
                    : SizedBox(
                        width: 150,
                        height: 45,
                        child: RaisedButton(
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
                      ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _switchMode,
                  child: Text(
                      (_autoMode == AutoMode.LOGIN)
                          ? "SIGN UP INSTEAD?"
                          : "LOGIN INSTEAD?",
                      style: GoogleFonts.lato(
                          fontSize: 16, color: Theme.of(context).primaryColor)),
                ),
              ]),
            )),
      ),
    );
  }
}
