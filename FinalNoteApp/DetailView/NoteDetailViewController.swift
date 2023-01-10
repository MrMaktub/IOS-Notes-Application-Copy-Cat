//
//  DetailViewController.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

protocol NoteListDetailDelegate {
    func updateNoteListView(sender: NoteDetailViewController)
    func saveNoteListView(sender: NoteDetailViewController)
}

protocol NoteCellDetailDelegate {
    func updateNoteCellView(sender: NoteDetailViewController)
    func saveNoteCellView(sender: NoteDetailViewController)
}

class NoteDetailViewController: UIViewController {
    
    var note: Note
    
    var listDelegate: NoteListDetailDelegate!
    var cellDelegate: NoteCellDetailDelegate!
    var textView: UITextView?
    var textField: UITextField?
    
    var currentController: UICollectionViewController
    
    init(note: Note, currentController: UICollectionViewController) {
        self.note = note
        self.currentController = currentController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(note.title)
        if note.title != "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(updateNote))
            textView = UITextView(frame: view.frame)
            textView?.text = "\(note.title)\n\(note.body)"
            textView?.textColor = .white
            textView?.backgroundColor = .clear
            textView?.font = UIFont(name: "", size: 18)
            textView?.becomeFirstResponder()
            view.addSubview(textView!)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
            textView = UITextView(frame: view.frame)
            textView?.textColor = .white
            textView?.backgroundColor = .clear
            textView?.becomeFirstResponder()
            view.addSubview(textView!)
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveNote), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView?.contentInset = .zero
        } else {
            textView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView?.scrollIndicatorInsets = textView!.contentInset
        
        let selectedRange = (textView?.selectedRange)!
        textView?.scrollRangeToVisible(selectedRange)
    }
    
    @objc func saveNote() {
        print(textView?.text)
        cellDelegate?.saveNoteCellView(sender: self)
        listDelegate?.saveNoteListView(sender: self)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateNote() {
        print(textView?.text)
        cellDelegate?.updateNoteCellView(sender: self)
        listDelegate?.updateNoteListView(sender: self)
        navigationController?.popViewController(animated: true)
    }
}
