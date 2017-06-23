//
//  BackTableVC.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController{
    
    
    var options = [String]()
    
    override func viewDidLoad() {
        options = ["Mapa","Opciones", "Favoritos", "Legal"]
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: options[indexPath.row], for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        //cell.contentView.backgroundColor = UIColor(red:0.36, green:0.74, blue:0.82, alpha:1.0)
        return cell
    }
   
    
}
