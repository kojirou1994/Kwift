#if os(macOS)
import Foundation
import Combine

@available(OSX 10.15, *)
public extension Executable {
    func publisher(options: ExecutableOutputOptions) -> ExecutablePublisher<Self> {
        .init(executable: self, options: options)
    }
}

public struct ExecutableOutputOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let stdout    = Self(rawValue: 1 << 0)
    public static let stderr    = Self(rawValue: 1 << 1)

    public static let all: Self = [.stdout, .stderr]
}

@available(OSX 10.15, *)
public struct ExecutablePublisher<E: Executable>: Publisher {

    public enum Output {
        case stderr(Data)
        case stdout(Data)
        case launched(identifier: Int32)
        case terminated(status: Int32, reason: Process.TerminationReason)
    }

    public typealias Failure = Never

    let executable: E

    let options: ExecutableOutputOptions

    class ProcessPublisherSubscription: Subscription {
        let process: Process

        init(process: Process) {
            self.process = process
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            if self.process.isRunning {
                self.process.terminate()
            }
        }

        deinit {
//            Swift.print("Subscription deinit")
        }
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        autoreleasepool {
            let process = try! executable.generateProcess()
            let subscription = ProcessPublisherSubscription(process: process)

            var catchedPipes = [Pipe]()

            if options.contains(.stderr) {
                let stderr = Pipe()
                process.standardError = stderr
                stderr.fileHandleForReading.readabilityHandler = { handle in
                    let data = handle.availableData
                    if data.isEmpty {
                        return
                    }
                    _ = subscriber.receive(.stderr(data))
                }
                catchedPipes.append(stderr)
            } else {
                process.standardError = FileHandle.nullDevice
            }

            if options.contains(.stdout) {
                let stdout = Pipe()
                process.standardError = stdout
                stdout.fileHandleForReading.readabilityHandler = { handle in
                    let data = handle.availableData
                    if data.isEmpty {
                        return
                    }
                    _ = subscriber.receive(.stdout(data))
                }
                catchedPipes.append(stdout)
            } else {
                process.standardOutput = FileHandle.nullDevice
            }

            process.terminationHandler = { p in
                catchedPipes.forEach {$0.fileHandleForReading.readabilityHandler = nil}
                _ = subscriber.receive(.terminated(status: p.terminationStatus, reason: p.terminationReason))
                subscriber.receive(completion: .finished)
                p.terminationHandler = nil
            }

            subscriber.receive(subscription: subscription)
            try! process.run()
            _ = subscriber.receive(.launched(identifier: process.processIdentifier))
        }
    }
}
#endif
