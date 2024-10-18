import UIKit
import Flutter
import StoreKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SKPaymentTransactionObserver {
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

    // Required method for SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful transaction
                print("Transaction successful!")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // Handle failed transaction
                print("Transaction failed!")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
