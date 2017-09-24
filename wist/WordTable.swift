//
//  File.swift
//  Wist
//
//  Created by Shaobo Sun on 2/15/16.
//  Copyright © 2016 Shaobo Sun. All rights reserved.
//

import UIKit

class WordTable : UIViewController, UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wordStore = WordStore()
    var words = [String:String]()
    
    var currentWord =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (traitCollection.forceTouchCapability == UIForceTouchCapability.available) {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        wordStore.fetchWords {
            result in
            self.words = result
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()

                })
            print("Finish reloading")
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        let preview = storyboard?.instantiateViewController(withIdentifier: "learnedWordView")
//        show(preview!, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let indexPath = self.tableView.indexPathForRow(at: location)
        let currentWordFromForceTouch = Array(words.keys.sorted())[(indexPath?.row)!]
        let preview = storyboard?.instantiateViewController(withIdentifier: "learnedWordView") as! LearnedWordController
        preview.wordFromForceTouch = currentWordFromForceTouch
        return preview
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableCell", for: indexPath) as? WordTableCell
        
        let key:String = Array(words.keys.sorted())[indexPath.row]
        
        cell!.word?.text = key
        cell!.count?.text = words[key]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentWord = Array(words.keys.sorted())[indexPath.row]
        self.tabBarController?.selectedIndex = 2;

    }
}
