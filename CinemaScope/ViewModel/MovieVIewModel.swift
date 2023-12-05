//
//  MovieVIewModel.swift
//  CinemaScope
//
//  Created by Albert Negoro on 4/8/23.
//

import Foundation
import Combine

protocol MovieAPIProtocol {
    func getSingleMovie(id: Int, completion: @escaping (Result<MovieModel, APIError>) -> ())
    func getMovies(from endpoint: APIEndpoint, completion: @escaping (Result<APIResponse, APIError>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<APIResponse, APIError>) -> ())
}



class MovieViewModel: MovieAPIProtocol {
    
    static let shared = MovieViewModel()
    private init() {}
    
    private let apiKey = "f74ba20c62dc02e4311f81095b38d94a"
    private let baseURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    
    private let decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        let decoder = JSONDecoder()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    func getSingleMovie(id: Int, completion: @escaping (Result<MovieModel, APIError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.processURL(url: url, parameters: ["append_to_response": "videos,credits"], completion: completion)
    }
    
    func getMovies(from endpoint: APIEndpoint, completion: @escaping (Result<APIResponse, APIError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.processURL(url: url, completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<APIResponse, APIError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.processURL(url: url, parameters: [
            "language": "en-US",
            "region": "US",
            "include_adult": "false",
            "query": query
        ], completion: completion)
    }


    private func processURL<res: Decodable>(url: URL, parameters: [String: String]? = nil, completion: @escaping (Result<res, APIError>) -> ()) {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queries = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = parameters {
            queries.append(contentsOf: params.map { param in
                URLQueryItem(name: param.key, value: param.value)
            })
        }
        
        components.queryItems = queries
        
        guard let finalURL = components.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else {return}
            
            if error != nil {
                self.completionHandler(with: .failure(.failedToFetch), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.completionHandler(with: .failure(.invalidAPIResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.completionHandler(with: .failure(.invalidData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.decoder.decode(res.self, from: data)
                self.completionHandler(with: .success(decodedResponse), completion: completion)
            } catch {
                self.completionHandler(with: .failure(.decodeError), completion: completion)
            }
        }
        .resume()
        
    }
    
    
    private func completionHandler<res: Decodable>(with result: Result<res, APIError>, completion: @escaping (Result<res, APIError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}



enum APIEndpoint: String, CaseIterable, Identifiable {
    
    var id: String { rawValue }
    
    case nowPlaying = "now_playing"
    case upcoming
    
    var description: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .upcoming:
            return "Upcoming"
        }
    }
}

enum APIError: Error, CustomNSError {
    case failedToFetch
    case invalidEndpoint
    case invalidAPIResponse
    case invalidData
    case decodeError
    
    var localizedDescription: String {
        switch self {
        case .failedToFetch:
            return "Failed to featch data"
        case .invalidEndpoint:
            return "Invalid endpoint"
        case .invalidAPIResponse:
            return "Invalid API response"
        case .invalidData:
            return "Invalid data"
        case .decodeError:
            return "Failed to decode data"
        }
    }
}



class MovieLoader: ObservableObject {
    @Published var movieList: [MovieModel]?
    @Published var movie: MovieModel?
    @Published var isLoading = false
    @Published var error: NSError?
    @Published var searchQuery = ""
    
    private let movieAPI: MovieAPIProtocol
    private var subToken: AnyCancellable?
    
    init(movieAPI: MovieAPIProtocol = MovieViewModel.shared) {
        self.movieAPI = movieAPI
    }
    
    func loadMovies(with endpoint: APIEndpoint) {
        self.movieList = nil
        self.isLoading = false
        self.movieAPI.getMovies(from: endpoint) {
            [weak self] (result) in
            
            guard let self = self else {
                return
            }
            
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.movieList = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    func loadMovieDetails(with id: Int) {
        self.movie = nil
        self.isLoading = false
        self.movieAPI.getSingleMovie(id: id) {
            [weak self] (res) in
            guard let self = self else {return}
            
            self.isLoading = false
            switch res {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
        
    }
    
    
    
    func ObserveSearchBar() {
        guard subToken == nil else {
            return
        }
        
        self.subToken = self.$searchQuery
            .map { [weak self] text in
                self?.movieList = nil
                self?.error = nil
                return text
            }
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [weak self] query in
                self?.search(query: query)
            })
    }
    
    
    func search(query: String) {
        self.movieList = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.isLoading = true
        self.movieAPI.searchMovie(query: query) {
            [weak self] (res) in
            
            guard let self = self, self.searchQuery == query else {
                return
            }
            
            switch res {
            case .success(let response):
                self.movieList = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    
    deinit {
        self.subToken?.cancel()
        self.subToken = nil
    }
   
    
}
