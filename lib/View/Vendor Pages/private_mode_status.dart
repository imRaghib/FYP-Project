import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class pmode{
  static var private=false;

  static  getprivateMode()async{
    var ids=[];
    var data= await  FirebaseFirestore.instance.collection('Venues').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    for(int i=0;i<data.size;i++){
      ids.add(data.docs[i].id);
    }
    var d2=await  FirebaseFirestore.instance.collection('Venues').doc(ids[0]).get();
    private=d2.get('isPrivate');
  }

  static  privateMode(value)async{
  private=value;
  var ids=[];
  var data= await  FirebaseFirestore.instance.collection('Venues').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
  ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
  await  FirebaseFirestore.instance.collection('Venues').doc(ids[i]).update({
  'isPrivate':value
  });
  }

   data= await  FirebaseFirestore.instance.collection('Jewelerys').where('sellerUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
    ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
    await  FirebaseFirestore.instance.collection('Jewelerys').doc(ids[i]).update({
      'isPrivate':value
    });
  }

   data= await  FirebaseFirestore.instance.collection('Dresses').where('sellerUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
    ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
    await  FirebaseFirestore.instance.collection('Dresses').doc(ids[i]).update({
      'isPrivate':value
    });
  }

   data= await  FirebaseFirestore.instance.collection('Bridal Salon').where('vendorUID',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  for(int i=0;i<data.size;i++){
    ids.add(data.docs[i].id);
  }
  for(int i=0;i<ids.length;i++){
    await  FirebaseFirestore.instance.collection('Bridal Salon').doc(ids[i]).update({
      'isPrivate':value
    });
  }

  }

}