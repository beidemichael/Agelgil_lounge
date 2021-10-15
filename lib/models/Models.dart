import 'package:flutter/foundation.dart';

class Controller {
  String documentId;
  int version;
  Controller({this.documentId, this.version});
}

class Lounges {
  List category;
  String name;
  String id;
  String images;
  double longitude;
  double latitude;
  double rating;
  bool weAreOpen;
  String documentId;
  double radius;

  Lounges({
    this.name,
    this.images,
    this.id,
    this.latitude,
    this.longitude,
    this.category,
    this.rating,
    this.weAreOpen,
    this.documentId,
    this.radius,
  });
}

class CarrierOrders {
  List food;
  List price;
  List quantity;
  double total;
  String loungeName;
  var created;
  bool isTaken;
  String orderCode;
  String userName;
  String userPhone;
  String carrierName;
  String carrierphone;
  String carrierUserUid;
  String documentId;
  double longitude;
  double latitude;
  String information;

  CarrierOrders(
      {this.food,
      this.price,
      this.quantity,
      this.total,
      this.loungeName,
      this.created,
      this.isTaken,
      this.orderCode,
      this.userName,
      this.userPhone,
      this.carrierName,
      this.carrierUserUid,
      this.carrierphone,
      this.documentId,
      this.latitude,
      this.longitude,
      this.information});
}

class Orders {
  List food;
  List price;
  List quantity;
  num subTotal;
  int tip;
  num serviceCharge;
  double deliveryFee;
  String loungeName;
  var created;
  bool isTaken;
  String orderCode;
  String loungeOrderNumber;
  String userName;
  String userPhone;
  String carrierName;
  String carrierphone;
  String carrierUserUid;
  String documentId;
  bool eatThere;
  bool isBeingPrepared;

  Orders({
    this.food,
    this.price,
    this.quantity,
    this.loungeName,
    this.created,
    this.isTaken,
    this.orderCode,
    this.userName,
    this.userPhone,
    this.carrierName,
    this.carrierUserUid,
    this.carrierphone,
    this.documentId,
    this.loungeOrderNumber,
    this.serviceCharge,
    this.deliveryFee,
    this.subTotal,
    this.tip,
    this.eatThere,
    this.isBeingPrepared,
  });
}

class Cart3Items {
  String foodNameL;
  double foodPriceL;
  int foodQuantityL;
  Cart3Items({this.foodNameL, this.foodPriceL, this.foodQuantityL});
}

class Menu with ChangeNotifier {
  String name;
  double price;
  String id;
  String images;
  String category;
  bool isAvaliable;
  String documentId;
  Menu(
      {this.name,
      this.images,
      this.id,
      this.category,
      this.price,
      this.isAvaliable,
      this.documentId});
}

class UserUid {
  final String uid;
  UserUid({this.uid});
}

class UserInfo {
  String userName;
  String userPhone;
  String userPic;

  UserInfo({this.userName, this.userPhone, this.userPic});
}

class Carriers {
  String carrierName;
  String carrierPhone;

  String carrierUid;
  String loungeUid;
  String documentUid;

  Carriers(
      {this.carrierName,
      this.carrierPhone,
      this.carrierUid,
      this.loungeUid,
      this.documentUid});
}
