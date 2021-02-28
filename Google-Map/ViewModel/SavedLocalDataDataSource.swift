//
//  SavedLocalDataDataSource.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//

import UIKit


protocol LocalDataSourceDelegate {
    func didSelectAPlace(_ place: Place)
}


class SavedLocalDataDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: LocalDataSourceDelegate?
    
    
    var localData: [Place] = []
    var localDataHandler = LocalDataHandler.shared
    
    func fetchLocalData() throws {
        let fetchRequest = Place.createFetchRequest()
        localData = try localDataHandler.viewContext.fetch(fetchRequest)
    }
    
    func saveDataToLocalStore() throws {
        try localDataHandler.saveContext()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //1
        localData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let locationData = localData[indexPath.row]
        cell.textLabel?.text = locationData.name
        cell.detailTextLabel?.text = "latitude: \(locationData.latitude), longitude: \(locationData.longitude)"
        let view = UIImageView(image: UIImage(systemName: "star.fill"))
        view.tintColor  = .yellow
        cell.accessoryView = view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = localData[indexPath.row]
        delegate?.didSelectAPlace(selectedItem)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = localData[indexPath.row]
            localDataHandler.viewContext.delete(place)
            localData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            try? localDataHandler.saveContext()
        }
    }
    
    

}
