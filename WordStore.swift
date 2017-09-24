//
//  WordStore.swift
//  wist
//
//  Created by Shaobo Sun on 2/15/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import Foundation

class WordStore {
    
    let baseUrl = "http://40.71.42.29:8080/wist-server/"
    
    // uncomment to test local API server
    //let baseUrl = "http://localhost:8080/wist-server/"

    
    func fetchWords(_ completion: @escaping ([String:String]) -> Void) {
        
        // Do any additional setup after loading the view, typically from a nib.
        let request = NSMutableURLRequest(url: URL(string: baseUrl + "allWords")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            
            data, response, error in
            
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    
                    if let allWords = json?["allWords"] as? [String: String] {
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
        let request = NSMutableURLRequest(url: URL(string: baseUrl + "word/" + wordQuery)!)
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
    
}
