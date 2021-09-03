//
//  NewsModel.swift
//  NewsModel
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation

import Foundation

// NewsAPI
/*
 
 URL: https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=\(API.news)
 
 JSON Response:
 {
 "status": "ok",
 "totalResults": 70,
 -"articles": [
 -{
 -"source": {
 "id": null,
 "name": "Honolulu Star-Advertiser"
 },
 "author": "Star-Advertiser staff",
 "title": "Safe Access Oahu program to require proof of vaccination or recent COVID test to enter establishments - Honolulu Star-Advertiser",
 "description": "UPDATE: 2:00 p.m.",
 "url": "https://www.staradvertiser.com/2021/08/30/breaking-news/watch-live-honolulu-mayor-rick-blangiardi-safe-to-announce-access-oahu-program/",
 "urlToImage": "https://www.staradvertiser.com/wp-content/uploads/2021/08/web1_WEB-Honolulu-Mayor-Blangiardi.jpg",
 "publishedAt": "2021-08-31T00:45:00Z",
 "content": "UPDATE: 2:00 p.m.\r\nCustomers at restaurants, gyms and other businesses will need to show proof of vaccination or a negative COVID-19 test within the last 48-hours to enter the establishments beginnin… [+2913 chars]"
 },
 -{
 -"source": {
 "id": null,
 "name": "Bitcoin.com"
 },
 "author": null,
 "title": "Billionaire John Paulson Warns Cryptocurrencies Will Be Worthless, Bitcoin Too Volatile to Short – Markets and Prices Bitcoin News - Bitcoin News",
 "description": "Billionaire hedge fund manager John Paulson, famed for making a fortune betting against the U.S. housing market, says that cryptocurrencies are a bubble that will prove to be \"worthless.\"",
 "url": "https://news.bitcoin.com/billionaire-john-paulson-cryptocurrencies-worthless-bitcoin-too-volatile-to-short/",
 "urlToImage": "https://static.news.bitcoin.com/wp-content/uploads/2021/08/paulson.jpg",
 "publishedAt": "2021-08-31T00:37:56Z",
 "content": "Billionaire hedge fund manager John Paulson, famed for making a fortune betting against the U.S. housing market, says that cryptocurrencies are a bubble that will prove to be “worthless.” While he se… [+2694 chars]"
 },
 ]
 }
 
 */

struct NewsResponse: Codable {
    var articles: [NewsModel]
}

struct NewsModel: Identifiable, Codable {
    var id: UUID { return UUID() }
    
    var source: Source
    var title: String
    var url: String
    var urlToImage: String?
    var publishedAt: String?
    
    var titleWithoutSource: String { title.replacingOccurrences(of: " - \(source.name)", with: "") }
    var imageUrl: String { urlToImage?.replacingOccurrences(of: "http://", with: "https://") ?? "https://i.pinimg.com/originals/7b/28/98/7b2898990ae6ce6d6b277113d51b14e8.png" }
    var publishedDate: Date { Date(newsAPITimeString: publishedAt ?? "") }
    var publishedToNow: String {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: publishedDate, to: Date())
        if let hour = diffComponents.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = diffComponents.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = diffComponents.second, second > 0 {
            return "\(second)s"
        }
        return ""
    }
}

struct Source: Codable {
    var id: String?
    var name: String
}
