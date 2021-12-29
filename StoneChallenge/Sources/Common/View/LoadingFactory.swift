//
//  LoadingFactory.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 29/12/21.
//

import Foundation
import UIKit

public class LoadingFactory {
    
    // MARK: Varbles & Constants
    public static let sharedInstance = LoadingFactory()
    fileprivate let blurImg = UIImageView()
    fileprivate let indicator = UIActivityIndicatorView()

    // MARK: View lifecycle & UI Setup
    init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = #colorLiteral(red: 0.2349716425, green: 0.2427235842, blue: 0.267629534, alpha: 1)
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 1
        
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.color = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
        indicator.startAnimating()
    }
    
    // MARK: Public functions
    func showLoading(){
        DispatchQueue.main.async {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self.blurImg)
            UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self.indicator)
        }
    }
    
    func hideLoading(){
        DispatchQueue.main.async {
                self.blurImg.removeFromSuperview()
                self.indicator.removeFromSuperview()
        }
    }
    
    func showIndicatorInView(currentView: UIView){
        DispatchQueue.main.async {
            self.indicator.center = currentView.center
            currentView.addSubview(self.blurImg)
            currentView.addSubview(self.indicator)
        }
    }
    
    func showLoadingInImageView(currentImageView: UIImageView){
        DispatchQueue.main.async {
            currentImageView.addSubview(self.blurImg)
            self.indicator.style = .large
            self.indicator.startAnimating()
            self.indicator.center.y = (currentImageView.frame.height/2)
            self.indicator.center.x = (currentImageView.frame.width/2)
            currentImageView.addSubview(self.indicator)
        }
    }
}
