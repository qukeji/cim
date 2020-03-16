package tidemedia.cms.test;

import org.punit.runner.ConcurrentRunner;
import org.punit.runner.SoloRunner;

public class punit {
	public static void main(String[] args) {
		new SoloRunner().run(SimpleTestClass.class);
	}
}
