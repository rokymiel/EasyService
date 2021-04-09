//
//  NewCarViewController.swift
//  EasyService
//
//  Created by Михаил on 02.01.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class NewCarViewController: UITableViewController {
    
    @IBOutlet weak var markTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var gearTextField: UITextField!
    @IBOutlet weak var engineVolumeTextField: UITextField!
    @IBOutlet weak var yearTextField: UIView!
    
    private var presentationAssembly: PresentationAssembly!
    
    class func sInit(presentationAssembly: PresentationAssembly) -> NewCarViewController {
        let contraller = UIStoryboard.newCarViewController.instantiate(self)
        contraller.presentationAssembly = presentationAssembly
        //        contraller.accountService = accountService
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markTextField.delegate = self
        modelTextField.delegate = self
        bodyTextField.delegate = self
        gearTextField.delegate = self
        chooser = presentationAssembly.buildItemInListChooserViewController()
        
        //        markTextField.inputView
        // Do any additional setup after loading the view.
    }
    var chooser: ItemInListChooserViewController?
    
    
    @IBAction func markClicked(_ sender: Any) {
        
        
        if let controller = chooser {
            controller.items = ["Audi", "Kia"]
            controller.itemChosenHandler = { str in
                self.markTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func modelClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = ["Audi", "Kia"]
            controller.itemChosenHandler = { str in
                self.modelTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func bodyClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = ["Audi", "Kia"]
            controller.itemChosenHandler = { str in
                self.bodyTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    
    @IBAction func gearClicked(_ sender: Any) {
        if let controller = chooser {
            controller.items = ["Audi", "Kia"]
            controller.itemChosenHandler = { str in
                self.gearTextField.text = str
            }
            present(controller, animated: true)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension NewCarViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
