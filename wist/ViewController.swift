//
//  ViewController.swift
//  wist
//
//  Created by Shaobo Sun on 1/17/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var word: UITextField!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet var indexLabel:UILabel!
    
    let wordStore = WordStore()
    
    @IBAction func learnedButton(_ sender: AnyObject) {
        let word = currentWord
        wordStore.updateWordInServer(word)
    }
    
    var currentIndex = -1
    var currentWord = ""
    var words =  [[String: String]]()
    var todayReviewedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        // TODO: use getAll here
        let request = NSMutableURLRequest(url: URL(string: APIServerBaseUrl + "words?q=wordsOfTheDay")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]

                    if let wordsOfToday = json?["elements"] as? [[String:String]] {
                        for wordOfToday in wordsOfToday {
                            var a = [String:String]()
                            a[wordOfToday["wordName"]!] = wordOfToday["wordDef"]
                            self.words.insert(a, at: 0)
                        }
                    }

                    DispatchQueue.main.async(execute: {
                        self.nextWordAction()
                    })
                    
                } catch {
                    print("Error serializing JSON: \(error)")
                }
            }
            
            if error != nil {
                print("error=\(error)")
                return
            }
        }) 
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    func nextWordAction() {
        if (words.count == 0) {
            return
        }
        print("next word")
        currentIndex += 1
        
        if (currentIndex >= words.count) {
            currentIndex = 0
        }
        indexLabel.text = "\(currentIndex+1)/\(words.count)"
        
        for (key, value) in words[currentIndex] {
            currentWord = key
            word.text = key
            noteView.text = value
            print("Note view")
            print(value)
        }
        
    }

    @IBAction func tapToNextWork(_ sender: AnyObject) {
        print("Tap happened!")
        wordStore.updateWordInServer(currentWord)
        nextWordAction()

    }
    
    @IBAction func swipeToNextWord(_ sender: AnyObject) {
        print("swiped to right!!!!")
        print("current word")
        print(currentWord)
        nextWordAction()
    }
    
    
    @IBAction func swipeToPreviousWord(_ sender: AnyObject) {
        if (words.count == 0) {
            return
        }
        print("previous word")

        currentIndex -= 1
        if (currentIndex < 0) {
            currentIndex = words.count - 1
        }
        print(currentIndex)
        indexLabel.text = "\(currentIndex+1)/\(words.count)"
        for (key, value) in words[currentIndex] {
            currentWord = key
            word.text = key
            noteView.text = value
        }
    }
}

