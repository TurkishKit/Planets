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


}

