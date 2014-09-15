/**
 * Created by Jung on 2014/8/14.
 */
package grape.packager.data {
public class BuildTarget {

    public static const PLATFORM_ANDROID:String = "grape.packager.multiplatform.android.platform";
    public static const PLATFORM_IOS:String = "grape.packager.multiplatform.ios.platform";

    protected var mBuildTargetName:String = null;
    protected var mPlatformID:String = null;//Android or iOS
    protected var mThirdPlatformID:String = null;//接入第三方平台ID
    protected var mThirdPlatformSelected:Boolean = false;//是否接入第三方平台
    protected var mReleasePackageType:String = null;//发行版包类型
    protected var mBuildTargetState:Boolean = false;//该BuildTarget的激活状态

    //Air设置
    protected var mCertificatePath:String = null;//证书路径
    protected var mCertificatePassword:String = null;//证书密码
    protected var mUseTimestamp:Boolean = false;//使用时间戳
    protected var mPackageAttachments:String = null;//添加到包的文件
    protected var mPackageAttachmentsSelected:Boolean = false;//是否添加包文件
    protected var mANESSelected:Boolean = false;
    protected var mANES:String = null;

    //针对IOS平台配置
    protected var mProvisioningFilePath:String = null;//ProvisioningFile文件路径
    protected var mHideANELibSymbols:String = "no";
    protected var mUseLegacyAOT:String = "no";


    //针对Android平台设置

    public function BuildTarget () {}

    public function get buildTargetName():String{return mBuildTargetName;}
    public function set buildTargetName(value:String):void{
        if(mBuildTargetName != value){
            mBuildTargetName = value;
        }
    }

    public function get platformID():String{return mPlatformID;}
    public function set platformID(value:String):void{
        if(mPlatformID != value){
            mPlatformID = value;
        }
    }

    public function get thirdPlatformID():String{return mThirdPlatformID;}
    public function set thirdPlatformID(value:String):void{
        if(mThirdPlatformID != value){
            mThirdPlatformID = value;
        }
    }

    public function get thirdPlatformSelected():Boolean{return mThirdPlatformSelected;}
    public function set thirdPlatformSelected(value:Boolean):void{
        if(mThirdPlatformSelected != value){
            mThirdPlatformSelected = value;
        }
    }

    public function get releasePackageType():String{return mReleasePackageType;}
    public function set releasePackageType(value:String):void{
        if(mReleasePackageType != value){
            mReleasePackageType = value;
        }
    }

    public function get state():Boolean{return mBuildTargetState;}
    public function set state(value:Boolean):void{
        if(mBuildTargetState != value){
            mBuildTargetState = value;
        }
    }

    public function get certificatePath():String{return mCertificatePath;}
    public function set certificatePath(value:String):void{
        if(mCertificatePath != value){
            mCertificatePath = value;
        }
    }

    public function get certificatePassword():String{return mCertificatePassword;}
    public function set certificatePassword(value:String):void{
        if(mCertificatePassword != value){
            mCertificatePassword = value;
        }
    }

    public function get useTimestamp():Boolean{return mUseTimestamp;}
    public function set useTimestamp(value:Boolean):void{
        if(mUseTimestamp != value){
            mUseTimestamp = value;
        }
    }

    public function get packageAttachments():String{return mPackageAttachments;}
    public function set packageAttachments(value:String):void{
        if(mPackageAttachments != value){
            mPackageAttachments = value;
        }
    }

    public function get packageAttachmentsSelected():Boolean{return mPackageAttachmentsSelected;}
    public function set packageAttachmentsSelected(value:Boolean):void{
        if(mPackageAttachmentsSelected != value){
            mPackageAttachmentsSelected = value;
        }
    }

    public function get anesSelected():Boolean{return mANESSelected;}
    public function set anesSelected(value:Boolean):void{
        if(mANESSelected != value){
            mANESSelected = value;
        }
    }

    public function get anes():String{return mANES;}
    public function set anes(value:String):void{
        if(mANES != value){
            mANES = value;
        }
    }

    //=======================iOS======================
    public function get provisioningFilePath():String{return mProvisioningFilePath;}
    public function set provisioningFilePath(value:String):void{
        if(mProvisioningFilePath != value){
            mProvisioningFilePath = value;
        }
    }

    //==============================Android=================
}
}
