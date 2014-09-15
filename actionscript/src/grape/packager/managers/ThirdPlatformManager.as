/**
 * Created by Administrator on 2014/8/7.
 */
package grape.packager.managers {
import flash.utils.Dictionary;

import grape.packager.data.ThirdPlatformData;
import grape.packager.ui.Console;

import mx.collections.ArrayList;

public class ThirdPlatformManager {


    protected static var mPlatforms:Dictionary = new Dictionary();

    public function ThirdPlatformManager() {
    }

    public static function Init(data:String):void{
        try{
            var config:XML = new XML(data);
            parseConfig(config);
        }catch (e:Error){
            Console.getInstance().show(e.getStackTrace());
        }
    }

    protected static function parseConfig(config:XML):void{
        var platform:XML = null;
        var file:XML = null;
        var fileObj:Object = null;
        var ane:XML = null;
        var data:ThirdPlatformData = null;
        var fileRes:Array = null;
        var aneRes:Array = null;
        for each(platform in config.elements("platform")){
            data = new ThirdPlatformData();
            data.id = platform.@id.toString();
            data.name = platform.@name.toString();
            data.description = platform.@description.toString();

            fileRes = new Array();
            for each(file in platform.elements("files").elements("file")){
                fileObj = new Object();
                fileObj.url = file.@url.toString();
                fileObj.name = file.@name.toString();
                fileRes.push(fileObj);
            }
            data.fileRes = fileRes;

            aneRes = new Array();
            for each(ane in platform.elements("anes").elements("ane")){
                aneRes.push(ane.@url.toString());
            }
            data.aneRes = aneRes;

            if(mPlatforms[data.id] == null){
                mPlatforms[data.id] = data;
            }
        }
    }

    public static function getPlatformData(id:String):ThirdPlatformData{
        if(id && id != ""){
            if(mPlatforms[id] != null){
                return mPlatforms[id];
            }
        }
        return null;
    }

    public static function add(data:ThirdPlatformData):void{
        if(mPlatforms[data.id] == null){
            mPlatforms[data.id] = data;
        }
    }

    public static function remove(id:String):void{
        if(mPlatforms[id] != null){
            delete mPlatforms[id];
        }
    }

    public static function removeAll():void{
        for(var key:String in mPlatforms){
            remove(key);
        }
    }

    public static function getAllPlatformsID():ArrayList{
        var al:ArrayList = new ArrayList();
        for(var id:String in mPlatforms){
            al.addItem(id);
        }
        return al;
    }

    public static function toXMLString():String{
        var xml:String = "<platforms>";
        for each(var data:ThirdPlatformData in mPlatforms){
            xml += "<platform name='" + data.name + "' id='" + data.id + "' description='" + data.description + "'>";
            xml += "<files>";
            for(var i:int = 0;i < data.fileRes.length;i++){
                xml += "<file url='" + data.fileRes[i].url + "' name='" + data.fileRes[i].name + "'/>";
            }
            xml += "</files>";
            xml += "<anes>";
            for(var j:int = 0;i < data.aneRes.length;j++){
                xml += "<ane url='" + data.aneRes[i].url + "'/>";
            }
            xml += "</anes>";
            xml += "</platform>";
        }
        return xml;
    }

    public static function SaveConfig():void{

    }
}
}
