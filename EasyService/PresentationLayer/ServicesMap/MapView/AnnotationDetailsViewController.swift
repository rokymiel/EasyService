//
//  AnnotationDetailsViewController.swift
//  EasyService
//
//  Created by Михаил on 12.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

class AnnotationDetailsViewController: UIViewController, Configurable {
    typealias Model = Service
    func configure(_ model: Service) {
        return
    }
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var dragView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.layer.cornerRadius = dragView.frame.height / 2.0
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layer.cornerRadius = 15
        
//        detailsView.layer.cornerRadius = 20
//        detailsView.layer.shadowColor = UIColor.black.cgColor
//        detailsView.layer.shadowOpacity = 0.3
//        detailsView.layer.shadowOffset = .zero
//        detailsView.layer.shadowRadius = 20
//        detailsView.layer.shadowPath = UIBezierPath(rect: detailsView.bounds).cgPath
//        detailsView.layer.shouldRasterize = true
//        detailsView.layer.rasterizationScale = UIScreen.main.scale
        //        UIView.animate(withDuration: 0.3) { [weak self] in
        //            let frame = self?.view.frame
        //            let yComponent = UIScreen.main.bounds.height - 200
        //            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        
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
