import Foundation
import Testing

@testable import ComicInfo

struct MatchTests {
  private func match(_ id: String, series: String, coverDate: String? = nil) -> ComicInfo.Match {
    ComicInfo.Match(id: id, heading: "\(series) #1", series: series, coverDate: coverDate)
  }

  @Test func testAMatchHoldsWhatASourceFound() {
    let found = ComicInfo.Match(
      id: "38475", heading: "Saga (2012) #1", series: "Saga", number: "1", coverDate: "2012-03-01",
      title: "Chapter One", details: "Image · Cover date 2012-03-01",
      siteURL: URL(string: "https://comicvine.gamespot.com/saga-1/4000-38475/"))
    #expect(found.id == "38475")
    #expect(found.heading == "Saga (2012) #1")
    #expect(found.number == "1")
    #expect(found.title == "Chapter One")
    #expect(found.details == "Image · Cover date 2012-03-01")
    #expect(found.siteURL?.host() == "comicvine.gamespot.com")
  }

  @Test func testASeriesNamedExactlyAsTypedRanksFirst() {
    let issue = ComicInfo.Issue(series: "Saga")
    let matches = [match("1", series: "Saga Deluxe"), match("2", series: " saga ")]
    #expect(matches.ranked(for: issue).map(\.id) == ["2", "1"])
  }

  @Test func testACoverInTheYearRanksNext() {
    let issue = ComicInfo.Issue(series: "Saga", year: 2012)
    let matches = [
      match("1", series: "Saga", coverDate: "2018-01-01"),
      match("2", series: "Saga Deluxe", coverDate: "2012-03-01"),
      match("3", series: "Saga", coverDate: "2012-03-01"),
    ]
    #expect(matches.ranked(for: issue).map(\.id) == ["3", "1", "2"])
  }

  @Test func testOtherwiseTheSourcesOrderStands() {
    let issue = ComicInfo.Issue(series: "Saga")
    let matches = [match("1", series: "Saga"), match("2", series: "Paper Girls"), match("3", series: "Saga")]
    #expect(matches.ranked(for: issue).map(\.id) == ["1", "3", "2"])
  }

  @Test func testWithoutAYearTheCoverDateCountsForNothing() {
    let issue = ComicInfo.Issue(series: "Saga")
    let matches = [match("1", series: "Saga", coverDate: "2018-01-01"), match("2", series: "Saga")]
    #expect(matches.ranked(for: issue).map(\.id) == ["1", "2"])
  }
}
