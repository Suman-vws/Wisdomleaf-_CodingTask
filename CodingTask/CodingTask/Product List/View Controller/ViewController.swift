//
//  ViewController.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 22/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let productCellReuseId = "ItemsTableViewCell"
    private let productCellNibName = "ItemsTableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Products"
        configTableView()
    }

    private func configTableView(){
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: productCellNibName, bundle: nil), forCellReuseIdentifier: productCellReuseId)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellReuseId, for: indexPath) as! ItemsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

