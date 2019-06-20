//
//  ListVC.swift
//  OnThaMap
//
//  Created by Ghaida Almahmoud on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {
    let cellId = "cellId"
    
    var studentsLocations: [StudentLocation]! {
        return Global.shared.StudentsLocations
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if studentsLocations == nil{
            reloadStudentsLocations(self)
        }else{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @IBAction func logout(_ sender: Any){
        UdacityAPI.deleteSession{(error) in
            if let error = error{
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func postPin(_ sender: Any){
        if UserDefaults.standard.value(forKey: "studentLocation") != nil{
            let alert = UIAlertController(title: "you have elready a student location. Would you like to overweite your current location?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action)in
                self.performSegue(withIdentifier: "listToNewLocation", sender: self)
            }))
            present(alert, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "listToNewLocation", sender: self)
        }
      }
    @IBAction func reloadStudentsLocations(_ sender: Any){
        UdacityAPI.parse.getStudentsLocations{(_, error) in
            if let error = error{
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return studentsLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.imageView?.image = UIImage(named: "pin" )
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentsLocations[indexPath.row]
        guard let toOpen = studentLocation.mediaURL , let url = URL(string: toOpen) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    }



