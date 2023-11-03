//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by 염성필 on 2023/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
     
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 80
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
     
    var items = BehaviorSubject(value: Array(100...150).map { "안녕하세요 \($0)"})
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
        
    }
     
    func bind() {
        
        items // == cellforRowAt
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green
            }
            .disposed(by: disposeBag)
        
        // didSelectRowAt
//        tableView.rx.itemSelected // 장점: 인덱스 정보를 알 수 있음 , 단점 : cell 정보는 알 수 없음
//            .subscribe(with: self) { owner, value in
//                print("테이블 뷰 선택 되었음 - itemSelected \(value)")
//            }
//            .disposed(by: disposeBag)
//
//
//        // modelSelected : 배열?에 갖고있는 타입을 똑같이 맞춰주면 됨
//        // 인덱스 정보는 주지 않지만 해당 cell의 정보를 가져옴
//        tableView.rx.modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print("테이블 뷰 선택 되었음 - modelSelected \(value)")
//            }
//            .disposed(by: disposeBag)
        
        // => 두개 다 써야 하나? 너무 낭비 같은데.... ⭐️ zip
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "쎌 선택 \($0) \($1)"}
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        // combind vs zip
        
        /*
         combindLatest : 셋중에 하나만 이벤트가 변경이 되어도 이벤트 탐
         zip: 동시에 짝꿍이 맞아야 이벤트 탐
         */
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
