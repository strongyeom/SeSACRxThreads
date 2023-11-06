//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        aboutUnicast()
        aboutMuticast()
        requestExample()
    }
    
    func requestExample() {
        // Observable<SearchAppModel>을 리턴하기 때문에 유니 캐스트 -> Observer의 갯수만큼 콜을 함...
        // 쓸데 없이 콜수가 많이 일어남 한번의 네트워크 통신으로 다른 Observer에 뿌려주는 방법은 없을까?
        
        // ⭐️ share(): 대표적인 기능 - 유니캐스트 -> 멀티캐스트로 바꿔줌
        let request = BasicAPIManager.fetchData().share()
        
      
        // 데이터 통신한 Observable을 사용해서
        // 1. TableView에 보여줄 수 있고
        request
            .subscribe(with: self) { owner, value in
                dump(value)
            }
            .disposed(by: disposeBag)
        
        // 2. DB에 저장할 수있고
        request
            .subscribe(with: self) { owner, value in
                print("데이터 통신 갯수 - \(value.results.count)")
            }
            .disposed(by: disposeBag)
        
        // 3. UI에 보여줄 수 있음
        request
            .map { data in
                "\(data.results.count)개의 검색 결과"
            }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    
    func aboutUnicast() { // Observable 특성
        
        // create : Observable 클래스를 만들고자 할때
        
       let random = Observable.create { value in
            value.onNext(Int.random(in: 1...100))
            return Disposables.create()
        } // create가 observer 갯수만큼 실행 
        
        random
            .subscribe(with: self) { owner, value in
                print("create Random1 - \(value)")
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print("create Random2 - \(value)")
            }
            .disposed(by: disposeBag)
        
        random
            .subscribe(with: self) { owner, value in
                print("create Random3 - \(value)")
            }
            .disposed(by: disposeBag)
    }
    
   
    func aboutMuticast() {  // Subject 특성
        let random = BehaviorSubject(value: 100)
         
        
        random.onNext(Int.random(in: 1...100))
        
         random
             .subscribe(with: self) { owner, value in
                 print("aboutMuticast1 - \(value)")
             }
             .disposed(by: disposeBag)
         
         random
             .subscribe(with: self) { owner, value in
                 print("aboutMuticast2 - \(value)")
             }
             .disposed(by: disposeBag)
         
         random
             .subscribe(with: self) { owner, value in
                 print("aboutMuticast3 - \(value)")
             }
             .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
