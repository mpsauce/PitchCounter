//
//  Person.swift
//  PitchCounter
//
//  Created by Matthew Surowiec on 6/18/15.
//  Copyright (c) 2015 MPS. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var numberOfPitches: NSNumber

    
//    class func createPerson(moc : NSManagedObjectContext, name : String, numberOfPitches : Int) -> Person {
//        let newPerson = NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: moc) as! Person
//        newPerson.name = name
//        newPerson.numberOfPitches = numberOfPitches
//        return newPerson
//    }
}
