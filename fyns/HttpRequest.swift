//
//  HttpRequest.swift
//  fyns
//
//  Created by Eric de La Varende on 07/08/2018.
//  Copyright © 2018 Eric de La Varende. All rights reserved.
//
import Foundation
import UIKit

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class HttpRequest {
    
    static func get(url: String, completionBlock: @escaping (NSDictionary) -> Void) -> Void {
        guard let endpoint = URL(string: url) else {
            print("Error creating endpoint")
            return
        }
        print(url)
        return URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                completionBlock(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }.resume()
    }
    
    static func post(url: String, data: [String:Any], completionBlock: @escaping (NSDictionary) -> Void) -> Void {
        guard let endpoint = URL(string: url) else {
            print("Error creating endpoint")
            return
        }
        do {
            let json = try JSONSerialization.data(withJSONObject: data, options: [])
            
            var request = URLRequest(url: endpoint)
            request.httpMethod = "POST"
            request.httpBody = json
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
                    completionBlock(json)
                } catch let error as JSONError {
                    print(error.rawValue)
                } catch let error as NSError {
                    print(error.debugDescription)
                }
                }.resume()
        } catch {
        }
    }
    
}
