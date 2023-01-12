//
//  DataModel.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

extension ContainerViewController: NoteListDelegate, MenuDelegate {
        
    func updateNotes(notes: [Note]) {
        self.notes = notes
        self.noteCount = notes.count
    }
    
    func switchView() {
        print("in switch view")
        
        currentCollectionViewController?.willMove(toParent: nil)
        currentCollectionViewController?.view.removeFromSuperview()
        currentCollectionViewController?.removeFromParent()

        if currentCollectionViewController == noteList {
            notes = noteList.notes
            noteCell.notes = noteList.notes
            noteCell.collectionView.reloadData()
            
            addChild(noteCell)
            noteCell.view.frame = view.bounds
            view.addSubview(noteCell.view)
            noteCell.didMove(toParent: self)
            currentCollectionViewController = noteCell
        } else {
            notes = noteCell.notes
            noteList.notes = noteCell.notes
            noteList.updateSnapshot()
            
            addChild(noteList)
            noteList.view.frame = view.bounds
            view.addSubview(noteList.view)
            noteList.didMove(toParent: self)
            currentCollectionViewController = noteList
            }
    }
    
}
