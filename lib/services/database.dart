import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth.dart';

//////////Table of content :)
///       *Carrier User related
///         -Carrier User write
///       *Menu related
///         -Menu write
///         -Menu read
///       *Lounge related
///         -Lounge read
///       *Order related
///         -Order read

class DatabaseService {
  String userUid;
  String userPhoneNumber;
  String loungeId;
  String id;
  int index;
  String messagingToken;
  String documentUid;

  DatabaseService(
      {this.userPhoneNumber, this.userUid, this.loungeId, this.id, this.index,this.messagingToken,this.documentUid});
  List category = [];
//collecton reference
  final CollectionReference loungesCollection =
      FirebaseFirestore.instance.collection('Lounges');
  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('Menu');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Orders');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference carrierUsersCollection =
      FirebaseFirestore.instance.collection('Carriers');
  final CollectionReference tempLoungesCollection =
      FirebaseFirestore.instance.collection('TempLounges');
  final CollectionReference controllerCollection =
      FirebaseFirestore.instance.collection('Controller');

  final AuthServices _auth = AuthServices();
  //******************************************************************************************** */

  List<Controller> _controllerInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Controller(
          version: doc.data()['AndroidGuadaVersion'].toInt() ?? 0,
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<Controller>> get controllerInfo {
    return controllerCollection
        .snapshots()
        .map(_controllerInfoListFromSnapshot);
  }

  //*************************************Carrier User related******************************************* */
  //*************************************Carrier User write******************************************* */
  Future newCarrierUserData(
    String profilePic,
    String name,
    String userUid,
  ) async {
    carrierUsersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((document) {
      if (document.docs.isEmpty) {
        return carrierUsersCollection
            .doc(userUid)
            .set({
              'created': Timestamp.now(),
              'profilePic': profilePic,
              'name': name,
              'phoneNumber': userPhoneNumber,
              'userUid': userUid
            })
            .then((value) => print('checked from data base'))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  Future updateCurrentUser(
    String profilePic,
    String name,
    String userPhone,
  ) async {
    return await carrierUsersCollection.doc(userUid).set({
      'profilePic': profilePic,
      'name': name,
      'phoneNumber': userPhone,
      'userUid': userUid
    });
  }

  Future userInfo() async {
    carrierUsersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          return UserInfo(
            userName: docs.docs[i].get('name') ?? '',
            userPhone: docs.docs[i].get('phoneNumber') ?? '',
            userPic: docs.docs[i].get('profilePic') ?? '',
          );
        }
      }
    });
  }

  //*************************************Carrier User write******************************************* */
  //*************************************Carrier User read******************************************* */

  //*************************************Carrier User read******************************************* */
  //******************************************Carrier User related************************************************** */

//******************************************menu related************************************************** */
//******************************************menu write************************************************** */
  Future updateMenuItem(
      String name, double price, bool isAvaliable, String newImage) async {
    menuCollection.doc(id).update({
      'name': name,
      'price': price,
      'isAvaliable': isAvaliable,
      'images': newImage,
    });
  }

  Future createNewMenuItem(
    String name,
    double price,
    String id,
    String category,
  ) async {
    menuCollection.add({
      'name': name,
      'price': price,
      'isAvaliable': true,
      'id': id,
      'images': null,
      'category': category,
      'description': ''
    });
  }

  Future removeMenu() async {
    return menuCollection.doc(id).delete();
  }

  //******************************************menu write************************************************** */
  //******************************************menu read************************************************** */
  List<Menu> _menuListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Menu(
          name: doc.data()['name'] ?? '',
          id: doc.data()['id'] ?? '',
          price: doc.data()['price'] ?? '',
          images: doc.data()['images'] ?? '',
          category: doc.data()['category'] ?? '',
          isAvaliable: doc.data()['isAvaliable'] ?? '',
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //menu  stream
  Stream<List<Menu>> get menu {
    return menuCollection
        .where('id', isEqualTo: userUid)
        .snapshots()
        .map(_menuListFromSnapshot);
  }
  //******************************************menu read************************************************** */
//******************************************menu related************************************************** */

  //********************************************Lounge related************************************************ */
  //******************************************Lounge read************************************************** */
  List<Lounges> _loungesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Lounges(
        name: doc.data()['name'] ?? '',
        images: doc.data()['image'] ?? '',
        id: doc.data()['id'] ?? '',
        longitude: doc.data()['Location']['geopoint'].longitude ?? 0,
        latitude: doc.data()['Location']['geopoint'].latitude ?? 0,
        category: doc.data()['category'] ?? '',
        rating: doc.data()['rating'].toDouble() ?? 0,
        weAreOpen: doc.data()['weAreOpen'] ?? '',
        documentId: doc.reference.id ?? '',
        radius: doc.data()['deliveryRadius'].toDouble() ?? 0,
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<Lounges>> get lounges {
    return loungesCollection
        .where('id', isEqualTo: userUid)
        .snapshots()
        .map(_loungesListFromSnapshot);
  }

  //******************************************Lounge read************************************************** */
  //******************************************Lounge write************************************************** */
  Future newLoungeUserData(
    String userUid,
  ) async {
    tempLoungesCollection
        .where('loungeUid', isEqualTo: userUid)
        .get()
        .then((document) {
      if (document.docs.isEmpty) {
        return tempLoungesCollection
            .doc(userUid)
            .set({
              'phoneNumber': userPhoneNumber,
              'loungeUid': userUid,
              'created': Timestamp.now(),
            })
            .then((value) => print('checked from data base'))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  Future newLoungeMessagingToken() async {
    loungesCollection.where('id', isEqualTo: loungeId).get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        return loungesCollection
            .doc(documentUid)
            .update({
              'messagingToken': messagingToken,
            })
            .then((value) => print('checked from data base'))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  Future updateLoungeName(
    String name,
    String newImage,
  ) async {
    loungesCollection.doc(id).update({
      'name': name,
      'image': newImage,
    });
  }

  Future updateLoungeWeAreOpen(
    bool weAreOpen,
  ) async {
    loungesCollection.doc(id).update({
      'weAreOpen': weAreOpen,
    });
  }

  Future updateCategory(
    String name,
  ) async {
    loungesCollection.doc(id).get().then((document) {
      category = document.data()['category'] ?? '';

      category[index] = name;

      loungesCollection.doc(id).update({
        'category': category,
      });
    });
  }

  Future addNewCategory(
    String name,
  ) async {
    loungesCollection.doc(id).get().then((document) {
      category = document.data()['category'] ?? '';

      category.add(name);

      loungesCollection.doc(id).update({
        'category': category,
      });
    });
  }

  Future removeCategory(
    String name,
  ) async {
    loungesCollection.doc(id).get().then((document) {
      category = document.data()['category'] ?? '';

      category.remove(name);

      loungesCollection.doc(id).update({
        'category': category,
      });
    });
  }

  Future updateRadius(
    double radius,
  ) async {
    loungesCollection.doc(id).update({
      'deliveryRadius': radius,
    });
  }

  //******************************************Lounge write************************************************** */
  //***********************************************Lounge related********************************************* */

  //********************************************Order related************************************************ */
  //********************************************Order read************************************************ */

//orders list from a snapshot
  List<Orders> _ordersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Orders(
        food: doc.data()['food'] ?? '',
        quantity: doc.data()['quantity'] ?? '',
        price: doc.data()['price'] ?? '',
        deliveryFee: doc.data()['deliveryFee'].toDouble() ?? 0.0,
        serviceCharge: doc.data()['serviceCharge'].toDouble() ?? 0.0,
        tip: doc.data()['tip'].toInt() ?? 0,
        subTotal: doc.data()['subTotal'] ?? '',
        loungeName: doc.data()['loungeName'] ?? '',
        created: doc.data()['created'] ?? '',
        isTaken: doc.data()['isTaken'] ?? '',
        orderCode: doc.data()['orderCode'] ?? '',
        loungeOrderNumber: doc.data()['loungeOrderNumber'] ?? '',
        userName: doc.data()['userName'] ?? '',
        userPhone: doc.data()['userPhone'] ?? '',
        carrierName: doc.data()['carrierName'] ?? '',
        carrierphone: doc.data()['carrierphone'] ?? '',
        carrierUserUid: doc.data()['carrierUserUid'] ?? '',
        eatThere: doc.data()['eatThere'] ?? false,
        isBeingPrepared: doc.data()['isBeingPrepared'] ?? false,
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<Orders>> get orders {
    return orderCollection
        .where('isDelivered', isEqualTo: false)
        .where('loungeId', isEqualTo: loungeId)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersListFromSnapshot);
  }

  //orders lounges stream
  Stream<List<Orders>> get completeOrders {
    return orderCollection
        .where('isDelivered', isEqualTo: true)
        .where('isPaid', isEqualTo: false)
        .where('loungeId', isEqualTo: loungeId)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersListFromSnapshot);
  }

  Future updateOrderWithCarriers(
    String carrierName,
    String carrierphone,
    String carrierUserUid,
  ) async {
    orderCollection.doc(id).update({
      'carrierName': carrierName,
      'carrierphone': carrierphone,
      'carrierUserUid': carrierUserUid,
      'isTaken': true
    });
  }

  Future updateOrderIsDelivered() async {
    orderCollection.doc(id).update({'isDelivered': true});
  }

  Future updateOrderByLounge(
  ) async {
    orderCollection.doc(id).update({
      'isBeingPrepared': true,
    });
  }
  //********************************************Order read************************************************ */
  //************************************************Order related******************************************** */

}
