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
    }

    func observableTest() {
        let observable = Observable<Int>.range(start: 0, count: 10)
        observable.subscribe(onNext: { (i) in
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(fibonacci)
        }, onCompleted: {
            print("Completed")
        })
        
        let observable2 = Observable.of("A", "B", "C")
        let subscription = observable2.subscribe({ (event) in
            print(event)
        })
        subscription.dispose()
    }

}

