//
//  ViewController.swift
//  Project7
//
//  Created by Will Kembel on 3/27/24.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabIndex = navigationController?.tabBarItem.tag
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            var urlString: String
            
            if tabIndex == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            }
            else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            
            // load up petition data
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(data)
                }
            }
            else {
                self?.notifyWithError(msg: "Unable to load URL")
            }
        }
    }
    
    func parse(_ json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        else {
            notifyWithError(msg: "Unable to parse JSON data")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dc = DetailViewController()
        dc.petition = petitions[indexPath.row]
        navigationController?.pushViewController(dc, animated: true)
    }

    func notifyWithError(msg: String) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default))
            
            self?.present(ac, animated: true)
        }
    }

}

