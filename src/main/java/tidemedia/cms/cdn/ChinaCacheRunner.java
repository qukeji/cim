package tidemedia.cms.cdn;

import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Socket;

public class ChinaCacheRunner implements Runnable {

	private Thread runner;

	private String url;

	public void run() {
		//boolean forever = true;
		Thread thisThread = Thread.currentThread();
		//System.out.println("running.....");
		while (thisThread == runner) {

			try {
				//				//String lurl = "http://59.151.3.80:18080/cgi-bin/recache.sh?urls=" + url;
				//				String lurl = "http://ccms.chinacache.com/index.jsp?user=vodone&pswd=vodone123&ok=ok&urls=" + url;
				//				//System.out.println(lurl);
				//				java.net.URL l_url = new java.net.URL(lurl); 
				//				java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
				//				HttpURLConnection.setFollowRedirects(true);
				//				con.setInstanceFollowRedirects(false);
				//				con.connect(); 
				//				InputStream l_urlStream = con.getInputStream(); 
				//				java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
				//				//String sCurrentLine = "";
				//				//String sTotalString = "";
				//				while ((l_reader.readLine()) != null) 
				//				{ 
				//					//sTotalString = sCurrentLine;
				//				}
				//		
				//				l_reader.close();
				//				con.disconnect();
				String ref_urls = "urls=" + url;
				String result = ""; //存放返回的结果
				Socket socket_telnet = null;
				DataInputStream in = null;
				BufferedWriter buffered_out = null;
				String ip = "ccms.chinacache.com";
				String username = "mywtv-shuaxin1";
				String password = "ABCabc@111";
				int port = 80;

				socket_telnet = new Socket();
				InetSocketAddress isa = new InetSocketAddress(ip, port);
				socket_telnet.setSoTimeout(5000);
				socket_telnet.connect(isa, 1000);
				if (socket_telnet.isConnected()) 
				{
					in = new DataInputStream(socket_telnet.getInputStream());
					buffered_out = new BufferedWriter(new OutputStreamWriter(
							socket_telnet.getOutputStream()));
					String strDomain = "ccms.chinacache.com";
					String strFile = "/index.jsp?user="+username+"&pswd="+password+"&ok=ok&";
					String strGET = "HEAD " + strFile + ref_urls
							+ " HTTP/1.0\r\n";
					String strHost = "Host: " + strDomain + "\r\n\r\n";
					//发送命令
					buffered_out.write(strGET);
					buffered_out.write(strHost);
					buffered_out.flush();
					StringBuffer strRead = new StringBuffer(); //读取刷新结果
					for (int i = 0; i < 20; i++) {
						byte[] b_in = new byte[200];
						in.read(b_in);
						if (b_in.length > 0) {
							String strTmp = "";
							strTmp = new String(b_in);
							strRead.append(strTmp);
							if ((strRead.toString().indexOf("whatsup:") != -1)) {
								break; //有whatsup:就跳出
							}
						} else {
							System.out.println("No enough info in HTTP HEAD");
						}
					}
					String strIn = strRead.toString();

					if (strIn.contains("succeed")) //如果成功
					{
							result = "succeed"; //result 置为 succeed  返回调用程序
					} else //如果失败
					{
							result = "fail"; //result 置为 fail  返回调用程序
					}					
				} else {
					result = "Connection error";
					System.out.println(result+","+url);
				}
				
				//if(!result.equals("succeed"))
				System.out.println("CDN刷新结果:"+result+","+url);
				
				//System.out.println(url);

			} catch (Exception e) {
				runner = null;
				System.out.println("CDN刷新失败，文件：" + getUrl() + " 原因："	+ e.getMessage());
			}
			runner = null;
		}

	}

	public void Start() {
		if (runner == null) {
			//System.out.println("ChinaCacheRunner Start!");
			//setUrl(urls);
			//NoTask_BeginTime = System.currentTimeMillis();
			runner = new Thread(this);
			runner.start();
		}
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
