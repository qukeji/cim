package tidemedia.cms.util;

public class JsonUtil {

	public static String success(String s)
	{
		return "{\"status\":1,\"message\":\""+Util.JSONQuote(s)+"\"}";
	}
	
	public static String fail(String s)
	{
		return "{\"status\":0,\"message\":\""+Util.JSONQuote(s)+"\"}";
	}
}
