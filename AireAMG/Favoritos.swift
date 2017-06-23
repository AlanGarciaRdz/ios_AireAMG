//
//  Favoritos.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation


class Favoritos: UIViewController{
    
    let prefs:UserDefaults = UserDefaults.standard
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var lbl_lat: UILabel!
    
    @IBOutlet weak var lbl_lon: UILabel!
    
    
    @IBOutlet weak var lb_fav1: UILabel!
    @IBOutlet weak var lb_fav2: UILabel!
    @IBOutlet weak var lb_fav3: UILabel!
    @IBOutlet weak var lb_fav4: UILabel!
    @IBOutlet weak var txt_fav: UITextField!
    
    override func viewDidLoad() {
        
        //clearfav();
        //self.view.backgroundColor = UIColor.yellow
        let gradient: CAGradientLayer = CAGradientLayer()
        
        //gradient.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradient.colors = [UIColor(red:0.57, green:0.76, blue:0.79, alpha:0.5).cgColor, UIColor(red:0.36, green:0.74, blue:0.82, alpha:0.5).cgColor]
        
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "splash")!)
        readfav();
        
        
        
        let lat_var: AnyObject? = prefs.value(forKey: "lat") as AnyObject?;
        print("data is \(lat_var)");
        
        let lon_var: AnyObject? = prefs.value(forKey: "lon") as AnyObject?;
        print("data is \(lon_var)");
        
        lbl_lat.text = lat_var as! String?;
        lbl_lon.text = lon_var as! String?;
        
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.setObject(Person1, forKey: "Person1")
        
        
        
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func clearfav(){
        for key in prefs.dictionaryRepresentation().keys {
            prefs.removeObject(forKey: key.description)
        }
    }
    
    @IBAction func SaveFav(_ sender: AnyObject) {
        addfavorites();
        
    }
    
    func readfav(){
        if UserDefaults.standard.object(forKey: "favorito1") != nil{
            
            var favvar = prefs.value(forKey: "favorito1") as! String?
            let favarr =  favvar?.components(separatedBy: ",");
            lb_fav1.text = favarr?[0];
        }
        if UserDefaults.standard.object(forKey: "favorito2") != nil{
            
            var favvar = prefs.value(forKey: "favorito2") as! String?
            let favarr =  favvar?.components(separatedBy: ",");
            lb_fav2.text = favarr?[0];
        }
        if UserDefaults.standard.object(forKey: "favorito3") != nil{
            
            var favvar = prefs.value(forKey: "favorito3") as! String?
            let favarr =  favvar?.components(separatedBy: ",");
            lb_fav3.text = favarr?[0];
        }
        if UserDefaults.standard.object(forKey: "favorito4") != nil{
            
            var favvar = prefs.value(forKey: "favorito4") as! String?
            let favarr =  favvar?.components(separatedBy: ",");
            lb_fav4.text = favarr?[0];
            
        }
        
    }
    
    
    @IBAction func mapa1(_ sender: AnyObject) {
        NSLog("mapa1");
        //performSegue(withIdentifier: "showmap", sender: self);
        
        self.performSegue(withIdentifier: "showmap", sender: self);
        
    }
    
    func prepare(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showmap") {
            NSLog("test");
        }
    }
    
    /*func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        NSLog("entro")
        if (segue.identifier == "showmap") {
            let secondViewController = segue.destination as! Mapa
            let latlon = sender as! String
            var favvar = prefs.value(forKey: "favorito1") as! String?
            let favarr =  favvar?.components(separatedBy: ",");
            var latlon_transfer = (favarr?[1])! + (favarr?[2])!;
            secondViewController.variable = latlon_transfer
        }
    }*/
    
    
    
    
    
    
    func addfavorites(){
        
         let fav_Val = txt_fav.text!+","+lbl_lat.text!+","+lbl_lon.text!;
        
        if UserDefaults.standard.object(forKey: "favorito1") != nil{
            // exist
            if UserDefaults.standard.object(forKey: "favorito2") != nil{
                //exist fav 2
                
                if UserDefaults.standard.object(forKey: "favorito3") != nil{
                    //exist fav 3
                    
                    if UserDefaults.standard.object(forKey: "favorito4") != nil{
                        //exist fav 4
                        // save on fav1
                        prefs.setValue(fav_Val, forKey: "favorito1")
                        lb_fav1.text = txt_fav.text;
                        
                        
                    }else{
                        // not exist fav 4  save fav4
                        prefs.setValue(fav_Val, forKey: "favorito4")
                        lb_fav4.text = txt_fav.text;
                    }
                    
                }else{
                    // not exist fav 3  save fav3
                    let prefs = UserDefaults.standard;
                    prefs.setValue(fav_Val, forKey: "favorito3")
                    lb_fav3.text = txt_fav.text;
                    
                }
            }else{
                // not exist fav 2  save fav2
                prefs.setValue(fav_Val, forKey: "favorito2")
                lb_fav2.text = txt_fav.text;
                
            }
        }
        else {
            // not exist save fav1
            prefs.setValue(fav_Val, forKey: "favorito1")
            lb_fav1.text = txt_fav.text;
            
            
        }
        
        lbl_lat.text = "";
        lbl_lon.text = "";
        txt_fav.text = "";
    }
}
