//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by Denny on 2020/05/09.
//  Copyright © 2020 Denny. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        observableTest()
        observableCreateTest()
        observableFactoryTest()
    }

    func observableTest() {
        let disposeBag = DisposeBag()
        let observable = Observable<Int>.range(start: 0, count: 10)
        observable.subscribe(onNext: { (i) in
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(fibonacci)
        }, onCompleted: {
            print("Completed")
        })
        
        let observable2 = Observable.of("A", "B", "C")
        observable2.subscribe{
            print($0)
            }
        .disposed(by: disposeBag)
        
//        subscription.dispose()
    }
    
    func observableCreateTest() {
        enum MyError: Error {
            case anError
        }
        
        let disposeBag = DisposeBag()
        Observable<String>.create({ (observer) -> Disposable in
            observer.onNext("1")
            observer.onError(MyError.anError) // onCompleted is not called
            observer.onCompleted()
            observer.onNext("?")
            
            return Disposables.create()
        }).subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        ).disposed(by: disposeBag)
    }
    
    func observableFactoryTest() {
        let disposeBag = DisposeBag()
        var flip = false
        let factory: Observable<Int> = Observable.deferred{
            flip = !flip
            if flip {
                return Observable.of(1,2,3)
            } else {
                return Observable.of(4,5,6)
            }
        }
        
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
            .disposed(by: disposeBag)
            
            print()
        }
    }

}

