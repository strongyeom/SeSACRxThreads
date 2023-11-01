//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    // 보여줄때 처음 초기값 보여주게 하기
    let phone = BehaviorSubject(value: "010")
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        // 초기에 false로 버튼 isEnabled 설정하기
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        buttonColor
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        // TextField에 borderColor 적용
        buttonColor
            .map { $0.cgColor } // cgColor로 변환
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        
        phone // 전달하는 목적일때도 있고 처리 할때도 쓰일때가 있기 때문에 Subject로 묶었음
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phone
            .map { $0.count > 10 }
            .subscribe { value in
                print("=== \(value)")
                let color = value ? UIColor.blue : UIColor.red
                self.buttonColor.onNext(color)
//                self.nextButton.isEnabled = value
                self.buttonEnabled.onNext(value) // ==  self.buttonEnabled.on(.next(value)) 같음
                
            }
            .disposed(by: disposeBag)
        
        // 클로저 안에 self 처리 1.
        phone
            .map { $0.count > 10 }
            .withUnretained(self) // 클로저 구문 안에 self를 안적게 도와줌 == [weak self] 대치
        // withUnretained를 사용하게 되면 매개변수로 (VC, Bool)이 되기 때문에 클로저 구문안에 매개변수로 하나더 생성하기
            .subscribe { object, value in
                print("=== \(value)")
                let color = value ? UIColor.blue : UIColor.red
                object.buttonColor.onNext(color)
//                self.nextButton.isEnabled = value
                object.buttonEnabled.onNext(value) // ==  self.buttonEnabled.on(.next(value)) 같음
                
            }
            .disposed(by: disposeBag)
        
        // 클로저 안에 self 처리 2.
        phone
            .map { $0.count > 10 }
            // subscribe(with ~ ) : 내부에 withUnretained 를 적용해줌
            .subscribe(with: self, onNext: { owner, value in
                print("=== \(value)")
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value) // ==  self.buttonEnabled.on(.next(value)) 같음
            })
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .subscribe { value in
                let result = value.formated(by: "###-###-####")
                print("result : \(result), value: \(value)")
                self.phone.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

extension String {
    var decimalFilteredString: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }
    
    func formated(by patternString: String) -> String {
        let digit: Character = "#"
 
        let pattern: [Character] = Array(patternString)
        let input: [Character] = Array(self.decimalFilteredString)
        var formatted: [Character] = []
 
        var patternIndex = 0
        var inputIndex = 0
 
        // 2
        while inputIndex < input.count {
            let inputCharacter = input[inputIndex]
 
            // 2-1
            guard patternIndex < pattern.count else { break }
 
            switch pattern[patternIndex] == digit {
            case true:
                // 2-2
                formatted.append(inputCharacter)
                inputIndex += 1
            case false:
                // 2-3
                formatted.append(pattern[patternIndex])
            }
 
            patternIndex += 1
        }
 
        // 3
        return String(formatted)
    }
}
