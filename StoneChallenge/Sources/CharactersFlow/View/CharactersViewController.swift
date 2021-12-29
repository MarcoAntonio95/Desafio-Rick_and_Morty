//
//  CharactersViewController.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class CharactersViewController: UIViewController {
    
    // MARK: UI Components
    private lazy var charactersTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.accessibilityIdentifier = "charactersTableView"
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "characterCell")
        tableView.rowHeight = 350
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: Varbles & Constants
    private var charactersViewModel: CharactersViewModel
    private var filterViewModel = FilterViewModel()
    private let disposeBag = DisposeBag()
    private var currentPage = 1
    
    // MARK: View Init
    init(viewModel: CharactersViewModel){
        self.charactersViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.buildNavegationBar()
        self.buildRxNavigationAction()
    }
    
    // MARK: UI Setup
    func buildView() {
        self.view.backgroundColor = #colorLiteral(red: 0.1406107545, green: 0.1563768387, blue: 0.1854715347, alpha: 1)
        self.buildHierarchy()
        self.buildConstraints()
        self.buildRxBindings()
        self.buildUIActions()
    }
    
    // MARK: Privated functions
    fileprivate func buildNavegationBar() {
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = #colorLiteral(red: 0.1406107545, green: 0.1563768387, blue: 0.1854715347, alpha: 1)
        customNavBarAppearance.shadowImage = nil
        customNavBarAppearance.shadowColor = nil
        
        self.navigationItem.title = "CHARACTERS"
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController!.isNavigationBarHidden = false
        self.navigationController!.navigationBar.standardAppearance = customNavBarAppearance
        self.navigationController!.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.accessibilityIdentifier = "searchButton"
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2140395045, green: 0.5938284397, blue: 0.1042619124, alpha: 1)
    }
    
    fileprivate func buildRxNavigationAction(){
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
              [weak self] in
              guard let `self` = self else { return }
            self.charactersViewModel.showFilterView(currentView: self)
          }).disposed(by: self.disposeBag)
    }
    
    fileprivate func buildHierarchy() {
        self.view.addSubview(charactersTableView)
    }
    
    fileprivate func buildConstraints() {
        NSLayoutConstraint.activate([
            self.charactersTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.charactersTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.charactersTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.charactersTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    fileprivate func buildRxBindings() {
        self.charactersViewModel.currentCharacters.bind(to: self.charactersTableView.rx.items(cellIdentifier: "characterCell",cellType: CharacterTableViewCell.self)){
            row,item,cell in
            
            cell.accessibilityIdentifier = "characterCell"
            
            cell.nameCharacter.text = item.name
            cell.statusCharacter.text = item.status
            
            cell.statusCircleCharacter.backgroundColor = item.status == "Alive" ? UIColor.green : item.status == "Dead" ? UIColor.red : UIColor.gray
            
            let loadingFactory = LoadingFactory()
            loadingFactory.showLoadingInImageView(currentImageView: cell.imageCharacter)
            
            guard let imageUrl = item.imageUrl else { return }
            
            if (!imageUrl.isEmpty){
                self.charactersViewModel.downloadCharacterImage(imageUrl: imageUrl).bind { data in
                    DispatchQueue.main.async {
                        loadingFactory.hideLoading()
                        cell.imageCharacter.image = UIImage(data: data)
                    }
                }.disposed(by: self.disposeBag)
            }
        }.disposed(by: self.disposeBag)
    }
    
    fileprivate func buildUIActions() {
        self.charactersTableView.rx.modelSelected(Character.self).bind { character in
            let characterData = character as Any
            self.charactersViewModel.startDetailsFlow(currentCharacter: characterData)
        }.disposed(by: self.disposeBag)
        
        self.charactersTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.charactersTableView.contentOffset.y
            let contentHeight = self.charactersTableView.contentSize.height
            
            if offSetY > (contentHeight - self.charactersTableView.frame.size.height - 10) {
                self.charactersViewModel.nextPage()
            }
        }
        .disposed(by: disposeBag)
    }

}

