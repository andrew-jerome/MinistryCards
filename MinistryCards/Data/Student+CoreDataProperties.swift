//
//  Student+CoreDataProperties.swift
//  MinistryCards
//
//  Created by Andrew Jerome on 7/3/23.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var degree: String?
    @NSManaged public var hasMet: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var year: String?
    @NSManaged public var lastMeeting: Meeting?
    @NSManaged public var meetings: NSSet?
    @NSManaged public var nextMeeting: Meeting?
    @NSManaged public var notes: NSSet?
    @NSManaged public var prayers: NSSet?
    @NSManaged public var tags: NSSet?
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedYear: String {
        year ?? "Other"
    }
    
    public var wrappedDegree: String {
        degree ?? ""
    }
    
    public var wrappedPhone: String {
        phone ?? "None"
    }
    
    public var prayersArray: [Prayer] {
        let set = prayers as? Set<Prayer> ?? []
        
        return set.sorted {
            ($0.dT ?? Date.now) > ($1.dT ?? Date.now)
        }
    }
    
    public var notesArray: [Note] {
        let set = notes as? Set<Note> ?? []
        
        return set.sorted {
            ($0.dT ?? Date.now) > ($1.dT ?? Date.now)
        }
    }
    
    public var meetingsArray: [Meeting] {
        let set = meetings as? Set<Meeting> ?? []
        
        return set.sorted {
            ($0.dT ?? Date.now) > ($1.dT ?? Date.now)
        }
    }
    
    public var tagsArray: [Tag] {
        let set = tags as? Set<Tag> ?? []
        
        return set.sorted {
            ($0.name ?? "") < ($1.name ?? "")
        }
    }

}

// MARK: Generated accessors for meetings
extension Student {

    @objc(addMeetingsObject:)
    @NSManaged public func addToMeetings(_ value: Meeting)

    @objc(removeMeetingsObject:)
    @NSManaged public func removeFromMeetings(_ value: Meeting)

    @objc(addMeetings:)
    @NSManaged public func addToMeetings(_ values: NSSet)

    @objc(removeMeetings:)
    @NSManaged public func removeFromMeetings(_ values: NSSet)

}

// MARK: Generated accessors for notes
extension Student {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for prayers
extension Student {

    @objc(addPrayersObject:)
    @NSManaged public func addToPrayers(_ value: Prayer)

    @objc(removePrayersObject:)
    @NSManaged public func removeFromPrayers(_ value: Prayer)

    @objc(addPrayers:)
    @NSManaged public func addToPrayers(_ values: NSSet)

    @objc(removePrayers:)
    @NSManaged public func removeFromPrayers(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Student {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Student : Identifiable {

}
