//
//  BackendOperations.swift
//  EMClient
//
//  Created by David Moeller on 20/08/16.
//
//

import Foundation

public class AuthenticationServiceOperation: NetworkOperation {
	
	let service: AuthenticationService
	
	public init(backendConfiguration: BackendConfiguration) {
		self.service = AuthenticationService(backendConfiguration)
		super.init()
	}
	
	public override func cancel() {
		service.cancel()
		super.cancel()
	}
}

public class DataServiceOperation: NetworkOperation {
	
	let service: DataService
	
	public init(backendConfiguration: BackendConfiguration) {
		self.service = DataService(backendConfiguration)
		super.init()
	}
	
	public override func cancel() {
		service.cancel()
		super.cancel()
	}
}

public class NetworkOperation: NSOperation {
	
	private var _ready: Bool
	public override var ready: Bool {
		get { return _ready }
		set { update({ self._ready = newValue }, key: "isReady") }
	}
	
	private var _executing: Bool
	public override var executing: Bool {
		get { return _executing }
		set { update({ self._executing = newValue }, key: "isExecuting") }
	}
	
	private var _finished: Bool
	public override var finished: Bool {
		get { return _finished }
		set { update({ self._finished = newValue }, key: "isFinished") }
	}
	
	private var _cancelled: Bool
	public override var cancelled: Bool {
		get { return _cancelled }
		set { update({ self._cancelled = newValue }, key: "isCancelled") }
	}
	
	private func update(change: (Void) -> Void, key: String) {
		willChangeValueForKey(key)
		change()
		didChangeValueForKey(key)
	}
	
	override init() {
		_ready = true
		_executing = false
		_finished = false
		_cancelled = false
		super.init()
		name = "Network Operation"
	}
	
	public override var asynchronous: Bool {
		return true
	}
	
	public override func start() {
		if self.executing == false {
			self.ready = false
			self.executing = true
			self.finished = false
			self.cancelled = false
		}
	}
	
	/// Used only by subclasses. Externally you should use `cancel`.
	func finish() {
		self.executing = false
		self.finished = true
	}
	
	public override func cancel() {
		self.executing = false
		self.cancelled = true
	}
}
