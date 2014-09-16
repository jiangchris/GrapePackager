package grape.packager.demo;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class HelloContext extends FREContext {

	private static final String FUNCTION_SAY_HELLO = "function_say_hello";
	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction>map = new HashMap<String, FREFunction>();
		map.put(FUNCTION_SAY_HELLO, new SayHello());
		return map;
	}

}
