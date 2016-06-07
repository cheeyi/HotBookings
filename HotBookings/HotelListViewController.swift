//
//  HotelListViewController.swift
//  HotBookings
//
//  Created by LOGAN CAUTRELL on 6/7/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

class HotelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Data
    let hotels: [Hotel]

    // MARK: UI
    let tableView = UITableView().withAutoLayout()

    // MARK: Setup and Teardown
    init(hotels: [Hotel]) {
        self.hotels = hotels

        super.init(nibName: nil, bundle: nil)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("USE init(wihtHotels: [Hotel]) INSTEAD NOOB")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("USE init(wihtHotels: [Hotel]) INSTEAD NOOB")
    }

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)

        let views = [
            "tableView": self.tableView,
            "topLayoutGuide": self.topLayoutGuide
        ]

        let relationships = [
            "H:|-[tableView]-|",
            "V:[topLayoutGuide]-[tableView]-(verticalMargin)-|"
        ]

        let metrics = ["verticalMargin": CGFloat(0)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
    }

    // MARK: Tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hotels.count
    }

    let cellIdent = "cellIdent"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdent)
        }
        return cell!
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        let hotel = self.hotels[indexPath.row]
        guard let titleLabel = cell.textLabel, detailTextLabel = cell.detailTextLabel else {
            print("cant get subviews from cell")
            return
        }

        titleLabel.text = hotel.name

        var viewsString = "views"
        if hotel.bookCount == 1 {
            viewsString = "view"
        }

        var bookString = "bookings"
        if hotel.bookCount == 1 {
            bookString = "booking"
        }

        detailTextLabel.text = "\(hotel.viewCount) \(viewsString), \(hotel.bookCount) \(bookString)"

        
    }

    // MARK: Implementation

}
