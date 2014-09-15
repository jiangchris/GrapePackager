package grape.packager.filters
{
	import flash.net.FileFilter;

	/**@classname:FileFilters.as
	 * @declaration:
	 * @author:Jung
	 * @E-mail:1476324395@qq.com
	 * @QQ:1476324395
	 * @createdtime:2014-8-3*/
	public class FileFilters
	{
		public static const P12_FILE_FILTERS:Array = [new FileFilter("*.p12","*.p12")];
        public static const PROVISION_FILE_FILTERS:Array = [new FileFilter("*.mobileprovision","*.mobileprovision")];
		public static const SWC_FILE_FILTERS:Array = [new FileFilter("*.swc","*.swc")];
		public static const XML_FILE_FILTERS:Array = [new FileFilter("*.xml","*.xml")];
		public static const ANDROID_LIB_FILE_FILTERS:Array = [new FileFilter("*.jar;*.so","*.jar;*.so")];
		public static const A_FILE_FILTERS:Array = [new FileFilter("*.a","*.a")];
		public static const DLL_FILE_FILTERS:Array = [new FileFilter("*.dll","*.dll")];
		public static const GRAPE_FILE_FILTERS:Array = [new FileFilter("*.gpc","*.gpc")];
        public static const GRAPE_ANE_FILE_FILTERS:Array = [new FileFilter("*.gapc","*.gapc")];
        public static const SWF_FILE_FILTERS:Array = [new FileFilter("*.swf","*.swf")];
        public static const ANE_FILE_FILTERS:Array = [new FileFilter("*.ane","*.ane")];
	}
}
