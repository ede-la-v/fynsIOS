import Foundation
import UIKit

class Switcher {
    
    static var test : UINavigationController?
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        
        print(status)
        
        if (status != true) {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        } else {
            rootVC = test
            print(rootVC ?? "")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let truc = appDelegate.window?.rootViewController as? UINavigationController {
            self.test = truc
        }
        print(appDelegate.window?.rootViewController ?? "")
        appDelegate.window?.rootViewController = rootVC
        print(appDelegate.window?.rootViewController ?? "")
        
    }
    
}
