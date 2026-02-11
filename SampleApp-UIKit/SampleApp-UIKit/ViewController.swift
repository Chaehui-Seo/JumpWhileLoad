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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            JumpWhileLoad.finishLoading()
        }
    }

    @IBAction func customButtonDidTap(_ sender: Any) {
        let message = """
        다음 이미지로 커스텀됩니다:
        • 캐릭터: dino_1
        • 점프 캐릭터: dino_2
        • 일반 장애물: dino_3, dino_4
        • 넓은 장애물: dino_5, dino_6
        """
        let alert = UIAlertController(title: "커스텀 이미지 확인", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                JumpWhileLoad.finishLoading()
            }
        })
        present(alert, animated: true)
    }
}
