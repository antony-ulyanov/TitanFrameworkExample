//
// Created by antony on 2019-08-20.
// Copyright (c) 2019 medlinesoft. All rights reserved.
//

import Foundation
import UIKit
import TitanFramework

class TitanMultipleTimesInitVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func initTitanFramework() {
        let app = UIApplication.shared
        let window = (app.delegate as? AppDelegate)?.window
        TitanManager.sharedInstance.initialize(window, app, ExampleTheme())
    }

    @IBAction func initializeFrameworkAction(_ sender: Any) {
        initTitanFramework()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        TitanManager.sharedInstance.api.login(token: "325859d2-af32-4579-81f0-e5fda43827a8", onSuccess: {
            print("±±±±±1")
//            MimasManager.sharedInstance.api.sendAPNSToken()
            self.showInfoAlert(message: "Успешно")
        }, onError: { error in
            print("±±±±±2 \(error)")
            self.showInfoAlert(message: error)
        })
    }

    @IBAction func showAction(_ sender: Any) {
        let startVC = TitanManager.sharedInstance.getStartScreen()
        self.navigationController?.pushViewController(startVC!, animated: true)
    }

    private func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "Авторизация", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in

        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
        // Входная точка для взаимодействия с сдк
//    static func start(parent: UIViewController, sessionId: String, appointmentId: String, partner: TelemedPartner) -> Completable {
//        let theme = MedlineSDKTheme(serverUrl: partner.serverUrl) // меняется только адрес сервера
//        let app = UIApplication.shared let window = (app.delegate as? App)?.window // Вызываем инициализацию прямо перед открытием чата
//        MimasManager.sharedInstance.initialize(window, app, theme) MimasManager.sharedInstance.delegate = MimasManagerDelegateWrapper()
//        return Completable.create { observer -> Disposable in
//            MimasManager.sharedInstance.requestPermissions()
//            let onLoggedIn = {
//                MedlineSDK.showChat(at: parent, appointmentId: appointmentId, onCompleted: {
//                    observer(.completed)
//                }
//
//                )
//            }
//
//            let loginCompletion: (Error?) -> Void = { error in
//                if let error = error {
//                    observer(.error(error))
//                } else {
//                    onLoggedIn()
//                }
//            }
//            MedlineSDK.login(sessionId: sessionId, completion: loginCompletion, retryOnError: true)
//
//            return Disposables.create()
//        }
//    }
//
//    private static func login(sessionId: String, completion: @escaping (Error?) -> Void, retryOnError: Bool) {
//        let onError: (String) -> Void = { message in
//            // Костыль. Если переключаться между партнерами (делать initialize) - при первом логине приходит ошибка, при повторном логине все ок
//            if retryOnError && MedlineSDK.isErrorWithMessageRecoverable(message) {
//                login(sessionId: sessionId, completion: completion, retryOnError: false)
//            } else {
//                completion(ErrorWithMessage(with: message))
//            }
//        } MimasManager.sharedInstance.api.login(sessionId: sessionId, onSuccess: {
//            completion(nil)
//        }, onError: onError)
//    }
//
//    private static func isErrorWithMessageRecoverable(_ message: String) -> Bool {
//        return message == "Необходимо войти в систему"
//    }
//
//    fileprivate static func showChat(at parent: UIViewController, appointmentId: String, onCompleted: (() -> Void)? = nil) {
//        let vc = MimasManager.sharedInstance.getChatScreen(appointmentId)
//        let navVc = UINavigationController(rootViewController: vc)
//        parent.present(navVc, animated: true, completion: nil)
//    }

}
