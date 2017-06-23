//
//  Opciones.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation


class Opciones: UITableViewController{
    
    let prefs:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let graficar: AnyObject? = prefs.value(forKey: "graficar") as AnyObject?;
        let showkml: AnyObject? = prefs.value(forKey: "showkml") as AnyObject?;
        
        
        
        readvalues();
        
    }
    
    func readvalues(){
        if prefs.object(forKey: "graficar") != nil{
            
            let valuegraf = prefs.value(forKey: "graficar") as! String?
            if(valuegraf == "imeca"){
                imeca.setOn(true, animated:true)
                concentracion.setOn(false, animated: true)
            }else{
                imeca.setOn(false, animated:true)
                concentracion.setOn(true, animated: true)
            }
           
        }
        if UserDefaults.standard.object(forKey: "showkml") != nil{
            let valuemap = prefs.value(forKey: "showkml") as! String?
            if(valuemap == "pm10"){
                pm10.setOn(true, animated:true)
                ozono.setOn(false, animated: true)
            }else{
                pm10.setOn(false, animated:true)
                ozono.setOn(true, animated: true)
            }
        }
        
        
    }

    
    
    @IBOutlet weak var pm10: UISwitch!
    @IBOutlet weak var ozono: UISwitch!
    
    
    @IBAction func pm10action(_ sender: AnyObject) {
        if pm10.isOn {
            ozono.setOn(false, animated:true)
            prefs.setValue("pm10", forKey: "showkml");
        }else{
            ozono.setOn(true, animated:true)
            prefs.setValue("ozono", forKey: "showkml");
        }
    }
    
    @IBAction func ozonoaction(_ sender: AnyObject) {
        if ozono.isOn {
            pm10.setOn(false, animated:true)
            prefs.setValue("ozono", forKey: "showkml");
        }else{
            pm10.setOn(true, animated:true)
            prefs.setValue("pm10", forKey: "showkml");
        }
    }
    
    
    @IBOutlet weak var concentracion: UISwitch!
    
    @IBOutlet weak var imeca: UISwitch!
    
    @IBAction func concentracionaction(_ sender: AnyObject) {
        if concentracion.isOn {
            imeca.setOn(false, animated:true)
            prefs.setValue("concentracion", forKey: "graficar");
        }else{
            imeca.setOn(true, animated:true)
            prefs.setValue("imeca", forKey: "graficar");

        }

    }
    
    @IBAction func imecaaction(_ sender: AnyObject) {
        if imeca.isOn {
            concentracion.setOn(false, animated:true)
            prefs.setValue("imeca", forKey: "graficar");
        }else{
            concentracion.setOn(true, animated:true)
            prefs.setValue("concentracion", forKey: "graficar");
        }
    }
    
    
    
}
