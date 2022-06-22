import 'package:connectivity_plus/connectivity_plus.dart';

 Future<bool> hasNetwork ()async{

  final Connectivity connectivity=Connectivity();

  ConnectivityResult  connectivityResult = await  connectivity.checkConnectivity();

  if (connectivityResult == ConnectivityResult.wifi) {
  return  true;
  } else if (connectivityResult == ConnectivityResult.mobile) {
  return true;
  }

  return false;
}