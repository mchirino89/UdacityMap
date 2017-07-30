//
//  Constants.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 29/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import Foundation

extension Networking {

    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        static let ApiScheme = "https"
        
    }
    
    // MARK: URLs
    struct URL {
        static let SignUp = "https://www.udacity.com/account/auth#!/signup"
        static let Udacity = "https://www.udacity.com"
    }
    
    struct Variables {
        static let studentCell = "studentListCell"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "/search/movie"
        
        // MARK: Config
        static let Config = "/configuration"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
    }
}
