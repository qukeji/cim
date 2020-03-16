package tidemedia.cms.video;


import java.lang.Thread.State;

public class CmsTranscodeManager {
	private CmsTranscode autoTranscode = null;

	public CmsTranscodeManager() {
		init();
	}

	// 初始化线程
	public void init() {
		System.out.println("start 	..");
		start();
	}

	public synchronized void start() {
		// sentcutv = new SentChaitiaoMp4();
		autoTranscode=new CmsTranscode();
		System.out.println("start CMSTranscode......");
		// 线程未启动开启线程
		if (autoTranscode.getRunner() == null)
			autoTranscode.start();
		Thread thread = autoTranscode.getRunner();
		State state = thread.getState();
		// 线程无限期地等待终止线程
		if (state == Thread.State.WAITING
				|| state == Thread.State.TIMED_WAITING)
			thread.interrupt();
	}
}
