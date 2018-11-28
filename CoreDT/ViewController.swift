//
//  ViewController.swift
//  CoreDT
//
//  Created by Equinox on 20/11/2561 BE.
//  Copyright © 2561 Equinox. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ViewController: UIViewController {

    var databaseRefer : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var Ck : String = ""
    
    @IBOutlet weak var FieldUname: UITextField!
    @IBOutlet weak var FieldPass: UITextField!
    @IBOutlet weak var LogbtnUI: UIButton!
    
    
    @IBOutlet weak var uidlabel: UILabel!
    @IBOutlet weak var fnamelebel: UILabel!
    @IBOutlet weak var lnamelabel: UILabel!
    @IBOutlet weak var agelabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowCoreUser()
        LogbtnUI.layer.cornerRadius = 0.07 * LogbtnUI.bounds.size.width
        
    }

    
    @IBAction func LoginAct(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: FieldUname.text!, password: FieldPass.text!) { (user, error) in
            if(user != nil){
                self.databaseRefer = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid
                
                if(uid != nil){
                    let context = self.appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "CoreUsers", in: context)
                    let logedUser = NSManagedObject(entity: entity!, insertInto: context)
                
                    print("LOGIN SUCCESS !")
                    print("UID : "+uid!)
                
                    self.databaseRefer.child("users").child(uid!).observeSingleEvent(of: .value, with: { (data) in
                        let value = data.value as? NSDictionary
                        let Fname = value?["First Name"] as? String ?? ""
                        let Lname = value?["Last Name"] as? String ?? ""
                        let Age = value?["Age"] as? String ?? ""
                        print("First Name : "+Fname)
                        print("Last Name : "+Lname)
                        print("Age : "+Age)
                        
                        logedUser.setValue(Fname, forKey: "corefname")
                        logedUser.setValue(Lname, forKey: "corelname")
                        logedUser.setValue(Age, forKey: "coreage")
                        logedUser.setValue(uid!, forKey: "coreuid")
                        
                        do{
                            try context.save()
                            
                            self.uidlabel.text = "UID : "+uid!
                            self.fnamelebel.text = "First Name : "+Fname
                            self.lnamelabel.text = "Last Name : "+Lname
                            self.agelabel.text = "Age : "+Age
                            
                            print("Core Data SAVED !")
                            self.ShowCoreUser()
                        }catch{
                            print("Core Data Can't SAVE !!!")
                        }
                        
                    })
                
                }
                
            }else{
                print("Error Cant Sign In")
            }
            
            
        }
        
    }
    
    
    
    func ShowCoreUser() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreUsers")
        let context = self.appDelegate.persistentContainer.viewContext
        
        request.returnsObjectsAsFaults = false
        
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "corefname") as! String)
                self.Ck = (data.value(forKey: "corefname") as! String)
            }
            if(self.Ck != ""){
                self.moveToLoged()
            }
        }catch{
            print("CANT FETCH FROM CORE DATA")
        }
        
    }
    
    
    func moveToLoged(){
        let strboard = UIStoryboard(name: "Main", bundle: nil)
        let ctrler = strboard.instantiateViewController(withIdentifier: "logStr")
        self.present(ctrler,animated: true,completion: nil)
    }
    
    
}

