//
//  LogedViewController.swift
//  CoreDT
//
//  Created by Equinox on 20/11/2561 BE.
//  Copyright © 2561 Equinox. All rights reserved.
//

import UIKit
import CoreData

class LogedViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var uidLa: UILabel!
    @IBOutlet weak var FnameLa: UILabel!
    @IBOutlet weak var LanemLa: UILabel!
    @IBOutlet weak var AgeLa: UILabel!
    @IBOutlet weak var SignOutBtnUi: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignOutBtnUi.layer.cornerRadius = 0.07 * SignOutBtnUi.bounds.size.width
        ShowCoreUser()
    }
    

    
    @IBAction func SignOutAct(_ sender: Any) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreUsers")
        let context = appDelegate.persistentContainer.viewContext
        let deleteReq = NSBatchDeleteRequest(fetchRequest: request)
        do{
            try context.execute(deleteReq)
            try context.save()
            print("CORE DATA HAS BEEN CLEAR !!!")
            moveToView(viewname: "LoginSTR")
        }catch{
            print("ERROR CANT DELETE COR DATA !!!")
        }
    }
    
    
    func ShowCoreUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreUsers")
        let context = self.appDelegate.persistentContainer.viewContext
        
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                
                uidLa.text = (data.value(forKey: "coreuid") as! String)
                FnameLa.text = (data.value(forKey: "corefname") as! String)
                LanemLa.text = (data.value(forKey: "corelname") as! String)
                AgeLa.text = (data.value(forKey: "coreage") as! String)
            }
           
        }catch{
            print("CANT FETCH FROM CORE DATA")
        }
        
    }
    
    
    func moveToView(viewname:String){
        let strboard = UIStoryboard(name: "Main", bundle: nil)
        let ctrler = strboard.instantiateViewController(withIdentifier: viewname)
        self.present(ctrler,animated: true,completion: nil)
    }
    
    
    
}
