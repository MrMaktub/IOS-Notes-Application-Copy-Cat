//
//  NoteCellCollectionViewController.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

class NoteCellCollectionViewController: UICollectionViewController, NoteCellDetailDelegate {
    
    var notes: [Note]!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Hello world")
        
        collectionView.backgroundColor = .black
        
        collectionView.reloadData()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NoteViewCell else {
            fatalError("Could not dequeue Note Cell")
        }
        
        let note = notes[indexPath.item]
        
        cell.title.text = note.title
        cell.title.numberOfLines = 1
        cell.title.textColor = .white
        cell.subtitle.text = note.body
        cell.subtitle.numberOfLines = 1
        cell.subtitle.textColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 20
        
        return cell
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
        vc.cellDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func note(for id: Note.ID) -> Note {
        let index = notes.indexOfNote(with: id)
        return self.notes[index]
    }
    
    func update(_ note: Note, for id: Note.ID) {
        let index = notes.indexOfNote(with: id)
        self.notes[index] = note
    }
    
    func saveNoteCellView(sender: NoteDetailViewController) {
        print("in noteList saving note")
        guard let lineBreak = sender.textView?.text.range(of: "\n")?.lowerBound else {return}
        let title = String((sender.textView?.text[(sender.textView?.text.startIndex)!...(sender.textView?.text.index(before: lineBreak))!])!) as String
        let body = String((sender.textView?.text[(sender.textView?.text.index(after: lineBreak))!..<(sender.textView?.text.endIndex)!])!) as String
        
        let newNote = Note(title: title, body: body, image: UIImage(systemName: "folder")!)
        
        self.notes.append(newNote)
        
        collectionView.reloadData()
        print("end of save note list view")
        
    }
    
    func updateNoteCellView(sender: NoteDetailViewController) {
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
        print(notes)
        
        collectionView.reloadData()
        
    }
}
