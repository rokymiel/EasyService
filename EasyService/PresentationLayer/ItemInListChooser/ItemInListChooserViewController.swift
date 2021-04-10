//
//  ItemInListChooserViewController.swift
//  EasyService
//
//  Created by Михаил on 09.04.2021.
//  Copyright © 2021 rokymiel. All rights reserved.
//

import UIKit

typealias ItemChosenHandler = (String) -> Void
class ItemInListChooserViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UIUnderlinedTextField!
    @IBOutlet weak var itemsTableView: UITableView!
    
    public var items: [String]?
    public var itemChosenHandler: ItemChosenHandler!
    
    let cellReuseIdentifier = "cell"
    private var searchString: String?
    private var filteredPersons: [String] {
        if let items = items {
            if let searchString = searchString?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                !searchString.isEmpty {
                return items.filter { $0.lowercased().contains(searchString) }
            }
            return items
        }
        return []
    }
    
    class func sInit() -> ItemInListChooserViewController {
        let contraller = UIStoryboard.itemInListChooser.instantiate(self)
        return contraller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.text = nil
        searchString = nil
        itemsTableView.reloadData()
    }
    
    @IBAction func searchTextChanged(_ sender: Any) {
        searchString = searchTextField.text
        itemsTableView.reloadData()
    }
    
}

extension ItemInListChooserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableViewCell()
        cell.textLabel?.text = filteredPersons[indexPath.row]
        return cell
    }
}

extension ItemInListChooserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = filteredPersons[indexPath.row]
        
        itemChosenHandler(filteredPersons[indexPath.row])
        
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            return
        }
        itemsTableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
