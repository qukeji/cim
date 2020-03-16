package tidemedia.cms.util;

import java.io.PrintStream;

public class TibetUtil
  implements Runnable
{
  private String FileName = "";
  private String TempFolder = "";
  private int site = 0;
  private int Scheme = 0;

  public int getScheme()
  {
    return this.Scheme;
  }

  public void setScheme(int scheme) {
    this.Scheme = scheme;
  }

  public void run()
  {
    if (this.Scheme == 24) {
      String url = "http://139.219.8.157:888/cms/api/publishitem_api.jsp?";
      url = url + "filename=" + this.FileName + "&folder=" + this.TempFolder + "&siteid=" + 
        this.site;
      Util.connectHttpUrl(url, "utf-8");
    } else {
      System.out.println("非发送到微软云，不调用发布接口");
    }
  }

  public void Start()
  {
    Thread ThisClass = new Thread(this);
    ThisClass.start();
  }

  public String getFileName() {
    return this.FileName;
  }

  public void setFileName(String fileName) {
    this.FileName = fileName;
  }

  public String getTempFolder() {
    return this.TempFolder;
  }

  public void setTempFolder(String tempFolder) {
    this.TempFolder = tempFolder;
  }

  public int getSite() {
    return this.site;
  }

  public void setSite(int site) {
    this.site = site;
  }
}