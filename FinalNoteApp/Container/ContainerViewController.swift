//
//  ViewController.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 12/30/22.
//

import UIKit

class ContainerViewController: UIViewController, UIPopoverPresentationControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    @IBOutlet var menuButton: UIButton!
    
    var notes: [Note] = Note.sampleData
    
    var filteredNotes: [Note]!
    
    var menuImage = UIImage(systemName: "circle.grid.3x3.circle")?.withTintColor(UIColor(red: 237/255, green: 198/255, blue: 67/255, alpha: 1.0), renderingMode: .alwaysOriginal)
    var galleryImage = UIImage(systemName: "square.grid.2x2")?.withTintColor(UIColor(red: 237/255, green: 198/255, blue: 67/255, alpha: 1.0), renderingMode: .alwaysOriginal)
    var ListImage = UIImage(systemName: "list.bullet.circle")?.withTintColor(UIColor(red: 237/255, green: 198/255, blue: 67/255, alpha: 1.0), renderingMode: .alwaysOriginal)
    var selectNoteImage = UIImage(systemName: "checkmark.circle")?.withTintColor(UIColor(red: 237/255, green: 198/255, blue: 67/255, alpha: 1.0), renderingMode: .alwaysOriginal)
    
    var tBarTitle: UIBarButtonItem!
    
    var noteCount = 2 {
        didSet {
            tBarTitle.title = "\(noteCount) notes"
        }
    }
        
    var noteList = NoteListCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    var noteCell: NoteCellCollectionViewController!
        
    var currentCollectionViewController: UICollectionViewController?
    
    var searchBar: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "All Notes"
        
        filteredNotes = notes
        searchBar = UISearchController()
        searchBar.searchResultsUpdater = self
        searchBar.delegate = self
        navigationItem.searchController = searchBar
        
        noteCell = storyboard?.instantiateViewController(identifier: "CellCollection")
        
        let listLayout = listLayout()
        noteList = NoteListCollectionViewController(collectionViewLayout: listLayout)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.setImage(menuImage, for: .normal)
        
        tBarTitle = UIBarButtonItem(title: "2 Notes", style: .plain, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        
        
        toolbarItems = [spacer, tBarTitle, spacer, compose]
        
        print(notes)
        noteCell.notes = filteredNotes
        noteList.notes = noteCell.notes

        addChild(noteCell)
        noteCell.view.frame = view.bounds
        view.addSubview(noteCell.view)
        noteCell.didMove(toParent: self)
        currentCollectionViewController = noteCell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        var searchText = searchBar.searchBar.text!
        filteredNotes = searchText.isEmpty ? notes : notes.filter { (item: Note) -> Bool in
            let text = item.body + item.title
            return text.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil;
        }
        view.reloadInputViews()
    }
    
    
    @objc func composeNote() {
        let vc = NoteDetailViewController(note: Note(title: "", body: "", image: UIImage(systemName: "folder")!), currentController: currentCollectionViewController!)
        if currentCollectionViewController == noteCell {
            vc.cellDelegate = noteCell
        } else {
            vc.listDelegate = noteList
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        let gallery = UIAction(title: "Show Gallery", image: galleryImage) { action in
            self.switchView()
            }
        
        let list = UIAction(title: "Show List", image: ListImage) { action in
            self.switchView()
            }
        
        let select = UIAction(title: "Select Notes", image: selectNoteImage) { action in
            
        }
        
        if currentCollectionViewController == noteList {
            
            let popoverContent = MenuViewController(actions: [gallery, select])
            
            popoverContent.popoverPresentationController?.sourceView = menuButton
            popoverContent.popoverPresentationController?.sourceRect = menuButton.bounds
            popoverContent.delegate = self
            
            present(popoverContent, animated: true)
            
        } else {
            
            let popoverContent = MenuViewController(actions: [list, select])
            
            popoverContent.popoverPresentationController?.sourceView = menuButton
            popoverContent.popoverPresentationController?.sourceRect = menuButton.bounds
            popoverContent.delegate = self
            
            present(popoverContent, animated: true)
            
        }
    }
    
    private func cellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") {
                [weak self] action, view, completion in
                self?.noteList.notes.remove(at: indexPath.item)
                self?.noteList.updateSnapshot()
                    
                self?.noteCell.notes.remove(at: indexPath.item)
                self?.noteCell.collectionView.reloadData()
                //self?.noteCount -= 1
                self?.updateNotes(notes: self!.notes)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        listConfig.showsSeparators = false
        listConfig.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }

}

