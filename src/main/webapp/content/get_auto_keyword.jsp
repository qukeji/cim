<%@ page import="java.net.*,
				java.text.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.base.*,
				java.util.*,
				java.io.*,
				java.util.regex.*,
				org.wltea.analyzer.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
	public String[] getKeyword(String title, String content) {
		int weight = 10;
		// 标题的权重为10，用lucene进行分词时，增加标题中词语的出现次数
		for (int i = 0; i < weight; i++) {
			content = title + " " + content;			
		}
		// content 为纯文本形式
		IKSegmentation seg = new IKSegmentation(new StringReader(content), true);
		Map<String, Integer> map = new TreeMap<String, Integer>();
		// 分词，添加到数组中
		ArrayList list = new ArrayList();
		try {
			for (Lexeme word = seg.next(); word != null; word = seg.next()) {
				String k = word.getLexemeText();
				// 过滤掉数字
				if (checkIsNumber(k)) {
				} else {
					if (k != null && k.length() != 1){
						if (map.containsKey(k)) {
							map.put(k, new Integer(((Integer) map.get(word.getLexemeText())).intValue() + 1));
						} else {
							map.put(k, new Integer(1));
						}
					}
				}
			}
			List<Map.Entry<String, Integer>> infoIds = new ArrayList<Map.Entry<String, Integer>>(
					map.entrySet());
			// 排序前
			for (int i = 0; i < infoIds.size(); i++) {
				String id = infoIds.get(i).toString();
				//System.out.println(id+"---------");
			}
			// 排序
			Collections.sort(infoIds, new Comparator<Map.Entry<String, Integer>>() {
				public int compare(Map.Entry<String, Integer> o1,
						Map.Entry<String, Integer> o2) {
					return (o2.getValue() - o1.getValue());
				}
			});
			// 排序后
			int m = 0;
			int n = infoIds.size();
			if(n < 5){
				m = n;
			}else{
				m = 5;
			}
			for (int i = 0; i < m; i++) {
				String id = infoIds.get(i).toString();
				String keyword = id.split("=")[0];
				int value = Integer.parseInt(id.split("=")[1]);
				if(value>=1){
					//System.out.println(keyword+"---"+id);
					list.add(keyword);
				}
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 返回字符串数组
		//System.out.println(list.size());
		String arr[] = new String[list.size()];
		for (int i = 0; i < list.size(); i++)
			arr[i] = list.get(i).toString();
		return arr;
	}
	//正则去数字形式的关键词
	public boolean checkIsNumber(String word) {
		boolean flag = false;
		String regxp = "^-?[0-9]\\d*$";
		Pattern pattern = Pattern.compile(regxp);
		Matcher matcher = pattern.matcher(word);
		flag = matcher.find();
		return flag;
	}
%>
<%
	String title   =	getParameter(request,"title");
	String content =    getParameter(request,"content");
	
	//title = URLDecoder.decode(title,"utf-8");
	//content = URLDecoder.decode(content,"utf-8");
	//System.out.println(content);
	//System.out.println("title+content===="+title+content);
	content = Util.removeHtml(content);

	//System.out.println("===============");
	//System.out.println(content);
	//System.out.println("===============");
	String[] str = getKeyword(title, content);
	// System.out.println(str.length);
	String keywords_str = "";
	int count = 0;
	for (int i = 0; i < str.length; i++) {
		String str1 = str[i];
		if(count==0){
			keywords_str += str1;
		}else{
			keywords_str += " " + str1;
		}
		count++;
	}
	out.println(keywords_str);
%>