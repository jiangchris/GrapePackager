package grape.packager.demo
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	
	/**@classname:Hello.as
	 * @declaration:
	 * @author:Jung
	 * @E-mail:1476324395@qq.com
	 * @QQ:1476324395
	 * @createdtime:2014-9-15*/
	public class Hello extends EventDispatcher
	{
		private static const FUNCTION_SAY_HELLO:String = "function_say_hello";
		
		private var extContext:ExtensionContext = null;
		public function Hello()
		{
			if(!extContext){
				extContext = ExtensionContext.createExtensionContext("grape.packager.demo","");
			}
		}
		
		public function sayHello(msg:String):String{
			return extContext.call(FUNCTION_SAY_HELLO,msg) as String;
		}
	}
}