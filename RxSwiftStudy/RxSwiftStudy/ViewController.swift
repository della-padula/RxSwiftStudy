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
        
//        observableTest()
//        observableCreateTest()
//        observableFactoryTest()
//        challengesQuestion1()
//        challengesQuestion2()
        
        subjectTest()
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
    
    func singleTest() {
        let disposeBag = DisposeBag()
        enum FileReadError: Error {
            case fileNotFound, unreadable, encodingFailed
        }
        
        func loadText(from name: String) -> Single<String> {
            // 4
            return Single.create{ single in
                // 4 - 1
                let disposable = Disposables.create()
                
                // 4 - 2
                guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                    single(.error(FileReadError.fileNotFound))
                    return disposable
                }
                
                // 4 - 3
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.error(FileReadError.unreadable))
                    return disposable
                }
                
                // 4 - 4
                guard let contents = String(data: data, encoding: .utf8) else {
                    single(.error(FileReadError.encodingFailed))
                    return disposable
                }
                
                // 4 - 5
                single(.success(contents))
                return disposable
            }
        }
        
        loadText(from: "Copyright")
        .subscribe{
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func challengesQuestion1() {
        let observable = Observable<Any>.never()
        let disposeBag = DisposeBag()
        
        observable.do(
            onSubscribe: { print("Subscribed") }
        ).subscribe(
            onNext: { (element) in
                print(element)
        }, onCompleted: {
            print("Completed")
        }
        ).disposed(by: disposeBag)
        
//        observable
//            .subscribe(
//                onNext: { (element) in
//                    print(element)
//            },
//                onCompleted: {
//                    print("Completed")
//            }
//        )
    }

    func challengesQuestion2() {
        let observable = Observable<Any>.never()
        let disposeBag = DisposeBag()
        
        observable
            .debug("never Confirmed")
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func subjectTest() {
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone Listening?")
        
        let subscriptionOne = subject.subscribe(onNext: { string in
            print(string)
        })
        subject.on(.next("1"))
        subject.onNext("2")
        
        let subscriptionTwo = subject.subscribe { event in
            print("2)", event.element ?? event)
        }
        
        subject.onNext("3")
        subscriptionOne.dispose()
        
        subject.onNext("4")
        
        subject.onCompleted()
        subject.onNext("5")
        subscriptionTwo.dispose()
        
        let disposeBag = DisposeBag()
        subject.subscribe {
            print("3)", $0.element ?? $0)
        }.addDisposableTo(disposeBag)
        
        subject.onNext("?") // re-emit "completed"
        
        
    }
    
}

