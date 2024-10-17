import UIKit
import Flutter
import StoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure StoreKit
        if #available(iOS 10.0, *) {
            SKPaymentQueue.default().add(self)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}