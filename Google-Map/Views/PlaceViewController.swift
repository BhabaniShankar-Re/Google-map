//
//  PlaceViewController.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//

import UIKit

class PlaceViewController: UIViewController {
    
    // IBoutlet properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    // IBAction methods
    @IBAction func toggleButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            dataSourceProvider.changeDataSourceTo = .savedData
            searchBar.isUserInteractionEnabled = false
            searchBar.resignFirstResponder()
        }else {
            dataSourceProvider.changeDataSourceTo = .autoComplete
            searchBar.isUserInteractionEnabled = true
        }
        tableView.reloadData()
    }
    
//    @IBAction func loadDummyData(_ sender: Any) {
//        dataSourceProvider.saveDummyData()
//    }
    
    var dataSourceProvider: DataSourceProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.textColor = .white
        dataSourceProvider = DataSourceProvider(tableView, delegate: self)
        searchBar.becomeFirstResponder()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToStartView", let destination = segue.destination as? StartViewController {
            destination.selectedPlace = sender as? Place
        }
    }
  

}

extension PlaceViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            dataSourceProvider.searchPlace(for: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension PlaceViewController: DataSourceProviderDelegate {
    func didSelectAnItem(_ item: Place) {
        // perform unwind segue
        self.performSegue(withIdentifier: "BackToStartView", sender: item)
    }
    
    func didOccurAnyError(_ error: Error) {
        let nserror = error as NSError
        let alert = UIAlertController(title: "Error", message: "Error code: \(nserror.code), info: \(nserror.userInfo)", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default, handler: nil))
        
        if (self.presentedViewController as? UIAlertController) == nil {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}


