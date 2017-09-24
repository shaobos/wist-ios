//
//  LearnedWordController.swift
//  Wist
//
//  Created by Shaobo Sun on 6/19/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import UIKit

class LearnedWordController : UIViewController {
    
    var wordStore = WordStore()

    
    @IBOutlet weak var review: UITextView!
    @IBOutlet weak var word: UILabel!
    
    var wordString:String = ""
    var wordFromForceTouch:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear!!")

        word.text = ""
        review.text = ""
        
        let controllers = self.tabBarController?.viewControllers
        print(controllers?.count)
        if let tableViewController = controllers?[1] as? WordTable {
            wordString = tableViewController.currentWord
            
            print("tableViewController")
            if (wordString != "") {
                wordStore.fetchWord(wordString) {
                    result in
                    print("returning word")
                    print(result)
                    DispatchQueue.main.async(execute: {
                        self.word.text = self.wordString
                        self.review.text = result["wordDef"] as! String
                    })
                }
            }
        } else {
            wordString = wordFromForceTouch
            
            print("word from force touch")
            print(wordString)
            if (wordString != "") {
                wordStore.fetchWord(wordString) {
                    result in
                    print("returning word")
                    print(result)
                    DispatchQueue.main.async(execute: {
                        self.word.text = self.wordString
                        self.review.text = result["wordDef"] as! String
                    })
                }
            }
        }
        

    }
}
