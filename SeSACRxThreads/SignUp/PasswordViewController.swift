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
