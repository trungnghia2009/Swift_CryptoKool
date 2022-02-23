//
//  testCase1.swift
//  CryptoKoolUITests
//
//  Created by trungnghia on 20/02/2022.
//

import XCTest

class TestSuit1: BaseTestCase {

    func testCase1_navigate_from_List_view_to_bitcoin_detail_view() throws {
        Logger.info(msg: "Start testCase1...")
        if FirstPage.checkFirstPageExist() {
            FirstPage.navToListPage()
        }
        ListPage.verifyListPageOpened()
        ListPage.navToDetailPage(labelContains: "Bitcoin")
        DetailPage.verifyDetailPageOpened()
        addTeardownBlock {
            DetailPage.tapBackBtn()
        }
        finishTest()
    }
    
    func testCase2_search_doge_keyword_then_navigate_to_detail_view() throws {
        Logger.info(msg: "Start testCase2...")
        if FirstPage.checkFirstPageExist() {
            FirstPage.navToListPage()
        }
        ListPage.verifyListPageOpened()
        ListPage.navToSearchPage()
        SearchPage.verifySearchPageOpened()
        SearchPage.search(keyword: "doge")
        SearchPage.verifySearchResult()
        SearchPage.navigateToFirstSearchResult()
        DetailPage.verifyDetailPageOpened()
        addTeardownBlock {
            DetailPage.tapBackBtn()
            SearchPage.tapCancelBtn()
        }
        finishTest()
    }

}
