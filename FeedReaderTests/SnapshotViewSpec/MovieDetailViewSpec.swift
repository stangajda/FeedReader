//
//  MovieDetailViewSpec.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 06/07/2023.
//

import Foundation
@testable import FeedReader
import SwiftUI
import Nimble
import Quick
import SnapshotTesting
import Nimble_SnapshotTesting

class MovieDetailViewSpec: QuickSpec {
    override func spec() {
        describe("check movie detail view to match recorded snapshot") {
                    
            var viewController: UIViewController!

            beforeEach { @MainActor in
                Injection.main.setupPreviewModeDetail()
            }

            context("when movie detail is loaded") {
                beforeEach { @MainActor in
                    @Injected(name: .movieDetailStateLoaded) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") { @MainActor in
                    expect(viewController).to(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movie detail is loading") {
                beforeEach { @MainActor in
                    @Injected(name: .movieDetailStateLoading) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") { @MainActor in
                    expect(viewController).to(haveValidSnapshot(as: .image))
                }
            }
            
            context("when movie detail is failed") {
                beforeEach { @MainActor in
                    @Injected(name: .movieDetailStateFailed) var viewModel: AnyMovieDetailViewModelProtocol
                    viewController = UIHostingController(rootView: MovieDetailView(viewModel))
                }

                it("it should match recorded image") { @MainActor in
                    expect(viewController).to(haveValidSnapshot(as: .image))
                }
            }
        }
    }
}
