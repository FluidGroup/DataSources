//
//  Throttle.swift
//  DataSources
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

final class Throttle {

  private var timerReference: DispatchSourceTimer?

  let interval: TimeInterval
  let queue: DispatchQueue

  private var lastSendTime: Date?

  init(interval: TimeInterval, queue: DispatchQueue = .main) {
    self.interval = interval
    self.queue = queue
  }

  func on(handler: @escaping () -> Void) {

    let now = Date()

    if let _lastSendTime = lastSendTime {
      if (now.timeIntervalSinceReferenceDate - _lastSendTime.timeIntervalSinceReferenceDate) >= interval {
        handler()
        lastSendTime = now
      }
    } else {
      lastSendTime = now
    }

    let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(interval * 1000.0))

    timerReference?.cancel()

    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: deadline)

    timer.setEventHandler(handler: { [weak timer, weak self] in
      self?.lastSendTime = nil
      handler()
      timer?.cancel()
      self?.timerReference = nil
    })
    timer.resume()
    
    timerReference = timer
  }

  func cancel() {
    timerReference = nil
  }
}
