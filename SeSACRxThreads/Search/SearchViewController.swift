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
    
    var data = ["A", "B", "C"]
    
    lazy var items = BehaviorSubject(value: data)
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
        setSearchController()
        
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
            //.bind(to: navigationItem.rx.title)
            .subscribe(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        /*
         combind vs zip
         combindLatest : 셋중에 하나만 이벤트가 변경이 되어도 이벤트 탐
         zip: 동시에 짝꿍이 맞아야 이벤트 탐
         */
        
        
        // 1. SearchBar text를 배열에 추가. return 키를 클릭했을때
        // 2. text 옵셔널 바인딩 처리 -> 배열에 추가 append -> reloadData
        // 3. SearchBarDelegate searchButtonClicked
        
        searchBar.rx
            .searchButtonClicked // return Void
        // withLatestFrom : 기존 (현재 버튼의 Void )과 가지고 오고 싶어하는 타입(TextField의 String)을 결합했을때 사용
            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { void, text in
                return text
            })
            .subscribe(with: self, onNext: { owner, text in
                print(text)
                // 배열에 append 하는 방법 data로 배열을 뺀 이유 : 안빼고 처리하면 try! 구문을 써야함
                // try! items.value().append(text)
                owner.data.insert(text, at: 0)
                owner.items.onNext(owner.data)
            })
//            .subscribe(with: self) { owner, _ in
//                // searchbar의 text를 바로 갖고오고 싶을때는? searchButtonClicked의 return 타입 void 인데 어떻게 가져 올 수 있을까?
////                // 1.
////                print(owner.searchBar.text!)
////
//                // 2.
//                print("Selected Search Return Button")
//            }
            .disposed(by: disposeBag)
//
//        searchBar.rx.text.orEmpty
//            .subscribe(with: self) { owner, value in
//                print("SearchBar Text : \(value)")
//            }
//            .disposed(by: disposeBag)
//
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
