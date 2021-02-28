//
//  DataSource.swift
//  Google-Map
//
//  Created by Summit on 28/02/21.
//

import UIKit
import GooglePlaces


protocol DataSourceProviderDelegate {
    func didSelectAnItem(_ item: Place)
    func didOccurAnyError(_ error: Error)
}


class DataSourceProvider: NSObject {
    
    enum DataSourceType {
        case autoComplete, savedData
    }
    
    var tableView: UITableView
    var delegate: DataSourceProviderDelegate?
    
    private var autoCompleteDataSource: GMSAutocompleteTableDataSource
    private var localDataDataSource: SavedLocalDataDatasource
    
    
    var changeDataSourceTo: DataSourceType {
        didSet {
            if changeDataSourceTo == .autoComplete {
                tableView.dataSource = autoCompleteDataSource
                tableView.delegate = autoCompleteDataSource
            }else {
                do {
                    try localDataDataSource.fetchLocalData()
                    tableView.dataSource = localDataDataSource
                    tableView.delegate = localDataDataSource
                }catch {
                    delegate?.didOccurAnyError(error)
                }
                    
            }
        }
    }
    
    init(_ tableView: UITableView, dataSourceType: DataSourceType = .autoComplete, delegate: DataSourceProviderDelegate? = nil) {
        
        changeDataSourceTo = dataSourceType
        self.tableView = tableView
        self.delegate = delegate
        
        autoCompleteDataSource = GMSAutocompleteTableDataSource()
        
        localDataDataSource = SavedLocalDataDatasource()
        
        super.init()
        autoCompleteDataSource.delegate = self
        localDataDataSource.delegate = self
    }
    
    
    func searchPlace(for text: String) {
        if changeDataSourceTo == .autoComplete {
            autoCompleteDataSource.sourceTextHasChanged(text)
        }
    }
    
    func saveDummyData() {
//        for i in 1...3 {
//            let place = Place(context: localDataDataSource.localDataHandler.viewContext)
//            place.name = "name\(i)"
//            place.placeid = "\(i)"
//            place.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(20 + i), longitude: CLLocationDegrees(80 + i))
//        }
//        do {
//            try localDataDataSource.saveDataToLocalStore()
//        } catch {
//            delegate?.didOccurAnyError(error)
//        }
    }
    
    private func saveSelectedPlace(_ place: GMSPlace) {
        let managedObject = Place(context: localDataDataSource.localDataHandler.viewContext)
        managedObject.name = place.name
        managedObject.placeid = place.placeID
        managedObject.coordinate = place.coordinate
        do {
            try localDataDataSource.saveDataToLocalStore()
        }catch {
            delegate?.didOccurAnyError(error)
        }
    }

    
}

//
// MARK: Confirm to Google api call Delegate, Local data Delegate.
//
extension DataSourceProvider: GMSAutocompleteTableDataSourceDelegate, LocalDataSourceDelegate {
    
    func didSelectAPlace(_ place: Place) {
        delegate?.didSelectAnItem(place)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        saveSelectedPlace(place)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        delegate?.didOccurAnyError(error)
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        tableView.reloadData()
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        tableView.reloadData()
    }
    
}
