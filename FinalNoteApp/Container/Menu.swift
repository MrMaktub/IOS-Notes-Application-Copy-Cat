//
//  Menu.swift
//  FinalNoteApp
//
//  Created by Bryce Hawkins on 1/2/23.
//

import UIKit

protocol MenuDelegate {
    func switchView()
}

class MenuViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
        
    var selectedIndexPath: IndexPath?
        
    private var actions: [UIAction] = [] 
    
    var delegate: MenuDelegate?
    
    convenience init(actions: [UIAction]) {
        self.init(style: .plain)
        self.actions = actions
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 240, height: 40 * actions.count)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.permittedArrowDirections = .up
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("In menu")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.rowHeight = 40
        tableView.separatorInset = .zero
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let action = actions[indexPath.row]
        cell.textLabel?.text = action.title
        cell.imageView?.image = action.image
        cell.backgroundColor = UIColor(white: 0.02, alpha: 0.88)
        cell.textLabel?.textColor = .white
        return cell
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = tableView.indexPathForSelectedRow
        
        tableView.deselectRow(at: selectedIndexPath!, animated: true)
        
        if tableView.cellForRow(at: selectedIndexPath!)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .checkmark
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
            self.delegate?.switchView()

        } else {
            tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = .none
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true, completion: nil)
            }
            self.delegate?.switchView()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canPerformPrimaryActionForRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

       func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
           return .none
       }
    
   }
