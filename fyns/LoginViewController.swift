//
//  LoginViewController.swift
//  fyns
//
//  Created by Eric de La Varende on 31/07/2018.
//  Copyright © 2018 Eric de La Varende. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func navigate(_ sender: UIButton) {
        print("navigate")
        if let emailText = email.text, emailText.count > 4, let passwordText = password.text, passwordText.count > 4 {
            let urlPath = "http://localhost:3001/api/users"
            guard let endpoint = URL(string: urlPath) else {
                print("Error creating endpoint")
                return
            }
            var json = [String:Any]()
            
            json["email"] = emailText
            json["password"] = passwordText
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                
                var request = URLRequest(url: endpoint)
                request.httpMethod = "POST"
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    do {
                        guard let data = data else {
                            throw JSONError.NoData
                        }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                            throw JSONError.ConversionFailed
                        }
                        print(json)
                        DispatchQueue.main.async{
                            print(json["id"]!)
                            UserDefaults.standard.set(json["id"]!, forKey: "id")
                            UserDefaults.standard.set(true, forKey: "status")
                            Switcher.updateRootVC()
                        }
                    } catch let error as JSONError {
                        print(error.rawValue)
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    }.resume()
            } catch {
            }
        } else {
            print("error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
