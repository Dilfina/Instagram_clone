import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading=false;

  @override
  void dispose() {
    
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading=true;
    });
    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if(res=="success"){
     // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ResponsiveLayout(mobileScreenLayout: 
               MobileScreenLayout(), webScreenLayout: WebScreenLayout())));
      

    }else{
      setState(() {
      _isLoading=false;
    });
      
      showSnackBar(res, context);
    }
  }
  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(child: Container(), flex: 2,),
            SvgPicture.asset("assets/ic_instagram.svg", color: primaryColor,height: 64,),
            const SizedBox(height: 64,),
            TextFieldInput(
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,

            ),
            const SizedBox(height: 24,),
            TextFieldInput(
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,

            ),
            const SizedBox(height: 24,),
            InkWell(
              onTap: loginUser,
              child: Container(child: _isLoading? Center(child: CircularProgressIndicator(color: primaryColor,),): Text("Log In"), width: double.infinity, alignment: Alignment.center,
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),), color: blueColor),
              padding: EdgeInsets.symmetric(vertical: 12),),
            ),
            const SizedBox(height: 12,),
            Flexible(child: Container(), flex: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Text("Don't have an account?"), padding: EdgeInsets.symmetric(vertical: 30),),
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Container(child: Text("Sign Up", style: TextStyle(
                    //color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),), padding: EdgeInsets.symmetric(vertical: 30),),
                ),
              ],
            )




          ],
        ),
      )),
    );
  }
}