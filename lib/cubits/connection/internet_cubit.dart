import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
 late StreamSubscription connectivityStreamSubscription;
  InternetCubit({required this.connectivity})
      : assert(connectivity != null),
        super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
          if (connectivityResult == ConnectivityResult.wifi) {
            emitInternetConnected(ConnectionType.wifi);
          } else if (connectivityResult == ConnectivityResult.mobile) {
            emitInternetConnected(ConnectionType.mobile);
          } else if (connectivityResult == ConnectivityResult.none) {
            emitInternetDisconnected();

          }
        });
  }

  void emitInternetConnected(ConnectionType _connectionType) =>
      emit(InternetConnected(connectionType: _connectionType,   ));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {

    connectivityStreamSubscription.cancel();
    return super.close();
  }
}