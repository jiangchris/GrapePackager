/**
 * Created by Jung on 2014/8/27.
 */
package grape.packager.managers {
import flash.filesystem.File;

public class FileManager {

    protected var mRecentOpenFileList:Array = null;

    protected static var _instance:FileManager = null;
    public function FileManager () {
        mRecentOpenFileList = [
	        new File("C:\\Users\\Administrator\\Desktop\\grabgirl.gpc"),
	        new File("C:\\Users\\Administrator\\Desktop\\gp_config22.gpc"),
	        new File("C:\\Users\\Administrator\\Desktop\\simulatorqh360.gpc")
        ];
    }

    public static function getInstance():FileManager{
        if(_instance == null){
            _instance = new FileManager();
        }
        return _instance;
    }

	public function get recentOpenFileList():Array{return mRecentOpenFileList;}
}
}
