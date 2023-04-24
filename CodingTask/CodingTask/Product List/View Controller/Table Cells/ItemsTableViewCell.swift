//
//  ItemsTableViewCell.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import UIKit

protocol ItemsTableCellDelegate: AnyObject {
    func productItemSelectedAt(_ productCell: ItemsTableViewCell, productModel: ProductUIModel)
}

class ItemsTableViewCell: UITableViewCell {
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    weak var cellDelegate: ItemsTableCellDelegate?
    private var productData: ProductUIModel!

    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var productTitleLabel : UILabel!
    @IBOutlet weak var productDescriptionLabel : UILabel!
    @IBOutlet weak var activityIndicatorVw : UIActivityIndicatorView!
    @IBOutlet weak var selectionBtn : UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicatorVw.hidesWhenStopped = true
        if #available(iOS 13.0, *){
            activityIndicatorVw.style = .medium
        }else{
            activityIndicatorVw.style = .gray
        }
    }
    
    @IBAction func productItemSelectionChanged(){
        productData.isSelected = !productData.isSelected
        updateSelectionModeForCell()
        cellDelegate?.productItemSelectedAt(self, productModel: productData)
    }
    
    private func updateSelectionModeForCell(){
        let image = productData.isSelected ? UIImage(named: "radio_on") : UIImage(named: "radio_off")
        selectionBtn.setImage(image, for: .normal)
    }
    
    public func updateItemCellWith(productModel : ProductUIModel){
        productData = productModel
        updateSelectionModeForCell()
        productTitleLabel.text = productModel.title
        productDescriptionLabel.text = productModel.description
        if let url = URL(string: productModel.imageUrlString ?? ""){
            downloadImage(from: url, imageView: productImageView)
        }
    }
    
    private func downloadImage(from url: URL, imageView : UIImageView) {
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) {
            imageView.image = imageFromCache as? UIImage
            return
        }
        
        activityIndicatorVw.startAnimating()
        getData(from: url) { [weak self] data, response, error in
            DispatchQueue.main.async() { [weak self] in
                self?.activityIndicatorVw.stopAnimating()
                guard let data = data, error == nil else {
                    imageView.image = UIImage(named: "default_image")
                    return
                }                
                if let image =  UIImage(data: data){
                    self?.imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
                    imageView.image = image
                }else{
                    imageView.image = UIImage(named: "default_image")
                }
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
