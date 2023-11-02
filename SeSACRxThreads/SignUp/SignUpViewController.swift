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
    let disposeBag = DisposeBag() // deinit 되는 시점에 내부에 dispose()되는 메서드 있음
    
    deinit {
        print("deinit - signUp")
    }
    enum JackError: Error {
        case invalid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
//        incrementExample()
//        disposeExample()
       // aboutPublishSubject()
       //  aboutBehaviorSubject()
        aboutReplaySubjectSubject()
    }
    
    func aboutReplaySubjectSubject() {
        // 버퍼 사이즈가 갖고 있음 어떤 이벤트를 가지고 있다가 뿜어줄것이냐 즉, 구독 이전에 몇개를 가지고 있다가 구독 이후에 한번에 내보냄
        let publish = ReplaySubject<Int>.create(bufferSize: 3)
        publish.onNext(1)
        publish.onNext(2)
        publish.onNext(3)
        publish.onNext(20)
        publish.onNext(30)
        
        publish
            .subscribe(with: self) { owner, value in
                print("PublishSubject - \(value)")
            } onError: { owner, error in
                print("PublishSubject error - \(error)")
            } onCompleted: { owner in
                print("PublishSubject onCompleted")
            } onDisposed: { owner in // 사라지는 타이밍을 보기 찍는 것인 이벤트는 아님
                print("PublishSubject onDisposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(7)
        publish.onNext(49)
        
        publish.onCompleted()
        
        // 리소스가 정리가 되면 그 이후에는 이벤트를 받을 수 없음
        publish.onNext(73)
        publish.onNext(6)
        
    }
    
    // 초기값 설정
    func aboutBehaviorSubject() {
        // 구독 전 최신 이벤트만 가져옴 - 가장 마지막에 방출한 값
        let publish = BehaviorSubject(value: 200)
        
        publish.onNext(20)
        publish.onNext(30)
        
        publish
            .subscribe(with: self) { owner, value in
                print("PublishSubject - \(value)")
            } onError: { owner, error in
                print("PublishSubject error - \(error)")
            } onCompleted: { owner in
                print("PublishSubject onCompleted")
            } onDisposed: { owner in // 사라지는 타이밍을 보기 찍는 것인 이벤트는 아님
                print("PublishSubject onDisposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(7)
        publish.onNext(49)
        
        publish.onCompleted()
        
        // 리소스가 정리가 되면 그 이후에는 이벤트를 받을 수 없음
        publish.onNext(73)
        publish.onNext(6)
        
    }
    
    // 초기값이 없음 즉, 비어있는 배열
    func aboutPublishSubject() {
        // 구독 이후 시점 후 부터 이벤트를 받아 볼 수 있음
        let publish = PublishSubject<Int>()
        
        publish.onNext(20)
        publish.onNext(30)
        
        publish
            .subscribe(with: self) { owner, value in
                print("PublishSubject - \(value)")
            } onError: { owner, error in
                print("PublishSubject error - \(error)")
            } onCompleted: { owner in
                print("PublishSubject onCompleted")
            } onDisposed: { owner in // 사라지는 타이밍을 보기 찍는 것인 이벤트는 아님
                print("PublishSubject onDisposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(7)
        publish.onNext(49)
        
        publish.onCompleted()
        
        // 리소스가 정리가 되면 그 이후에는 이벤트를 받을 수 없음
        publish.onNext(73)
        publish.onNext(6)
        
    }
    
    func incrementExample() {
        let increment = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        increment
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
    }
    
    func disposeExample() {
        // 에러 구문을 타게 하기 위해 BehaviorSubject 으로 변경
        // -> onCompleted, onDisposed print 찍히기 않음 이유 : 전달과 이벤트를 받을 수 있기 때문에 next만 계속 탐
        let textArray = BehaviorSubject(value: ["Hue", "Jack", "Koko", "Bran"])
        //Observable.from(["Hue", "Jack", "Koko", "Bran"])
        // -> onCompleted, onDisposed print 찍힘 이유: 전달만 하기 때문에 해당 요소를 전달하면 끝남
        
        // 상수로 담는 순간 dispose가 없더라도 컴파일 에러 발새하지 않는다.
        // 상수로 담으면 필요한 순간에 직접 리소스를 정리 할 수 있음
        let textArrayValue = textArray
            .subscribe(with: self) { owner, value in
                print("next - \(value)")
            } onError: { owner, error in
                print("error - \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in // 사라지는 타이밍을 보기 찍는 것인 이벤트는 아님
                print("onDisposed")
            }
           
        
        // 이벤트를 받는 것까지 처리하면 onCompleted, onDisposed 실행함
        textArray.onNext(["A", "B", "C"])
        
        textArray.onNext(["D", "E", "F"])
        
      //  textArray.onError(JackError.invalid)
        
        textArray.onNext(["Z", "ZZ", "ZZZ"])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 필요한 시점에 직접 정리 할 수 있음
            textArrayValue.dispose()
        }

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
