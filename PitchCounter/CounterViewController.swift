//
//  CounterViewController.swift
//  PitchCounter
//
//  Created by Matthew Surowiec on 6/18/15.
//  Copyright (c) 2015 MPS. All rights reserved.
//

import UIKit
import CoreData

class CounterViewController: UIViewController  {
    
    var count = 0
    var currentPlayer: NSManagedObject!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var pitchCounterOutlet: UILabel!
    @IBOutlet weak var minusOnePitchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prints to console core data entity to make sure this view controller received the proper data.
        println(currentPlayer)
        
        //for some reason if set to TRUE inside PLVC, it carries over creating minor unwanted performance. This sets back to false.
        //navigationController?.hidesBarsOnSwipe = false
        
        //creates a custom back button for the view controller. Uses a custom func titled saveAndGoBack
        let backButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveAndGoBack:")
        self.navigationItem.leftBarButtonItem = backButton
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItem = cancelButton
        title = self.currentPlayer.valueForKeyPath("name") as? String
        
        
    }
    
    func cancel(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //custom func to add and/or save new data and pop the view controller
    func saveAndGoBack(sender: UIBarButtonItem) {
        if (currentPlayer != nil) {
            count += (currentPlayer.valueForKey("numberOfPitches") as! Int)
            currentPlayer.setValue(count, forKey: "numberOfPitches")
            
            var error: NSError?
            if !managedObjectContext!.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func plusOnePitchTapped(sender: UIButton) {
        count += 1
        pitchCounterOutlet.text = "\(count)"
    }
    
    @IBAction func minusOnePitchTapped(sender: UIButton) {
        if (count > 0){
            minusOnePitchButton.enabled = true
            count -= 1
            pitchCounterOutlet.text = "\(count)"
        } else if (count == -1) {
            minusOnePitchButton.enabled = false
        }
    }
}
