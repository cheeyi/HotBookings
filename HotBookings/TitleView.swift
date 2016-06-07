//
//  Title View.swift
//  HotBookings
//
//  Created by Ashwin Badri Srimannarayanan on 7/06/2016.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit

class TitleView: UIView {

    var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Live", "Date"]).withAutoLayout()
        segmentControl.setWidth(70, forSegmentAtIndex: 0)
        segmentControl.setWidth(70, forSegmentAtIndex: 1)
        segmentControl.tintColor = UIColor.whiteColor()
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()

    let checkInDateButton: UIButton = {
        let button = UIButton().withAutoLayout()
        button.titleLabel?.textColor = UIColor.whiteColor()
        return button
    }()

    var datePickerInputView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redEyeColor()
        checkInDateButton.setTitle(gettingCurrentDate(), forState: .Normal)
        checkInDateButton.addTarget(self, action: #selector(calenderButtonPressed), forControlEvents: .TouchUpInside)
        addSubviews([segmentControl, checkInDateButton])
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let relationships = [
            "H:|-20-[segmentControl]",
            "V:|-30-[segmentControl]",
            "H:[checkInDateButton(100)]-|",
            "V:|-25-[checkInDateButton]"
        ]
        let views = [
            "segmentControl": segmentControl,
            "checkInDateButton": checkInDateButton
        ]
        let metrics = ["verticalMargin": CGFloat(8)]
        addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }


    func gettingCurrentDate() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }

    func calenderButtonPressed(sender: UIButton) {
        guard let size = superview?.frame.size else {
            return
        }
        //getting the current date and making the date picker to point to that date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        let currentCheckinDate = checkInDateButton.titleLabel?.text!

        //creating the date picker Input view to hold botht he date picker view and the dont button view
        datePickerInputView = UIView(frame: CGRectMake(0, size.height - 200, size.width, 200))
        datePickerInputView?.backgroundColor = UIColor.whiteColor()
        superview!.addSubview(datePickerInputView!)

        //date picker created
        let datePickerView = UIDatePicker(frame: CGRectMake(0, 40, size.width, 200))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.setDate(dateFormatter.dateFromString(currentCheckinDate!)!, animated: false)
        datePickerInputView?.addSubview(datePickerView)

        //done button created
        let doneButton = UIButton(frame: CGRectMake(size.width - 100, 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        datePickerInputView?.addSubview(doneButton)

        //KVO operation for the button handlers
        doneButton.addTarget(self, action: #selector(doneButtonHandling(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        datePickerView.addTarget(self, action: #selector(handleDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    func doneButtonHandling(sender:AnyObject) {
        datePickerInputView?.removeFromSuperview()
        toggleHandler()
    }

    //datePicker

    func handleDatePicker(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        checkInDateButton.setTitle(dateFormatter.stringFromDate(sender.date), forState: .Normal)
    }

    func toggleHandler() {
        if(checkInDateButton.titleLabel?.text == gettingCurrentDate()) {
            segmentControl.selectedSegmentIndex = 0
        }
        else {
            segmentControl.selectedSegmentIndex = 1
        }
    }
}

