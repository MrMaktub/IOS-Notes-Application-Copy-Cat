//
//  NoteListCollectionViewController.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

protocol NoteListDelegate {
    func updateNotes(notes: [Note])
}

class NoteListCollectionViewController: UICollectionViewController, NoteListDetailDelegate {
    enum section {
        case main
    }
    
    typealias Datasource = UICollectionViewDiffableDataSource<section, Note.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<section, Note.ID>
    
    var dataSource: Datasource?
    
    var delegate: NoteListDelegate?
            
    var notes: [Note]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = Datasource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Note.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
                
        collectionView.backgroundColor = .black

        updateSnapshot()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let id = self.notes?[indexPath.item].id {
            showDetail(for: id)
        }
        return false
    }
    
    func showDetail(for id: Note.ID) {
        let note = note(for: id)
        print(note.id)
        let vc = NoteDetailViewController(note: note, currentController: self)
        vc.listDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSnapshot(reloading ids: [Note.ID] = []) {
        var snapShot = Snapshot()
        snapShot.appendSections([section.main])
        snapShot.appendItems(self.notes.map { $0.title })
        if !ids.isEmpty {
            snapShot.reloadItems(ids)
        }
        dataSource?.apply(snapShot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Note.ID) {
        
        let note = self.notes?[indexPath.item]
        
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.textToSecondaryTextVerticalPadding = 0
        contentConfig.text = note?.title
        contentConfig.textProperties.color = .white
        contentConfig.secondaryText = note?.body
        contentConfig.secondaryTextProperties.color = .white
        contentConfig.image = note?.image
        contentConfig.imageProperties.tintColor = UIColor(red: 237/255, green: 198/255, blue: 67/255, alpha: 1.0)
        contentConfig.textProperties.font = UIFont(name: "Arial Bold", size: 16)!
        contentConfig.secondaryTextProperties.font = UIFont(name: "Arial", size: 16)!
        contentConfig.secondaryTextProperties.numberOfLines = 1
        cell.contentConfiguration = contentConfig
        
        cell.accessories = [.disclosureIndicator(displayed: .always)]
                
        var backgroundContentConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundContentConfig.backgroundColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.32)
        cell.backgroundConfiguration = backgroundContentConfig
        
    }

    func note(for id: Note.ID) -> Note {
        let index = notes.indexOfNote(with: id)
        return self.notes[index]
    }
    
    func update(_ note: Note, for id: Note.ID) {
        let index = notes.indexOfNote(with: id)
        self.notes[index] = note
    }
    
    func saveNoteListView(sender: NoteDetailViewController) {
        print("in noteList saving note")
        guard let lineBreak = sender.textView?.text.range(of: "\n")?.lowerBound else {return}
        let title = String((sender.textView?.text[(sender.textView?.text.startIndex)!...(sender.textView?.text.index(before: lineBreak))!])!) as String
        let body = String((sender.textView?.text[(sender.textView?.text.index(after: lineBreak))!..<(sender.textView?.text.endIndex)!])!) as String
        
        let newNote = Note(title: title, body: body, image: UIImage(systemName: "folder")!)
        
        self.notes.append(newNote)
        
        delegate?.updateNotes(notes: self.notes)
        
        var snapShot = Snapshot()
        snapShot.appendSections([section.main])
        snapShot.appendItems(self.notes.map { $0.title })
        dataSource?.apply(snapShot)
        
        print("end of save note list view")
        
    }
    
    func updateNoteListView(sender: NoteDetailViewController) {
        print("in noteList updating note")
        guard let lineBreak = sender.textView?.text.range(of: "\n")?.lowerBound else {return}
        let newTitle = String((sender.textView?.text[(sender.textView?.text.startIndex)!...(sender.textView?.text.index(before: lineBreak))!])!) as String
        let newBody = String((sender.textView?.text[(sender.textView?.text.index(after: lineBreak))!..<(sender.textView?.text.endIndex)!])!) as String

        let newNote = Note(title: newTitle, body: newBody, image: UIImage(systemName: "folder")!)
        print(newNote)
        print(sender.note.id)
        print("Im in delegate method in datasource")
        let note = sender.note
        let index = self.notes.indexOfNote(with: note.id)
        print(note)
        notes.remove(at: index)
        notes.insert(newNote, at: index)
        
        var snapShot = Snapshot()
        snapShot.appendSections([section.main])
        snapShot.appendItems(notes.map { $0.id })
        dataSource?.apply(snapShot)
    }
    
}
