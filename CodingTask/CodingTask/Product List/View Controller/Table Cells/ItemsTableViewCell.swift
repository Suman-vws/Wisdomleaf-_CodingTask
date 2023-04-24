//
//  ItemsTableViewCell.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {
    
    private let imageCache = NSCache<AnyObject, AnyObject>()

    @IBOutlet weak var productImageView : UIImageView!
    @IBOutlet weak var productTitleLabel : UILabel!
    @IBOutlet weak var productDescriptionLabel : UILabel!
    @IBOutlet weak var activityIndicatorVw : UIActivityIndicatorView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicatorVw.hidesWhenStopped = true
    }
    
    public func updateItemCellWith(productModel : ProductUIModel){
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
