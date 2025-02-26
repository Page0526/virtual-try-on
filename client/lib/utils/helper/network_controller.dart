
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// manage network connectivity and provide a method to handle network changes 
class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectivityStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    // check network connectivity
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityStatus.value = result;

    // dislay warning dialog when network is lost
    if (result == ConnectivityResult.none) {
      // show warning dialog




    }

  }

  Future<bool> isConnected() async {


    try {

      final ConnectivityResult result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } on PlatformException catch (e) {

      // handling with lost connection 
      // print(e.toString());
      return false;
    }

  }



}


