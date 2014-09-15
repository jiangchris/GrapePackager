/**
 * Created by Administrator on 2014/8/14.
 */
package grape.packager.process {
import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.IOErrorEvent;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;

import grape.packager.data.BuildTarget;
import grape.packager.data.ThirdPlatformData;

import grape.packager.events.ProcessEvent;
import grape.packager.managers.BuildManager;
import grape.packager.managers.ThirdPlatformManager;

import grape.packager.ui.Console;
import grape.packager.utils.TimeUtil;

import mx.formatters.DateFormatter;

/**
 * 打包完成事件
 */
[Event(name="COMPLETED",type="flash.events.Event")]
public class BuildProcess extends NativeProcess {

    protected static const ANE_TEMP_DIR:String = "ANEs";
    protected static const PLATFORM_TEMP_DIR:String = "Platforms";

    protected var mTempDir:File = null;//临时工作目录

    protected var mBuildQueue:Array = [];//编译队列

    public function BuildProcess () {
        super ();
        addEventListener(NativeProcessExitEvent.EXIT,onExit);
	    addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,function(event:ProgressEvent):void{
		    Console.getInstance().show(standardOutput.readUTFBytes(standardOutput.bytesAvailable));
	    });

	    addEventListener(ProgressEvent.STANDARD_ERROR_DATA,function(event:ProgressEvent):void{
//		    Console.getInstance().show(standardError.readUTFBytes(standardError.bytesAvailable));
	    });

	    addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, function(event:IOErrorEvent):void{
//		    Console.getInstance().show(event.toString());
	    });
	    addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, function(event:IOErrorEvent):void{
//		    Console.getInstance().show(event.toString());
	    });
    }

    protected function onExit(event:NativeProcessExitEvent):void{
//        Console.getInstance().show("结果代码："+event.exitCode);

        switch(event.exitCode)
        {
            case 0:
                Console.getInstance().show("打包完成");
                break;
            case 100:
                Console.getInstance().show("无法分析应用程序描述符");
                break;
            case 101:
                Console.getInstance().show("缺少命名空间");
                break;
            case 102:
                Console.getInstance().show("命名空间无效");
                break;
            case 103:
                Console.getInstance().show("意外的元素或属性：\n1.删除引起错误的元素和属性。描述符文件中不允许使用自定义值。\n" +
                        "2.检查元素和属性名称的拼写。\n" +
                        "3.确保将元素放置在正确的父元素内，且使用属性时对应着正确的元素。");
                break;
            case 104:
                Console.getInstance().show("缺少元素或属性");
                break;
            case 105:
                Console.getInstance().show("元素或属性所含的某个值无效");
                break;
            case 106:
                Console.getInstance().show("窗口属性组合非法");
                break;
            case 107:
                Console.getInstance().show("窗口最小大小大于窗口最大大小");
                break;
            case 108:
                Console.getInstance().show("前面的元素中已使用的属性");
                break;
            case 109:
                Console.getInstance().show("重复元素");
                break;
            case 110:
                Console.getInstance().show("至少需要一个指定类型的元素");
                break;
            case 111:
                Console.getInstance().show("在应用程序描述符中列出的配置文件都不支持本机扩展，将配置文件添加到支持 本机扩展的 supportedProfies 列表。");
                break;
            case 112:
                Console.getInstance().show("AIR 目标不支持本机扩展，选择支持本机扩展的目标。");
                break;
            case 113:
                Console.getInstance().show("<nativeLibrary> 和 <initializer> 必须一起提供，必须为本机扩展中的每个本机库都指定初始值设定项函数。");
                break;
            case 114:
                Console.getInstance().show("找到不含 <nativeLibrary> 的 <finalizer>，除非平台使用本机库，否则不要指定终结器。");
                break;
            case 115:
                Console.getInstance().show("默认平台不得包含本机实施。");
                break;
            case 116:
                Console.getInstance().show("此目标不支持浏览器调用，对于指定的打包目标，<allowBrowserInvocation> 元素不能为 true。");
                break;
            case 117:
                Console.getInstance().show("此目标至少需要命名空间 n 打包本机扩展。");
                break;
            case 200:
                Console.getInstance().show("无法打开图标文件");
                break;
            case 201:
                Console.getInstance().show("图标大小错误");
                break;
            case 202:
                Console.getInstance().show("图标文件包含的某种图像格式不受支持");
                break;
            case 300:
                Console.getInstance().show("缺少文件，或无法打开文件");
                break;
            case 301:
                Console.getInstance().show("缺少或无法打开应用程序描述符文件");
                break;
            case 302:
                Console.getInstance().show("包中缺少根内容文件");
                break;
            case 303:
                Console.getInstance().show("包中缺少图标文件");
                break;
            case 304:
                Console.getInstance().show("初始窗口内容无效");
                break;
            case 305:
                Console.getInstance().show("初始窗口内容的 SWF 版本超出命名空间的版本");
                break;
            case 306:
                Console.getInstance().show("配置文件不受支持");
                break;
            case 307:
                Console.getInstance().show("命名空间必须至少为 nnn");
                break;
            case 2:
                Console.getInstance().show("用法错误，检查命令行参数是否存在错误");
                break;
            case 5:
                Console.getInstance().show("未知错误，此错误表示所发生的情况无法按常见的错误条件作出解释。可能的根源包括 ADT 与 Java 运行时环境之间不兼容、ADT 或 JRE 安装损坏以及 ADT 内有编程错误。");
                break;
            case 6:
                Console.getInstance().show("无法写入输出目录，确保指定的（或隐含的）输出目录可访问，并且所在驱动器有足够的磁盘空间。");
                break;
            case 7:
                Console.getInstance().show("无法访问证书");
                break;
            case 8:
                Console.getInstance().show("证书无效，证书文件格式错误、被修改、已到期或被撤消。");
                break;
            case 9:
                Console.getInstance().show("无法为 AIR 文件签名，验证传递给 ADT 的签名选项。");
                break;
            case 10:
                Console.getInstance().show("无法创建时间戳，ADT 无法与时间戳服务器建立连接。如果通过代理服务器连接到 Internet，则可能需要配置 JRE 的代理服务器设置。");
                break;
            case 11:
                Console.getInstance().show("创建证书时出错");
                break;
            case 12:
                Console.getInstance().show("输入无效，验证命令行中传递给 ADT 的文件路径和其他参数。");
                break;
            case 13:
                Console.getInstance().show("缺少设备 SDK，验证设备 SDK 配置。ADT 找不到执行指定命令所需的设备 SDK。");
                break;
            case 14:
                Console.getInstance().show("设备错误，ADT 无法执行命令，因为存在设备限制或设备问题。例如，在尝试卸载未实际安装的应用程序时会显示此退出代码。");
                break;
            case 15:
                Console.getInstance().show("无设备，验证设备是否已连接且已开启，或仿真器是否正在运行。");
                break;
            case 16:
                Console.getInstance().show("缺少 GPL 组件，当前的 AIR SDK 未包含执行请求的操作所需的所有组件。");
                break;
            case 17:
                Console.getInstance().show("设备打包工具失败，由于缺少预期的操作系统组件，因此无法创建包。");
                break;
            case 400:
                Console.getInstance().show("当前的 Android sdk 版本不支持属性，检查属性名称的拼写是否正确，以及对于在其中出现的元素是否为有效的属性。如果此属性是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");
                break;
            case 401:
                Console.getInstance().show("当前的 Android sdk 版本不支持属性值，检查属性值的拼写是否正确，以及对于该属性是否为有效的值。如果此属性值是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");
                break;
            case 402:
                Console.getInstance().show("当前的 Android sdk 版本不支持 XML 标签，检查 XML 标签名称的拼写是否正确，以及是否为有效的 Android 清单文档元素。如果此元素是在 Android 2.2 之后新增的，您可能需要在 ADT 命令中设置 -platformsdk 标志。");
                break;
            case 403:
                Console.getInstance().show("不允许覆盖 Android 标签");
                break;
            case 404:
                Console.getInstance().show("不允许覆盖 Android 属性");
                break;
            case 405:
                Console.getInstance().show("Android 标签 %1 必须是 manifestAdditions 标签中的第一个元素");
                break;
            case 406:
                Console.getInstance().show("Android 标签 %2 的属性 %1 具有无效值 %3。");
                break;
            case 1000:
                Console.getInstance().show("参数太少!");
                break;
            case 1001:
                Console.getInstance().show("创建进程失败!");
                break;
        }

        if (event.exitCode != 0){
            Console.getInstance().show("打包失败!请检查配置!");
        }

        deleteTempDir();

        if(mBuildQueue.length > 0){
            build(mBuildQueue.pop());
        }else{
            dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETED,true,false));
        }
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

    public function StartBuildTarget():void{
        mBuildQueue = BuildManager.getInstance().getActiveBuildTargets();
        if(mBuildQueue.length > 0){
            build(mBuildQueue.pop());
        }
    }

    private function build(target:BuildTarget):void{
        try{

            Console.getInstance().show("开始针对" + target.platformID + "打包!");

            Console.getInstance().show("创建临时工作目录");
            mTempDir = File.createTempDirectory();

            var attachmentsArray:Array = null;
            var fileAttachment:File = null;
            var anesDir:File = mTempDir.resolvePath(ANE_TEMP_DIR);
            var i:int = 0;
            var thirdPlatformData:ThirdPlatformData = null;

            if(target.anesSelected){
                attachmentsArray = target.anes.split(';');
                for(i = 0;i < attachmentsArray.length;i++){
                    try{
                        fileAttachment = new File(attachmentsArray[i].replace(/\\/g,"/"));
                        if(fileAttachment.exists){
                             fileAttachment.copyTo(anesDir.resolvePath(fileAttachment.name),true);
                        }else{
                            Console.getInstance().show(fileAttachment.name + "文件不存在!");
                        }
                    }catch (e:Error){
                        Console.getInstance().show(fileAttachment.name + "文件不存在!");
                    }
                }
            }

            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                if(target.thirdPlatformSelected){
                    thirdPlatformData = ThirdPlatformManager.getPlatformData(target.thirdPlatformID);
                    if(thirdPlatformData){
                        attachmentsArray = thirdPlatformData.aneRes;
                        for(i = 0;i < attachmentsArray.length;i++){
                            try{
                                if(fileAttachment.exists){
                                    fileAttachment.copyTo(anesDir.resolvePath(fileAttachment.name),true);
                                }else{
                                    Console.getInstance().show(fileAttachment.name + "文件不存在!");
                                }
                            }catch (e:Error){
                                Console.getInstance().show(fileAttachment.name + "文件不存在!");
                            }
                        }
                    }
                }
            }

            if(target.packageAttachmentsSelected){
                attachmentsArray = target.packageAttachments.split(';');
                for(i = 0;i < attachmentsArray.length;i++){
                    fileAttachment = new File(attachmentsArray[i].replace(/\\/g,"/"));
                }
            }


            var args:Vector.<String> = new <String>[];
            args.push("-jar");
            args.push(BuildManager.getInstance().adtFilePath.replace(/\\/g,"/"));
            args.push("-package");
            args.push("-target");
            args.push(target.releasePackageType);
            if(target.platformID == BuildTarget.PLATFORM_IOS){
                args.push("-hideAneLibSymbols");
                args.push("no");
                args.push("-useLegacyAOT");
                args.push("no");
                args.push("-provisioning-profile");
                args.push(target.provisioningFilePath.replace(/\\/g,"/"));
            }
            args.push("-storetype");
            args.push("PKCS12");
            args.push("-keystore");
            args.push(target.certificatePath.replace(/\\/g,"/"));
            if(target.useTimestamp){
                args.push("-tsa");
                args.push("none");
            }
            args.push("-storepass");
            args.push(target.certificatePassword);
            var exportFile:File = null;
            var projectSWFFile:File = null;
            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                exportFile = new File(BuildManager.getInstance().exportPath.replace(/\\/g,"/") + "/" + BuildManager.getInstance().projectName + TimeUtil.getCurrentTime() + ".apk");
            }else if(target.platformID == BuildTarget.PLATFORM_IOS){
                exportFile = new File(BuildManager.getInstance().exportPath.replace(/\\/g,"/") + "/" + BuildManager.getInstance().projectName + TimeUtil.getCurrentTime() + ".ipa");
            }
            args.push(exportFile.nativePath.replace(/\\/g,"/"));
            args.push(BuildManager.getInstance().projectDescriptionPath.replace(/\\/g,"/"));
            args.push("-C");
            projectSWFFile = new File(BuildManager.getInstance().projectSWFPath.replace(/\\/g,"//"));
            args.push(projectSWFFile.parent.nativePath.replace(/\\/g,"/"));
            args.push(projectSWFFile.name);

            if(target.packageAttachmentsSelected){
                attachmentsArray = target.packageAttachments.split(';');
                for(i = 0;i < attachmentsArray.length;i++){
                    try{
                        fileAttachment = new File(attachmentsArray[i].replace(/\\/g,"/"));
                        if(fileAttachment.exists){
                            if(fileAttachment.isDirectory){
                                args.push("-C");
                                args.push(fileAttachment.parent.nativePath.replace(/\\/g,"/"));
                            }
                            args.push(fileAttachment.name);
                        }else{
                            Console.getInstance().show(fileAttachment.name + "文件不存在!");
                        }
                    }catch (e:Error){
                        Console.getInstance().show(fileAttachment.name + "文件不存在!");
                    }
                }
            }

            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                if(target.thirdPlatformSelected){
                    thirdPlatformData = ThirdPlatformManager.getPlatformData(target.thirdPlatformID);
                    if(thirdPlatformData){
                        attachmentsArray = thirdPlatformData.fileRes;
                        for(i = 0;i < attachmentsArray.length;i++){
                            try{
                                fileAttachment = File.applicationDirectory.resolvePath(attachmentsArray[i].url.replace(/\\/g,"//"));
                                if(fileAttachment.exists){
                                    if(fileAttachment.isDirectory){
                                        args.push("-C");
                                        args.push(fileAttachment.parent.nativePath.replace(/\\/g,"/"));
                                        args.push(fileAttachment.name);
                                    }
                                    else{
                                        args.push(fileAttachment.nativePath.replace(/\\/g,"/"));
                                    }
                                }else{
                                    Console.getInstance().show(fileAttachment.name + "文件不存在!");
                                }
                            }catch (e:Error){
                                Console.getInstance().show(fileAttachment.name + "文件不存在!");
                            }
                        }
                    }
                }
            }


            if(target.anesSelected){
                args.push("-extdir");
                args.push(anesDir.nativePath.replace(/\\/g,"/"));
            }else{
                if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                    if(target.thirdPlatformSelected){
                        thirdPlatformData = ThirdPlatformManager.getPlatformData(target.thirdPlatformID);
                        if(thirdPlatformData.aneRes.length > 0){
                            args.push("-extdir");
                            args.push(anesDir.nativePath.replace(/\\/g,"/"));
                        }
                    }
                }
            }

//            Console.getInstance().show(args.join(" "));

            var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            info.executable = new File(BuildManager.getInstance().javaFilePath.replace(/\\/g,"/"));
            info.arguments = args;
            start(info);

            Console.getInstance().show("正在执行打包,请稍后...");
        }catch (e:Error){
            Console.getInstance().show("打包过程中出现错误!");
            Console.getInstance().show(e.getStackTrace());
            deleteTempDir();
        }
    }
}
}
