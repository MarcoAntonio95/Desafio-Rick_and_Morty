//
//  FilterView.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public class FilterViewController : UIViewController {
    
    // MARK: Varbles & Constants
    
    lazy var greyView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.2349716425, green: 0.2427235842, blue: 0.267629534, alpha: 1)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        title.text = "Filter:"
        title.font = UIFont(name: "DIN Alternate Bold", size: 22)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var nameTextfield: UITextField = {
        let name = UITextField(frame: .zero)
        name.accessibilityIdentifier = "filterNameTextfield"
        name.layer.cornerRadius = 16
        name.layer.borderWidth = 2.0
        name.layer.borderColor = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
        name.placeholder = "  Name:"
        name.returnKeyType = .done
        name.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var statusSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: self.statusItens)
        control.accessibilityIdentifier = "filterStatusSegmentControl"
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.accessibilityIdentifier = "filterButton"
        button.backgroundColor = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
        button.layer.cornerRadius = 24
        button.setTitle("Filter!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var filterViewModel = FilterViewModel()
    private let disposeBag = DisposeBag()
    let statusItens = ["Alive", "Dead", "unknown"]
    
    // MARK: View lifecycle & UI Setup
    init(viewModel:FilterViewModel) {
       self.filterViewModel = viewModel
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.buildView()
    }
    
    fileprivate func buildView() {
        self.buildHierarchy()
        self.buildConstraints()
        self.buildUIActions()
    }
   
    fileprivate func buildHierarchy() {
        self.view.backgroundColor = #colorLiteral(red: 0.1406107545, green: 0.1563768387, blue: 0.1854715347, alpha: 0.7978716718)
        self.view.addSubview(self.greyView)
        self.greyView.addSubview(self.titleLabel)
        self.greyView.addSubview(self.nameTextfield)
        self.greyView.addSubview(self.statusSegmentControl)
        self.greyView.addSubview(self.filterButton)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate ([
            self.greyView.heightAnchor.constraint(equalToConstant: (self.view.frame.height*0.5)),
            self.greyView.widthAnchor.constraint(equalToConstant: (self.view.frame.width*0.8)),
            self.greyView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.greyView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.greyView.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.greyView.leadingAnchor, constant: 8),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.greyView.trailingAnchor, constant: -8),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 32),
            
            self.nameTextfield.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.nameTextfield.leadingAnchor.constraint(equalTo: self.greyView.leadingAnchor, constant: 8),
            self.nameTextfield.trailingAnchor.constraint(equalTo: self.greyView.trailingAnchor, constant: -8),
            self.nameTextfield.heightAnchor.constraint(equalToConstant: 32),
            
            self.statusSegmentControl.topAnchor.constraint(equalTo: self.nameTextfield.bottomAnchor, constant: 16),
            self.statusSegmentControl.leadingAnchor.constraint(equalTo: self.greyView.leadingAnchor, constant: 8),
            self.statusSegmentControl.trailingAnchor.constraint(equalTo: self.greyView.trailingAnchor, constant: -8),
           
            self.filterButton.leadingAnchor.constraint(equalTo: self.greyView.leadingAnchor, constant: 16),
            self.filterButton.trailingAnchor.constraint(equalTo: self.greyView.trailingAnchor, constant: -16),
            self.filterButton.bottomAnchor.constraint(equalTo: self.greyView.bottomAnchor, constant: -16),
            self.filterButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    fileprivate func buildUIActions() {
        self.filterButton.addTarget(self, action: #selector(self.setFilter), for: .touchUpInside)
    }
    
    @objc func setFilter(){
        let name = self.nameTextfield.text ?? ""
        
        let status = statusSegmentControl.selectedSegmentIndex != -1 ? statusSegmentControl.titleForSegment(at: statusSegmentControl.selectedSegmentIndex) ?? "" : ""
        
        DispatchQueue.main.async {
            self.filterViewModel.changeFilter(name, status)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

