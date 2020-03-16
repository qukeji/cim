package tidemedia.cms.publish;

import org.apache.commons.net.ftp.FTPClient;

import java.io.IOException;

public class TideFtpClient {
	public int publish_scheme_id = 0;//发布方案编号
	

	private boolean used = false;//是否在使用
	private long last_use_time = 0;//最后使用时间
	
	private FTPClient ftp = null;//FtpClient对象
	private String message = "";//保存错误信息
	
	public FTPClient getFtp() {
		return ftp;
	}
	
	public void setFtp(FTPClient ftp) {
		this.ftp = ftp;
	}

	public int getPublish_scheme_id() {
		return publish_scheme_id;
	}
	public void setPublish_scheme_id(int publish_scheme_id) {
		this.publish_scheme_id = publish_scheme_id;
	}
	public boolean isUsed() {
		return used;
	}
	public void setUsed(boolean u) {
		setLast_use_time(System.currentTimeMillis());
		this.used = u;
		
		//2016.11.7 不再使用ftp
		if(!u)
		{
			try {
				if (ftp != null && ftp.isConnected()) {
					ftp.logout();
				}
			} catch (IOException io) {
				io.printStackTrace(System.out);
			} finally {
				// 注意,一定要在finally代码中断开连接，否则会导致占用ftp连接情况
				try {
					if(ftp!=null) ftp.disconnect();
				} catch (Exception io) {
					io.printStackTrace(System.out);
				}
			}
			
			ftp = null;
		}
	}
	public long getLast_use_time() {
		return last_use_time;
	}
	public void setLast_use_time(long last_use_time) {
		this.last_use_time = last_use_time;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
