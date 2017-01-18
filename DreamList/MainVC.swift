//
//  ViewController.swift
//  DreamList
//
//  Created by Alwin Lazar on 16/01/17.
//  Copyright © 2017 Xeoscript Technologies. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    // it helps to fetch data from coreData
    var controller: NSFetchedResultsController<Item>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // genereteTestData()
        attemptFetch()
    }

    // this function is to cell view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // pass that cell to this function
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    // custom function to help cellForRowAt
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        
        // manupulations not take place in VC
        // that in ItemView
        //update cell
        let item = controller.object(at: indexPath as IndexPath)
        
        cell.configureCell(item: item)
        
    }
    
    // when select a cell 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // it ensure it have object and atleast one object in there
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // segue 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            
            if let destination = segue.destination as? ItemDetailsVC {
                
                if let item = sender as? Item {
                    
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    // it gives the row count to display in tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // we check here if any sections then take info of them and count
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            
            return sectionInfo.numberOfObjects
            
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
        }
        
        return 0
    }
    
    //set the row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func attemptFetch() {
        
        // which fetchRequest are we working with fetching items
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // how we want to be sorted
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let typeSort = NSSortDescriptor(key: "toItemType", ascending: true)
        
        
        if segment.selectedSegmentIndex == 0 {
        
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
            
        } else if segment.selectedSegmentIndex == 3 {
            
            fetchRequest.sortDescriptors = [typeSort]
        }
        
        
        // *** created our controller
        // we put keyPath nil because we want all the results
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        // perform the actual fetching
        
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        
        attemptFetch()
        tableView.reloadData()
    }
    
    
    // when tableView changes this function starts listen for changes and
    // it will handle that for you
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }
    
    // when the contents changed
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    // this function will listen for when we make change 
    // insertion, deletion .. etc
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
            
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            break
            
        case.update:
            if let indexPath = indexPath {
                
                let cell = tableView.cellForRow(at: indexPath)
                //update the cell data
                
                configureCell(cell: cell as! ItemCell, indexPath: indexPath as NSIndexPath)
            }
            
            break
            
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            
            break
            
        }
    }
    
    
    func genereteTestData() {
        
        // this context is comming from appDelegate
        let item = Item(context: context)
        
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MBPs"
        
        // this context is comming from appDelegate
        let item2 = Item(context: context)
        
        item2.title = "Bose HeadPhones"
        item2.price = 300
        item2.details = "But man, its so nice to be block outeveryone with noise cancelling tech"
        
        
        // this context is comming from appDelegate
        let item3 = Item(context: context)
        
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day I will own it."
        
        // to save the data
        ad.saveContext()
        
    }
    
}




















