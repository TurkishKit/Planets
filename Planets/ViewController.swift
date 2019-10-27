//
//  ViewController.swift
//  Planets
//
//  Created by Ege Sucu on 11.10.2019.
//  Copyright © 2019 Ege Sucu. All rights reserved.
//

import UIKit
import FirebaseDatabase


struct Planet{
    //    Bu şablonun amacı bize kolay yoldan gezegen yaratıp bunu göstermeyi sağlamak, bu yolu öneriyoruz.
    var title =  ""
    var description = ""
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var planetTable:UITableView!
    
    private var ref : DatabaseReference!
    
    private var planets = [Planet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Objeleri buluttan çekiyoruz.
        fetchObjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    
    private func fetchObjects(){
        
        //        Referans ile Veritabanını çağırıyoruz.
        ref = Database.database().reference(withPath: "planets")
        
        //        Referansta olan her değişikliği sürekli gözetliyoruz.
        ref.observe(.value) { (snapshot) in
            
            //            İçeriğinde bir veya daha fazla obje olduğundan emin oluyoruz.
            if snapshot.childrenCount > 0 {
                
                //                Dizinin içini boşaltıyoruz. (Önceden doldu ise)
                self.planets.removeAll()
                
                //                Objeleri döngüye alıyoruz.
                for planets in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //                    Objenin geldiğinden emin oluyoruz.
                    if let planetObject = planets.value as? [String:Any],
                        //                        Objemizin başlığı olduğundan emin oluyoruz.
                        let title = planetObject["title"] as? String,
                        //                        Objemizin açıklaması olduğundan emin oluyoruz.
                        let description = planetObject["description"] as? String{
                        
                        //                        Yeni bir gezegen objesi yaratıyoruz.
                        let planet = Planet(title: title, description: description)
                        
                        //                        Gezegen listemize ekliyoruz.
                        self.planets.append(planet)
                        
                    }
                    
                }
                //                Tablomuzu yeniliyoruz.
                self.planetTable.reloadData()
                
                
            }
            
        }
        
        
        
    }
    
    
    func removeItem(item: Planet){
        ref = Database.database().reference()
        ref.child("planets/\(item.title)").removeValue()
        
    }
    
    
    
    func updateItem(item: Planet){
        ref = Database.database().reference()
        
        
        let popup = UIAlertController(title: "Update Description", message: "You can fix what's wrong.", preferredStyle: .alert)
        popup.addTextField { (textField) in
            textField.text = item.description
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let textFields = popup.textFields,
                let textField = textFields.first,
                let text = textField.text else { return }
            self.ref.child("\(item.title)/description").setValue(text)
            
            self.fetchObjects()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        popup.addAction(saveAction)
        popup.addAction(cancelAction)
        self.present(popup, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        Kaç gezegen varsa liste o kadar olmalı.
        return planets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        Özel hücremizi çağırıyoruz.
        let cell = tableView.dequeueReusableCell(withIdentifier: "planet") as! PlanetCell
        //        Listeden sırası gelen objeyi seçiyoruz.
        let selected = planets[indexPath.row]
        //        Bilgileri dolduruyoruz.
        cell.planetTitle.text = selected.title
        cell.planetDescription.text = selected.description
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let remove = UIContextualAction(style: .destructive, title: "Remove") { (action, UIView, (Bool)->Void) in
            self.removeItem(item: self.planets[indexPath.row])
            self.planets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [remove])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "Update") { (action, UIView, (Bool) -> Void) in
            self.updateItem(item: self.planets[indexPath.row])
            self.fetchObjects()
            tableView.reloadData()
        }
        update.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [update])
    }
    
    
    
    
}

