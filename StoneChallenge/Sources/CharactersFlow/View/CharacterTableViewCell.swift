//
//  CharacterTableViewCell.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    // MARK: UI Components
    lazy var imageCharacter : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var  nameCharacter : UILabel = {
        let title = UILabel()
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.font = UIFont(name: "DIN Alternate Bold", size: 24)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var  statusCircleCharacter: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 7.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var  statusCharacter : UILabel = {
        let title = UILabel()
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.font = UIFont(name: "DIN Alternate", size: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var greyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.2349716425, green: 0.2427235842, blue: 0.267629534, alpha: 1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = #colorLiteral(red: 0.1406107545, green: 0.1563768387, blue: 0.1854715347, alpha: 1)
        self.buildHierarchy()
        self.buildConstraints()
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
   }
    
    // MARK: Privated functions
    fileprivate func buildHierarchy(){
        self.contentView.addSubview(self.greyView)
        self.greyView.addSubview(self.nameCharacter)
        self.greyView.addSubview(self.imageCharacter)
        self.greyView.addSubview(self.statusCharacter)
        self.greyView.addSubview(self.statusCircleCharacter)
    }
    
    fileprivate func buildConstraints(){
        NSLayoutConstraint.activate([
            self.greyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            self.greyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            self.greyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            self.greyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            self.imageCharacter.topAnchor.constraint(equalTo: self.greyView.topAnchor, constant: 24),
            self.imageCharacter.leadingAnchor.constraint(equalTo: self.greyView.leadingAnchor, constant: 24),
            self.imageCharacter.trailingAnchor.constraint(equalTo: self.greyView.trailingAnchor, constant: -24),
            
            self.nameCharacter.topAnchor.constraint(equalTo: self.imageCharacter.bottomAnchor, constant: 16),
            self.nameCharacter.heightAnchor.constraint(equalToConstant: 32),
            self.nameCharacter.centerXAnchor.constraint(equalTo: self.self.greyView.centerXAnchor),
            
            self.statusCharacter.topAnchor.constraint(equalTo: self.nameCharacter.bottomAnchor, constant: 8),
            self.statusCharacter.centerXAnchor.constraint(equalTo: self.nameCharacter.centerXAnchor),
            self.statusCharacter.bottomAnchor.constraint(equalTo: self.greyView.bottomAnchor, constant: -16),
            
            self.statusCircleCharacter.heightAnchor.constraint(equalToConstant: 15),
            self.statusCircleCharacter.widthAnchor.constraint(equalToConstant: 15),
            self.statusCircleCharacter.trailingAnchor.constraint(equalTo: self.statusCharacter.leadingAnchor, constant: -8),
            self.statusCircleCharacter.centerYAnchor.constraint(equalTo: self.statusCharacter.centerYAnchor)
        ])
    }
}
