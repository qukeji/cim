package tidemedia.cms.test;
import java.util.Random;

import org.punit.util.ThreadUtil;

public class SampleUtil { 
	private static Random _random = new Random();
	  
	public static void consumeMemory(int length) {
		byte[] data = new byte[length];
		for(int i = 0, j = 0; i < data.length; ++i) {
		  ++j;
		}
	}

	public static void consumeTime(int time) {
		ThreadUtil.sleepIgnoreInterruption(time);
	}
	
	public static void doSomething() {
		consumeTime(Math.abs(_random.nextInt()) % 500);
		consumeMemory(Math.abs(_random.nextInt()) % 100000);
	}
}