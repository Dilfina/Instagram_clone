import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyA2pxcPaqkLyCtSgz-V-TdV6VaS-cxxc-w', appId: '3NZY2bsd1ttRbidLiyo8SJV4SHxsvpKh9M',
     messagingSenderId: '823158960651', projectId: 'instagram-clone-d3052', storageBucket: 'instagram-clone-d3052.appspot.com'));

  }else{
    await Firebase.initializeApp();

  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.connectionState== ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(mobileScreenLayout: 
                 MobileScreenLayout(), webScreenLayout: WebScreenLayout());
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
    
              }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: primaryColor,),);
            }
            return LoginScreen();
    
          },
        ),
      ),
    );
  }
}

