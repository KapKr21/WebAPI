//
//  ViewController.swift
//  WebAPISample
//
//  Created by Kap's on 29/06/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var listOfHolidays = [HolidayDetail]() {
        
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfHolidays.count) Holidays found"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBarOutlet.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension ContentViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBarText = searchBar.text else {
            
            let alertTitle = "Alert!"
            let alertMessage = "Search bar can not be empty!"
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        
        holidayRequest.getHolidays { [weak self] result in
            
            switch result {
            case .failure(let error) :
                print(error)
            case .success(let holidays):
                self?.listOfHolidays = holidays
            }
        }
    }
}

extension ContentViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let holidays = listOfHolidays[indexPath.row]
        
        cell?.textLabel?.text = holidays.name
        cell?.detailTextLabel?.text = holidays.date.iso
        
        return cell!
    }
}

