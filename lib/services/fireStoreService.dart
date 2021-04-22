import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class DB_service_write {
  final String uid;
  DB_service_write({this.uid});

  // ignore: non_constant_identifier_names
  final CollectionReference BeaconCollection = FirebaseFirestore.instance.collection('Users_Data');
  
  // ignore: non_constant_identifier_names
  Future setuserData(String ScannedQRCode) async{
    return await BeaconCollection.doc(uid).set({
      'Device-ID': ScannedQRCode,
    });
  }
  
  Future getuserData() async{
    DocumentSnapshot documents = (await BeaconCollection.doc(uid).get() == null) ? null : await BeaconCollection.doc(uid).get();  
    if(documents == null){
      return null;
    }
    else{
      final object = documents.data();
      return object;
    }
  } //end of updateUserData
} //end of DB_service