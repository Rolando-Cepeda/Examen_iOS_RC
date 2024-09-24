//
//  MovieViewCell.swift
//  Examen_iOS_RC
//
//  Created by Mañanas on 24/9/24.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieAñoLabel: UILabel!
    @IBOutlet weak var moviePosterLabel: UILabel!
    
    func render (_ movie: Movie) {
        movieImageView.loadFrom(url: movie.Poster)
        movieNameLabel.text = movie.Title
        movieAñoLabel.text = movie.Year
               
    }
}
