//
//  NetworkService.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 21/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkService {
    func getMovies(onSuccess: @escaping ([Movie]) -> (), onError: @escaping (Error) -> ())
    func downloadImage(from url: URL, onCompleted: @escaping ((_ image: UIImage) -> ()))
}

final class NetworkServiceImpl: NSObject, NetworkService, URLSessionDelegate {
    lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default

      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()

    public func downloadImage(from url: URL, onCompleted: @escaping ((_ image: UIImage) -> ())) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else { return }
                onCompleted(image)
            }
        }
    }

    private func getData(from url: URL, onCompleted: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: onCompleted).resume()
    }

    public func getMovies(onSuccess: @escaping ([Movie]) -> (), onError: @escaping (Error) -> ()){
        getRequest(urlString: "https://api.androidhive.info/json/movies.json",
                   onSuccess: { data in
                    guard let models = data as? [[String: Any]] else { return }

                    var jsonModels = [Movie]()
                    for model in models {
                        if let movie = try? Movie(json: model) {
                            jsonModels.append(movie)
                        }
                    }
                    onSuccess(jsonModels)
                }, onError: { error in
                    onError(error)
                })
    }

    private func getRequest(urlString: String, onSuccess: @escaping (Any) -> (), onError: @escaping (Error) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }

            do {
                let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                onSuccess(str)
            } catch {
                onError(error)
            }
        }
        task.resume()
    }
}

