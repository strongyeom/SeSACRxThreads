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

    let viewModel = PhoneViewModel()
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
        viewModel.buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        viewModel.buttonColor
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        // TextField에 borderColor 적용
        viewModel.buttonColor
            .map { $0.cgColor } // cgColor로 변환
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        viewModel.phone // 전달하는 목적일때도 있고 처리 할때도 쓰일때가 있기 때문에 Subject로 묶었음
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        viewModel.phone
            .observe(on: MainScheduler.instance)
            .map { $0.count > 10 }
            .subscribe { value in
                print("=== \(value)")
                let color = value ? UIColor.blue : UIColor.red
                
            //    self.buttonEnabled.onNext(value) // ==  self.buttonEnabled.on(.next(value)) 같음
                self.viewModel.buttonColor.onNext(color)
                self.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .observe(on: MainScheduler.instance)
            .subscribe { value in // value는 단지 TextField에 보여지는 text를 나타냄
                let result = value.formated(by: "###-####-####")
                print("result : \(result), value: \(value)")
                self.viewModel.phone.onNext(result)
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
