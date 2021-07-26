//
//  DetailViewController.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/21/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var scorelbl: UILabel!
    @IBOutlet weak var releaselbl: UILabel!
    @IBOutlet weak var runtimelbl: UILabel!
    @IBOutlet weak var Homepagelbl: UILabel!
    @IBOutlet weak var overviewlbl: UITextView!
    var vm: DetailViewModel?
    
    func setMovie(movie: Movie) {
        vm = DetailViewModel()
        vm?.delegate = self
        vm?.setMovieObject(movie: movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailViewController: UpdateDetailProtocol {
    // Delegate call
    func didRecieveMovie(movie: Movie) {
        DispatchQueue.main.async {

            self.titlelbl.text = movie.title ?? ""
            self.overviewlbl.text = movie.overview ?? ""
            self.scorelbl.text = "Score: \(movie.popularity?.description ?? "-")"
            self.releaselbl.text = "Release date: \(movie.release_date ?? "-")"
            self.runtimelbl.text = "Runtime: \(movie.runtime?.description ?? "-")"
            self.Homepagelbl.text = "Homepage: \(movie.homepage ?? "-")"
            if let data = self.vm?.getPoster(),
               let image = UIImage(data: data) {
                self.imgview.image = image
            }
        }
    }
}
