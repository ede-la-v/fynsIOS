

import UIKit
import Foundation

class SwipeViewController: UIViewController {
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    var shows = [Any]()
    var showId = 0
    var type: String?
    var backend: String?

    @IBOutlet weak var imageShow: UIImageView! {
        didSet {
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeShow))
            swipeUp.direction = .up
            imageShow.addGestureRecognizer(swipeUp)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeShow))
            swipeDown.direction = .down
            imageShow.addGestureRecognizer(swipeDown)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeShow))
            swipeRight.direction = .right
            imageShow.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeShow))
            swipeLeft.direction = .left
            imageShow.addGestureRecognizer(swipeLeft)
        }
    }
    
    @objc func swipeShow(gesture: UISwipeGestureRecognizer) {
        print("swipe occured")
        imageShow.image = nil
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            saveShow(category: 1)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            saveShow(category: -1)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            saveShow(category: 2)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            saveShow(category: 0)
        }
    }
    
    
    func getTVShow() {
        let id = Int(arc4random_uniform(UInt32(self.shows.count)) + 1)
        let json = self.shows[id] as! NSDictionary
        print(json)
        if json["poster_path"] != nil, let vote_count = json["vote_count"] as? Int, vote_count > 10, let poster_path = json["poster_path"] as? String, poster_path != "<null>" {
            var test = "https://image.tmdb.org/t/p/w185/"
            test += json["poster_path"] as! String
            if let url = URL(string: test) {
                self.showId = json["id"] as! Int
                self.downloadImage(url: url)
            }
        } else {
            getTVShow()
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.imageShow.image = UIImage(data: data)
            }
        }
    }
    
    func saveShow(category: Int) {
        self.getTVShow()
        if self.showId > 0 {
            let urlPath = "http://localhost:3001/api/shows"
            var json = [String:Any]()
            
            json["userId"] = UserDefaults.standard.integer(forKey: "id")
            json["showId"] = self.showId
            json["category"] = category
            
            HttpRequest.post(url: urlPath, data: json) { (json) in
                print(json)
            }
        }
    }
    
    func loadPopular() {
        for page in 1...2 {
            print(page)
            let urlPath = "https://api.themoviedb.org/3/tv/popular?api_key=153e4cae613524ffa8744e905913a417&page=" + String(page)
            HttpRequest.get(url: urlPath) { (json) in
                if let results = json["results"] as? [Any] {
                    self.shows += results
                    print("ici", self.shows.count / 20)
                    self.getTVShow()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPopular()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

