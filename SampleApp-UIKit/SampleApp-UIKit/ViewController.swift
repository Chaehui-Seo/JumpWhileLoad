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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            JumpWhileLoad.finishLoading()
        }
    }

    @IBAction func customButtonDidTap(_ sender: Any) {
        let message = """
        Apply the custom images included in this sample?

        • Main character: Penguin → Dinosaur
        • Background: Snow → Forest
        """
        let alert = UIAlertController(title: "Apply Custom Images?", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Apply", style: .default) { [weak self] _ in
            guard let self else { return }
            self.present(
                JumpWhileLoad.Builder()
                    .withCharacter(UIImage(named: "dino_1")!)
                    .withJumpCharacter(UIImage(named: "dino_2")!)
                    .withNormalObstacles([UIImage(named: "dino_3")!,
                                         UIImage(named: "dino_4")!])
                    .withWideObstacles([UIImage(named: "dino_5")!,
                                       UIImage(named: "dino_6")!])
                    .build(),
                animated: true
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                JumpWhileLoad.finishLoading()
            }
        })
        present(alert, animated: true)
    }
}
