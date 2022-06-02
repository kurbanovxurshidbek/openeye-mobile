import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller = window?.rootViewController as! FlutterViewController;
      
      let channel = FlutterMethodChannel(name: "flutter.native/helper", binaryMessenger: controller.binaryMessenger);
      
      prepareMethodHandler(deviceChannel: channel);
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

    
    
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
          
          // 4
          deviceChannel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              
              // 5
              if call.method == "helloNativeCode" {
                  
                  // 6
//
                  
              
                  if let url = URL(string:UIApplication.openSettingsURLString) {
                  if UIApplication.shared.canOpenURL(url) {
                      if #available(iOS 10.0, *) {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                      } else {
                          // Fallback on earlier versions
                      }

                  }
////
                  }
//
                  self.receiveDeviceModel(result: result)
              }
              else {
                  // 9
                  result(FlutterMethodNotImplemented)
                  return
              }
              
          })
      }
    
    
    private func receiveDeviceModel(result: FlutterResult) {
            // 7
            let deviceModel = UIDevice.current.model
            
            // 8
            result(deviceModel)
        }
    
}
