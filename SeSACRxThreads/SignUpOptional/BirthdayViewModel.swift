//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 염성필 on 2023/11/02.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    // 데이터 기반으로 생각 해야함 년, 월, 일 , datePicker에 오늘 날짜를 띄어줄지 초기값 설정
    
    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    let year =  BehaviorRelay(value: 2023) // Observable.of(2020)
    let month = BehaviorRelay(value: 12)
    let day = BehaviorRelay(value: 25)
    

    
    let disposeBag = DisposeBag()
    
    init() {
        birthday
            .subscribe(with: self) { owner, date in
                // 년, 월 , 일 필터링하기 - Calendar 구조체 사용
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                // 주‼️ 직접적으로 넣어주는게 아님!!! 전달 -> 전달 -> 전달 ‼️의
                owner.year.accept(component.year!) // year Observer
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
                
                
                
            }
            .disposed(by: disposeBag)
    }

    
}
