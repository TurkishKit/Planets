//
//  AddPlanetViewController.swift
//  Planets
//
//  Created by Ege Sucu on 14.10.2019.
//  Copyright © 2019 Ege Sucu. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AddPlanetViewController: UIViewController {
    
    
//    IBOutlet variables
    @IBOutlet weak var planetTitle : UITextField!
    @IBOutlet weak var planetDescription: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func save(_ sender:UIBarButtonItem){
        
//        Verilerin boş olmadığından emin oluyoruz.
        guard let title = planetTitle.text,
            let description = planetDescription.text else {return}
        
//        Veritabanına referans göstererek erişiyoruz.
        let ref = Database.database().reference(withPath: "planets")
        
//        Veritabanına gezegenin ismini ve altına isim/özelliği bilgilerini ekliyoruz.
        ref.child(title).setValue(["title" : title , "description" : description])
        
//        Önceki Sayfaya geri dönüyoruz.
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    
    

   

}
