//
//  MimasVC.swift
//  TestAddingTitanFramework
//
//  Created by ANTON ULYANOV on 22.06.2018.
//  Copyright © 2018 medlinesoft. All rights reserved.
//

import UIKit
import TitanFramework
import UITextView_Placeholder

class MimasVC: UIViewController {

    var window: UIWindow?
    
    @IBOutlet weak var jsessionInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func initializeMimasAction(_ sender: Any) {
        let app = UIApplication.shared
        window = (app.delegate as? AppDelegate)?.window
        
        MimasManager.sharedInstance.initialize(window, app, ExampleTheme())
        MimasManager.sharedInstance.initPush()
        MimasManager.sharedInstance.delegate = self
        MimasManager.sharedInstance.setRootViewController(self)
        MimasManager.sharedInstance.api.setDeviceId("f18cffe449c0219c956f5c986dfec763130f84d6b917b34bf92cdfc634e2b197")
    }

    @IBAction func loginAction(_ sender: Any) {
        print("loginAction")
        print(jsessionInput.text)
//        MimasManager.sharedInstance.api.login(sessionId: jsessionInput.text ?? "", onSuccess: {
//            print("±±±±±1")
//            MimasManager.sharedInstance.api.sendAPNSToken()
//            self.showInfoAlert(message: "Успешно")
//        }, onError: { error in
//            print("±±±±±2 \(error)")
//            self.showInfoAlert(message: error)
//        })
        
//        MimasManager.sharedInstance.api.login(login: "lolka", password: "Qwertyq1", onSuccess: {
//            print("±±±±±1")
//            MimasManager.sharedInstance.api.sendAPNSToken()
//            self.showInfoAlert(message: "Успешно")
//        }) { (error) in
//            print("±±±±±2 \(error)")
//            self.showInfoAlert(message: error)
//        }
        
        // 72aad08e-33e1-43c8-91b3-767095f04366
        // 9c636e7c-8e2f-4fca-8664-e78c38662375 - lolka
        // f81a1fec-08a8-4e12-a2ee-07d8667cb743
        MimasManager.sharedInstance.api.login(token: "5767225b-db14-40b6-a053-d0dbe379bf71", onSuccess: {
            print("±±±±±1")
            MimasManager.sharedInstance.api.sendAPNSToken()
            self.showInfoAlert(message: "Успешно")
        }, onError: { error in
            print("±±±±±2 \(error)")
            self.showInfoAlert(message: error)
        })
    }

    @IBAction func logoutAction(_ sender: Any) {
        MimasManager.sharedInstance.api.logout(onSuccess: {
            self.showInfoAlert(message: "logout")
        }, onError: { error in
            self.showInfoAlert(message: "logout error = \(error)")
        })
    }
    
    @IBAction func startTMKTitanAction(_ sender: Any) {
        print("openChatAction")
        MimasManager.sharedInstance.api.getAppointmentsByStates(states: [TMKAppointmentState.active, TMKAppointmentState.scheduled], onSuccess: { items in
            print("±±±±±1")
            print("loaded appointments")
            for item in items {
                print("appointmentId = \(item.id)")
            }
            if (items.count > 0) {
                let appointmentId = items[0].id 
                print("appointmentId for chat = \(appointmentId)")
                MimasManager.sharedInstance.requestPermissions()
                let chatVC = MimasManager.sharedInstance.getChatScreen(appointmentId)
                print("openChatAction chatVC = \(chatVC)")
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }, onError: { error in
            print("±±±±±2 \(error)")
            self.showInfoAlert(message: error)
        })
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func showInfoAlert(message: String) {
        let alertController = UIAlertController(title: "Авторизация", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}


extension MimasVC: MimasManagerDelegate {
    func didReceiveDoctorCall(_ appointmentId: String?) {
        DispatchQueue.main.async {
            var navVC: UINavigationController
            if let rootVC = self.window!.rootViewController {
                print(">> rootVC = \(rootVC)")
                if let existNavVc = rootVC as? UINavigationController {
                    print(">> existNavVc = \(existNavVc)")
                    navVC = existNavVc
                } else {
                    print(">> not existNavVc")
                    if let rootNavVC = rootVC.navigationController {
                        print(">> rootNavVC = \(rootNavVC)")
                        navVC = rootNavVC
                    } else {
                        navVC = UINavigationController(rootViewController: rootVC)
                    }
                }
            } else {
                navVC = UINavigationController()
                self.window!.rootViewController = navVC
                self.window!.makeKeyAndVisible()
            }

            // Open chat
            if var vc = navVC.viewControllers.last as? ChatVCProtocol {
//                        vc.appointmentId = appointmentId
                // Chat window is already openned
                return
            }

            let chatVC = MimasManager.sharedInstance.getChatScreen(appointmentId!)
            print(">> chatVC = \(chatVC)")
            navVC.pushViewController(chatVC, animated: true)
            print(">> navVC.viewControllers = \(navVC.viewControllers)")
        }
    }
}
