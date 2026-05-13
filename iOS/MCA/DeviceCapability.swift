import Foundation

enum DeviceCapability {

    /// Gemma 4 E2B INT4 weights are ~3.6 GB on disk and expand further at runtime
    /// (model + KV cache + Metal buffers). Devices with less than 8 GB physical
    /// memory (iPhone 14 Pro, iPhone 15, etc.) get jetsam-killed before inference
    /// completes, so the feature is gated to iPhone 15 Pro and newer.
    ///
    /// iOS reports a value slightly below the spec'd RAM (an 8 GB device shows
    /// roughly 7.5-7.8 GB). Use 7 GB as the threshold so 8 GB devices reliably
    /// pass while 6 GB devices are still gated out.
    static let minimumPhysicalMemoryBytes: UInt64 = 7 * 1024 * 1024 * 1024

    static var hasSufficientMemory: Bool {
        ProcessInfo.processInfo.physicalMemory >= minimumPhysicalMemoryBytes
    }

    static var supportsOnDeviceAI: Bool {
        hasSufficientMemory
    }

    static let unsupportedDeviceMessage =
        "This feature requires an iPhone 15 Pro or newer (8 GB of memory or more)."
}
