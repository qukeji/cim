/**
 * author hailong	
 * created on 2016-7-26下午04:48:37
 */
package tidemedia.cms.publish;

import java.io.IOException;
import java.net.SocketException;
import java.sql.SQLException;
import java.util.Random;

import org.apache.commons.net.ftp.FTPClient;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.publish.PublishScheme;

/**
 * @author hailong
 *
 */
public class TestFtp implements Runnable

{
	public Thread runner = null;
	public int index =	0;
	public int ftp1=	0;
	public int ftp2=	0;
	public int ftp3=	0;
	public int ftp4= 	0;
	public boolean logout = true;
	public boolean one = true;
	

	public void Start(){
		
		if(runner==null)
		{
			runner = new Thread(this);
			runner.start();
		}
	}


	
	public void run()
	{
		FTPClient ftp = null;
		int ftpid = 0;
		try {
			int rand = new Random().nextInt(3) + 1;
			
			if(rand==1) ftpid = ftp1;
			if(rand==2) ftpid = ftp2;
			if(rand==3) ftpid = ftp3;
			ftp = ftp(ftpid);
		} catch (SQLException e1) {
			e1.printStackTrace(System.out);
			return;
		} catch (MessageException e1) {
			e1.printStackTrace(System.out);
			return;
		}
		
		for(int i=0;i<count;i++)
		{
			boolean ttt;
			try {
				ttt = ftp.changeWorkingDirectory("/2015/12/01");
				System.out.println("切换目录成功,"+index+",ftp:"+ftpid);
			} catch (IOException e) {
				System.out.println("切换目录失败,"+index+",ftp:"+ftpid);
				e.printStackTrace(System.out);
			}			
		} 
		
		if (ftp!=null && ftp.isConnected())
		{
            try {
				ftp.logout();
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace(System.out);
			}            
        }
	}

	public boolean isOne() {
		return one;
	}

	public void setOne(boolean one) {
		this.one = one;
	}

	public boolean isLogout() {
		return logout;
	}

	public void setLogout(boolean logout) {
		this.logout = logout;
	}

	public int getFtp1() {
		return ftp1;
	}

	public void setFtp1(int ftp1) {
		this.ftp1 = ftp1;
	}

	public int getFtp2() {
		return ftp2;
	}

	public void setFtp2(int ftp2) {
		this.ftp2 = ftp2;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}


	public int count = 0;
	public Thread getRunner() {
		return runner;
	}

	public void setRunner(Thread runner) {
		this.runner = runner;
	}
	
	public FTPClient ftp(int publishScheme) throws SQLException, MessageException
	{

	   FTPClient ftp = new FTPClient();	
	  String server = "";
    PublishScheme ps = new PublishScheme(publishScheme);
  	 server = ps.getServer();
  	int port = Integer.parseInt(ps.getPort());
  	String username = ps.getUsername();
  	String password = ps.getPassword();
  	int mode = ps.getFtpMode();
  	 
      if (port>0)
      {
        //int port = Util.parseInt(ps.getPort());
        ftp.setDefaultPort(port);
      }

        ftp.setBufferSize(1048576);
        ftp.setDefaultTimeout(40000);
      
        try {
			ftp.connect(server);
	        ftp.login(username, password);
	        ftp.setSoTimeout(40000);
	        
	        ftp.setConnectTimeout(40000);
	        ftp.setFileType(FTPClient.BINARY_FILE_TYPE);			
		} catch (SocketException e) {
			e.printStackTrace(System.out);
		} catch (IOException e) {
			e.printStackTrace(System.out);
		}

        if (mode == 1)
        {
      	  ftp.enterLocalPassiveMode();
     	}
        return ftp;
	}	
	
	public int getFtp3() {
		return ftp3;
	}



	public void setFtp3(int ftp3) {
		this.ftp3 = ftp3;
	}



	public int getFtp4() {
		return ftp4;
	}



	public void setFtp4(int ftp4) {
		this.ftp4 = ftp4;
	}	
}