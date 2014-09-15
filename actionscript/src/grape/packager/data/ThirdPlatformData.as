/**
 * Created by Jung on 2014/8/7.
 */
package grape.packager.data {

public class ThirdPlatformData {
    protected var mID:String = null;
    protected var mName:String = null;
    protected var mDescription:String = null;
    protected var mFileRes:Array = null;
    protected var mANERes:Array = null;

    public function ThirdPlatformData() {}

    public function get id():String{return mID;}
    public function set id(value:String):void{
        if(mID != value){
            mID = value;
        }
    }

    public function get name():String{return mName;}
    public function set name(value:String):void{
        if(mName != value){
            mName = value;
        }
    }

    public function get description():String{return mDescription;}
    public function set description(value:String):void{
        if(mDescription != value){
            mDescription = value;
        }
    }

    public function get fileRes():Array{return mFileRes;}
    public function set fileRes(value:Array):void{
        if(mFileRes != value){
            mFileRes = value;
        }
    }

    public function get aneRes():Array{return mANERes;}
    public function set aneRes(value:Array):void{
        if(mANERes != value){
            mANERes = value;
        }
    }
}
}
