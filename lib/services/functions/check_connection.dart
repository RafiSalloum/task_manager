import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


final Connectivity connectivity = Connectivity();

void Function(List<ConnectivityResult>)? updateConnectivity(ConnectivityResult connectivityResult, BuildContext context) {
  if(connectivityResult == ConnectivityResult.none) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please check your Internet connection'),
        duration: Duration(days: 1),

      ),
    );
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
  return null;
}