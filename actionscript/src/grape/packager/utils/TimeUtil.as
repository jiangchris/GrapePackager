/**
 * Created by Administrator on 2014/8/20.
 */
package grape.packager.utils {
import mx.formatters.DateFormatter;

public class TimeUtil {
    public function TimeUtil () {
    }

    public static function getCurrentTime(formatString:String = "YYYYMMDDHHNNSS"):String{
        var df:DateFormatter = new DateFormatter()
        df.formatString = formatString;
        return df.format(new Date());
    }
}
}
