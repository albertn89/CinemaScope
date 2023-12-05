//
//  MovieModel.swift
//  CinemaScope
//
//  Created by Albert Negoro on 3/19/23.
//

import Foundation

struct APIResponse: Decodable {
    let results: [MovieModel]
}


struct MovieModel: Decodable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let genres: [Genre]?
    let credits: Credits?
    

    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var movieGenre: String {
        genres?.first?.name ?? "N/A"
    }
    
    var movieRating: String {
        let rating = Int(voteAverage)
        if rating <= 0 {
            return "N/A"
        }
        return "\(rating)/10"
    }

    
    var yearRelease: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        guard let releaseDate = self.releaseDate, let date = dateFormatter.date(from: releaseDate) else {
            return "N/A"
        }
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: date)
    }
    
    var movieDuration: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "N/A"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: TimeInterval(runtime) * 60) ?? "N/A"
    }
    
    var cast: [Cast]? {
        credits?.cast
    }
    
    var crew: [Crew]? {
        credits?.crew
    }
    
    var directors: [Crew]? {
        guard let crew = self.crew else {
            return nil
        }
        
        return crew.filter { (crewMember) -> Bool in
            return crewMember.job.lowercased() == "director"
        }
    }
    
    var producers: [Crew]? {
        guard let crew = self.crew else {
            return nil
        }
        
        return crew.filter { (crewMember) -> Bool in
            return crewMember.job.lowercased() == "producer"
        }
    }
    

}


struct Genre: Decodable {
    let name: String
}

struct Credits: Decodable {
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct Crew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}
