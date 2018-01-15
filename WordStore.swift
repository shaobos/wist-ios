//
//  WordStore.swift
//  wist
//
//  Created by Shaobo Sun on 2/15/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import Foundation

class WordStore {
    
    func fetchAllWords(_ completion: @escaping ([[String:Any]]) -> Void) {
        
        // Do any additional setup after loading the view, typically from a nib.
        let request = NSMutableURLRequest(url: URL(string: APIServerBaseUrl + "words")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    
                    if let allWords = json?["elements"] as? [[String:Any]] {
                        completion(allWords)
                    }
                } catch {
                    print("Error serializing JSON: \(error)")
                }
            }
        }) 
        
        task.resume()
    }
    
    func fetchWord(_ wordQuery: String, _ completion: @escaping ([String:Any]) -> Void) {
     
        print("word query is: " + wordQuery)
        // Do any additional setup after loading the view, typically from a nib.
        let request = NSMutableURLRequest(url: URL(string: APIServerBaseUrl + "words/" + wordQuery)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            
            data, response, error in
            
            if data != nil {
                do {
                    print("something is returned")
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    
                    completion(json!)
                    
                    
                } catch {
                    print("Error serializing JSON: \(error)")
                }
            } else {
                print("nothing returned!!")
            }
        })
        
        task.resume()
    }
    
    
    func updateWordInServer(_ word:String) {
        print("Word '\(word)' has been reviewed. Sending update to server")
        let request = NSMutableURLRequest(url: URL(string: APIServerBaseUrl + "word/\(word)")!)
        request.httpMethod = "PUT"
        let parameters = [String:String]()
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            retData, response, error in
            print(response)
        })
        task.resume()
    }
}
