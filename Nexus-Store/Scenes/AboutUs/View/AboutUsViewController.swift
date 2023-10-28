//
//  AboutUsViewController.swift
//  Nexus-Store
//
//  Created by Ahmed Ashraf on 28/10/2023.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = """
        Welcome to Nexus-Store, your one-stop online shop for all your fashion and lifestyle needs. At Nexus-Store, we are committed to providing you with the latest trends, high-quality products, and exceptional customer service. Our mission is to make online shopping a delightful experience, allowing you to browse through a vast collection of products from the comfort of your home and have them delivered to your doorstep.
        """
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
