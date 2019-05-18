//
//  Stadistic.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 5/12/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class StadisticScreen: UIViewController, UIScrollViewDelegate{
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Properties
    private var controller: MasterController = MasterController.shared
    private var slide1: StadisticView!
    private var slide2: SpecificStadisticView!
    private var slides:[Any]!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Estadisticas"
        
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        
        slide1 = (Bundle.main.loadNibNamed("StadisticView", owner: self, options: nil)?.first as! StadisticView)
        slide2 = (Bundle.main.loadNibNamed("SpecificStadisticView", owner: self, options: nil)?.first as! SpecificStadisticView)
        
        slide1.setInfo(typeNumber: 1)
        //slide2.setInfo(numberStudent: 0)
        
        slides = [slide1, slide2]
        
        setupSlideScrollView(slideList: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    //MARK: Scroll View
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    //MARK: Page Control
    func setupSlideScrollView(slideList : [Any]) {
        scrollView.frame = CGRect(x: 0, y: 162, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slideList.count {
            (slideList[i] as! UIView).frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slideList[i] as! UIView)
        }
    }
}
