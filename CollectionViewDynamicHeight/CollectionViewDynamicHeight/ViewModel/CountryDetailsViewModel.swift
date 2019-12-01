//
//  CountryDetailsViewModel.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 01/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryDetailsViewModel: NSObject {
    
    //MARK: - Variables
    
    var countryDetailsArray = [CountryDetailsModel]() {
        didSet {
            filterArray = countryDetailsArray
        }
    }
    
    var filterArray = [CountryDetailsModel]()
    
    private var view: CountryDetailsVC?
    
    //MARK: - init
    
    /// init
    /// - Parameter view: CountryDetailsVC object
    init(view: CountryDetailsVC) {
        self.view = view
    }
    
    //MARK: - Helper Methods
    
    ///
    func getCountryDetails() {
        if ApiManager.isInternetAvailable {
            self.view?.showHud(title: nil)
            ApiManager.sharedInstance.requestFor(urlPath: ApiList.getCountryDetails, param: nil, httpMethod: .get, includeHeader: false, success: { [weak self] (response) in
                
                self?.view?.hideHud()
                
                let jsonData = JSON(response)
                
                self?.countryDetailsArray = jsonData.arrayValue.map { CountryDetailsModel($0)}
                
                self?.view?.detailCollectionView.reloadData()
                
                self?.view?.reloadDropDown()
                
            }, failure: { [weak self] (response, error) in
                self?.view?.hideHud()
                print(response, error)
            })
        } else {
            self.view?.showInternetAlert()
        }
    }
    
    /// filter Countrydetails by using symobl
    /// - Parameter symobl: symbol
    func filterByUsingSymbol(symobl: String) {
        if symobl == "Select" {
            reset()
        } else {
            filterArray = []
            for value in countryDetailsArray {
                if let currency = value.currencies {
                    for valueCu in currency {
                        if let sym = valueCu.symbol, symobl == sym {
                            filterArray.append(value)
                        }
                    }
                }
            }
        }
        self.view?.detailCollectionView.reloadData()
    }
    /// reset
    func reset() {
        filterArray = countryDetailsArray
    }
}
