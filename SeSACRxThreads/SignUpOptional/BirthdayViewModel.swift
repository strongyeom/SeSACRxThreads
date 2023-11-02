//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 염성필 on 2023/11/02.
//

import Foundation
import RxSwift
// import RxCocoa  UIKit 기반이긴 하지만 구성하다보면 import 할 때도 있음 
class BirthdayViewModel {
    
    // 데이터 기반으로 생각 해야함 년, 월, 일 , datePicker에 오늘 날짜를 띄어줄지 초기값 설정
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year =  BehaviorSubject(value: 2023) // Observable.of(2020)
    let month = BehaviorSubject(value: 12)
    let day = BehaviorSubject(value: 25)
    
    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .subscribe(with: self) { owner, date in
                // 년, 월 , 일 필터링하기 - Calendar 구조체 사용
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                // 주‼️ 직접적으로 넣어주는게 아님!!! 전달 -> 전달 -> 전달 ‼️의
                owner.year.onNext(component.year!) // year Observer
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
            }
            .disposed(by: disposeBag)
    }

    
}
