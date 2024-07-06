
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset("assets/login.png",
                  fit: BoxFit.fitWidth, height: 297.815.h),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 25.52.h,
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userNameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                              hintText: 'User Name'),
                          validator: (name) {
                            if (name!.isNotEmpty) {
                              return null;
                            }
                            return 'Please enter the user name';
                          },
                        ),
                        SizedBox(height: 15.h),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            hintText: 'Password',
                          ),
                          validator: (password) {
                            if (password!.isNotEmpty) {
                              return null;
                            }
                            return 'Please enter a password';
                          },
                        )
                      ],
                    )),
                SizedBox(height: 5.h),
              ]),
            ),
            SizedBox(
              height: 34.036.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.20.w),
              child: FilledButton(
                onPressed: () {
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      saveUser(user: _userNameController.text);


                      Navigator.pushNamed(context, '/homeScreen');

                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r)),
                    minimumSize: Size(357.w, 47.h)),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 34.036.h),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
Future<void> saveUser({
  required String user,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user', user);
}