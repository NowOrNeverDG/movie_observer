//
//  ViewController.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/21/21.
//

import UIKit

class ViewController: UIViewController {
    private var movieList: [Movie]?
    private var genres: [Genre]?
    var currentPage = 1
    var vm: MovieListViewModel?
    
    typealias CompletionHandler = (()->())?
    let apihandler = APIHandler.shared
    @IBOutlet weak var tblview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblview.rowHeight = 160
        vm = MovieListViewModel()
        vm?.fetchMovieData(completion: {
            DispatchQueue.main.async {
                self.tblview.reloadData()
            }
        })
    }
    
    private func fetchGenres(completion:@escaping () -> ()) {
        APIHandler.shared.requestData(endPoint: .genres) { [weak self] resp in
            guard let genres = (resp as? Genres)?.genres,
                  let self = self else {return}
            self.genres = genres
            completion()
        }
    }
    
    private func fetchMovies(page: Int = 1, completion:@escaping () -> ()) {
        APIHandler.shared.requestData(endPoint: .popularMovies, page: page) { [weak self] resp in
            guard let movies = (resp as? Movies)?.results,
                  let self = self else {return}
            self.movieList == nil ? self.movieList = movies : self.movieList?.append(contentsOf: movies)
            completion()
        }
    }
    
    func fetchMovieData(completion:@escaping () -> ()) {
        let dg = DispatchGroup()
        if genres == nil {
            dg.enter()
            fetchGenres {
                dg.leave()
            }
        }
        dg.enter()
        fetchMovies(page: self.currentPage) {
            self.currentPage += 1
            dg.leave()
        }

        dg.notify(queue: .global(), work: DispatchWorkItem(block: {
            completion()
        }))
    }
    
    func getMovieForCell(at item: Int) -> Movie? {
        guard let movie = movieList?[item],
              let genreID = movie.genre_ids?.first else {return nil}
        let genre = genres?.filter {$0.id == genreID}
        
        return Movie(title: movie.title, popularity: movie.popularity, release_date: movie.release_date, poster_path: movie.poster_path, genre_ids: nil, mainGenre: genre?.first, id: movie.id)
    }

    /// - Returns: Count of items for CollectionView depends of number of Movie objects
    func getMoviesCount() -> Int {
        return movieList?.count ?? 0
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = self.vm else {return 0}
        return vm.getMoviesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MovieTableViewCell, let vm = self.vm else {
            return  UITableViewCell()
        }
        cell.MovieObj = vm.getMovieForCell(at: indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "DetailVC") as? DetailViewController,
              let vm = self.vm,
              let movie = vm.getMovieForCell(at: indexPath.item) else {return}
        vc.setMovie(movie: movie)
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

//        guard let url = URL.init(string: "https://api.themoviedb.org/3/movie/550?api_key=7999f5b956850572e6a87c8259935d14") else { return }
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//        task.resume()

