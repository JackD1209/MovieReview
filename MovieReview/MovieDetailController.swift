//
//  MovieDetailController.swift
//  MovieReview
//
//  Created by Đoàn Minh Hoàng on 7/8/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    var titleDetail: String?
    var reviewDetail: String?
    var backgroudDetail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleDetail
        reviewLabel.text = reviewDetail
        let path = "https://image.tmdb.org/t/p/w342" + backgroudDetail!
        background.setImageWith(URL(string: path)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
