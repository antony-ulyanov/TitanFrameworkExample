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
    }

    @IBAction func loginAction(_ sender: Any) {
        MimasManager.sharedInstance.api.login(token: "325859d2-af32-4579-81f0-e5fda43827a8", onSuccess: {
            print("±±±±±1")
            MimasManager.sharedInstance.api.sendAPNSToken()
            self.showInfoAlert(message: "Успешно")
        }, onError: { error in
            print("±±±±±2 \(error)")
            self.showInfoAlert(message: error)
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
