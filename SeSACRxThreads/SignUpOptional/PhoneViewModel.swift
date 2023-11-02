//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 염성필 on 2023/11/02.
//

import RxSwift
import UIKit

class PhoneViewModel {

    let phone = BehaviorSubject(value: "010")
    let buttonEnabled = BehaviorSubject(value: false)
    let buttonColor = BehaviorSubject(value: UIColor.red)
    
    let disposeBag = DisposeBag()
    
    init() {
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
          //      print("=== \(value)")
                let color = value ? UIColor.blue : UIColor.red
                owner.buttonColor.onNext(color)
                owner.buttonEnabled.onNext(value) // ==  self.buttonEnabled.on(.next(value)) 같음
            })
            .disposed(by: disposeBag)
        
    }
}
