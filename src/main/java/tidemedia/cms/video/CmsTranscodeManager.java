package tidemedia.cms.video;


import java.lang.Thread.State;

public class CmsTranscodeManager {
	private CmsTranscode autoTranscode = null;

	public CmsTranscodeManager() {
		init();
	}

	// ��ʼ���߳�
	public void init() {
		System.out.println("start 	..");
		start();
	}

	public synchronized void start() {
		// sentcutv = new SentChaitiaoMp4();
		autoTranscode=new CmsTranscode();
		System.out.println("start CMSTranscode......");
		// �߳�δ���������߳�
		if (autoTranscode.getRunner() == null)
			autoTranscode.start();
		Thread thread = autoTranscode.getRunner();
		State state = thread.getState();
		// �߳������ڵصȴ���ֹ�߳�
		if (state == Thread.State.WAITING
				|| state == Thread.State.TIMED_WAITING)
			thread.interrupt();
	}
}
