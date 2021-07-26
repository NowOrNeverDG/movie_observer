//
//  MovieTableViewCell.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/21/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var scorelbl: UILabel!
    @IBOutlet weak var relseaselbl: UILabel!
    @IBOutlet weak var labellbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var MovieObj: Movie? {
        willSet(value) {
            guard let value = value else {return}
            self.titlelbl.text = "Title:\(value.title ?? "-")"
            self.scorelbl.text = "Score:\(value.popularity?.description ?? "-")"
            self.relseaselbl.text = "Release:\(value.release_date ?? "-")"
            if let genre = value.mainGenre {
                labellbl.text = "Genre:\(genre.name ?? "-")"
            }
            //Setting image
            if let url = URL(string: Constants.ImageURLBase.rawValue + (value.poster_path ?? "")) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imgView.image = image
                        }
                    }
                }
            }
        }
    }
}
