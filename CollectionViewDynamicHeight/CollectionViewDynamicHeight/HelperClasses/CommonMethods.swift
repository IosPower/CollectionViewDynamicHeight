

import UIKit
import DropDown

///
class CommonMethods: NSObject {

    /// Generating random string
    ///
    /// - Parameter length: string length
    /// - Returns: Give random string
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // Hemant Change
        return String((0...length-1).map { _ in letters.randomElement() ?? Character("random") })
    }
    
    // MARK: Navigation Methdods
    ///This methods manage the navigation.
    ///
    ///- parameter destinationVC:        destination view controller
    ///- parameter navigationController: navigation controller object
    ///- parameter animated:             Animation (true/false)
    class func navigateTo(_ destinationVC: UIViewController, inNavigationViewController navigationController: UINavigationController, animated: Bool ) {
        var VCFound: Bool = false
        let viewControllers = navigationController.viewControllers
        var indexofVC: NSInteger = 0
        for existVc in navigationController.viewControllers {
            if existVc.nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        DispatchQueue.main.async(execute: {
            if VCFound == true {
                navigationController.popToViewController(viewControllers[indexofVC], animated: animated)
            } else {
                navigationController.pushViewController(destinationVC, animated: animated)
            }
        })
    }
    
    /// character limit of textfields set
    ///
    /// - Parameters:
    ///   - textField: current text field
    ///   - charLength: max length of textfield
    ///   - range: range of string
    ///   - string: number of characters
    /// - Returns: return true false value
    class func textFieldsValidate(textField: UITextField, charLength: Int, range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= charLength
    }
    
    class func textFieldWithDecimalPointAndCharacterLimit(textField: UITextField, charLength: Int =  CharacterLimit.threeDigit, range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil) || newText.hasPrefix(".")
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        if !newText.contains(".") && newText.count > charLength {
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && CommonMethods.textFieldsValidate(textField: textField, charLength: CharacterLimit.threeDigit, range: range, replacementString: string)
        } else {
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && CommonMethods.textFieldsValidate(textField: textField, charLength: charLength + CharacterLimit.threeDigit, range: range, replacementString: string)
        }
    }
    
    /// only allow number and given character limit in textfield
    ///
    /// - Parameters:
    ///   - textField: UItextField
    ///   - range: range
    ///   - string: string to pass
    /// - Returns: return's valid or not with bool value.
    class func textFieldWithNumberAndCharacterLimit(textField: UITextField, range: NSRange, string: String, charLength: Int) -> Bool {
        let onlyNo = "0123456789"
        if string.isEmpty {
            return true
        }
        let numberFiltered = string.getFilterCharacterSet(strNumorSym: onlyNo)
        if numberFiltered == "" {
            return false
        }
        return CommonMethods.textFieldsValidate(textField: textField, charLength: charLength, range: range, replacementString: string)
    }
    
    /// check textfield value zero so set empty value textfield
    ///
    /// - Parameter textField: textfield object
    /// - Returns: bool value
    class func checkZeroValue(textField: UITextField) -> Bool {
        guard textField.text == "0.0" || textField.text == "00.0" || textField.text == "000.0" || textField.text == "0.00" || textField.text == "00.00" || textField.text == "000.00" else { return false }
        return true
    }
    
    /// convert pdf to images
    class func convertPDFPageToImage(fileUrl: URL, success: @escaping (_ filesArray: [String]) -> Void, failure: @escaping (_ errorResponse: [String: Any]) -> Void) {
    
        var fileListArray = [String]()
        let filePath = fileUrl.path
    
        DispatchQueue.global(qos: .utility).async {
            // Do background work
            do {
                let pdfdata = try NSData(contentsOfFile: filePath, options: NSData.ReadingOptions.init(rawValue: 0))
                let pdfData = pdfdata as CFData
                
                guard let provider: CGDataProvider = CGDataProvider(data: pdfData), let pdfDoc: CGPDFDocument = CGPDFDocument(provider) else {
                    return failure([ModelKeys.ResponseKeys.message: "Not getting images from pdf."])
                }
                
                let pageCount = pdfDoc.numberOfPages
                
                for index in 0..<pageCount {
                    if let pdfPage: CGPDFPage = pdfDoc.page(at: index + 1) {
                        var pageRect: CGRect = pdfPage.getBoxRect(.mediaBox)
                        pageRect.size = CGSize(width: pageRect.size.width, height: pageRect.size.height)
                        UIGraphicsBeginImageContext(pageRect.size)
                        
                        if let context = UIGraphicsGetCurrentContext() {
                            context.saveGState()
                            context.translateBy(x: 0.0, y: pageRect.size.height)
                            context.scaleBy(x: 1.0, y: -1.0)
                            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
                            context.drawPDFPage(pdfPage)
                            context.restoreGState()
                            
                            if let pdfImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
                                UIGraphicsEndImageContext()
                                
                                let imagedata = pdfImage.pngData()
                                let documentsPath = FileManageHelper.documentsDirectory().appendingPathComponent("page\(index + 1).png")
                                do {
                                    fileListArray.append(documentsPath.absoluteString)                       
                                    fileListArray.append(documentsPath.lastPathComponent.lowercased())
                                    print(documentsPath.absoluteString)
                                    try imagedata?.write(to: documentsPath)
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    success(fileListArray)
                }
            } catch let error {
                failure([ModelKeys.ResponseKeys.message: error.localizedDescription])
            }
        }
    }
    ///
    static func setDropDown(withTextField textField: UITextField, dropDown: DropDown, button: UIButton, dropDownArray: [String]) {
        dropDown.anchorView = button
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropDown.dataSource = dropDownArray
    }
    
    ///
    static func onDropDownClick(dropDown: DropDown, textField: UITextField) {
        dropDown.show()
        dropDown.selectionAction = { (index: Int, item: String) in
            if item != "Select" {
                textField.text = item
            } else {
                textField.text = ""
            }
        }
    }
    
    ///
    static func openURL(withURL url: String) {
        var urlString = url
        if !urlString.contains("http://") && !urlString.contains("https://") {
            urlString = "https://" + urlString
        }
        guard let urlPath = URL(string: urlString) else {
            return //be safe // "http://www.google.com"
        }
        if UIApplication.shared.canOpenURL(urlPath) {
            UIApplication.shared.open(urlPath, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        } else {
           // alert here
            // cant open url
        }
    }
    
    ///
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String) {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
    }
    
    ///
    static func convertToJsonString(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    ///
    static func currentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
}
