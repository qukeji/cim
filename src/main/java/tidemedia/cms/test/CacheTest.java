package tidemedia.cms.test;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Random;

public class CacheTest {

	public static void main(String[] args)
	{
		String s = "中国장나라, 웃음으로 스스로 성장한 그녀(번역), 2010-03-03, 관리자. 축하해주셔서 감사드립니다~ 사진추가, 2010-02-20, 관리자. 내일 졸업식 공지입니다";
		System.out.println(s);
		
		print("最大的内存为："+Runtime.getRuntime().maxMemory()/1024);
		print("总的内存为："+Runtime.getRuntime().totalMemory()/1024);
		long currMemory=Runtime.getRuntime().freeMemory();
		print("目前可用的内存为："+currMemory/1024);
		HashMap h = new HashMap();
		
		long a = System.currentTimeMillis();
		for(int n=0;n<1000000;n++)
		{
		//Element e = new Element(String.valueOf(n), "blah.....blah... 100 chars...");
	    //cache.put(n,);
			h.put(n+"", "abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij");
		}
		long b = System.currentTimeMillis();
		System.out.println((b-a));		//100万 用时2469毫秒(key为int) 3813毫秒(用string作key)
		
		a = System.currentTimeMillis();
		for(int n=0;n<1000000;n++)
		{
			int m = new java.util.Random().nextInt(1000000);
			String str = (String)h.get(m+"");
		}
		b = System.currentTimeMillis();
		System.out.println((b-a));
		//100万 读取用时2969毫秒(用int做key) 4109(用string做key)
		
		h = null;
		
		Hashtable hh = new Hashtable();
		
		long aa = System.currentTimeMillis();
		for(int n=0;n<1000000;n++)
		{
		//Element e = new Element(String.valueOf(n), "blah.....blah... 100 chars...");
	    //cache.put(n,);
			hh.put(n+"", "abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij");
		}
		long bb = System.currentTimeMillis();
		System.out.println((bb-aa));//100万 加入用时625毫秒(用int做key) 1922(用string做key)
		
		a = System.currentTimeMillis();
		for(int n=0;n<1000000;n++)
		{
			int m = new java.util.Random().nextInt(1000000);
			String str = (String)hh.get(m+"");
		}
		b = System.currentTimeMillis();
		System.out.println((b-a));	
		//100万 读取用时2937毫秒(用int做key) 3484(用string做key)
		
		long tempMemory=Runtime.getRuntime().freeMemory();
		print("目前可用的内存为："+tempMemory/1024);
	}
	
	private static void print(String msg){
		System.out.println(msg);
	}	
}
