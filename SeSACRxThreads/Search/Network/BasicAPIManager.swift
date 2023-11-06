//
//  BasicAPIManager.swift
//  SeSACRxThreads
//
//  Created by 염성필 on 2023/11/06.
//

import Foundation
import RxSwift

enum APIERROR: Error {
    case invalidURL
    case unknown
    case statusError
}

class BasicAPIManager {
    
    static func fetchData() -> Observable<SearchAppModel> {
        // <SearchAppModel> 받으려고 하는 데이터 제네릭으로 넣기
      return Observable<SearchAppModel>.create { value in
            let urlString = "https://itunes.apple.com/search?term=todo&country=KR&media=software&lang=ko_KR&limit=10"
            
            guard let url = URL(string: urlString) else {
                // Error completion을 했었는데 Observable.onError를 사용해서 구현할 수 있음
                value.onError(APIERROR.invalidURL)
                // create 은 return값이 Disposable임
                return Disposables.create()
            }
            
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("URLSession Succeed")
                if let _ = error {
                    value.onError(APIERROR.unknown)
                    //  return Disposables.create()을하지 않는 이유 dataTask 클로저 구문의 return값이 Void이기 때문에!
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value.onError(APIERROR.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self, from: data) {
                    value.onNext(appData)
                }
                
            }
            .resume()
            
            return Disposables.create()
        }
    }
}
