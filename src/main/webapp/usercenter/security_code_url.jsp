<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				javax.imageio.ImageIO,
				java.awt.Color,
java.awt.Font,
java.awt.Graphics,
java.awt.image.BufferedImage,
javax.servlet.ServletException,
java.io.IOException,
				java.sql.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
/*
 * 用途：用户中心登录验证码验证
 * 
 *								
 */	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 使用java图形界面技术绘制一张图片
		int charNum = 4;
		int width = 20 * 4;
		int height = 35;

		// 1. 创建一张内存图片
		BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

		// 2.获得绘图对象
		Graphics graphics = bufferedImage.getGraphics();

		// 3、绘制背景颜色
		//graphics.setColor(Color.CYAN); 
		graphics.setColor( new Color(173,216,230));
		graphics.fillRect(0, 0, width + 1, height + 2);

		// 4、绘制图片边框
		graphics.setColor(Color.WHITE);
		graphics.drawRect(0, 0, width + 1, height + 2);

		// 5、输出验证码内容
		graphics.setColor(Color.RED);
		graphics.setFont(new Font("宋体", Font.BOLD, 22));
		
		// 随机输出4个字符
		String s = "ABCDEFGHGKLMNPQRSTUVWXYZ23456789";
		Random random = new Random();
		
		// session中要用到
		String msg = "";
		
		int x = 5;
		for (int i = 0; i < charNum; i++) {
			int index = random.nextInt(32);
			String content = String.valueOf(s.charAt(index));			
			msg += content;
			graphics.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
			graphics.drawString(content, x, 22);
			x += 20;
		}
        HttpSession session = request.getSession();
		  session.setAttribute("security_code",msg);
		// 6、绘制干扰线
		graphics.setColor(Color.GRAY);
		for (int i = 0; i < 5; i++) {
			int x1 = random.nextInt(width);
			int x2 = random.nextInt(width);

			int y1 = random.nextInt(height);
			int y2 = random.nextInt(height);
			graphics.drawLine(x1, y1, x2, y2);
		}
		// 释放资源
		graphics.dispose();

		// 图片输出 ImageIO
		ImageIO.write(bufferedImage, "jpg", response.getOutputStream());

	}

%>
<%
doGet(request,response);
%>
