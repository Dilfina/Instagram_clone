import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading=false;

  @override
  void dispose() {
    
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();

  }

  void selectImage() async{
    Uint8List im =  await pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }
  void signUpUser() async{
    setState(() {
      _isLoading=true;
    });
    String res =await  AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text, file: _image!);

    setState(() {
      _isLoading=false;
    });  

      if(res!='success'){
        showSnackBar(res, context);

      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ResponsiveLayout(mobileScreenLayout: 
               MobileScreenLayout(), webScreenLayout: WebScreenLayout())));
      }
  }
  void navigateToLogIn(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
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
            Stack(
              children: [
                _image!=null?
                CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!),
                ):
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWpMt1I4YD-NiUmlnM-PPrUL-6BR84_HTRBw&usqp=CAU"),
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(onPressed: (){
                    selectImage();
                  },icon: Icon(Icons.add_a_photo),))
              ],
            ),
            const SizedBox(height: 24,),
            TextFieldInput(
              hintText: 'Enter your username',
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
       
            ),
            const SizedBox(height: 24,),

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
            TextFieldInput(
              hintText: 'Enter your bio',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
    

            ),
            
            const SizedBox(height: 24,),
            InkWell(
              onTap: signUpUser,
              child: Container(child: _isLoading? Center(child: CircularProgressIndicator(color: Colors.white,),): Text("Sign Up"), width: double.infinity, alignment: Alignment.center,
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),), color: blueColor),
              padding: EdgeInsets.symmetric(vertical: 12),),
            ),
            const SizedBox(height: 12,),
            Flexible(child: Container(), flex: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Text("Already have an account?"), padding: EdgeInsets.symmetric(vertical: 30),),
                GestureDetector(
                  onTap: navigateToLogIn,
                  child: Container(child: Text("Log In", style: TextStyle(
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