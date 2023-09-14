//
//  ViewController.swift
//  ListApp
//
//  Created by Emre Dikici on 13.09.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [NSManagedObject]()
    
    var alertController  =  UIAlertController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
        
    /*    let appDelagete = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelagete?.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListItem")
        
        data = try! managedObjectContext?.fetch(fetchrequest) as! [NSManagedObject] */
    }
    
   
    
    
    // trash iconun görevi
    @IBAction func didRemoveBUtton(_ sender: UIBarButtonItem) {
        
        presentAlert(title: "Warning ",
                     message: "Are You Sure ? ",
                     defaultButtonTitle: "Yes",
                     cancelButtonTitle: "No") { _ in
            
            self.data.removeAll()
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func didTapButton(_ sender: UIBarButtonItem) {
        
        presentAddAlert()
    }
    
    
    
    
    
    // alert ekleme fonksiyonu
    func presentAddAlert(){
        
        presentAlert(title: "Add New Things ",
                     message: nil,
                     defaultButtonTitle: "Add",
                     cancelButtonTitle:"Anyway",
                     isTextFieldAvailable: true,
                     defaultButtonHandler: { [self] _ in
            let text = self.alertController.textFields?.first?.text
            if text != "" { // textfield alanı boş ise value eklenmemesini önlüyor
               // self.data.append((text)!)
                let appDelagate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelagate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "listItem",
                                                        in: managedObjectContext!)
                
                let ListItem = NSManagedObject(entity: entity!,
                                               insertInto: managedObjectContext)
                
                ListItem.setValue(text, forKey: "title")
                
                try? managedObjectContext?.save()
                
                fetch()
                
            }else{
                self.presentWarningAlert()
                
            }
        })
        
    }
    
    
    // uyarı ekrana bastırma fonksiyonu
    func presentWarningAlert() {
        
        presentAlert(title: "Warning !",
                     message: "Empty Element Cannot Be Added",
                     cancelButtonTitle: "Okey")
    }
    
    
    
    
    func presentAlert(title : String?,
                      message : String?,
                      preferredStyle: UIAlertController.Style = .alert ,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle : String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandler : ((UIAlertAction) -> Void)? = nil){
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        
        if defaultButtonTitle != nil{
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            
            alertController.addAction(defaultButton)
            
        }
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel )
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        
        
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
        
        
    }
    
    func fetch(){
        let appDelagete = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelagete?.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListItem")
        
        data = try! managedObjectContext?.fetch(fetchrequest) as! [NSManagedObject]
        
        tableView.reloadData()
    }
}
    
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let ListItem =  data[indexPath.row]
        cell.textLabel?.text = ListItem.value(forKey: "title") as? String
        return cell
    }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let deleteAction = UIContextualAction(style: .normal,
                                                  title: "Delete") { _,_,_ in
                
                //self.data.remove(at: indexPath.row)
                let appDelagete = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelagete?.persistentContainer.viewContext
                
                managedObjectContext?.delete(self.data[indexPath.row])
                
                try? managedObjectContext?.save()
                
                self.fetch()
                
            }
            
            let editAction = UIContextualAction(style: .normal,
                                                  title: "Edit") { _,_,_ in
                self.presentAlert(title: "Edit Things ",
                             message: nil,
                             defaultButtonTitle: "Edit",
                             cancelButtonTitle:"Anyway",
                             isTextFieldAvailable: true,
                             defaultButtonHandler: { _ in
                    let text = self.alertController.textFields?.first?.text
                    if text != "" { // textfield alanı boş ise value eklenmemesini önlüyor
                        //self.data[indexPath.row] = text!
                        
                        let appDelagete = UIApplication.shared.delegate as? AppDelegate
                        
                        let managedObjectContext = appDelagete?.persistentContainer.viewContext
                        
                        self.data[indexPath.row].setValue(text, forKey: "title")
                        
                        if managedObjectContext!.hasChanges{
                            try? managedObjectContext?.save()
                        }
                        
                        self.tableView.reloadData()
                    }else{
                        self.presentWarningAlert()
                        
                    }
                })
                
                
                
                
            }
                                                  
                                                  
            deleteAction.backgroundColor = .systemRed
            let config =  UISwipeActionsConfiguration(actions: [deleteAction , editAction])
            return config
    
    }
}




                      
                      
