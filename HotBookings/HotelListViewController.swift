//
//  HotelListViewController.swift
//  HotBookings
//
//  Created by LOGAN CAUTRELL on 6/7/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

class HotelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Data

    let hotels: [Hotel]
    let regionName: String

    // MARK: - UI

    let tableView = UITableView().withAutoLayout()

    // MARK: - Setup and Teardown

    init(hotels: [Hotel], regionName: String) {
        self.hotels = hotels
        self.regionName = regionName

        super.init(nibName: nil, bundle: nil)

        tableView.delegate = self
        tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("USE init(wihtHotels: [Hotel]) INSTEAD NOOB")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("USE init(wihtHotels: [Hotel]) INSTEAD NOOB")
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        view.addSubview(tableView)
        title = "Hotels In \(regionName)"

        let views = [
            "tableView": tableView,
            "topLayoutGuide": topLayoutGuide
        ]

        let relationships = [
            "H:|[tableView]|",
            "V:|[tableView]|"
        ]

        let metrics = ["verticalMargin": CGFloat(0)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: Tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }

    let cellIdent = "cellIdent"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdent)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdent)
            let button = UIButton(type: .Custom)
            button.titleLabel?.font = UIFont.systemFontOfSize(12.0)
            button.setTitle("Book Now", forState: .Normal)
            button.setTitleColor(UIColor.jetBlueGrayColor(), forState: .Normal)
            button.layer.borderColor = UIColor.jetBlueGrayColor().CGColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 5.0
            button.sizeToFit()
            let frame = button.frame
            button.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width+10, frame.height)
            button.addTarget(self, action: #selector(tapped(_:)), forControlEvents: .TouchUpInside)
            cell?.accessoryView = button
        }
        return cell!
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        let hotel = hotels[indexPath.row]
        guard let titleLabel = cell.textLabel, detailTextLabel = cell.detailTextLabel, button = cell.accessoryView as? UIButton else {
            print("cant get subviews from cell")
            return
        }

        button.tag = indexPath.row

        titleLabel.text = hotel.name

        let viewsString = hotel.bookCount == 1 ? "view" : "views"
        let bookString = hotel.bookCount == 1 ? "booking" : "bookings"
        detailTextLabel.text = "\(hotel.viewCount ?? 0) \(viewsString), \(hotel.bookCount ?? 0) \(bookString)"


    }

    // MARK: Implementation
    func tapped(button: UIButton) {
        let hotel = self.hotels[button.tag]
        guard let url = NSURL(string: "expda://hotelSearch?hotelId=\(hotel.hotelID)") else {
            fatalError("can't build URL")
        }
        UIApplication.sharedApplication().openURL(url)
    }

}
