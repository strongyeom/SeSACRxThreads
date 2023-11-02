//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
    // dispose() vs disposed(by: )의 차이
    // dispose : 즉시 리소스 정리 -> 구독을 해제 -> 메모리에서 제거 -> 더이상 코드가 동작하지 않는다.
    // disposed(by: ) : 코드를 계속 활용해야하고 필요한 시점에 정리하는게 필요
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    
    func bind() {
        // datePicker의 값 rx로 랩핑해서 date 값 가져오기
        birthDayPicker.rx.date
             // 가져운 date 값 birthday에 넣기
            .bind(to: viewModel.birthday) // 피커 -> birthday -> 가공 -> 년, 월, 일 전달
            .disposed(by: disposeBag)
    
        viewModel.year // year Observable
            .observe(on: MainScheduler.instance) // ⭐️ MainThread에서 동작할 수 있게끔 넘겨주는 코드
            .map { "\($0)년" } // Int이기 때문에 형 변환 해야함
            .subscribe(with: self, onNext: { owner, value in
                owner.yearLabel.text = value
            }) // subscribe 가 작동할때 백그라운드에서 동작 할 수도 있음 -> 보라색 에러 발생함
            .disposed(by: disposeBag)
        
        viewModel.month
            .observe(on: MainScheduler.instance) // MainThread에서 동작할 수 있게끔 넘겨주는 코드
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = "\(value)월"
            } // subscribe 가 작동할때 백그라운드에서 동작 할 수도 있음 -> 보라색 에러 발생함
            .disposed(by: disposeBag)
        
        viewModel.day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text) // ⭐️ (RxCocoa를 사용한다면) bind: MainThread에서 동작하게끔 내부적으로 구현되어 있음 ‼️ 아닐때도 있음 - 추후
            .disposed(by: disposeBag)
        
        
        
    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
