package grape.packager.demo;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SayHello implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		FREObject result = null;
		
		String msg = "";
		try {
			msg = args[0].getAsString();
			result = FREObject.newObject(msg);
		} catch (Exception e) {
			return null;
		}
		
		return result;
	}

}
