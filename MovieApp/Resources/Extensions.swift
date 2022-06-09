//
//  Extensions.swift
//  MovieApp
//
//  Created by Serhat Yılmazer on 2.06.2022.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
