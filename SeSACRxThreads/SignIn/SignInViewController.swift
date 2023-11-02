//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SignInViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    // 기존 스위치 버튼 만드는 방법
    let test = UISwitch()
    
    // 데이터 기반으로 적용 : 이벤트 생성, 전달 <- 이벤트를 처리 할 수는 없음 즉, 이벤트를 받을 수 없음
    // ⭐️ 이벤트를 전달과 처리를 같이 하기 위해 Subject 사용 BehaviorSubject: 초기값을 갖고 있음
    // PublishSubject : isOn.onNext(true) 초기값이 없기 때문에 데이터를 개별로 전달해줘야 한다.
    let isOn = PublishSubject<Bool>() // BehaviorSubject(value: true)    // Observable.of(true)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        testSwitch()
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    func testSwitch() {
        view.addSubview(test)
        test.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.leading.equalTo(100)
        }
        
//        isOn // isOn : Observable 역할
//            .subscribe { value in
//                // 이벤트 처리
//                self.test.setOn(value, animated: false)
//            }
//            .disposed(by: disposeBag)
        
        isOn // rx 스러운 코드
            .bind(to: test.rx.isOn)
            .disposed(by: disposeBag)
        
        isOn.onNext(true) // 구독으 안했기 때문에 구독 전에 이벤트를 전달해서 받을 수 없음 bind 이후에 이벤트를 전달해야함
        
        // 버튼을 만들지 않고 타이머를 통해 꺼지는것 확인하기 위한 DispatchQueue
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.isOn.onNext(false) // <- isOn : Observer 역할
        }
        
    }
    
    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    
}
