/**
 * Created by Administrator on 2014/8/19.
 */
package grape.packager.data {
public class ANEBuildTarget {

    public var swcPath:String = null;
    public var airVersion:String = null;

    public var aneName:String = null;
    public var aneID:String = null;
    public var aneVersion:String = null;
    public var aneDescription:String = null;
    public var aneDescriptionFileContent:String = null;
    public var aneCopyright:String = null;
    public var aneExportPath:String = null;

    public var certificateFilePath:String = null;
    public var certificatePassword:String = null;
    public var useTimestamp:Boolean = false;

    public var defaultPlatformSelected:Boolean = false;

    public var androidPlatformSelected:Boolean = false;
    public var androidExtensionNativeLibFilePath:String = null;
    public var androidExtensionInitializer:String = null;
    public var androidExtensionFinalizer:String = null;
    public var androidExtensionAttachmentsSelected:Boolean = false;
    public var androidExtensionAttachments:String = null;
    public var androidExtensionDependsSelected:Boolean = false;
    public var androidExtensionDepends:String = null; //Android Java 依赖项，依赖项均为Java格式的jar文件，不能为dex格式

    public var androidx86PlatformSelected:Boolean = false;
    public var androidx86ExtensionNativeLibFilePath:String = null;
    public var androidx86ExtensionInitializer:String = null;
    public var androidx86ExtensionFinalizer:String = null;
    public var androidx86ExtensionAttachmentsSelected:Boolean = false;
    public var androidx86ExtensionAttachments:String = null;
    public var androidx86ExtensionDependsSelected:Boolean = false;
    public var androidx86ExtensionDepends:String = null;

    public var iosPlatformSelected:Boolean = false;
    public var iosExtensionUseRealDevice:Boolean = true;
    public var iosExtensionNativeLibFilePath:String = null;
    public var iosExtensionInitializer:String = null;
    public var iosExtensionFinalizer:String = null;
    public var iosExtensionAttachmentsSelected:Boolean = false;
    public var iosExtensionAttachments:String = null;
    public var iosExtensionPlatformOptionsSelected:Boolean = false;
    public var iosExtensionPlatformOptionsFilePath:String = null;

    public var windowsPlatformSelected:Boolean = false;
    public var windowsExtensionNativeLibFilePath:String = null;
    public var windowsExtensionInitializer:String = null;
    public var windowsExtensionFinalizer:String = null;
    public var windowsExtensionAttachmentsSelected:Boolean = false;
    public var windowsExtensionAttachments:String = null;

    public var macPlatformSelected:Boolean = false;
    public var macExtensionNativeLibFilePath:String = null;
    public var macExtensionInitializer:String = null;
    public var macExtensionFinalizer:String = null;
    public var macExtensionAttachmentsSelected:Boolean = false;
    public var macExtensionAttachments:String = null;

    public function ANEBuildTarget () {}
}
}
