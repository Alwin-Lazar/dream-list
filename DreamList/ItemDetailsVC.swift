//
//  ItemDetailsVC.swift
//  DreamList
//
//  Created by Alwin Lazar on 17/01/17.
//  Copyright © 2017 Xeoscript Technologies. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // to clear the <DreamLIst to < only
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // custom data
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        
//        let store3 = Store(context: context)
//        store3.name = "Frys Electronics"
//        
//        let store4 = Store(context: context)
//        store4.name = "Target"
//
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        
//        let store6 = Store(context: context)
//        store6.name = "K Mart"
//        
//        ad.saveContext()
        
        
//        let type = ItemType(context: context)
//        type.type = "Electronics"
//        
//        let type1 = ItemType(context: context)
//        type1.type = "Toys"
//        
//        let type2 = ItemType(context: context)
//        type2.type = "Cars"
//        
//        ad.saveContext()
        
        getStores()
        
        getItemTypes()
        
        // this is execute when tap on an existing cell
        if itemToEdit != nil {
            
            loadItemData()
        }
    }

    // set title for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
        let store = stores[row]
        
        // this is actual entity from coreData
        return store.name
            
        } else {
            
            let itemType = itemTypes[row]
            return itemType.type
        }
    }
    
    // how many rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
        
            return stores.count
            
        } else {
            
            return itemTypes.count
        }
        
    }
    
    // how many columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // when selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // update when selected
    }
    
    // to fetch the results
    func getStores() {
        
        let fetchRequest: NSFetchRequest = Store.fetchRequest()
        
        do {
            
            self.stores = try context.fetch(fetchRequest)
            
            // relaod all components in it
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle the error
        }
    }
    
    func getItemTypes() {
        
        let fetchRequest: NSFetchRequest = ItemType.fetchRequest()
        
        do {
            
            self.itemTypes = try context.fetch(fetchRequest)
            
            self.storePicker.reloadAllComponents()
            
        } catch {
            
            // handle error
        }
    }
    
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        
        // image have its own entity so lets create first
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
//        let itemType = ItemType(context: context)
//        itemType.type = String(storePicker.selectedRow(inComponent: 1))
        
        
        if itemToEdit == nil {
            
            item = Item(context: context)
            
        } else {
            
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            
            item.title = title
        }
        
        if let price = priceField.text {
            
            // here price is double so we covert use NSString quick convertion possible
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            
            item.details = details
        }
        
        // this specifies the item relationship to store
        // inComponent is 0 because we have only one column
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        // to back the previous view
        _ = navigationController?.popViewController(animated: true)
    }
    
    // custom function load existing data
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                // create a loop to compare the name
                var index = 0
                repeat {
                    
                    let s = stores[index]
                    
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        
                        break
                    }
                    
                    index += 1
                    
                    
                } while(index < stores.count)
            }
            
            if let type = item.toItemType {
                
                var index = 0
                repeat {
                    
                    let i = itemTypes[index]
                    
                    if i.type == type.type {
                        
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        
                        break
                    }
                    
                    index += 1
                } while(index < itemTypes.count)
            }
        }
        
        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        // delete the item if data is exist
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // it give dictionary of image so we pick image from that
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // inside we can work
            
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
