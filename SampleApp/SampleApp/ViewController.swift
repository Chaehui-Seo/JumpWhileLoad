//
//  ViewController.swift
//  SampleApp
//
//  Created by 서채희 on 3/4/25.
//

import UIKit
import JumpWhileLoad

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        self.present(JumpWhileLoad.Builder().build(), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            JumpWhileLoad.finishLoading()
        }
    }
}

