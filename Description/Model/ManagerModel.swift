//
//  ManagerModel.swift
//  Description
//
//  Created by MacBook on 09.10.2021.
//

import Foundation

protocol ManagerDelegate {
    
    func updateData(_ extract: String)
}

struct ManagerModel {
    
    // set ManagerDelegate as variable only
    var managerDelegate: ManagerDelegate?
    
    private let wikiURL = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&indexpageids&redirects=1&titles="
    
    // get title - name of a flower
    func getTitle(_ title: String) {
        
        let components = title.split{ !$0.isLetter }
        var item = ""
        
        switch components.count {
        case 2:
            item = "\(wikiURL)\(components[0])%20\(components[1])"
        case 3:
            item = "\(wikiURL)\(components[0])%20\(components[1])%20\(components[2])"
        default:
            item = "\(wikiURL)\(components[0])"
        }
       
        performRequest(item)
       
    }
    
    
    
    
    
    // get API Data by url
    func performRequest(_ url: String) {
        
        // convert url string to URL
        guard let url = URL(string: url) else { return }
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else { return }
            
            parseJSON(data)
 
        }
        dataTask.resume()
    }
    
    func parseJSON(_ data: Data) {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(DescriptionData.self, from: data)
            
            let pageId = decodedData.query.pageids[0]
            
            guard let extract = decodedData.query.pages[pageId]?.extract else { return }
            
            print("extract from parsing JSON: \(extract)")
            
            
            managerDelegate?.updateData(extract)
            
        } catch { print(error) }
        
        
        
    }
    
    
    
}
