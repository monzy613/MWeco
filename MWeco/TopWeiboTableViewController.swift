//
//  TopWeiboTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import CoreMotion

class TopWeiboTableViewController: UITableViewController, StatusCellDelegate, UIGestureRecognizerDelegate {
    var weatherView: MZWeatherView?
    
    @IBOutlet weak var gravityDirectionButton: UIBarButtonItem!
    @IBAction func changeGravityScrollDirection(sender: UIBarButtonItem) {
        print("changeGravityScrollDirection")
        if currentGDirection == .Normal {
            currentGDirection = .UpsideDown
            gravityDirectionButton.image = UIImage(named: ImageNames.gsUpsideDown)
        } else {
            currentGDirection = .Normal
            gravityDirectionButton.image = UIImage(named: ImageNames.gsNormal)
        }
        GravityScroller.direction = currentGDirection
    }
    
    private var currentGDirection = GravityScroller.Direction.Normal
    private var loadingView: MZLoadingView?
    private var loadingMoreView: UIView?
    private var loadingMoreActivator: UIActivityIndicatorView?
    private var isLoadingMore = false
    private var isFirstLoad = true
    
    let transitionManager = TransitionManager()
    
    // long press gesture
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    @IBAction func longPressGestureTriggered(sender: UILongPressGestureRecognizer) {
        print("longPressGestureTriggered")
        MZToastView().configure((self.tabBarController?.view)!, content: "重力刷微博开启啦", position: .Middle, length: .Short, lightMode: .Light).show()
        GravityScroller.restart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherView = MZWeatherView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), day: 0)
        self.tabBarController!.view.addSubview(weatherView!)
        currentTabIndex = 0
        registerFor3DTouch()
        initUI()
        if publicStatuses.count == 0 {
            loadStatus()
        }
        self.refreshControl?.addTarget(self, action: #selector(TopWeiboTableViewController.loadStatus), forControlEvents: .ValueChanged)
    }
    
    private func initAutoScrolling() {
        GravityScroller.initAccelerometer(withTableView: tableView, andMotionManager: AppDelegate.motionManager, withDirection: currentGDirection)
        GravityScroller.start(onTop: {}, onBottom: {
            [unowned self] in
            self.loadMore()
        })
        GravityScroller.bottomOffsetMaxHeight = loadingMoreView?.frame.height ?? 0
    }
    
    private func initUI() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //init long press gesture
        longPressGesture.minimumPressDuration = 0.6
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
        
        let width = UIScreen.mainScreen().bounds.width
        let height = width * 0.5
        loadingMoreView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let line = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        line.backgroundColor = UIColor.darkGrayColor()
        loadingMoreView?.addSubview(line)
        loadingMoreActivator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        let activatorWidth: CGFloat = height
        loadingMoreActivator?.frame = CGRect(x: ((loadingMoreView?.frame.width)! - activatorWidth) / 2, y: ((loadingMoreView?.frame.height)! - activatorWidth) / 2, width: activatorWidth, height: activatorWidth)
        loadingMoreView?.addSubview(loadingMoreActivator!)
        tableView.tableFooterView = loadingMoreView!
    }
    
    
    func loadStatus() {
        loadingView = MZLoadingView(rootView: (self.navigationController?.view)!, effect: UIBlurEffect(style: .Dark))
        loadingView?.start()
        var since_id: Int64 = 0
        if publicStatuses.count != 0 {
            since_id = publicStatuses[0].id ?? 0
        }
        NetWork.getTimeLine(.FriendTimeLine
            , since_id: since_id
            , max_id: 0
            , onSuccess: {
                [unowned self] status in
                print("onSuccess \(status.count) new weibo")
                NetWork.getUserInfo({
                    json in
                    currentUserInfo = Blogger(withJSON: json)
                    }, onFailure: {})
                publicStatuses = (status + publicStatuses)
                self.tableView.reloadData()
                self.initAutoScrolling()
                if self.refreshControl?.refreshing == true {
                    self.refreshControl?.endRefreshing()
                }
                if self.loadingView?.isAnimating() == true {
                    self.loadingView?.stop()
                }
                if self.isFirstLoad {
                    self.isFirstLoad = false
                    NetWork.getTimeLine(.SelfTimeLine
                        , since_id: 0
                        , max_id: 0
                        , onSuccess: {
                            status in
                            selfStatuses = status
                        }, onFailure: {
                    })
                    NetWork.getFriends(ofType: .Following)
                    NetWork.getFriends(ofType: .FollowMe)
                }
            }, onFailure: {
                self.weatherView?.dismissSelf()
                self.performSegueWithIdentifier("LoginSegue", sender: self)
        })
    }

    func registerFor3DTouch() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        } else {
            print("force touch not available")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return publicStatuses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusCell(withStatus: publicStatuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        GravityScroller.pause()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! StatusCell
        if selectedCell.retweetView != nil {
            (selectedCell.retweetView!).backgroundColor = Colors.retweetBackgroundColor
        }
        performSegueWithIdentifier(Segues.detailStatus, sender: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Calculator.statusCellHeight(withStatus: publicStatuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
    }

    
    
    // StatusCellDelegate
    func repost(withSender sender: AnyObject) {
        performSegueWithIdentifier(Segues.Repost, sender: sender)
    }
    
    func comment(withSender sender: AnyObject) {
        performSegueWithIdentifier(Segues.Comment, sender: sender)
    }
    
    func detailImage(withSender sender: AnyObject) {
        print("the \((sender as! DetailImageInfo).index) picture pressed")
        hideTabbar()
        performSegueWithIdentifier(Segues.detailImage, sender: sender)
    }
    
    // hide tabBar
    func hideTabbar() {
        guard let myTabBarController = self.tabBarController as? TabBarController else {return}
        myTabBarController.hideTabbar()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.Repost:
                if let editorController = (segue.destinationViewController as? UINavigationController)?.visibleViewController as? EditorViewController {
                    editorController.retweetStatus = (sender as! StatusCell).status
                    editorController.hasRetweetStatus = true
                }
            case Segues.Comment:
                let commentViewController = segue.destinationViewController as! CommentFloatingViewController
                commentViewController.statusId = (sender as! StatusCell).status.id
            case Segues.detailStatus:
                print("performSegue: DetailStatusSegue")
                if let dest = segue.destinationViewController as? DetailStatusController, let tbController = self.tabBarController as? TabBarController {
                    tbController.hideTabbar()
                    let indexPath = sender as! NSIndexPath
                    dest.tbController = tbController
                    dest.statusCell = StatusCell(withStatus: publicStatuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
                    NetWork.getComments(byStatusID: publicStatuses[indexPath.row].id!, onSuccess: {
                        comments in
                        dest.comments = comments
                    })
                }
            case Segues.detailImage:
                if let dest = segue.destinationViewController as? DetailImageViewController,
                let detailImageInfo = sender as? DetailImageInfo,
                let tbController = self.tabBarController as? TabBarController {
                    dest.transitioningDelegate = transitionManager
                    dest.pic_urls = detailImageInfo.pic_urls
                    dest.index = detailImageInfo.index
                    dest.tbController = tbController
                }
            default:
                break
            }
        }
    }
    
    
    //load more
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (isLoadingMore == false) && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height) {
            loadMore()
        }
    }
    
    
//    var offsetBeforeLoadMore: CGPoint = CGPoint.zero
    
    func loadMore() {
        if isLoadingMore == true {
            return
        }
        //offsetBeforeLoadMore = tableView.contentOffset
        print("load more")
        loadingMoreActivator?.startAnimating()
        isLoadingMore = true
        if publicStatuses.count == 0 {return}
        var max_id = (publicStatuses[publicStatuses.count - 1].id ?? 0)
        if max_id > 0 {
            max_id -= 1
        }
        NetWork.getTimeLine(.FriendTimeLine, since_id: 0, max_id: max_id, onSuccess: {
            [unowned self] statuses in
            publicStatuses += statuses
            self.isLoadingMore = false
            print("current timeline count: \(publicStatuses.count)")
            self.loadingMoreActivator?.stopAnimating()
            self.tableView.reloadData()
            //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }, onFailure: {
        })
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        GravityScroller.pause()
    }
}
