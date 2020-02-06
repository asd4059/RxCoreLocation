//
//  CLLocationManagerEvents+Rx.swift
//  RxCoreLocation
//
//  Created by Bob Obi on 08.11.17.
//  Copyright © 2017 RxCoreLocation. All rights reserved.
//

import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension Reactive where Base: CLLocationManager {
    /// Reactive Observable for `activityType`
    public var activityType: Observable<CLActivityType?> {
        self.observe(CLActivityType.self, .activityType)
    }
    /// Reactive Observable for `distanceFilter`
    public var distanceFilter: Observable<CLLocationDistance> {
        self.observe(CLLocationDistance.self, .distanceFilter)
            .compactMap { $0 }
    }
    /// Reactive Observable for `desiredAccuracy`
    public var desiredAccuracy: Observable<CLLocationAccuracy> {
        self.observe(CLLocationAccuracy.self, .desiredAccuracy)
            .compactMap { $0 }
    }
    /// Reactive Observable for `pausesLocationUpdatesAutomatically`
    public var pausesLocationUpdatesAutomatically: Observable<Bool> {
        self.observe(Bool.self, .pausesLocationUpdatesAutomatically)
            .compactMap { $0 }
    }
    /// Reactive Observable for `allowsBackgroundLocationUpdates`
    public var allowsBackgroundLocationUpdates: Observable<Bool> {
        self.observe(Bool.self, .allowsBackgroundLocationUpdates)
            .compactMap { $0 }
    }
    /// Reactive Observable for `showsBackgroundLocationIndicator`
    public var showsBackgroundLocationIndicator: Observable<Bool> {
        self.observe(Bool.self, .showsBackgroundLocationIndicator)
            .compactMap { $0 }
    }
    /// Reactive Observable for `location`
    public var location: Observable<CLLocation?> {
        let updatedLocation = self.didUpdateLocations.map { $1.last }
        let location =  self.observe(CLLocation.self, .location)
        return Observable.of(location, updatedLocation).merge()
    }
    /// Reactive Observable for CLPlacemark
    public var placemark: Observable<CLPlacemark> {
        location.compactMap { $0 }.flatMap(placemark(with:))
    }
    /// Private reactive wrapper for `CLGeocoder`.`reverseGeocodeLocation`
    /// used to search for placemark
    private func placemark(with location: CLLocation) -> Observable<CLPlacemark> {
        Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                observer.onNext(placemarks?.first)
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }.compactMap { $0 }
    }
    /// Reactive Observable for `headingFilter`
    public var headingFilter: Observable<CLLocationDegrees> {
        self.observe(CLLocationDegrees.self, .headingFilter)
            .compactMap { $0 }
    }
    /// Reactive Observable for `headingOrientation`
    public var headingOrientation: Observable<CLDeviceOrientation?> {
        self.observe(CLDeviceOrientation.self, .headingOrientation)
    }
     #if os(iOS) || os(macOS)
    /// Reactive Observable for `heading`
    public var heading: Observable<CLHeading?> {
        self.observe(CLHeading.self, .heading)
    }
    #endif
    /// Reactive Observable for `maximumRegionMonitoringDistance`
    public var maximumRegionMonitoringDistance: Observable<CLLocationDistance> {
        self.observe(CLLocationDistance.self, .maximumRegionMonitoringDistance)
            .compactMap { $0 }
    }
    /// Reactive Observable for `monitoredRegions`
    public var monitoredRegions: Observable<Set<CLRegion>> {
        self.observe(Set<CLRegion>.self, .monitoredRegions)
            .compactMap { $0 }
    }
    /// Reactive Observable for `rangedRegions`
    public var rangedRegions: Observable<Set<CLRegion>> {
        self.observe(Set<CLRegion>.self, .rangedRegions)
            .compactMap { $0 }
    }
    
    /// Reactive Observable for `locationServicesEnabled`
    public var isEnabled: Observable<Bool> {
        CLLocationManager.__isEnabled.share()
    }
    
    /// Reactive Observable for `authorizationStatus`
    public var status: Observable<CLAuthorizationStatus> {
        CLLocationManager.__status.share()
    }
    
     #if os(iOS) || os(macOS)
    /// Reactive Observable fo `deferredLocationUpdatesAvailable`
    public var isDeferred: Observable<Bool> {
        CLLocationManager.__isDeferred.share()
    }
    
    /// Reactive Observable fo `significantLocationChangeMonitoringAvailable`
    public var hasChanges: Observable<Bool> {
        CLLocationManager.__hasChanges.share()
    }
    
    /// Reactive Observable fo `headingAvailable`
    public var isHeadingAvailable: Observable<Bool> {
        CLLocationManager.__isHeadingAvailable.share()
    }
    #endif
    /// Reactive Observable fo `isRangingAvailable`
    #if os(iOS)
    public var isRangingAvailable: Observable<Bool> {
        CLLocationManager.__isRangingAvailable.share()
    }
    #endif
}

extension CLLocationManager {
    /// Reactive Observable for `locationServicesEnabled`
    internal static var __isEnabled: Observable<Bool> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.locationServicesEnabled()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    /// Reactive Observable for `authorizationStatus`
    internal static var __status: Observable<CLAuthorizationStatus> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.authorizationStatus()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    /// Reactive Observable fo `deferredLocationUpdatesAvailable`
     #if os(iOS) || os(macOS)
    internal static var __isDeferred: Observable<Bool> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.deferredLocationUpdatesAvailable()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    /// Reactive Observable fo `significantLocationChangeMonitoringAvailable`
    internal static var __hasChanges: Observable<Bool> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.significantLocationChangeMonitoringAvailable()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    /// Reactive Observable fo `headingAvailable`
    internal static var __isHeadingAvailable: Observable<Bool> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.headingAvailable()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    #endif
    
    /// Reactive Observable fo `isRangingAvailable`
    #if os(iOS)
    internal static var __isRangingAvailable: Observable<Bool> {
        Observable.create { observer in
            observer.on(.next(CLLocationManager.isRangingAvailable()))
            return Disposables.create {
                observer.onCompleted()
            }
        }
    }
    #endif
}
