//
//  Note.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

struct Note: Hashable, Identifiable {
    var id: String = UUID().uuidString //Identifier for each note
    var title: String
    var body: String
    var image: UIImage
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Array where Element == Note { //method returns the index of individual notes
    func indexOfNote(with id: Note.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG //this if debug statement doesnt allow this data out during production
extension Note {
    static var sampleData = [
        Note(title: "Welcome", body: "Click on this note or tap compose to get started", image: UIImage(systemName: "folder")!),
        Note(title: "First Note", body: "This is a sample note", image: UIImage(systemName: "folder")!)
    ]
}
#endif
