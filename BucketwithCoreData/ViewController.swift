//
//  ViewController.swift
//  BucketwithCoreData
//
//  Created by admin on 17/12/2021.
//

import UIKit
import CoreData


struct Bucketitem{
    
    var title : String?
    var BucketDescription : String?
}
class ViewController: UITableViewController {
    var BucketObjects = [Bucketitem]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var Bucketrecords = [BucketEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchdata()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BucketObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCell", for: indexPath) as! TableViewCell
        cell.title?.text = BucketObjects[indexPath.row].title
        cell.bucketdetails?.text = BucketObjects[indexPath.row].BucketDescription
      
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "toedit", sender: indexPath)
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        BucketObjects.remove(at: indexPath.row)
        deletedata(index: indexPath as NSIndexPath as NSIndexPath )
        tableView.reloadData()
        
    
    }
    
    @IBAction func gotoaddpage(_ sender: UIBarButtonItem) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "additemViewController") as! additemViewController
                viewController.delegate = self
               navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier=="toedit"{

                let finaldestadditempage = segue.destination as! additemViewController
                   finaldestadditempage.delegate = self
                   let indexPath = sender as! NSIndexPath //  give the
                   let item = BucketObjects[indexPath.row]
                finaldestadditempage.itemtitle = item.title
                   finaldestadditempage.indexPath = indexPath
                finaldestadditempage.desc = item.BucketDescription
            }
    }
 
       
}

//MARK: conform the protocol to add and edit data
extension ViewController : BucketListDelegate {
    func tosaveitem(by controller: UIViewController, thenewitem Bucketobj: Bucketitem, indexPath: NSIndexPath?) {
        if let ip = indexPath
        {
            BucketObjects[ip.row].title = Bucketobj.title
            BucketObjects[ip.row].BucketDescription = Bucketobj.BucketDescription
            
            updatadata(BucketObjects: Bucketobj, index: ip)
        }
        else {
            BucketObjects.append(Bucketitem.init(title: Bucketobj.title!, BucketDescription: Bucketobj.BucketDescription!))
          print("save to table view")
            savedata(BucketObjects: Bucketobj)
        }
        tableView.reloadData()
    }
}



//MARK: CoreData

extension ViewController {
    
    func fetchdata() {
     
      
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BucketEntity")
        do {
            let result =  try context.fetch(request) as! [NSManagedObject]
            for i in result {
                let title = i.value(forKey: "title") as! String
                let desc = i.value(forKey: "bucketdesc") as! String
                let obj = Bucketitem(title: title , BucketDescription: desc )
                BucketObjects.append(obj)
            }
        }
        catch{
            print (error.localizedDescription)
        }
        tableView.reloadData()
    
    }
    
    
    func savedata(BucketObjects: Bucketitem){
    
        
        guard  let theentity = NSEntityDescription.entity(forEntityName: "BucketEntity", in: context) else { return }
        let bucketrecord = NSManagedObject.init(entity: theentity, insertInto: context)
        bucketrecord.setValue(BucketObjects.title, forKey: "title")
        bucketrecord.setValue(BucketObjects.BucketDescription, forKey: "bucketdesc")
        do
        {
            try context.save()
            print ("data saved in coredata")
        }
        catch{
            print (error.localizedDescription)
        }
    }
    func updatadata(BucketObjects: Bucketitem, index: NSIndexPath)
    {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BucketEntity")
        do {
            let result =  try context.fetch(request) as! [NSManagedObject]
        
            result[index.row].setValue(BucketObjects.title, forKey: "title")
            result[index.row].setValue(BucketObjects.BucketDescription, forKey: "bucketdesc")

           try context.save()
        }
        catch{
            print (error.localizedDescription)
        }
    }
    
    func deletedata(index: NSIndexPath){
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "BucketEntity")
        do {
            var result =  try context.fetch(request) as! [NSManagedObject]
        
            let deleteobj = result[index.row]
            context.delete(deleteobj)

           try context.save()
        }
        catch{
            print (error.localizedDescription)
        }
        
    }
}
  
