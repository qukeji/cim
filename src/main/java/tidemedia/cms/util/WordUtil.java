package tidemedia.cms.util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Log;

public class WordUtil {

	public static boolean sensitiveword_init = false;// 是否已经初始化敏感词
	public static String[] sensitiveword = new String[] {};// 敏感词

	public static boolean hotkeyword_init = false;// 是否已经初始化热词库
	public static String[] hotword = new String[] {};// 热词
	public static String[] hotword_url = new String[] {};// 热词对应链接
	public static String tide_hot_style = "tide_hotword";// 标准样式

	// 获取敏感词
	public static String[] getSensitiveword() throws MessageException,
			SQLException {
		if (sensitiveword_init)
			return sensitiveword;

		// 根据频道编号获取频道信息
		TableUtil tu = new TableUtil();
		Channel ch = CmsCache.getChannel("sensitive_word");

		if (ch != null && ch.getId() > 0) {
			ArrayList<String> array = new ArrayList<String>();
			String sql = "select Title from " + ch.getTableName()
					+ " where Status=1";
			ResultSet rs = tu.executeQuery(sql);
			while (rs.next()) {
				String word = tu.convertNull(rs.getString("Title"));
				array.add(word);
			}
			tu.closeRs(rs);

			sensitiveword = (String[]) array.toArray(new String[array.size()]);
		}

		sensitiveword_init = true;

		return sensitiveword;
	}

	public static void initSensitiveword() {
		sensitiveword_init = false;
		Log.SystemLog("词库", "初始化敏感词库");
	}

	// 获取热词库
	public static String[][] getHotword() throws MessageException, SQLException {
		if (!hotkeyword_init) {
			TableUtil tu = new TableUtil();
			Channel ch = CmsCache.getChannel("hotkeyword");

			if (ch != null && ch.getId() > 0) {
				ArrayList<String> array1 = new ArrayList<String>();
				ArrayList<String> array2 = new ArrayList<String>();
				String sql = "select Title,Href from " + ch.getTableName()
						+ " where Status=1";
				ResultSet rs = tu.executeQuery(sql);
				while (rs.next()) {
					String Title = tu.convertNull(rs.getString("Title"));
					String Href = tu.convertNull(rs.getString("Href"));
					array1.add(Title);
					array2.add(Href);
				}
				tu.closeRs(rs);

				hotword = (String[]) array1.toArray(new String[array1.size()]);
				hotword_url = (String[]) array2.toArray(new String[array2
						.size()]);
			}

			hotkeyword_init = true;
		}

		String[][] words = new String[2][hotword.length];
		words[0] = hotword;
		words[1] = hotword_url;

		return words;
	}

	public static void initHotkeyword() {
		hotkeyword_init = false;
		Log.SystemLog("词库", "初始化热词库");
	}

	/**
	 * 替换热词   首先识别热刺Class属性  清除全篇a链接，然后进行替换
	 * @param value
	 * @return
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static String processHotword(String value) throws MessageException,
			SQLException {
		String[][] hotword_ = WordUtil.getHotword();
		String[] hotword = hotword_[0];
		String[] hotword_url = hotword_[1];

		if (hotword.length > 0 && hotword.length == hotword_url.length) {
			value = ClearHotWord(value);
			for (int i = 0; i < hotword.length; i++) {
				String w = hotword[i];
				String url = hotword_url[i];

				int l = 0;
				String result = "";
				boolean flag = false;

				while (l < value.length()) {
					int index = value.substring(l).indexOf(">");

					if (index == -1) {
						break; // 没有找到‘>‘ 的标识的话 则跳出循环
					}

					String prepare = value.substring(l, index + l);

					if (prepare.startsWith("<a") || prepare.startsWith("<A")) {
						flag = true;// 如果是ａ标签内的内容 则设置标识为True 不替换
					}
					
					result += prepare;

					l += index;

					int index_tail = value.substring(l).indexOf("<");

					if (index_tail == -1) {
						result += value.substring(l);// 没有找到‘<’ 的标识的话 则跳出循环
						break;
					}

					String tail_end = value.substring(l, index_tail + l);
					
					if (!flag) {// 为True 则代表此是a标签中的内容 不做替换
						tail_end = tail_end.replaceAll(w, "<a href='" + url
								+ "' class=\"" + tide_hot_style
								+ "\" target=\"_blank\">" + w + "</a>");
					}

					flag = false;

					l += index_tail;
					result += tail_end;

				}
				if (!"".equals(result)) {
					value = result;
				}
			}
		}

		return value;
	}

	/**
	 * 将原有文章中 附加的热词都a标签都删除掉，识别依据tide_hotword
	 * 
	 * @param str
	 * @return
	 */
	public static String ClearHotWord(String str) {
		// String result = "";
		Document doc = Jsoup.parse(str);
		Elements els = doc.getElementsByTag("a");
		for (Element el : els) {
			if (tide_hot_style.equals(el.className())) {
				str = str.replaceAll(el.toString(), el.text());
			}
		}
		return str;
	}

	public static void main(String[] args) throws MessageException,
			SQLException {
		
		//System.out.println("-----");
	}
}
