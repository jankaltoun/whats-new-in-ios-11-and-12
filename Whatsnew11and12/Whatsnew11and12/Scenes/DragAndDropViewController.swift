//
//  DragAndDropViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 20/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit
import MobileCoreServices

class DragContext {
    let sourceTableView: UITableView
    let indexPaths: [IndexPath]
    
    init(sourceTableView: UITableView, indexPaths: [IndexPath]) {
        self.sourceTableView = sourceTableView
        self.indexPaths = indexPaths
    }
}

class DragAndDropViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var doneTableView: UITableView!
    
    var todoItems: [String] = ["Prepare SwiftUI workshop", "Prepare iOS Meeting", "Sleep at some point"]
    var doneItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        todoTableView.dataSource = self
        doneTableView.dataSource = self
        
        todoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        doneTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        todoTableView.dragDelegate = self
        todoTableView.dropDelegate = self
        doneTableView.dragDelegate = self
        doneTableView.dropDelegate = self

        todoTableView.dragInteractionEnabled = true
        doneTableView.dragInteractionEnabled = true
    }
}

extension DragAndDropViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todoTableView {
            return todoItems.count
        }
        
        return doneItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if tableView == todoTableView {
            cell.textLabel?.text = todoItems[indexPath.row]
        } else {
            cell.textLabel?.text = doneItems[indexPath.row]
        }

        return cell
    }
}

extension DragAndDropViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let string = tableView == todoTableView ?
            todoItems[indexPath.row] :
            doneItems[indexPath.row]
        
        guard let data = string.data(using: .utf8) else {
            return []
        }
        
        let itemProvider = NSItemProvider(
            item: data as NSData,
            typeIdentifier: kUTTypePlainText as String
        )
        
        session.localContext = DragContext(
            sourceTableView: tableView,
            indexPaths: [indexPath]
        )

        return [UIDragItem(itemProvider: itemProvider)]
    }
}

extension DragAndDropViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let dragContext = coordinator.session.localDragSession?.localContext as? DragContext else {
            return
        }
        
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let string = items.first as? String else {
                    return
                }
                
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    // Move row within TableView
                    if tableView == self.todoTableView {
                        self.todoItems.remove(at: sourceIndexPath.row)
                        self.todoItems.insert(string, at: destinationIndexPath.row)
                    } else {
                        self.doneItems.remove(at: sourceIndexPath.row)
                        self.doneItems.insert(string, at: destinationIndexPath.row)
                    }
                    
                    tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
                    
                    break
                case (nil, .some(let destinationIndexPath)):
                    // Move row to a different table view to a specific position
                    self.addRow(
                        value: string,
                        tableView: tableView,
                        indexPath: destinationIndexPath,
                        dragContext: dragContext
                    )
                    
                    break
                case (nil, nil):
                    // Move row to a different table view to an unspecified position
                    self.addRow(
                        value: string,
                        tableView: tableView,
                        indexPath: nil,
                        dragContext: dragContext
                    )
                    
                    break
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func cleanup(dragContext: DragContext) {
        for indexPath in dragContext.indexPaths {
            if dragContext.sourceTableView == self.todoTableView {
                self.todoItems.remove(at: indexPath.row)
            } else {
                self.doneItems.remove(at: indexPath.row)
            }
        }
        
        dragContext.sourceTableView.deleteRows(at: dragContext.indexPaths, with: .automatic)
    }
    
    func addRow(value: String, tableView: UITableView, indexPath: IndexPath?, dragContext: DragContext) {
        tableView.beginUpdates()
        
        let finalIndexPath: IndexPath
        
        if tableView == self.todoTableView {
            todoItems.insert(value, at: indexPath?.row ?? todoItems.count)
            
            finalIndexPath = indexPath ?? IndexPath(row: todoItems.count - 1, section: 0)
        }
        else {
            doneItems.insert(value, at: indexPath?.row ?? doneItems.count)
            
            finalIndexPath = indexPath ?? IndexPath(row: doneItems.count - 1, section: 0)
        }
        
        tableView.insertRows(at: [finalIndexPath], with: .automatic)
        
        tableView.endUpdates()
        
        self.cleanup(dragContext: dragContext)
    }
}
