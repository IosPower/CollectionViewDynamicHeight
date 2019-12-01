//
//  CountryDetailsVC.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 01/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher
import SVGKit

/// this class is responsible to display country flag, description and user response related stuff
class CountryDetailsVC: UIViewController {
    
    //MARK: - IBOutlet
    
    ///
    @IBOutlet weak var detailCollectionView: UICollectionView!
    ///
    @IBOutlet weak var dropTextfield: UITextField!
    
    //MARK: - Variables
    
    ///
    let titleString = "By default, the drop down will be shown onto to anchor view. It will hide it. If you need the drop down to be below your anchor view when the direction of the drop down is .bottom, you can precise an offset like this:"
    ///
    let subTitleStr = "No tap is needed to dismiss"
    ///
    var countryDetailsViewModel: CountryDetailsViewModel?
    /// dropdown object
    let dropDown = DropDown()
    ///
    var dropDownDataArray = [String]()
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryDetailsViewModel = CountryDetailsViewModel(view: self)
        
        setupDropDown()
        countryDetailsViewModel?.getCountryDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Initial Setup
    
    /// drop down datasource, selection action setup
    func setupDropDown() {
        dropDown.anchorView = dropTextfield
        dropDown.direction = .any
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 5
        dropDown.dataSource = dropDownDataArray
        dropDown.offsetFromWindowBottom = Constant.screenHeight/2
        
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.dropTextfield.text = item
            self?.countryDetailsViewModel?.filterByUsingSymbol(symobl: item)
        }
        dropDown.cancelAction = { [unowned self] in
            print(self)
            print("Drop down dismissed")
        }
        dropDown.willShowAction = { [unowned self] in
            print(self)
            print("Drop down will show")
        }
    }
    
    //MARK: - IBAction
    
    ///
    @IBAction func dropButtonAction(_ sender: Any) {
        dropDown.show()
    }
    
    //MARK: - Helper Methods
    
    /// dropDown listing item given
    func reloadDropDown() {
        let arrayNew  = countryDetailsViewModel?.countryDetailsArray.compactMap({$0.currencies?.map({$0.symbol})}).flatMap({$0}).uniqueElements
        let finalArray = arrayNew?.filter({$0 != nil})
        guard let arrayCurrency: [String] = finalArray as? [String] else { return }
        let result = ["Select"] + arrayCurrency.filter({!$0.isEmpty})
        dropDownDataArray = result.uniqueElements
        dropDown.dataSource = dropDownDataArray
    }
}

//MARK: - UICollectionViewDataSource
extension CountryDetailsVC: UICollectionViewDataSource {
    /// Asks your data source object for the number of items in the specified section.
    /// - Parameter collectionView: The collection view requesting this information. section An index number identifying a section in collectionView.
    /// - Parameter section: This index value is 0-based.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("index Count", countryDetailsViewModel?.filterArray.count ?? 0)
        return countryDetailsViewModel?.filterArray.count ?? 0
    }
    
    ///
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell  else { fatalError("DetailCollectionViewCell not created") }
        
        cell.titleLabel.text = countryDetailsViewModel?.filterArray[indexPath.item].name
        cell.subTitleLabel.text = countryDetailsViewModel?.filterArray[indexPath.item].capital
        cell.imgHeightConstraint.constant = (detailCollectionView.frame.size.width - 30)/2
        
        //let str = countryDetailsViewModel?.countryDetailsArray[indexPath.item].flag ?? ""
        let str = "https://cdn.pixabay.com/photo/2015/12/01/20/28/fall-1072821__340.jpg"
        
        
        if let flagUrl = URL(string: str) {
            
            //            DispatchQueue.global(qos: .userInitiated).async {
            //                let dasdas = SVGKImage(contentsOf: flagUrl)
            //                DispatchQueue.main.async {
            //                    cell.imageView.image = dasdas?.uiImage
            //                }
            //            }
            //
            
            let sizeNew = CGSize(width: (detailCollectionView.frame.size.width - 30)/2, height: (detailCollectionView.frame.size.width - 30)/2)
            let processor = DownsamplingImageProcessor(size: sizeNew)
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: flagUrl,
                placeholder: nil,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    cell.imageView.image = value.image
                //   print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    cell.imageView.image = nil
                }
            }
            
            //                      KingfisherManager.shared.retrieveImage(with: flagUrl, options: nil, progressBlock: nil) { result in
            //                          switch result {
            //                          case .success(let value):
            //                           cell.imageView.image = value.image
            //                          case .failure(let error):
            //                              print("Error: \(error)")
            //                              cell.imageView.image = nil
            //                          }
            //                      }
            
        }
        
        
        
        return cell
    }
}
//MARK: - UICollectionViewDelegate
extension CountryDetailsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension CountryDetailsVC: UICollectionViewDelegateFlowLayout {
    ///
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var name = countryDetailsViewModel?.filterArray[indexPath.item].name ?? ""
        var capital = countryDetailsViewModel?.filterArray[indexPath.item].capital ?? ""
        
        if name.isEmpty {
            name = " "
        }
        
        if capital.isEmpty {
            capital = " "
        }
        
        let font1 = UIFont.systemFont(ofSize: 16.0)
        let title = heightForLabel(name, font: font1)
        let subTitle = heightForLabel(capital, font: font1)
        
        let imageHeight:CGFloat = (detailCollectionView.frame.size.width - 30)/2
        
        return CGSize(width: imageHeight, height: imageHeight + title + subTitle + 10)
    }
    /// height of label
    /// - Parameter text: text of label
    /// - Parameter font: font of label
    func heightForLabel(_ text:String, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: (detailCollectionView.frame.size.width - 30)/2, height: .greatestFiniteMagnitude))
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
}
