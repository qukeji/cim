package tidemedia.cms.video;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.Util;

public class CmsTranscode implements Runnable {

	private Thread runner;
	public int defaultBitrate = 400;
	public String ffmpegPath = "/usr/bin/ffmpeg";
	public String video_dest = "/video_dest/";

	public Thread getRunner() {
		return runner;
	}

	public void start() {
		if (this.runner == null) {
			runner = new Thread(this);
			runner.start();
		}
		System.out.println("this runner" + runner);
	}

	@Override
	public void run() {
		Thread thread = Thread.currentThread();
		while (thread == this.runner) {
			try {
				boolean ValidFlag = CmsCache.hasValidLicense();
				// System.out.println("授权是否存在问题"+ValidFlag);
				if (ValidFlag) {
					Thread.sleep(30000);
					checkTranscode();

				}
			} catch (MessageException e) {
				Log.SystemLog("CMS自动转码", "错误信息" + e.toString());
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				Log.SystemLog("CMS自动转码", "错误信息" + e.toString());
				e.printStackTrace();
			} catch (InterruptedException e) {
				Log.SystemLog("CMS自动转码", "错误信息" + e.toString());
				e.printStackTrace();
			}
		}
		// TODO Auto-generated method stub

	}

	// 获取编码方式
	public static String getVideoType(String videoInfo, String sub) {
		System.out.println(videoInfo);
		int index1 = videoInfo.indexOf(sub);
		System.out.println(index1);
		String temp = "";
		if (index1 != -1) {
			String dur = videoInfo.substring(index1);
			int j1 = dur.indexOf(",");
			dur = dur.substring(0, j1) + " ";

			temp = dur.substring(sub.length(), sub.length() + 5);
		} else {
			temp = "";
		}
		return temp;
	}

	// 通过正则来提取
	public static String getRegex(String videoInfo, String reg) {
		Pattern pat = Pattern.compile(reg);
		Matcher mat = pat.matcher(videoInfo);
		while (mat.find())
			return mat.group();
		return "";
	}

	// 从ffmpeg信息中读取视频时长，单位是秒
	public static String getDurations(String s, String sub) {
		String m = "Duration: ";
		int index1 = s.indexOf(m);
		String t = "";
		if (index1 != -1) {
			String dur = s.substring(index1 + m.length());
			int j1 = dur.indexOf(",");
			t = dur.substring(0, j1);
		} else {
			t = "";
		}
		return t;
	}

	// 获取视频信息，duration 时长 bitrate 码流 width 宽 height 高 videotype 编码方式 fps 帧率

	public HashMap getVideoInfo(String ffmpeg[]) {
		HashMap map = new HashMap();
		String duration = "";// 时长
		String bitrate = "";// 码流
		String widthHeight = "";// 分辨率
		String videoType = "";// 编码方式
		String fps = "";// 帧率

		try {

			String videoInfo = cmd(ffmpeg, false);
			System.out.println("videoInfowhl:" + videoInfo);
			if (videoInfo.indexOf("No such file") != -1) {

				Log.SystemLog("转码服务端", "视频源文件无法读取："
						+ org.apache.commons.lang.StringUtils.join(ffmpeg, "")
						+ "," + videoInfo);
			}
			duration = getDurations(videoInfo, " Duration: ");
			bitrate = getBitrate(videoInfo, " bitrate: ");
			videoType = getVideoType(videoInfo, " Video: ");

			widthHeight = getRegex(videoInfo, "[0-9]{2,}x[0-9]{2,}");
			fps = getRegex(videoInfo, "[0-9]{1,}(.[0-9]+)* fps");
			map.put("Duration", duration);
			map.put("Bitrate", bitrate);
			map.put("VideoType", videoType);
			map.put("WidthHeight", widthHeight);
			map.put("Fps", fps);
			System.out.println(map.get("Duration") + "=Durationwhl");
		} catch (Exception e) {

			e.printStackTrace();
		}
		return map;
	}

	// 获取码率
	public String getBitrate(String videoInfo, String sub) {
		int index1 = videoInfo.indexOf(sub);
		String temp = "";
		if (index1 != -1) {
			String dur = videoInfo.substring(index1);
			int j1 = dur.indexOf(",");
			dur = dur.substring(0, j1);
			temp = dur.substring(sub.length(), sub.length() + 9);
		} else {
			temp = "";
		}
		return temp;
	}

	public void checkTranscode() throws MessageException, SQLException {
		String ChannelIDs = CmsCache.getParameterValue("autotranscode");
		String[] channelIds = ChannelIDs.split(",");

		for (String cid : channelIds) {
			ArrayList<Integer> readyTranscode = new ArrayList<Integer>();
			TableUtil tu = new TableUtil();
			String sql = "select * from "
					+ CmsCache.getChannel(Util.parseInt(cid)).getTableName()
					+ " where Active=1 and videosource!='' and videosource is not null  and Status2=0 ";
			System.out.println("Sql=" + sql);
			ResultSet rs = tu.executeQuery(sql);
			while (rs.next()) {
				int globalid = rs.getInt("globalid");
				if (globalid != 0) {
					readyTranscode.add(globalid);
				}
			}
			tu.closeRs(rs);

			for (int gid : readyTranscode) {
				Document doc = CmsCache.getDocument(gid);
				String sitefolder = doc.getChannel().getSite().getSiteFolder();
				String videoSource_Field = doc.getValue("videosource");
				String videoSource = Util.ClearPath(sitefolder + "/"
						+ videoSource_Field);
				String videoDest = Util.ClearPath(sitefolder + video_dest
						+ videoSource_Field);
				videoDest = videoDest.replace(
						"." + Util.getFileExt(videoSource), ".mp4");
				// videoSource_Field=videoSource_Field.replace(Util.getFileExt(videoSource_Field),
				// ".mp4");
				String videoDestPath_field = Util.ClearPath(video_dest
						+ videoSource_Field);
				videoDestPath_field = videoDestPath_field.replace(
						"." + Util.getFileExt(videoDestPath_field), ".mp4");
				String VideoDestPath = Util.getFilePath(videoDest);
				File f = new File(VideoDestPath);
				File f_s = new File(videoSource);
				if (!f.exists()) {
					f.mkdirs();
				}
				try {
					if (!f_s.exists()) {
						Log.SystemLog("自动转码进程",
								"转码源文件不存在---文章标题:" + doc.getTitle()
										+ "---转码原视频路径:" + videoSource
										+ "---转码后视频路径 :" + videoDest);
						updateVideoDest(gid, 3, "", doc.getChannel()
								.getTableName());// 设置完成状态
						continue;
					}
					executeTranscode(videoSource, videoDest, gid,
							defaultBitrate);
					Publish publish = new Publish();
					System.out.println(video_dest + videoSource_Field+"====="+sitefolder+"--"+videoDestPath_field);
					publish.InsertToBePublished(
							Util.ClearPath(videoDestPath_field),
							sitefolder, doc.getChannel().getSite());
					PublishManager.getInstance().CopyFileNow();
					String ffmpeg[] = { ffmpegPath, "-i",
							Util.ClearPath(videoSource) };
					HashMap mapInfo = getVideoInfo(ffmpeg);
					String timeInfo = mapInfo.get("Duration").toString();
					int dur = getTime(timeInfo);
					try {
						new TableUtil().executeUpdate("update "
								+ doc.getChannel().getTableName()
								+ " set duration=" + dur + " where globalid="
								+ gid + "");
					} catch (Exception e) {
						e.printStackTrace();
						System.out.println("更新时长失败" + e.toString());
					}
					updateVideoDest(gid, 2, videoDestPath_field, doc
							.getChannel().getTableName());// 设置完成状态
					Log.SystemLog("自动转码进程", "转码完成    视频标题:" + doc.getTitle()
							+ "    源视频地址  " + videoSource + "---目标视频地址: "
							+ videoDest);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					updateVideoDest(gid, 3, "", doc.getChannel().getTableName());// 设置完成状态
					Log.SystemLog("自动转码进程", "转码出现异常" + e.toString()
							+ "---文章标题:" + doc.getTitle() + "---转码原视频路径:"
							+ videoSource + "---转码后视频路径 :" + videoDest);
				}

			}
		}
	}

	// 执行一个命令 第一个参数改成数组
	public String cmd(String s[], boolean print) {
		System.out.println("enter cmd");
		List<String> commend = new java.util.ArrayList<String>();

		ProcessBuilder builder = new ProcessBuilder();
		builder.command(commend);
		builder.redirectErrorStream(true);

		// String[] ss = Util.StringToArray(s, " ");
		for (int i = 0; i < s.length; i++) {
			commend.add(s[i]);
		}

		String commend_desc = commend.toString().replace(", ", " ");
		// System.out.println("commend_desc:"+commend_desc);
		try {
			Process process1 = builder.start();
			InputStream is2 = process1.getInputStream();
			BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
			StringBuilder buf2 = new StringBuilder();
			String line2 = null;
			String bufs = null;
			while ((line2 = br2.readLine()) != null)
				buf2.append(line2 + "\r\n");
			bufs = buf2.toString();
			br2.close();
			is2.close();
			process1.destroy();
			if (print)
				System.out.println("bufsCmd:" + bufs);
			return bufs;
		} catch (Exception e) {
			e.printStackTrace(System.out);
			System.out.println(e.getMessage());
		}
		return "";
	}

	public void executeTranscode(String videoSource, String videoDest,
			int globalid, int Bitrate) throws IOException,
			InterruptedException, MessageException, SQLException {
		ProcessBuilder builder = new ProcessBuilder();

		String tab = CmsCache.getDocument(globalid).getChannel().getTableName();
		updateVideoDest(globalid, 1, "", tab);// 设置完成状态
		List<String> commend = new java.util.ArrayList<String>();
		commend.add(ffmpegPath);
		commend.add("-y");
		commend.add("-i");
		commend.add(videoSource);
		commend.add("-acodec");
		commend.add("libfaac");
		commend.add("-vcodec");
		commend.add("libx264");
		commend.add("-b:v");
		commend.add(Bitrate + "k");
		commend.add("-b:a");
		commend.add("64k");
		commend.add(videoDest);
		StringBuilder buf = new StringBuilder(); // 保存ffmpeg的输出结果流
		String commend_desc = commend.toString().replace(",", " ");
		System.out.println("commend:" + commend_desc);
		builder.command(commend);
		builder.redirectErrorStream(true);
		Process process = builder.start();
		// process = java.lang.Runtime.getRuntime().exec(cmd);
		// process.waitFor();
		InputStream is = process.getInputStream(); // 获取ffmpeg进程的输出流
		BufferedReader br = new BufferedReader(new InputStreamReader(is)); // 缓冲读入
		String line = null;
		int duration = 0;
		int current = 0;
		int progress = 0;
		while ((line = br.readLine()) != null) {
			System.out.println(line);
			buf.append(line); // 循环等待ffmpeg进程结束
			if (duration == 0) {
				int m = line.indexOf("Duration: ");
				if (m != -1) {
					int n = line.indexOf(",");
					if (n != -1) {
						duration = getTime(line.substring(m + 10, n));
					}
				}
			} else {
				int m = line.indexOf("time=");
				if (m != -1) {
					int n = line.indexOf(" bitrate=");
					if (n != -1) {
						current = getTime(line.substring(m + 6, n));

						int prog = 100 * current / duration;

						if (prog > progress) {
							progress = prog;
							if (prog % 10 == 0)
								System.out.println("duration:" + duration
										+ ",current:" + current + "," + prog);
							System.out.println(progress);
							updateProgress(globalid, progress, tab);
						}
					}
				}
			}
			// System.out.println(line);
		}

		int ret = process.waitFor();
		System.out.println("the return code is " + ret);
		br.close();
		is.close();

	}

	// 更新进度
	public static void updateProgress(int globalid, int progress, String tab)
			throws MessageException, SQLException {
		TableUtil tu = new TableUtil();
		String sql = "update " + tab + " set process=" + progress
				+ " where globalid=" + globalid;
		tu.executeUpdate(sql);
	}

	// 更新转码后地址
	public static void updateVideoDest(int globalid, int Status2,
			String VideoDest, String tab) throws MessageException, SQLException {
		TableUtil tu = new TableUtil();
		String sql = "update " + tab + " set status2=" + Status2
				+ ",videourl='" + VideoDest + "'  where globalid=" + globalid;
		System.out.println(sql);
		tu.executeUpdate(sql);
	}

	// 获取时间
	public static int getTime(String s) {
		// System.out.println(s);
		String[] ss = Util.StringToArray(s, ":");
		if (ss == null || ss.length != 3)
			return 0;
		String s3 = ss[2];
		int i = s3.indexOf(".");
		if (i != -1)
			s3 = s3.substring(0, i);
		return Util.parseInt(ss[0]) * 3600 + Util.parseInt(ss[1]) * 60
				+ Util.parseInt(s3);
	}

	public static void main(String[] args) throws IOException,
			InterruptedException {
		String a="宜宾市(231001)";
		System.out.println(a.substring(a.indexOf("(")+1,a.lastIndexOf(")")));
	}
}
