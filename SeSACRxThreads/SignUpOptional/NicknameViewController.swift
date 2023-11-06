//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
       
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
    }
    
    func bind() { // share()의 활용?
        
        let tap = nextButton
            .rx
            .tap
        // map의 return값이 Observable<Result> 으로 되어 있기 때문에 Unicast로 보여짐 -> Observer의 갯수만큼 탐
        // ==> 해결 방법 .share()을 사용하여 Muticast의 기능을 할 수있게 해줌
            .map{ "안녕하세요 반갑습니다. \(Int.random(in: 1...100))" }
            .share()
        
        tap
            .subscribe(with: self) { owner, value in
                owner.nextButton.setTitle(value, for: .normal)
            }
            .disposed(by: disposeBag)
        
        tap
        // bind : UI에 적합한 형태 next만 방출함
            .bind(with: self) { owner, value in
                owner.nicknameTextField.text = value
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                owner.navigationItem.title = value
            }
            .disposed(by: disposeBag)
        
        
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(BirthdayViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
