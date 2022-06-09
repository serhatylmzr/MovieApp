//
//  APICaller.swift
//  MovieApp
//
//  Created by Serhat Yılmazer on 2.06.2022.
//

import Foundation

enum MovieServiceEndPoint : String{
    case API_KEY = "************"
    case BASE_URL = "https://api.themoviedb.org/3"
    case YOUTUBE_API_KEY = "********"
    case YOUTUBE_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
    case API_PATH = "?api_key="
    case PAGINATION = "&language=en-US&page=1"
    case TRENDING_MOVIES = "/trending/movie/day"
    case TRENDING_TVS = "/trending/tv/day"
    case POPULAR = "/movie/popular"
    case UPCOMING = "/movie/upcoming"
    case TOP_RATED = "/movie/top_rated"
    case DISCOVER = "/discover/movie"
    case SEARCH = "/search/movie"
    case MOVIE_DETAIL = "q"
    
    static func trendingMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(TRENDING_MOVIES.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)"
    }
    static func trendingTVsPath() -> String {
        return "\(BASE_URL.rawValue)\(TRENDING_TVS.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)"
    }
    static func popularMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(POPULAR.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)\(PAGINATION.rawValue)"
    }
    static func upcomingMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(UPCOMING.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)\(PAGINATION.rawValue)"
    }
    static func topRatedMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(TOP_RATED.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)\(PAGINATION.rawValue)"
    }
    static func discoverMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(DISCOVER.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
    }
    static func searchMoviesPath() -> String {
        return "\(BASE_URL.rawValue)\(SEARCH.rawValue)\(API_PATH.rawValue)\(API_KEY.rawValue)"
    }
}
protocol IMovieService{
    func fetchAllDatas(response : @escaping (Result<[Title],Error>) -> Void )
}
struct Constants {
    static let API_KEY = "838544c273ff9b27d25228f6d327f465"
    static let baseURL = "https://api.themoviedb.org/3"
    static let YoutubeAPI_KEY = "AIzaSyAfZE9v07-oa5-cTvcIoV79eFRkI5cBsbY"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError : Error{
    case failedToGetData
}
class APICaller {
    static let shared  = APICaller()
    /*func getTrendingMovies(){
      return  getData(with: MovieServiceEndPoint.getTrendingMovies())
    }
    func  getData(with urlPath : String, completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: urlPath) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }*/
    
    func  getTrendingMovies(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.trendingMoviesPath()) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func  getTrendingTVs(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.trendingTVsPath()) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    func  getPopularMovies(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.popularMoviesPath()) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    func  getUpcomingMovies(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.upcomingMoviesPath()) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func  getTopRatedMovies(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.topRatedMoviesPath()) else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func  getDiscoverMovies(completion : @escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: MovieServiceEndPoint.discoverMoviesPath())
 else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func  getSearchMovies(with query : String ,completion : @escaping (Result<[Title],Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(MovieServiceEndPoint.searchMoviesPath())&query=\(query)") else{
            return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
    func  getMovie(with query : String ,completion : @escaping (Result<VideoElement,Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    
}
