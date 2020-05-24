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
    func getRequest(urlString: String, completion: @escaping (Any) -> ())
    func downloadImage(from url: URL, onCompleted: @escaping ((_ image: UIImage) -> ()))
}

class NetworkServiceImpl: NSObject, NetworkService, URLSessionDelegate {
    lazy var downloadsSession: URLSession = {
      let configuration = URLSessionConfiguration.default

      return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()

    public func downloadImage(from url: URL, onCompleted: @escaping ((_ image: UIImage) -> ())) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else { return }
                onCompleted(image)
            }
        }
    }

    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    public func getRequest(urlString: String, completion: @escaping (Any) -> ()) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                print(str)
                completion(str)


            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
    }
}

