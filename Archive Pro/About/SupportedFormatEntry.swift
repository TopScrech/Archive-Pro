import Foundation

struct SupportedFormatEntry: Identifiable {
    let shortName: String
    let details: LocalizedStringResource
    let canCreate: Bool
    let canExtract: Bool
    
    init(_ shortName: String, details: LocalizedStringResource, canCreate: Bool, canExtract: Bool) {
        self.shortName = shortName
        self.details = details
        self.canCreate = canCreate
        self.canExtract = canExtract
    }
    
    var id: String {
        shortName
    }
}

extension SupportedFormatEntry {
    static let nonZipBased: [SupportedFormatEntry] = [
        .init("7z", details: "7-Zip archive", canCreate: true, canExtract: true),
        .init("rar", details: "RAR archive", canCreate: true, canExtract: true),
        .init("tar", details: "Tar archive", canCreate: true, canExtract: true),
        .init("tar.gz", details: "Gzip-compressed tar", canCreate: true, canExtract: true),
        .init("tar.bz2", details: "Bzip2-compressed tar", canCreate: true, canExtract: true),
        .init("tar.xz", details: "XZ-compressed tar", canCreate: true, canExtract: true),
        .init("tar.lzma", details: "LZMA-compressed tar", canCreate: true, canExtract: true),
        .init("gz", details: "Gzip compressed file", canCreate: true, canExtract: true),
        .init("cpio", details: "CPIO archive", canCreate: true, canExtract: true),
        .init("aar", details: "Apple Archive", canCreate: true, canExtract: true),
        .init("aea", details: "Apple Encrypted Archive", canCreate: true, canExtract: true),
        .init("xar", details: "eXtensible ARchive", canCreate: true, canExtract: true),
        .init("ar", details: "Unix ar archive", canCreate: false, canExtract: true),
        .init("arj", details: "ARJ archive", canCreate: false, canExtract: true),
        .init("bz2", details: "Bzip2 compressed file", canCreate: false, canExtract: true),
        .init("cab", details: "Microsoft Cabinet", canCreate: false, canExtract: true),
        .init("chm", details: "Compiled HTML Help", canCreate: false, canExtract: true),
        .init("cramfs", details: "CramFS image", canCreate: false, canExtract: true),
        .init("deb", details: "Debian package", canCreate: false, canExtract: true),
        .init("dmg", details: "Apple disk image", canCreate: false, canExtract: true),
        .init("fat", details: "FAT filesystem image", canCreate: false, canExtract: true),
        .init("hfs", details: "HFS filesystem image", canCreate: false, canExtract: true),
        .init("img", details: "Disk image", canCreate: false, canExtract: true),
        .init("iso", details: "ISO 9660 image", canCreate: false, canExtract: true),
        .init("lzma", details: "LZMA compressed file", canCreate: false, canExtract: true),
        .init("lzh", details: "LZH/LHA archive", canCreate: false, canExtract: true),
        .init("msi", details: "Windows Installer package", canCreate: false, canExtract: true),
        .init("ntfs", details: "NTFS filesystem image", canCreate: false, canExtract: true),
        .init("pkg", details: "Apple installer package", canCreate: false, canExtract: true),
        .init("qcow", details: "QEMU copy-on-write image", canCreate: false, canExtract: true),
        .init("qcow2", details: "QEMU copy-on-write v2 image", canCreate: false, canExtract: true),
        .init("rpm", details: "RPM package", canCreate: false, canExtract: true),
        .init("squashfs", details: "SquashFS image", canCreate: false, canExtract: true),
        .init("taz", details: "Alias for tar.gz", canCreate: false, canExtract: true),
        .init("tbz", details: "Alias for tar.bz2", canCreate: false, canExtract: true),
        .init("tbz2", details: "Alias for tar.bz2", canCreate: false, canExtract: true),
        .init("tgz", details: "Alias for tar.gz", canCreate: false, canExtract: true),
        .init("tlz", details: "Alias for tar.lzma", canCreate: false, canExtract: true),
        .init("tlzma", details: "Alias for tar.lzma", canCreate: false, canExtract: true),
        .init("txz", details: "Alias for tar.xz", canCreate: false, canExtract: true),
        .init("udf", details: "UDF filesystem image", canCreate: false, canExtract: true),
        .init("vdi", details: "VirtualBox disk image", canCreate: false, canExtract: true),
        .init("vhd", details: "Virtual hard disk", canCreate: false, canExtract: true),
        .init("vhdx", details: "Virtual hard disk v2", canCreate: false, canExtract: true),
        .init("vmdk", details: "VMware disk image", canCreate: false, canExtract: true),
        .init("wim", details: "Windows Imaging Format", canCreate: false, canExtract: true),
        .init("xip", details: "Signed XAR package", canCreate: false, canExtract: true),
        .init("xz", details: "XZ compressed file", canCreate: false, canExtract: true),
        .init("z", details: "Unix compress file", canCreate: false, canExtract: true),
        .init("zst", details: "Zstandard compressed file", canCreate: false, canExtract: true)
    ]
    
    static let zipBased: [SupportedFormatEntry] = [
        .init("zip", details: "ZIP archive", canCreate: true, canExtract: true),
        .init("apk", details: "Android package", canCreate: false, canExtract: true),
        .init("appx", details: "Windows app package", canCreate: false, canExtract: true),
        .init("cbz", details: "Comic book ZIP", canCreate: false, canExtract: true),
        .init("docx", details: "Word document", canCreate: false, canExtract: true),
        .init("ear", details: "Enterprise archive", canCreate: false, canExtract: true),
        .init("epub", details: "EPUB e-book", canCreate: false, canExtract: true),
        .init("ipa", details: "iOS app package", canCreate: false, canExtract: true),
        .init("jar", details: "Java archive", canCreate: false, canExtract: true),
        .init("odp", details: "OpenDocument Presentation", canCreate: false, canExtract: true),
        .init("ods", details: "OpenDocument Spreadsheet", canCreate: false, canExtract: true),
        .init("odt", details: "OpenDocument Text", canCreate: false, canExtract: true),
        .init("pptx", details: "PowerPoint document", canCreate: false, canExtract: true),
        .init("vsix", details: "Visual Studio extension", canCreate: false, canExtract: true),
        .init("war", details: "Web application archive", canCreate: false, canExtract: true),
        .init("whl", details: "Python wheel", canCreate: false, canExtract: true),
        .init("xlsx", details: "Excel document", canCreate: false, canExtract: true)
    ]
    
    static var allFormats: [SupportedFormatEntry] {
        nonZipBased + zipBased
    }
}
