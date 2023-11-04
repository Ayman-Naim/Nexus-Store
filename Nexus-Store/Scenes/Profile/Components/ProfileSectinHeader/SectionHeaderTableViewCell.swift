//
//  SectionHeaderTableViewCell.swift
//  Nexus-Store
//
//  Created by ayman on 20/10/2023.
//

import UIKit
protocol ProfileDelegete
{
    func Seeallpressed(section:Int?)
}

class SectionHeaderTableViewCell: UITableViewHeaderFooterView {
    var Delegate:ProfileDelegete?
    var section:Int?
   
    @IBOutlet weak var SeeAll: UIButton!
    @IBOutlet weak var HeaderTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(section:Int){
        self.section = section
        
    }
    
    
    @IBAction func SeeAllClicked(_ sender: Any) {
        if(self.section == 0){
           
            Delegate?.Seeallpressed(section: self.section)
           
        }
        if(self.section == 1){
         
            Delegate?.Seeallpressed(section: self.section)
        }
        //Delegate.
    }
   
}
