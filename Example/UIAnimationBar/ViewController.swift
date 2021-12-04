//
//  ViewController.swift
//  UIAnimationBar
//
//  Created by League2EB on 09/05/2021.
//  Copyright (c) 2021 League2EB. All rights reserved.
//

import UIKit
import UIAnimationBar
import TYCyclePagerView

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var headerView: UIHeaderView = UIHeaderView()

    fileprivate lazy var pagerView: TYCyclePagerView = {
        let pagerView = TYCyclePagerView()
        pagerView.isInfiniteLoop = true
        pagerView.autoScrollInterval = 3.0
        return pagerView
    }()

    fileprivate lazy var pageControl: TYPageControl = {
        let pageControl = TYPageControl()
        pageControl.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        pageControl.numberOfPages = images.count
        return pageControl
    }()

    fileprivate var images: [String] = ["Example", "Example2", "Example3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInsetAdjustmentBehavior = .never

        view.addSubview(headerView)
        headerView.layoutIfNeeded()
        headerView.delegate = self
        setupPagerView()
        setupExampleImageView()
    }

    private func setupPagerView() {
        pagerView.layer.borderWidth = 1
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(PageViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        pagerView.addSubview(pageControl)
    }

    /// 設定範例背景圖片
    private func setupExampleImageView() {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        pagerView.frame = header.bounds
        pageControl.frame = CGRect(x: 0, y: header.frame.height - 26, width: header.frame.width, height: 26)
        header.addSubview(pagerView)
        tableView.tableHeaderView = header
    }
}

extension ViewController: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {

    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return images.count
    }

    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cellId", for: index) as! PageViewCell
        cell.imageView.image = UIImage(named: images[index])
        return cell
    }

    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pagerView.frame.width, height: pagerView.frame.height)
        layout.itemHorizontalCenter = true
        return layout
    }

    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        pageControl.currentPage = toIndex
    }
}

extension ViewController: UIAnimationBarDelegate {

    func didTapTextField() {
        print("didTapTextField")
    }

    func didTapSearchBtn(text: String) {
        print("didTapSearchBtn\(text)")
    }

    func didTapScanBtn() {
        print("didTapScanBtn")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.setSubViewFrameWith(contentOffset: scrollView.contentOffset)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        cell?.textLabel?.textColor = .black
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}
