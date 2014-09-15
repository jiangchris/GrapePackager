package grape.packager.utils
{
	public class StringUtil
	{
		public function StringUtil(){}

        /**字符串判空*/
		public static function isEmpty(str:String):Boolean{
			return (str == null || str == "");
		}
	}
}