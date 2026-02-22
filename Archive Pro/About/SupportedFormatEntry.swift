import Foundation

struct SupportedFormatEntry: Identifiable {
    let shortName: String
    let details: LocalizedStringResource
    let canCreate: Bool
    let canExtract: Bool
    
    var id: String {
        shortName
    }
}

extension SupportedFormatEntry {
    static let nonZipBased: [SupportedFormatEntry] = [
        .init(shortName: "7z", details: "7-Zip archive", canCreate: true, canExtract: true),
        .init(shortName: "rar", details: "RAR archive", canCreate: true, canExtract: true),
        .init(shortName: "tar", details: "Tar archive", canCreate: true, canExtract: true),
        .init(shortName: "tar.gz", details: "Gzip-compressed tar", canCreate: true, canExtract: true),
        .init(shortName: "tar.bz2", details: "Bzip2-compressed tar", canCreate: true, canExtract: true),
        .init(shortName: "tar.xz", details: "XZ-compressed tar", canCreate: true, canExtract: true),
        .init(shortName: "tar.lzma", details: "LZMA-compressed tar", canCreate: true, canExtract: true),
        .init(shortName: "cpio", details: "CPIO archive", canCreate: true, canExtract: true),
        .init(shortName: "aar", details: "Apple Archive", canCreate: true, canExtract: true),
        .init(shortName: "aea", details: "Apple Encrypted Archive", canCreate: true, canExtract: true),
        .init(shortName: "xar", details: "eXtensible ARchive", canCreate: true, canExtract: true),
        .init(shortName: "ar", details: "Unix ar archive", canCreate: false, canExtract: true),
        .init(shortName: "arj", details: "ARJ archive", canCreate: false, canExtract: true),
        .init(shortName: "bz2", details: "Bzip2 compressed file", canCreate: false, canExtract: true),
        .init(shortName: "cab", details: "Microsoft Cabinet", canCreate: false, canExtract: true),
        .init(shortName: "chm", details: "Compiled HTML Help", canCreate: false, canExtract: true),
        .init(shortName: "cramfs", details: "CramFS image", canCreate: false, canExtract: true),
        .init(shortName: "deb", details: "Debian package", canCreate: false, canExtract: true),
        .init(shortName: "dmg", details: "Apple disk image", canCreate: false, canExtract: true),
        .init(shortName: "fat", details: "FAT filesystem image", canCreate: false, canExtract: true),
        .init(shortName: "gz", details: "Gzip compressed file", canCreate: false, canExtract: true),
        .init(shortName: "hfs", details: "HFS filesystem image", canCreate: false, canExtract: true),
        .init(shortName: "img", details: "Disk image", canCreate: false, canExtract: true),
        .init(shortName: "iso", details: "ISO 9660 image", canCreate: false, canExtract: true),
        .init(shortName: "lzma", details: "LZMA compressed file", canCreate: false, canExtract: true),
        .init(shortName: "lzh", details: "LZH/LHA archive", canCreate: false, canExtract: true),
        .init(shortName: "msi", details: "Windows Installer package", canCreate: false, canExtract: true),
        .init(shortName: "ntfs", details: "NTFS filesystem image", canCreate: false, canExtract: true),
        .init(shortName: "pkg", details: "Apple installer package", canCreate: false, canExtract: true),
        .init(shortName: "qcow", details: "QEMU copy-on-write image", canCreate: false, canExtract: true),
        .init(shortName: "qcow2", details: "QEMU copy-on-write v2 image", canCreate: false, canExtract: true),
        .init(shortName: "rpm", details: "RPM package", canCreate: false, canExtract: true),
        .init(shortName: "squashfs", details: "SquashFS image", canCreate: false, canExtract: true),
        .init(shortName: "taz", details: "Alias for tar.gz", canCreate: false, canExtract: true),
        .init(shortName: "tbz", details: "Alias for tar.bz2", canCreate: false, canExtract: true),
        .init(shortName: "tbz2", details: "Alias for tar.bz2", canCreate: false, canExtract: true),
        .init(shortName: "tgz", details: "Alias for tar.gz", canCreate: false, canExtract: true),
        .init(shortName: "tlz", details: "Alias for tar.lzma", canCreate: false, canExtract: true),
        .init(shortName: "tlzma", details: "Alias for tar.lzma", canCreate: false, canExtract: true),
        .init(shortName: "txz", details: "Alias for tar.xz", canCreate: false, canExtract: true),
        .init(shortName: "udf", details: "UDF filesystem image", canCreate: false, canExtract: true),
        .init(shortName: "vdi", details: "VirtualBox disk image", canCreate: false, canExtract: true),
        .init(shortName: "vhd", details: "Virtual hard disk", canCreate: false, canExtract: true),
        .init(shortName: "vhdx", details: "Virtual hard disk v2", canCreate: false, canExtract: true),
        .init(shortName: "vmdk", details: "VMware disk image", canCreate: false, canExtract: true),
        .init(shortName: "wim", details: "Windows Imaging Format", canCreate: false, canExtract: true),
        .init(shortName: "xip", details: "Signed XAR package", canCreate: false, canExtract: true),
        .init(shortName: "xz", details: "XZ compressed file", canCreate: false, canExtract: true),
        .init(shortName: "z", details: "Unix compress file", canCreate: false, canExtract: true),
        .init(shortName: "zst", details: "Zstandard compressed file", canCreate: false, canExtract: true)
    ]
    
    static let zipBased: [SupportedFormatEntry] = [
        .init(shortName: "zip", details: "ZIP archive", canCreate: true, canExtract: true),
        .init(shortName: "apk", details: "Android package", canCreate: false, canExtract: true),
        .init(shortName: "appx", details: "Windows app package", canCreate: false, canExtract: true),
        .init(shortName: "cbz", details: "Comic book ZIP", canCreate: false, canExtract: true),
        .init(shortName: "docx", details: "Word document", canCreate: false, canExtract: true),
        .init(shortName: "ear", details: "Enterprise archive", canCreate: false, canExtract: true),
        .init(shortName: "epub", details: "EPUB e-book", canCreate: false, canExtract: true),
        .init(shortName: "ipa", details: "iOS app package", canCreate: false, canExtract: true),
        .init(shortName: "jar", details: "Java archive", canCreate: false, canExtract: true),
        .init(shortName: "odp", details: "OpenDocument Presentation", canCreate: false, canExtract: true),
        .init(shortName: "ods", details: "OpenDocument Spreadsheet", canCreate: false, canExtract: true),
        .init(shortName: "odt", details: "OpenDocument Text", canCreate: false, canExtract: true),
        .init(shortName: "pptx", details: "PowerPoint document", canCreate: false, canExtract: true),
        .init(shortName: "vsix", details: "Visual Studio extension", canCreate: false, canExtract: true),
        .init(shortName: "war", details: "Web application archive", canCreate: false, canExtract: true),
        .init(shortName: "whl", details: "Python wheel", canCreate: false, canExtract: true),
        .init(shortName: "xlsx", details: "Excel document", canCreate: false, canExtract: true)
    ]
    
    static var allFormats: [SupportedFormatEntry] {
        nonZipBased + zipBased
    }
}
