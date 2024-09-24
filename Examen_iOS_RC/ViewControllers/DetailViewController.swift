//
//  DetailViewController.swift
//  Examen_iOS_RC
//
//  Created by Mañanas on 24/9/24.
//

import UIKit

struct MovieDetail: Decodable {
    let title: String
    let year: String
    let poster: String
    let plot: String
    let runtime: String
    let director: String
    let genre: String
    let country: String
   
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case plot = "Plot"
        case runtime = "Runtime"
        case director = "Director"
        case genre = "Genre"
        case country = "Country"
    }
}


class DetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var moviePlotLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieCountryLabel: UILabel!
    
    
    // Película seleccionada desde la lista
        var movie: Movie?

        override func viewDidLoad() {
            super.viewDidLoad()

            // Verificar si hay una película seleccionada y realizar la llamada para obtener detalles
            if let movie = movie {
                fetchMovieDetails()
            } else {
                print("Error: No movie found")
            }
        }

        // Función para realizar la llamada a la API y obtener los detalles completos de la película
        func fetchMovieDetails() {
            guard let imdbID = movie?.imdbID else { return } // Asegurarse de que imdbID no sea nulo
            
            // URL de la API con el imdbID
            let urlString = "https://www.omdbapi.com/?i=\(imdbID)&apikey=68056634"
            
            guard let url = URL(string: urlString) else { return }

            // Realizar la llamada a la API
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error fetching movie details: \(error)")
                    return
                }

                guard let data = data else { return }

                do {
                    // Decodificar el JSON en el modelo MovieDetail
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    
                    // Actualizar la interfaz en el hilo principal
                    DispatchQueue.main.async {
                        self.updateUI(with: movieDetail)
                    }
                } catch {
                    print("Error decoding movie details: \(error)")
                }
            }.resume()
        }

        // Función para actualizar los elementos de la interfaz con los datos obtenidos
        func updateUI(with movieDetail: MovieDetail) {
            // Actualizar los labels con los datos de la película
            movieTitleLabel.text = movieDetail.title
            movieYearLabel.text = movieDetail.year
            moviePlotLabel.text = movieDetail.plot
            movieRuntimeLabel.text = movieDetail.runtime
            movieDirectorLabel.text = movieDetail.director
            movieGenreLabel.text = movieDetail.genre
            movieCountryLabel.text = movieDetail.country

            // Cargar la imagen desde la URL del poster
            movieImageView.loadFrom(urlString: movieDetail.poster)
        }
    }
// Extensión para cargar imágenes desde una URL en UIImageView
extension UIImageView {
    func loadFrom(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        // Cargar la imagen en segundo plano
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                // Actualizar la imagen en el hilo principal
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
