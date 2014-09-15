/**
 * Created by Administrator on 2014/8/22.
 */
package grape.packager.data {
import flash.desktop.IFilePromise;
import flash.events.ErrorEvent;
import flash.utils.ByteArray;
import flash.utils.IDataInput;

public class ConfigFilePromise implements IFilePromise {
    protected var mBytes:ByteArray = null;
    public function ConfigFilePromise (bytes:ByteArray) {
        mBytes = bytes;
    }

    public function get relativePath():String{
        return "gp_config.gpc";
    }

    public function get isAsync():Boolean{return false;}

    public function open():IDataInput{return mBytes;}

    public function reportError(event:ErrorEvent):void{}

    public function close():void{}
}
}
