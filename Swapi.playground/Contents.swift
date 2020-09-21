import UIKit

struct TopLevelObject: Decodable {
    // to get an abject need to pass in a key
    var results: [Person]
    
}

struct Person: Decodable {
   var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

class SwapiService {
    static private var baseURL = URL(string: "https://swapi.dev/api/")
    static let personEndPoint = "people"
    static let filmsEndPoint = "films"
    
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let id = String(id)
        let finalURL = baseURL.appendingPathComponent(personEndPoint).appendingPathComponent(id)
         // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            print(finalURL)
            // 3 - Handle errors
            if let error = error {
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
        // 5 - Decode Person from JSON
            do {
                let decoder = JSONDecoder()
             //   print(String(data: data, encoding: .utf8)!)
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            }catch {
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    //MARK: - Fetch Film
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
//        guard let baseURL = baseURL else { return completion(nil)}
////        let completeURL = baseURL.appendingPathComponent("films")
//        let filmURL = baseURL.appendingPathComponent("people")
        
       URLSession.shared.dataTask(with: url) { (data, _, error) in
            print(url)
            
        // 2 - Handle errors
            if let error = error {
                print("print error 1")
                print(error)
                print(error.localizedDescription)
                return completion(nil)
            }
        // 3 - Check for data
            guard let data = data else { return completion(nil) }
        // 4 - Decode Film from JSON
            do {
                let decoder = JSONDecoder()
                  // print(String(data: data, encoding: .utf8)!)
                let films = try decoder.decode(Film.self, from: data)
                return completion(films)
            }catch {
                print("print error 2 \(error)")
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    
}//end class

SwapiService.fetchPerson(id: 3) { (person) in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
        print(film.title)
      }
  }
}


