package
{
	public class Config
	{
        /**应用程序描述*/
		public static var versionNumber:String;
		public static var description:String;
		public static var filename:String;
		public static var name:String;

		/**应用程序更新路径*/
        public static const UPDATE:String = "";

		/**ANE打包默认的AIR版本*/
        public static const DEFAULT_AIR_VERSION:String = "4.0";

		/**工程配置文件(放在用户目录)*/
		public static const RECENT_OPEN_FILE:String = ".projectConfig";

		public function Config(){}
	}
}
