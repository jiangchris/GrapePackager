/**
 * Created by Jung on 2014/8/14.
 */
package grape.packager.managers {
import flash.filesystem.File;

import grape.packager.data.ANEBuildTarget;

import grape.packager.data.BuildTarget;
import grape.packager.ui.Console;
import grape.packager.utils.StringUtil;

public class BuildManager {

    protected var mProjectVersionNumber:String = "0.0.0";
    protected var mProjectName:String = null;//项目名称
    protected var mProjectDescriptionPath:String = null;//项目描述文件
    protected var mProjectSWFPath:String = null;//项目SWF文件
    protected var mJavaFilePath:String = null;
    protected var mFlexSDKPath:String = null;
    protected var mAdtFilePath:String = null;
    protected var mExportPath:String = null;

    protected var mBuildTargets:Array = null;

    protected var mANEBuildTarget:ANEBuildTarget = null;

    private static var _instance:BuildManager = null;
    public function BuildManager () {

        mBuildTargets = [];

    }

    public static function getInstance():BuildManager{
        if(!_instance){
            _instance = new BuildManager();
        }
        return _instance;
    }

    public function addBuildTarget(platformId:String):Boolean{
        if(!hasBuildTarget(platformId)){
            var target:BuildTarget = new BuildTarget();
            target.platformID = platformId;
            mBuildTargets.push(target);
            return true;
        }
        return false;
    }

    public function hasBuildTarget(platformId:String):Boolean{
        var b:Boolean = false;
        //every如果数组中的所有项对指定的函数都返回 true，则为布尔值 true；否则为 false。
        b = mBuildTargets.every(function(item:BuildTarget,...rest):Boolean{
            return item.platformID != platformId;
        });
        return !b;
    }

    public function getBuildTarget(platformId:String):BuildTarget{
        for each(var item:BuildTarget in mBuildTargets){
            if(item.platformID == platformId)
                return item;
        }
        return null;
    }

    public function getActiveBuildTargets():Array{
        var arr:Array = mBuildTargets.filter(function(target:BuildTarget,...rest):Boolean{
            return (target.state == true);
        });
        return arr;
    }

    public function removeBuildTarget(platformId:String):Boolean{
        var item:BuildTarget = getBuildTarget(platformId);
        if(item){
            mBuildTargets.splice(mBuildTargets.indexOf(item),1);
            item = null;
            return true;
        }

        return false;
    }

    public function checkConfig():Boolean{
        var g:Boolean = checkGlobalConfig();
        var t:Boolean = checkTargetConfig();
        return (g && t);
    }

    protected function checkGlobalConfig ():Boolean {
        var file:File = null;
        if(StringUtil.isEmpty(mProjectName)){
            Console.getInstance().show("工程名称未指定!");
            return false;
        }

        if(StringUtil.isEmpty(mProjectDescriptionPath)){
            Console.getInstance().show("工程描述文件未指定!");
            return false;
        }
        try{
            file = new File(mProjectDescriptionPath.replace(/\\/g,"/"));
            if(!file.exists){
                Console.getInstance().show("所指定的工程描述文件不存在!");
                return false;
            }
        }catch (e:Error){
            Console.getInstance().show("所指定的工程描述文件不存在!");
            return false;
        }

        if(StringUtil.isEmpty(mProjectSWFPath)){
            Console.getInstance().show("工程SWF文件未指定!");
            return false;
        }
        try{
            file = new File(mProjectSWFPath.replace(/\\/g,"/"));
            if(!file.exists){
                Console.getInstance().show("所指定的工程SWF文件不存在!");
                return false;
            }
        }catch (e:Error){
            Console.getInstance().show("所指定的工程SWF文件不存在!");
            return false;
        }

        if (StringUtil.isEmpty (javaFilePath)) {
            Console.getInstance ().show ("Java命令文件未指定!请点击选项菜单或者使用Ctrl+I快捷键进行设置!");
            return false;
        }
        try {
            file = new File (javaFilePath.replace (/\\/g, "/"));
            if (! file.exists) {
                Console.getInstance ().show ("所指定的Java命令文件不存在!");
                return false;
            }
        } catch (e:Error) {
            Console.getInstance ().show ("所指定的Java命令文件不存在!");
            return false;
        }

        if (StringUtil.isEmpty (flexSDKPath)) {
            Console.getInstance ().show ("Flex SDK未指定!请点击选项菜单或者使用Ctrl+I快捷键进行设置!");
            return false;
        }
        try {
            file = new File (flexSDKPath.replace (/\\/g, "/"));
            if (! file.exists) {
                Console.getInstance ().show ("所指定的Flex SDK不存在!");
                return false;
            }
        } catch (e:Error) {
            Console.getInstance ().show ("所指定的Flex SDK不存在!");
            return false;
        }

        try {
            file = file.resolvePath ("lib/adt.jar");
            if (! file.exists) {
                Console.getInstance ().show ("所指定的Flex SDK已经损坏!");
                return false;
            }else{
                adtFilePath = file.nativePath.replace(/\\/g,"/");
            }
        } catch (e:Error) {
            Console.getInstance ().show ("所指定的Flex SDK已经损坏!");
            return false;
        }

        if (StringUtil.isEmpty (mExportPath)) {
            Console.getInstance ().show ("导出路径未指定!");
            return false;
        }
        try {
            file = new File (mExportPath.replace (/\\/g, "/"));
            if (! file.exists) {
                Console.getInstance ().show ("所指定的导出路径不存在!");
                return false;
            }
        } catch (e:Error) {
            Console.getInstance ().show ("所指定的导出路径不存在!");
            return false;
        }
        return true;
    }

    protected function checkTargetConfig():Boolean{
        var b:Boolean = mBuildTargets.every(function(target:BuildTarget,...rest):Boolean{
            return checkTarget(target) == true;
        });
        return b;
    }

    protected function checkTarget(target:BuildTarget):Boolean{
        var file:File = null;
        if(StringUtil.isEmpty(target.certificatePath)){
            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                Console.getInstance ().show ("Android平台证书未指定!");
            }else if(target.platformID == BuildTarget.PLATFORM_IOS){
                Console.getInstance ().show ("iOS平台证书未指定!");
            }
            return false;
        }
        try{
            file = new File(target.certificatePath.replace(/\\/g,"/"));
            if(!file.exists){
                if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                    Console.getInstance ().show ("所指定的Android平台证书不存在!");
                }else if(target.platformID == BuildTarget.PLATFORM_IOS){
                    Console.getInstance ().show ("所指定的iOS平台证书未指定!");
                }
            }
        }catch (e:Error){
            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                Console.getInstance ().show ("Android平台证书未指定!");
            }else if(target.platformID == BuildTarget.PLATFORM_IOS){
                Console.getInstance ().show ("iOS平台证书未指定!");
            }
        }

        if(StringUtil.isEmpty(target.certificatePassword)){
            if(target.platformID == BuildTarget.PLATFORM_ANDROID){
                Console.getInstance ().show ("Android平台证书密码未指定!");
            }else if(target.platformID == BuildTarget.PLATFORM_IOS){
                Console.getInstance ().show ("iOS平台证书密码未指定!");
            }
            return false;
        }

        if(target.platformID == BuildTarget.PLATFORM_IOS){
            if(StringUtil.isEmpty(target.provisioningFilePath)){
                Console.getInstance ().show ("iOS平台配置文件未指定!");
                return false;
            }
            try{
                file = new File(target.provisioningFilePath.replace(/\\/g,"/"));
                if(!file.exists){
                    Console.getInstance ().show ("所指定的iOS平台配置文件不存在!");
                }
            }catch (e:Error){
                Console.getInstance ().show ("所指定的iOS平台配置文件不存在!");
            }
        }
        return true;
    }

    public function getConfigData():Object{
        var data:Object = new Object();
        data["projectName"] = mProjectName;
        data["projectDescriptionPath"] = mProjectDescriptionPath;
        data["projectSWFPath"] = mProjectSWFPath;
        data["javaFilePath"] = mJavaFilePath;
        data["flexSDKPath"] = mFlexSDKPath;
        data["adtFilePath"] = mAdtFilePath;
        data["exportPath"] = mExportPath;
        data["buildTargets"] = mBuildTargets;

        data["aneBuildTarget"] = aneBuildTarget;
        return data;
    }

    public function setConfigData(data:Object):void{
        mProjectName = data["projectName"];
        mProjectDescriptionPath = data["projectDescriptionPath"];
        mProjectSWFPath = data["projectSWFPath"];
        mJavaFilePath = data["javaFilePath"];
        mFlexSDKPath = data["flexSDKPath"];
        mAdtFilePath = data["adtFilePath"];
        mExportPath = data["exportPath"];
        var temp:Array = data["buildTargets"] as Array;
        mBuildTargets.splice(0,mBuildTargets.length);
        var buildTarget:BuildTarget = null;
        for(var i:int = 0;i < temp.length;i++){
            buildTarget = new BuildTarget();
            for(var key:String in temp[i]){
                buildTarget[key] = temp[i][key]  ;
            }
            mBuildTargets.push(buildTarget);
        }

        for(var k:String in data["aneBuildTarget"]){
            aneBuildTarget[k] =data["aneBuildTarget"][k];
        }
    }

    public function get adtFilePath():String{return mAdtFilePath;}
    public function set adtFilePath(value:String):void{
        if(mAdtFilePath != value){
            mAdtFilePath = value;
        }
    }

    public function get javaFilePath():String{return mJavaFilePath;}
    public function set javaFilePath(value:String):void{
        if(mJavaFilePath != value){
            mJavaFilePath = value;
        }
    }

    public function get flexSDKPath():String{return mFlexSDKPath;}
    public function set flexSDKPath(value:String):void{
        if(mFlexSDKPath != value){
            mFlexSDKPath = value;
        }
    }

    public function get projectDescriptionPath():String{return mProjectDescriptionPath;}
    public function set projectDescriptionPath(value:String):void{
        if(mProjectDescriptionPath != value){
            mProjectDescriptionPath = value;
        }
    }

    public function get projectSWFPath():String{return mProjectSWFPath;}
    public function set projectSWFPath(value:String):void{
        if(mProjectSWFPath != value){
            mProjectSWFPath = value;
        }
    }

    public function get projectName():String{return mProjectName;}
    public function set projectName(value:String):void{
        if(mProjectName != value){
            mProjectName = value;
        }
    }

    public function get exportPath():String{return mExportPath;}
    public function set exportPath(value:String):void{
        if(mExportPath != value){
            mExportPath = value;
        }
    }

    public function get projectVersionNumber():String{return mProjectVersionNumber;}
    public function set projectVersionNumber(value:String):void{
        if(mProjectVersionNumber != value){
            mProjectVersionNumber = value;
        }
    }

    public function get aneBuildTarget():ANEBuildTarget{
        if(!mANEBuildTarget){
            mANEBuildTarget = new ANEBuildTarget();
        }
        return mANEBuildTarget;
    }
    public function set aneBuildTarget(value:ANEBuildTarget):void{
        if(mANEBuildTarget != value){
            mANEBuildTarget = value;
        }
    }
}
}
