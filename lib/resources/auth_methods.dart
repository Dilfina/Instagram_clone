import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/resources/storage_methods.dart';
import 'package:insta_clone/models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser= _auth.currentUser!; 
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snapshot);

  }

  Future<String> signUpUser ({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file !=null){
        //register user
        UserCredential cred =await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username:username,
          uid:cred.user!.uid,
          email:email,
          password:password,
          bio:bio,
          photoUrl:photoUrl,
          followers:[],
          following: []

        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res="success";
      }

    
    }catch(error){
      res=error.toString();
      print(res);
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async{
    String res="Some error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        _auth.signInWithEmailAndPassword(email: email, password: password);
        res="success";
      }else{
        res="Enter all the fields";
      }
    }catch(error){
      res = error.toString();
    }
    return res;


  }
  Future<void> signOut() async{
    await _auth.signOut();
  }
}