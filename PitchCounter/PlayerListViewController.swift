//
//  ViewController.swift
//  PitchCounter
//
//  Created by Matthew Surowiec on 6/12/15.
//  Copyright (c) 2015 MPS. All rights reserved.
//

import UIKit
import CoreData


class PlayerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //storing Person entities instead of just names so this Mutable Array is called people
    //instead of names and is of NSManagedObject instead of a String
    var people = [NSManagedObject]()
    
    
    @IBAction func addNewPlayerName(sender: AnyObject) {
        var alert = UIAlertController(title: "New Player",
            message: "",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (UIAlertAction) -> Void in
            let textField = alert.textFields![0] as! UITextField
            
            //use saveName func to to save to Core Data
            self.saveName(textField.text)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
            (UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //Implementing the Add Name Button Action
//    @IBAction func addName(sender: AnyObject) {
//        var alert = UIAlertController(title: "Player Name",
//            message: "Add New Player",
//            preferredStyle: .Alert)
//        
//        let saveAction = UIAlertAction(title: "Save", style: .Default) { (UIAlertAction) -> Void in
//            let textField = alert.textFields![0] as! UITextField
//            
//            //use saveName func to to save to Core Data
//            self.saveName(textField.text)
//            self.tableView.reloadData()
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
//            (UIAlertAction) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert, animated: true, completion: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hides the menu bar when scrolling down
        //navigationController?.hidesBarsOnSwipe = true
        
        
        //Create a view frame variable then adjust the frame down 20 points so cells don't fall under the menu bar
//        var viewFrame = self.tableView.frame
//        viewFrame.origin.y += 20
        
//        //sets the row height to automatic FIX FIX FIX FIX FIX FIX FIX
//        //
//        //
//        //
//        tableView.estimatedRowHeight = 85
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        //prints managedObjectContext to Console
        println(managedObjectContext)
        
//        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 36, UIScreen.mainScreen().bounds.size.width, 44))
//        addButton.setTitle("Add Player", forState: .Normal)
//        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
//        addButton.addTarget(self, action: "addNewPlayer", forControlEvents: .TouchUpInside)
//        self.tableView.addSubview(addButton)
//        viewFrame.size.height -= (20 + addButton.frame.size.height)
        
        title = "Pitch Counter Pro"
        self.tableView.reloadData()
    }
    
//    func addNewPlayer() {
//
//    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return customPitcherCellAtIndexPath(indexPath)
    }
    
    func customPitcherCellAtIndexPath(indexPath:NSIndexPath) -> CustomPitcherListCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomPitcherListCell
        let thisPerson = people[indexPath.row] as! Person
        cell.playerNameOutlet.text = thisPerson.name
        setNumberOfPitchesForCell(cell, indexPath: indexPath)

        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == .Delete) {
            let personToDelete = people[indexPath.row]
            managedObjectContext?.deleteObject(personToDelete)
            people.removeAtIndex(indexPath.row)
            
            var error: NSError?
            if !managedObjectContext!.save(&error) {
                println("Could Not Delete \(error), \(error?.userInfo)")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func setNumberOfPitchesForCell(cell:CustomPitcherListCell, indexPath: NSIndexPath) {
        let thisPerson = people[indexPath.row] as! Person
        var totalNumberPitchedInt = thisPerson.valueForKey("numberOfPitches") as? Int
        var totalNumberPitchedString:String = String(format: "%i", totalNumberPitchedInt!)
        cell.totalNumberPitchedOutlet.text = totalNumberPitchedString
    }
    
    
    func saveName(name: String) {
        //step 1 : Instantiate
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext!)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        //step 2 : Set object value for core data property
        person.setValue(name, forKey: "name")
        
        //Step 3 : handle error and save
        var error: NSError?
        if !managedObjectContext!.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            
        }
        
        //Step 4 : append saved data to core data object
        people.append(person)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
        self.tableView.reloadData()
        
        //Step 1
        //Creates a new fetch request using the Person Entity
        let fetchRequest = NSFetchRequest(entityName: "Person")
        fetchRequest.returnsObjectsAsFaults = false
        
        //Step 2
        //Executes the fetch request and casts new data to an array "people"
        //if there's an error or cannot get results, this will provide a message as well.
        var error: NSError?
        let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Person]
        
        if let results = fetchedResults {
            people = results
            self.tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func deselectAllRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    
    // MARK UITableVieDelegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPitchCounter" {
            if let destination = segue.destinationViewController as?
                CounterViewController {
                    if let SelectIndex = tableView.indexPathForSelectedRow()?.row {
                        let selectedPlayer:NSManagedObject = people[SelectIndex] as NSManagedObject
                        destination.currentPlayer = selectedPlayer
                        println(destination.currentPlayer)
                    }
            }
        }
    }
}

