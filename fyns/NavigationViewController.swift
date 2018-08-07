//
//  NavigationViewController.swift
//  fyns
//
//  Created by Eric de La Varende on 01/08/2018.
//  Copyright © 2018 Eric de La Varende. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc = segue.destination as? SwipeViewController {
            switch segue.identifier {
            case "swipe":
                svc.type = "swipe"
            case "love":
                svc.type = "love"
            case "like":
                svc.type = "like"
            case "dislike":
                svc.type = "dislike"
            case "unknown":
                svc.type = "unknown"
            default:
                svc.type = "swipe"
            }
        }
        
    }
}
