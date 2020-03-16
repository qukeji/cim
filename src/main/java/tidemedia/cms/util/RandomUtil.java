package tidemedia.cms.util;

import java.util.LinkedList;

public class RandomUtil {

	public static boolean debug = false;
	public static long time = 0;
	public static LinkedList<Integer> randoms = new LinkedList<Integer>();
	static int random_last = 0;
	
	//获取一个随机数
	public synchronized static int getRandom(long currenttime)
	{
		currenttime = System.currentTimeMillis() / 1000;
		int random = 0;
		
		if(currenttime==time)
		{
			/*
			//时间相同，有可能重复随机数
			boolean exist = false;
			int i = 0;
			do
			{
				exist = false;
				int bound = 999;
				if(i>10) bound = 9999;
				if(i>100) bound = 99999;
				random = new java.util.Random().nextInt(bound)+1;				
				for(Integer s:randoms){  
					if(random==s.intValue())
					{
						exist = true;
						break;
					}
		         } 
				if(debug) System.out.println("time:"+time+",exist:"+exist+","+random);
				i++;
			}while(exist);
			randoms.add(random);
			if(debug)System.out.println("time:"+time+","+i+",size:"+randoms.size());
			*/
			random = random_last + 1;
			random_last = random;
		}
		else
		{
			random = new java.util.Random().nextInt(999)+1;
			time = currenttime;
			random_last = random;
			if(randoms.size()>0) randoms.clear();
		}
		
		return random;
	}
}
