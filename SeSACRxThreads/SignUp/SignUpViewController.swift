//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    
    enum JackError: Error {
        case invalid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        disposeExample()

    }
    
    func disposeExample() {
        // 에러 구문을 타게 하기 위해 BehaviorSubject 으로 변경
        // -> onCompleted, onDisposed print 찍히기 않음 이유 : 전달과 이벤트를 받을 수 있기 때문에 next만 계속 탐
        let textArray = BehaviorSubject(value: ["Hue", "Jack", "Koko", "Bran"])
        //Observable.from(["Hue", "Jack", "Koko", "Bran"])
        // -> onCompleted, onDisposed print 찍힘 이유: 전달만 하기 때문에 해당 요소를 전달하면 끝남
        textArray
            .subscribe(with: self) { owner, value in
                print("next - \(value)")
            } onError: { owner, error in
                print("error - \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in // 사라지는 타이밍을 보기 찍는 것인 이벤트는 아님
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
        // 이벤트를 받는 것까지 처리하면 onCompleted, onDisposed 실행함
        textArray.onNext(["A", "B", "C"])
        
        textArray.onNext(["D", "E", "F"])
        
        textArray.onError(JackError.invalid)
        
        textArray.onNext(["Z", "ZZ", "ZZZ"])

    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
