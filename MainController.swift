

import Foundation
import UIKit
import SpriteKit

class  MainController: UIViewController {
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        
  }
  
  @IBAction func btnclick(_ sender: Any) {
    
    let storyboard = UIStoryboard(name: "Main",bundle:nil).instantiateViewController(withIdentifier: "GameViewController") as UIViewController
    present(storyboard, animated: true, completion: nil)
    
  }
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  

}
