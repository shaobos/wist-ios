//
//  ViewController.swift
//  wist
//
//  Created by Shaobo Sun on 1/17/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBAction func learnedButton(_ sender: AnyObject) {
        let word = currentWord
        updateWordInServer(word)
        typing_off()
        typingResult.text = "Correct!"
        
    }
    var currentIndex = -1
    var currentWord = ""
    var words =  [[String: String]]()
    let baseUrl = "http://40.71.42.29:8080/wist-server/"
    var todayReviewedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
                
        typeWordTextField.delegate = self //set delegate to textfile

        // Do any additional setup after loading the view, typically from a nib.
        let request = NSMutableURLRequest(url: URL(string: baseUrl + "wordsOfToday/1")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]

                    if let wordsOfToday = json?["wordsOfToday"] as? [String:String] {
                        for var (wordInput, noteInput) in wordsOfToday {
                            var a = [String:String]()
                            a[wordInput] = noteInput
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

    @IBOutlet weak var word: UITextField!

    @IBOutlet weak var typeWordTextField: UITextField!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var typingResult: UILabel!
    @IBOutlet weak var memorizeButton: UIButton!
    
    @IBAction func memorizeButtonPressed(_ sender: AnyObject) {
        typing_on()
    }
    
    func typing_on() {
        word.isHidden = true
        typeWordTextField.isHidden = false
        typeWordTextField.becomeFirstResponder()
    }
    
    func typing_off() {
        word.isHidden = false
        typeWordTextField.isHidden = true
        typeWordTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == typeWordTextField {
            let userTyping:String = typeWordTextField.text!
            let word = currentWord
            print("word is \(word)")
            if (userTyping ==  word) {
                print("User typing \(userTyping) matched the word \(word)")
                todayReviewedWords.append(word)
                updateWordInServer(word)
                typing_off()
                typingResult.text = "Correct!"
                textField.resignFirstResponder()
                return false
            } else {
                print("User typing \(userTyping) did not match the word \(word)")
                typingResult.text = "Wrong!"
            }
        } else {
            print("not the target text field")
        }
        
        return true
    }
    

    @IBAction func nextWord(_ sender: AnyObject) {
        nextWordAction()

        
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
        
        typingResult.text = ""
        print(currentIndex)
        for (key, value) in words[currentIndex] {
            currentWord = key
            word.text = key
            noteView.text = value
            if (todayReviewedWords.contains(key)) {
                memorizeButton.isUserInteractionEnabled = false
                memorizeButton.titleLabel?.text = "Reviewed"
            } else {
                memorizeButton.isUserInteractionEnabled = true
                memorizeButton.titleLabel?.text = "Memorize!"
            }
        }
    }
    
    func updateWordInServer(_ word:String) {
        print("Word '\(word)' has been reviewed. Sending update to server")
        let request = NSMutableURLRequest(url: URL(string: baseUrl + "word/\(word)")!)
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
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        typeWordTextField.resignFirstResponder()
        typing_off()
    }
    
    @IBAction func swipeToNextWord(_ sender: AnyObject) {
        print("swiped!!!!")
        nextWord(sender)
    }
    
    @IBOutlet var indexLabel:UILabel!
    
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
            if (todayReviewedWords.contains(key)) {
                memorizeButton.isUserInteractionEnabled = false
                memorizeButton.titleLabel?.text = "Reviewed"
            } else {
                memorizeButton.isUserInteractionEnabled = true
                memorizeButton.titleLabel?.text = "Memorize!"
            }
        }
    }
}

