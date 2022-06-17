import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/connection/internet_cubit.dart';
import 'package:key_board_app/cubits/convertion/convertion_cubit.dart';
import 'package:key_board_app/cubits/convertion/convertion_state.dart';
import 'package:key_board_app/navigators/goto.dart';
import 'package:key_board_app/pages/convertion_page.dart';
import 'package:key_board_app/views/dialogs.dart';
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