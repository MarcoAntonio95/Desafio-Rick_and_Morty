//
//  CharacterDetailsViewController.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 28/12/21.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CharacterDetailsViewController: UIViewController {

    // MARK: UI Setup
    lazy var characterImage : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let name = UILabel(frame: .zero)
        name.layer.cornerRadius = 16
        name.layer.masksToBounds = true
        name.textColor = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
        name.textAlignment = .center
        name.backgroundColor = .clear
        name.layer.cornerRadius = 16
        name.font = UIFont(name: "DIN Alternate Bold", size: 36)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var statusCircleView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 7.5
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let status = UILabel(frame: .zero)
        status.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        status.textAlignment = .center
        status.font = UIFont(name: "DIN Alternate Bold", size: 18)
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    private lazy var statusView: UIView = {
      let contentView = UIView()
      contentView.layer.cornerRadius = 16
      contentView.layer.masksToBounds = true
      contentView.backgroundColor = #colorLiteral(red: 0.1802104115, green: 0.1840381324, blue: 0.2006301582, alpha: 1)
      contentView.translatesAutoresizingMaskIntoConstraints = false
      return contentView
    }()
    
    private lazy var speciesLabel: UILabel = {
        let species = UILabel(frame: .zero)
        species.layer.cornerRadius = 16
        species.layer.masksToBounds = true
        species.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        species.textAlignment = .center
        species.backgroundColor = #colorLiteral(red: 0.1802104115, green: 0.1840381324, blue: 0.2006301582, alpha: 1)
        species.layer.cornerRadius = 16
        species.font = UIFont(name: "DIN Alternate Bold", size: 18)
        species.translatesAutoresizingMaskIntoConstraints = false
        return species
    }()
    
    private lazy var typeLabel: UILabel = {
        let type = UILabel(frame: .zero)
        type.layer.cornerRadius = 16
        type.layer.masksToBounds = true
        type.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        type.textAlignment = .center
        type.backgroundColor = #colorLiteral(red: 0.1802104115, green: 0.1840381324, blue: 0.2006301582, alpha: 1)
        type.font = UIFont(name: "DIN Alternate Bold", size: 18)
        type.translatesAutoresizingMaskIntoConstraints = false
        return type
    }()
    
    private lazy var genderLabel: UILabel = {
        let gender = UILabel(frame: .zero)
        gender.layer.cornerRadius = 16
        gender.layer.masksToBounds = true
        gender.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        gender.textAlignment = .center
        gender.backgroundColor = #colorLiteral(red: 0.1802104115, green: 0.1840381324, blue: 0.2006301582, alpha: 1)
        gender.font = UIFont(name: "DIN Alternate Bold", size: 18)
        gender.translatesAutoresizingMaskIntoConstraints = false
        return gender
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
        button.layer.cornerRadius = 21
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()

    private lazy var contentView: UIView = {
      let contentView = UIView()
      contentView.translatesAutoresizingMaskIntoConstraints = false
      return contentView
    }()

    private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.alignment = .leading
      stackView.spacing = 16
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
    }()
    
    // MARK: Varbles & Constants
    private var characterDetailsViewModel: CharacterDetailsViewModel
    private let disposeBag = DisposeBag()
    var currentCharacter = Character()
    
    // MARK: Initialization
    init(viewModel: CharacterDetailsViewModel){
        self.characterDetailsViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        buildView()
    }
    
    // MARK: UI Setup
    func buildView() {
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.buildHierarchy()
        self.buildConstraints()
        self.bindDataInView()
        self.buildRxBindings()
        self.buildUIActions()
    }
    
    fileprivate func buildHierarchy() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.characterImage)
        self.statusView.addSubview(self.statusLabel)
        self.statusView.addSubview(self.statusCircleView)
        self.stackView.addArrangedSubview(self.statusView)
        self.stackView.addArrangedSubview(self.speciesLabel)
        self.stackView.addArrangedSubview(self.genderLabel)
        self.stackView.addArrangedSubview(self.typeLabel)
        self.stackView.addArrangedSubview(self.backButton)
    }
    
    fileprivate func buildConstraints() {
        let characterImageSize = (self.view.frame.width-32)
        NSLayoutConstraint.activate([
               self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
               self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
               self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
               self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),

               self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
               self.contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
               self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
               self.contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
               self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),

               self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
               self.stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
               self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
               self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
               
               self.nameLabel.heightAnchor.constraint(equalToConstant: 36),
               self.nameLabel.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
               
               self.characterImage.widthAnchor.constraint(equalToConstant: characterImageSize),
               self.characterImage.heightAnchor.constraint(equalToConstant: characterImageSize),
               self.characterImage.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
               
               self.statusView.leadingAnchor.constraint(equalTo:
                    self.stackView.leadingAnchor, constant: 16),
               self.statusView.trailingAnchor.constraint(equalTo:
                    self.stackView.trailingAnchor, constant: -16),
               self.statusView.heightAnchor.constraint(equalToConstant: 36),
               
               self.statusLabel.centerXAnchor.constraint(equalTo:
                    self.statusView.centerXAnchor),
               self.statusLabel.centerYAnchor.constraint(equalTo:
                    self.statusView.centerYAnchor),
               self.statusLabel.heightAnchor.constraint(equalToConstant: 36),
               
               self.statusCircleView.trailingAnchor.constraint(equalTo: self.statusLabel.leadingAnchor,constant: -8),
               self.statusCircleView.centerYAnchor.constraint(equalTo:
                    self.statusLabel.centerYAnchor),
               self.statusCircleView.widthAnchor.constraint(equalToConstant: 15),
               self.statusCircleView.heightAnchor.constraint(equalToConstant: 15),
               
               self.speciesLabel.leadingAnchor.constraint(equalTo:
                    self.stackView.leadingAnchor, constant: 16),
               self.speciesLabel.trailingAnchor.constraint(equalTo:
                    self.stackView.trailingAnchor, constant: -16),
               self.speciesLabel.heightAnchor.constraint(equalToConstant: 36),
               
               self.genderLabel.leadingAnchor.constraint(equalTo:
                    self.stackView.leadingAnchor, constant: 16),
               self.genderLabel.trailingAnchor.constraint(equalTo:
                    self.stackView.trailingAnchor, constant: -16),
               self.genderLabel.heightAnchor.constraint(equalToConstant: 36),
               
               self.typeLabel.leadingAnchor.constraint(equalTo:
                    self.stackView.leadingAnchor, constant: 16),
               self.typeLabel.trailingAnchor.constraint(equalTo:
                    self.stackView.trailingAnchor, constant: -16),
               self.typeLabel.heightAnchor.constraint(equalToConstant: 36),
               
               self.backButton.leadingAnchor.constraint(equalTo:
                    self.stackView.leadingAnchor, constant: 16),
               self.backButton.trailingAnchor.constraint(equalTo:
                    self.stackView.trailingAnchor, constant: -16),
               self.backButton.heightAnchor.constraint(equalToConstant: 42),
        ])
        
    }
    
    fileprivate func bindDataInView() {
        self.nameLabel.text = self.currentCharacter.name
        let status = self.currentCharacter.status
        self.statusCircleView.backgroundColor = status == "Alive" ? UIColor.green : status == "Dead" ? UIColor.red : UIColor.gray
        self.statusLabel.text = status
        self.speciesLabel.text = self.currentCharacter.species
        self.genderLabel.text = self.currentCharacter.gender
        self.typeLabel.text = self.currentCharacter.type
    }
    
    fileprivate func buildRxBindings(){
        guard let imageUrl = self.currentCharacter.imageUrl else { return }
        
        if (!imageUrl.isEmpty){
            self.characterDetailsViewModel.downloadCharacterImage(imageUrl: imageUrl).bind { data in
                DispatchQueue.main.async {
                    self.characterImage.image = UIImage(data: data)
                }
            }.disposed(by: self.disposeBag)
        }
    }

    fileprivate func buildUIActions() {
        self.backButton.rx.tap.subscribe(onNext: {
              [weak self] in
              guard let `self` = self else { return }
            self.characterDetailsViewModel.returnToCharacters()
        }).disposed(by: self.disposeBag)
    }
}

