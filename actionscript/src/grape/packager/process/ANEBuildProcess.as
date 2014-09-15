/**
 * Created by Administrator on 2014/8/20.
 */
package grape.packager.process {
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import grape.packager.data.ANEBuildTarget;

import grape.packager.events.ProcessEvent;
import grape.packager.managers.BuildManager;
import grape.packager.ui.Console;

import nochump.util.zip.ZipEntry;
import nochump.util.zip.ZipError;

import nochump.util.zip.ZipFile;
import nochump.util.zip.ZipOutput;

public class ANEBuildProcess extends NativeProcess {

    protected static const PLATFORM_ANDROID_DIR_NAME:String = "Android-ARM";
    protected static const PLATFORM_ANDROIDX86_DIR_NAME:String = "Android-x86";
    protected static const PLATFORM_IOS_DIR_NAME:String = "iOS";
    protected static const PLATFORM_WINDOWS_DIR_NAME:String = "Windows";
    protected static const PLATFORM_MAC_DIR_NAME:String = "Mac";
    protected static const PLATFORM_DEFAULT_DIR_NAME:String = "default";

    protected var mTempDir:File = null;//临时工作目录

    public function ANEBuildProcess () {
        super ();
        addEventListener(NativeProcessExitEvent.EXIT,onExit);
        addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,function(event:ProgressEvent):void{
	        Console.getInstance().show(standardOutput.readUTFBytes(standardOutput.bytesAvailable));
        });

        addEventListener(ProgressEvent.STANDARD_ERROR_DATA,function(event:ProgressEvent):void{
//	        Console.getInstance().show(standardError.readUTFBytes(standardError.bytesAvailable));
        });

	    addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, function(event:IOErrorEvent):void{
//		    Console.getInstance().show(event.toString());
	    });
	    addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, function(event:IOErrorEvent):void{
//		    Console.getInstance().show(event.toString());
	    });

    }

    protected function onExit(event:NativeProcessExitEvent):void{
        switch(event.exitCode){
            case 0:Console.getInstance().show("打包完成");break;
            case 100:Console.getInstance().show("无法分析应用程序描述符");break;
            case 101: Console.getInstance().show("缺少命名空间");break;
            case 102:Console.getInstance().show("命名空间无效");break;
            case 103:Console.getInstance().show("意外的元素或属性：\n1.删除引起错误的元素和属性。描述符文件中不允许使用自定义值。\n2.检查元素和属性名称的拼写。\n3.确保将元素放置在正确的父元素内，且使用属性时对应着正确的元素。");break;
            case 104:Console.getInstance().show("缺少元素或属性");break;
            case 105:Console.getInstance().show("元素或属性所含的某个值无效");break;
            case 106:Console.getInstance().show("窗口属性组合非法");break;
            case 107:Console.getInstance().show("窗口最小大小大于窗口最大大小");break;
            case 108:Console.getInstance().show("前面的元素中已使用的属性");break;
            case 109:Console.getInstance().show("重复元素");break;
            case 110:Console.getInstance().show("至少需要一个指定类型的元素");break;
            case 111:Console.getInstance().show("在应用程序描述符中列出的配置文件都不支持本机扩展，将配置文件添加到支持 本机扩展的 supportedProfies 列表。");break;
            case 112:Console.getInstance().show("AIR 目标不支持本机扩展，选择支持本机扩展的目标。");break;
            case 113:Console.getInstance().show("<nativeLibrary> 和 <initializer> 必须一起提供，必须为本机扩展中的每个本机库都指定初始值设定项函数。");break;
            case 114:Console.getInstance().show("找到不含 <nativeLibrary> 的 <finalizer>，除非平台使用本机库，否则不要指定终结器。");break;
            case 115:Console.getInstance().show("默认平台不得包含本机实施。");break;
            case 116:Console.getInstance().show("此目标不支持浏览器调用，对于指定的打包目标，<allowBrowserInvocation> 元素不能为 true。");break;
            case 117:Console.getInstance().show("此目标至少需要命名空间 n 打包本机扩展。");break;
            case 200:Console.getInstance().show("无法打开图标文件");break;
            case 201:Console.getInstance().show("图标大小错误");break;
            case 202:Console.getInstance().show("图标文件包含的某种图像格式不受支持");break;
            case 300: Console.getInstance().show("缺少文件，或无法打开文件");break;
            case 301: Console.getInstance().show("缺少或无法打开应用程序描述符文件");break;
            case 302:Console.getInstance().show("包中缺少根内容文件");break;
            case 303:Console.getInstance().show("包中缺少图标文件");break;
            case 304:Console.getInstance().show("初始窗口内容无效");break;
            case 305:Console.getInstance().show("初始窗口内容的 SWF 版本超出命名空间的版本");break;
            case 306:Console.getInstance().show("配置文件不受支持");break;
            case 307:Console.getInstance().show("命名空间必须至少为 nnn");break;
            case 2:Console.getInstance().show("用法错误，检查命令行参数是否存在错误");break;
            case 5:Console.getInstance().show("未知错误，此错误表示所发生的情况无法按常见的错误条件作出解释。可能的根源包括 ADT 与 Java 运行时环境之间不兼容、ADT 或 JRE 安装损坏以及 ADT 内有编程错误。");break;
            case 6:Console.getInstance().show("无法写入输出目录，确保指定的（或隐含的）输出目录可访问，并且所在驱动器有足够的磁盘空间。");break;
            case 7:Console.getInstance().show("无法访问证书");break;
            case 8:Console.getInstance().show("证书无效，证书文件格式错误、被修改、已到期或被撤消。");break;
            case 9:Console.getInstance().show("无法为 AIR 文件签名，验证传递给 ADT 的签名选项。");break;
            case 10:Console.getInstance().show("无法创建时间戳，ADT 无法与时间戳服务器建立连接。如果通过代理服务器连接到 Internet，则可能需要配置 JRE 的代理服务器设置。");break;
            case 11:Console.getInstance().show("创建证书时出错");break;
            case 12:Console.getInstance().show("输入无效，验证命令行中传递给 ADT 的文件路径和其他参数。");break;
            case 13:Console.getInstance().show("缺少设备 SDK，验证设备 SDK 配置。ADT 找不到执行指定命令所需的设备 SDK。");break;
            case 14:Console.getInstance().show("设备错误，ADT 无法执行命令，因为存在设备限制或设备问题。例如，在尝试卸载未实际安装的应用程序时会显示此退出代码。");break;
            case 15:Console.getInstance().show("无设备，验证设备是否已连接且已开启，或仿真器是否正在运行。");break;
            case 16:Console.getInstance().show("缺少 GPL 组件，当前的 AIR SDK 未包含执行请求的操作所需的所有组件。");break;
            case 17:Console.getInstance().show("设备打包工具失败，由于缺少预期的操作系统组件，因此无法创建包。");break;
            case 400:Console.getInstance().show("当前的 Android sdk 版本不支持属性，检查属性名称的拼写是否正确，以及对于在其中出现的元素是否为有效的属性。如果此属性是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");break;
            case 401:Console.getInstance().show("当前的 Android sdk 版本不支持属性值，检查属性值的拼写是否正确，以及对于该属性是否为有效的值。如果此属性值是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");break;
            case 402:Console.getInstance().show("当前的 Android sdk 版本不支持 XML 标签，检查 XML 标签名称的拼写是否正确，以及是否为有效的 Android 清单文档元素。如果此元素是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");break;
            case 403:Console.getInstance().show("不允许覆盖 Android 标签");break;
            case 404:Console.getInstance().show("不允许覆盖 Android 属性");break;
            case 405:Console.getInstance().show("Android 标签 %1 必须是 manifestAdditions 标签中的第一个元素");break;
            case 406:Console.getInstance().show("Android 标签 %2 的属性 %1 具有无效值 %3。");break;
            case 1000:Console.getInstance().show("参数太少!");break;
            case 1001:Console.getInstance().show("创建进程失败!");break;
        }

        if (event.exitCode != 0){
            Console.getInstance().show("打包失败!请检查配置");
        }

        deleteTempDir();

        dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETED,true,false));
    }

    /**
     * 删除临时工作目录
     */
    public function deleteTempDir():void{
        if(mTempDir && mTempDir.exists){
            Console.getInstance().show("删除临时工作目录");
            mTempDir.deleteDirectory(true);
        }
    }

    private function copyZipEntries(dist:ZipOutput,src:ZipFile):void{
        var tmpZipEntry:ZipEntry;
        for each(tmpZipEntry in src.entries){
            if(tmpZipEntry.name.indexOf("META_INF") <= -1 && !tmpZipEntry.isDirectory()){
                try{
                    dist.putNextEntry(new ZipEntry(tmpZipEntry.name));
                    dist.write(src.getInput(tmpZipEntry));
                    dist.closeEntry();
                }catch (e:ZipError){
                    Console.getInstance().show(e.message);
                }
            }
        }
    }

    public function StartANEBuild():void{
        try{
            var target:ANEBuildTarget = BuildManager.getInstance().aneBuildTarget;
            Console.getInstance().show("开始打包");
            var swcFile:File = new File(target.swcPath.replace(/\\/g,"/"));
            var fs:FileStream = new FileStream();
            fs.open(swcFile,FileMode.READ);
            var bytes:ByteArray = new ByteArray();
            fs.readBytes(bytes,0,fs.bytesAvailable);
            fs.close();

            var zip:ZipFile = new ZipFile(bytes);
            var libraryZipEntry:ZipEntry = zip.getEntry("library.swf");
            if(!libraryZipEntry){
                Console.getInstance().show("指定的swc文件无效!");
                return;
            }

            Console.getInstance().show("提取SWC中的library.swf文件")
            var libSwfFileContent:ByteArray = zip.getInput(libraryZipEntry);

            Console.getInstance().show("创建临时工作目录");
            mTempDir = File.createTempDirectory();

            Console.getInstance().show("生成library.swf文件");
            var libSwfFile:File = mTempDir.resolvePath("library.swf");
            fs = new FileStream();
            fs.open(libSwfFile,FileMode.WRITE);
            fs.writeBytes(libSwfFileContent);
            fs.close();

            Console.getInstance().show("生成extension.xml文件");
            var extensionFile:File = mTempDir.resolvePath("extension.xml");
            fs = new FileStream();
            fs.open(extensionFile,FileMode.WRITE);
            fs.writeUTFBytes(target.aneDescriptionFileContent);
            fs.close();

            var platformDir:File = null;
            var fileNativeLib:File = null;
            var fileAttachment:File = null;
            var attachmentPaths:Array = null;
            var androidDepends:Array = null;
            var i:int = 0;
            if(target.defaultPlatformSelected){
                Console.getInstance().show("创建default平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_DEFAULT_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到default平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);
            }

            if(target.androidPlatformSelected){
                Console.getInstance().show("创建Android-ARM平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_ANDROID_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到Android-ARM平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);

                fileNativeLib = new File(target.androidExtensionNativeLibFilePath.replace(/\\/g,"/"));
                Console.getInstance().show("拷贝" + fileNativeLib.name + "到Android-ARM平台目录");
                fileNativeLib.copyTo(platformDir.resolvePath(fileNativeLib.name),true);

                if(target.androidExtensionAttachmentsSelected){
                    Console.getInstance().show("开始拷贝扩展附件到Android-ARM平台目录");
                    attachmentPaths = target.androidExtensionAttachments.split(";");
                    for(i = 0;i < attachmentPaths.length;i++){
                        try{
                            fileAttachment = new File(attachmentPaths[i].replace(/\\/g,"/"));
                            if(fileAttachment.exists){
                                Console.getInstance().show("拷贝附件" + fileAttachment.name);
                                fileAttachment.copyTo(platformDir.resolvePath(fileAttachment.name),true);
                            }else{
                                Console.getInstance().show(attachmentPaths[i] + "不存在!");
                            }
                        }catch (e:Error){
                            Console.getInstance().show("路径" + attachmentPaths[i] + "无效,跳过");
                        }
                    }
                }

                if(target.androidExtensionDependsSelected && fileNativeLib.extension != null && fileNativeLib.extension.toLowerCase() == "jar"){
                    androidDepends = target.androidExtensionDepends.split(";");
                    if(androidDepends && androidDepends.length > 0){
                        var dependFile:File = null;
                        Console.getInstance().show("开始将本地库和依赖库打包在一起,打包过程中将忽略所有冲突!");
                        var allNativeLibZip:ZipOutput = new ZipOutput();
                        //write main native lib file
                        Console.getInstance().show("打包本地库" + fileNativeLib.name);
                        var tmpStream:FileStream = new FileStream();
                        tmpStream.open(fileNativeLib,FileMode.READ);
                        var tmpZipFile:ZipFile = new ZipFile(tmpStream);
                        var tmpZipEntry:ZipEntry = null;
                        copyZipEntries(allNativeLibZip,tmpZipFile);
                        tmpStream.close();

                        for(var j:int = 0;j < androidDepends.length;j++){
                            dependFile = new File((androidDepends[j].replace(/\\/g,"/")));
                            if(dependFile.exists){
                                if(!dependFile.isDirectory){
                                    if(dependFile.extension && dependFile.extension.toLowerCase() == "jar"){
                                        Console.getInstance().show("打包依赖库" + dependFile.name);
                                        tmpStream.open(dependFile,FileMode.READ);
                                        tmpZipFile = new ZipFile(tmpStream);
                                        copyZipEntries(allNativeLibZip,tmpZipFile);
                                        tmpStream.close();
                                    }
                                }else{
                                    var children:Array = dependFile.getDirectoryListing();
                                    for each(var f:File in children){
                                        if(f.exists && !f.isDirectory && f.extension && f.extension.toLowerCase() == "jar"){
                                            Console.getInstance().show("打包依赖库" + f.name);
                                            tmpStream.open(f,FileMode.READ);
                                            tmpZipFile = new ZipFile(tmpStream);
                                            tmpStream.close();
                                        }
                                    }
                                }
                            }else{
                                Console.getInstance().show("依赖项" + dependFile.name + "不存在,跳过");
                            }
                        }
                        allNativeLibZip.finish();

                        //wirte the packaged libraries data to the main library file
                        Console.getInstance().show("生成打包后的本机库文件");
                        tmpStream.open(fileNativeLib,FileMode.WRITE);
                        tmpStream.writeBytes(allNativeLibZip.byteArray);
                        tmpStream.close();
                    }
                }
            }

            if(target.androidx86PlatformSelected){
                Console.getInstance().show("创建Android-x86平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_ANDROIDX86_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到Android-x86平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);

                fileNativeLib = new File(target.androidx86ExtensionNativeLibFilePath.replace(/\\/g,"/"));
                Console.getInstance().show("拷贝" + fileNativeLib.name + "到Android-x86平台目录");
                fileNativeLib.copyTo(platformDir.resolvePath(fileNativeLib.name),true);

                if(target.androidx86ExtensionAttachmentsSelected){
                    Console.getInstance().show("开始拷贝扩展附件到Android-x86平台目录");
                    attachmentPaths = target.androidx86ExtensionAttachments.split(";");
                    for(i = 0;i < attachmentPaths.length;i++){
                        try{
                            fileAttachment = new File(attachmentPaths[i].replace(/\\/g,"/"));
                            if(fileAttachment.exists){
                                Console.getInstance().show("拷贝附件" + fileAttachment.name);
                                fileAttachment.copyTo(platformDir.resolvePath(fileAttachment.name),true);
                            }else{
                                Console.getInstance().show(attachmentPaths[i] + "不存在!");
                            }
                        }catch (e:Error){
                            Console.getInstance().show("路径" + attachmentPaths[i] + "无效,跳过");
                        }
                    }
                }

                if(target.androidx86ExtensionDependsSelected && fileNativeLib.extension != null && fileNativeLib.extension.toLowerCase() == "jar"){
                    androidDepends = target.androidx86ExtensionDepends.split(";");
                    if(androidDepends && androidDepends.length > 0){
                        var dependFile:File = null;
                        Console.getInstance().show("开始将本地库和依赖库打包在一起,打包过程中将忽略所有冲突!");
                        var allNativeLibZip:ZipOutput = new ZipOutput();
                        //write main native lib file
                        Console.getInstance().show("打包本地库" + fileNativeLib.name);
                        var tmpStream:FileStream = new FileStream();
                        tmpStream.open(fileNativeLib,FileMode.READ);
                        var tmpZipFile:ZipFile = new ZipFile(tmpStream);
                        var tmpZipEntry:ZipEntry = null;
                        copyZipEntries(allNativeLibZip,tmpZipFile);
                        tmpStream.close();

                        for(var j:int = 0;j < androidDepends.length;j++){
                            dependFile = new File((androidDepends[j].replace(/\\/g,"/")));
                            if(dependFile.exists){
                                if(!dependFile.isDirectory){
                                    if(dependFile.extension && dependFile.extension.toLowerCase() == "jar"){
                                        Console.getInstance().show("打包依赖库" + dependFile.name);
                                        tmpStream.open(dependFile,FileMode.READ);
                                        tmpZipFile = new ZipFile(tmpStream);
                                        copyZipEntries(allNativeLibZip,tmpZipFile);
                                        tmpStream.close();
                                    }
                                }else{
                                    var children:Array = dependFile.getDirectoryListing();
                                    for each(var f:File in children){
                                        if(f.exists && !f.isDirectory && f.extension && f.extension.toLowerCase() == "jar"){
                                            Console.getInstance().show("打包依赖库" + f.name);
                                            tmpStream.open(f,FileMode.READ);
                                            tmpZipFile = new ZipFile(tmpStream);
                                            tmpStream.close();
                                        }
                                    }
                                }
                            }else{
                                Console.getInstance().show("依赖项" + dependFile.name + "不存在,跳过");
                            }
                        }
                        allNativeLibZip.finish();

                        //wirte the packaged libraries data to the main library file
                        Console.getInstance().show("生成打包后的本机库文件");
                        tmpStream.open(fileNativeLib,FileMode.WRITE);
                        tmpStream.writeBytes(allNativeLibZip.byteArray);
                        tmpStream.close();
                    }
                }
            }

            if(target.iosPlatformSelected){
                Console.getInstance().show("创建iOS平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_IOS_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到iOS平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);

                fileNativeLib = new File(target.iosExtensionNativeLibFilePath.replace(/\\/g,"/"));
                Console.getInstance().show("拷贝" + fileNativeLib.name + "到iOS平台目录");
                fileNativeLib.copyTo(platformDir.resolvePath(fileNativeLib.name),true);

                if(target.iosExtensionAttachmentsSelected){
                    Console.getInstance().show("开始拷贝扩展附件到iOS平台目录");
                    attachmentPaths = target.iosExtensionAttachments.split(";");
                    for(i = 0;i < attachmentPaths.length;i++){
                        try{
                            fileAttachment = new File(attachmentPaths[i].replace(/\\/g,"/"));
                            if(fileAttachment.exists){
                                Console.getInstance().show("拷贝附件" + fileAttachment.name);
                                fileAttachment.copyTo(platformDir.resolvePath(fileAttachment.name),true);
                            }else{
                                Console.getInstance().show(attachmentPaths[i] + "不存在，跳过");
                            }
                        }catch (e:Error){
                            Console.getInstance().show("路径" + attachmentPaths[i] + "不存在，跳过");
                        }
                    }
                }
            }

            if(target.windowsPlatformSelected){
                Console.getInstance().show("创建Windows平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_WINDOWS_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到Windows平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);

                fileNativeLib = new File(target.windowsExtensionNativeLibFilePath.replace(/\\/g,"/"));
                Console.getInstance().show("拷贝" + fileNativeLib.name + "到Windows平台目录");
                fileNativeLib.copyTo(platformDir.resolvePath(fileNativeLib.name),true);

                if(target.windowsExtensionAttachmentsSelected){
                    Console.getInstance().show("开始拷贝扩展附件到Windows平台目录");
                    attachmentPaths = target.windowsExtensionAttachments.split(";");
                    for(i = 0;i < attachmentPaths.length;i++){
                        try{
                            fileAttachment = new File(attachmentPaths[i].replace(/\\/g,"/"));
                            if(fileAttachment.exists){
                                Console.getInstance().show("拷贝附件" + fileAttachment.name);
                                fileAttachment.copyTo(platformDir.resolvePath(fileAttachment.name),true);
                            }else{
                                Console.getInstance().show(attachmentPaths[i] + "不存在,跳过");
                            }
                        }catch (e:Error){
                            Console.getInstance().show("路径" + attachmentPaths[i] + "不存在,跳过");
                        }
                    }
                }
            }

            if(target.macPlatformSelected){
                Console.getInstance().show("创建Mac平台目录");
                platformDir = mTempDir.resolvePath(PLATFORM_MAC_DIR_NAME);
                platformDir.createDirectory();

                Console.getInstance().show("拷贝library.swf到Mac平台目录");
                libSwfFile.copyTo(platformDir.resolvePath("library.swf"),true);

                fileNativeLib = new File(target.macExtensionNativeLibFilePath.replace(/\\/g,"/"));
                Console.getInstance().show("拷贝" + fileNativeLib.name + "到Mac平台目录");
                fileNativeLib.copyTo(platformDir.resolvePath(fileNativeLib.name),true);

                if(target.macExtensionAttachmentsSelected){
                    Console.getInstance().show("开始拷贝扩展附件到Mac平台目录");
                    attachmentPaths = target.macExtensionAttachments.split(";");
                    for(i = 0;i < attachmentPaths.length;i++){
                        try{
                            fileAttachment = new File(attachmentPaths[i].replace(/\\/g,"/"));
                            if(fileAttachment.exists){
                                Console.getInstance().show("拷贝附件" + fileAttachment.name);
                                fileAttachment.copyTo(platformDir.resolvePath(fileAttachment.name),true);
                            }else{
                                Console.getInstance().show(attachmentPaths[i] + "不存在,跳过");
                            }
                        }catch (e:Error){
                            Console.getInstance().show("路径" + attachmentPaths[i] + "不存在,跳过");
                        }
                    }
                }
            }

           var args:Vector.<String> = new Vector.<String>();
            args.push("-jar");
            args.push(BuildManager.getInstance().adtFilePath.replace(/\\/g,"/"));
            args.push("-package");
            if(target.useTimestamp){
                args.push("-tsa");
                args.push("none");
            }
            args.push("-storetype");
            args.push("PKCS12");
            args.push("-keystore");
            args.push(target.certificateFilePath.replace(/\\/g,"/"));
            args.push("-storepass");
            args.push(target.certificatePassword);
            args.push("-target");
            args.push("ane");
            args.push(target.aneExportPath.replace(/\\/g,"/") + "/" + target.aneName + ".ane");
            args.push(extensionFile.nativePath.replace(/\\/g,"/"));
            args.push("-swc");
            args.push(swcFile.nativePath.replace(/\\/g,"/"));
            if(target.defaultPlatformSelected){
                args.push("-platform");
                args.push("default");
                args.push("-C");
                args.push(mTempDir.resolvePath(PLATFORM_DEFAULT_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }
            if(target.androidPlatformSelected){
                args.push("-platform");
                args.push("Android-ARM");
                args.push("-C");
                args.push(mTempDir.resolvePath(PLATFORM_ANDROID_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }

            if(target.androidx86PlatformSelected){
                args.push("-platform");
                args.push("Android-x86");
                args.push("-C");
                args.push(mTempDir.resolvePath(PLATFORM_ANDROID_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }

            if(target.iosPlatformSelected){
                args.push("-platform");
                if(target.iosExtensionUseRealDevice){
                    args.push("iPhone-ARM");
                }else{
                    args.push("iPhone-x86");
                }
                if(target.iosExtensionPlatformOptionsSelected){
                    args.push("-platformoptions");
                    args.push(target.iosExtensionPlatformOptionsFilePath);
                }
                args.push("-C");
                args.push(mTempDir.resolvePath(PLATFORM_IOS_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }

            if(target.windowsPlatformSelected){
                args.push("-platform");
                args.push("Windows-x86");
                args.push("-C");
                args.push(mTempDir.resolvePath(PLATFORM_WINDOWS_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }

            if(target.macPlatformSelected){
                args.push("-platform");
                args.push("MacOS-x86");
                args.push(mTempDir.resolvePath(PLATFORM_MAC_DIR_NAME).nativePath.replace(/\\/g,"/"));
                args.push(".");
            }

//            Console.getInstance().show("执行Java命令" + args.join(" "));

            var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            info.executable = new File(BuildManager.getInstance().javaFilePath.replace(/\\/g,"/"));
            info.arguments = args;
            start(info);

            Console.getInstance().show("正在执行打包操作,请稍候");
        }catch (e:Error){
            Console.getInstance().show("打包过程中出现错误!");
            Console.getInstance().show(e.getStackTrace());

            deleteTempDir();
        }
    }
}
}
