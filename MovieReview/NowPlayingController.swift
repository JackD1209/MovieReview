//
//  NowPlayingController.swift
//  MovieReview
//
//  Created by Đoàn Minh Hoàng on 6/5/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit
import AFNetworking

class NowPlayingController: UIViewController, UITableViewDelegate, UITableViewDataSource, movieModelDelegate {

    @IBOutlet weak var moviesList: UITableView!
    
    let model = movieModel()
    var filteredMovies = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    var movieTitleDetail: String?
    var movieReviewDetail: String?
    var movieBackgroundDeatil: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        model.delegate = self
        moviesList.delegate = self
        moviesList.dataSource = self

        model.loadData("now_playing")
        moviesList.reloadData()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        moviesList.tableHeaderView = searchController.searchBar

        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
//        moviesList.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
    }
    
//    func refreshControlAction(_ refreshControl: UIRefreshControl) {
//        
//        // ... Create the URLRequest `myRequest` ...
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//            
//            // ... Use the new data to update the data source ...
//            
//            // Reload the tableView now that there is new data
//            myTableView.reloadData()
//            
//            // Tell the refreshControl to stop spinning
//            refreshControl.endRefreshing()
//        }
//        task.resume()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMovies.count
        }
        return model.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingCell") as! NowPlayingCell
        let movie: Movie
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = filteredMovies[indexPath.row]
        }
        else {
            movie = model.movies[indexPath.row]
        }
        cell.title.text = movie.title
        cell.review.text = movie.review
        let path = "https://image.tmdb.org/t/p/w342" + movie.backgound
        cell.poster.setImageWith(URL(string: path)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = moviesList.indexPathForSelectedRow {
            let movie: Movie
            if searchController.isActive && searchController.searchBar.text != "" {
                movie = filteredMovies[indexPath.row]
            } else {
                movie = model.movies[indexPath.row]
            }
            movieTitleDetail = movie.title
            movieReviewDetail = movie.review
            movieBackgroundDeatil = movie.backgound
        }
        self.performSegue(withIdentifier: "showNowPlayingDetail", sender: nil) // move to edit screen with suitable data
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNowPlayingDetail" {
            let detailView = segue.destination as! MovieDetailController
            detailView.titleDetail = movieTitleDetail
            detailView.reviewDetail = movieReviewDetail
            detailView.backgroudDetail = movieBackgroundDeatil
        }
    }
    
    func gotData(movies: [Movie]) {
        moviesList.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredMovies = model.movies.filter { movie -> Bool in
            return movie.title.lowercased().contains((searchText.lowercased()))
        }
        moviesList.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NowPlayingController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension NowPlayingController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
