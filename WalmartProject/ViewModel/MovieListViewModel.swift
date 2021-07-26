//
//  MovieListViewModel.swift
//  WalmartProject
//
//  Created by Ge Ding on 7/22/21.
//

import Foundation

class MovieListViewModel {

    private var movieList: [Movie]?
    private var genres: [Genre]?
    var currentPage = 1

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

    func getMoviesCount() -> Int {
        return movieList?.count ?? 0
    }
}
