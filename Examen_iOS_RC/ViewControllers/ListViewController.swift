//
//  ViewController.swift
//  Examen_iOS_RC
//
//  Created by Mañanas on 24/9/24.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieList: [Movie] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.dataSource = self
            
            // Buscar movies (paso un término de búsqueda, por ejemplo, "Batman")
            searchMovies("Batman")
        }
        
        // MARK: TableView DataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieViewCell
            let movie = movieList[indexPath.row]
            cell.render(movie)
            return cell
        }
        
        // MARK: Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            let movie = movieList[indexPath!.row]
            detailViewController.movie = movie
        }
        
        // MARK: API call
        func searchMovies(_ query: String) {
            Task {
                guard let url = URL(string: "https://www.omdbapi.com/?s=\(query)&apikey=68056634") else {
                    print("URL not valid")
                    movieList = []
                    return
                }
                
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    // Decodificar el JSON en MovieSearchResponse, que contiene una lista de películas
                    let result = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.movieList = result.search // Ahora usamos la propiedad 'search'
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error fetching movies: \(error)")
                }
            }
        }
}
