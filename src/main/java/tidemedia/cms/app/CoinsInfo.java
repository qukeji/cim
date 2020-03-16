    package tidemedia.cms.app;

    import org.json.JSONArray;
    import org.json.JSONException;
    import org.json.JSONObject;
    import tidemedia.cms.base.MessageException;
    import tidemedia.cms.base.Table;
    import tidemedia.cms.base.TableUtil;
    import tidemedia.cms.system.Document;
    import tidemedia.cms.system.ItemUtil;

    import java.sql.ResultSet;
    import java.sql.SQLException;
    import java.text.SimpleDateFormat;
    import java.util.*;
    import java.util.logging.SimpleFormatter;

    public class CoinsInfo {

        //金币明细表
        private String Title="";//动作名称

        private Integer userid=0;//操作人用户编号

        private String code="";//操作类型

        private Integer itemid=0;//评论或发帖编号

        private Integer coins=0;//金币

        private String ip="";//ip用户操作


        private String actionTableName;//用户行为表名

        private String coinsTableName;//用户金币记录表名

        private int coinsChannelid;//用户金币记录频道id

		private String cms_register;//用户库

        public CoinsInfo(String actionTableName,String coinsTableName,int coinsChannelid) throws MessageException, SQLException {
            this.actionTableName= actionTableName;
            this.coinsTableName = coinsTableName;
            this.coinsChannelid =coinsChannelid;
        }
		public CoinsInfo(String actionTableName,String coinsTableName,int coinsChannelid,String cms_register) throws MessageException, SQLException {
            this.actionTableName= actionTableName;
            this.coinsTableName = coinsTableName;
            this.coinsChannelid =coinsChannelid;
			this.cms_register =cms_register;
        }


        public JSONObject add() throws SQLException, MessageException,JSONException{
            ItemUtil it = new ItemUtil();
            JSONObject json = new JSONObject();
            json.put("status",0);
            if(userid==null||userid==0){
                throw new MessageException("操作人用户编号不得为空");
            }
            getCoinsInfo(code);
            synchronized (this.getClass()) {
                if(addCoinsCheck(code, userid)) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    HashMap<String, String> map = new HashMap<String, String>();
                    map.put("userid", userid + "");
                    map.put("itemid", itemid + "");
                    map.put("ip", ip);
                    map.put("CreateDate", sdf.format(new Date()));
                    map.put("active", 1 + "");
                    map.put("code", code);
                    map.put("Title", Title);
                    map.put("coins", coins + "");
                    int insertid = it.addItemGetID(coinsChannelid, map);
                    if (insertid == 0) {
                        json.put("status",0);
                        json.put("type",0);
                        return json;
                    }
                    json.put("status",1);
                    return json;
                }else{
                    json.put("type",1);
                    return json;
                }
            }
        }
        //获取对应的金币数
        public void getCoinsInfo(String code) throws SQLException, MessageException {
            TableUtil tu = new TableUtil();
            if(code==null||"".equals(code)) {
                throw new MessageException("操作类型不得为空");
            }
            String sql = "select goldaddition ,Title from "+actionTableName+ " where active =1 and code ='"+code+"'";
            ResultSet rs = tu.executeQuery(sql);
            if(rs.next()){
                this.coins = rs.getInt("goldaddition");
                this.Title = rs.getString("Title");
            }else{
                throw new MessageException("操作类型无法对应金币方案");
            }
            tu.closeRs(rs);
        }
        //获取金币明细列表
        public JSONObject getCoinsInfoList(Integer page,Integer pagesize,Integer userid,String userTableName) throws SQLException, MessageException , JSONException {
            JSONObject json = new JSONObject();
            JSONObject rejson = new JSONObject();
            if(page==0){
                page =1;
            }
            if(pagesize==0){
                pagesize=10;
            }
            TableUtil tu = new TableUtil();
            String userinfoSql = "select Title,avatar,sex,level  from " + userTableName +"  where id = "+userid;
            String coinsSql = "select  coins ,CreateDate,Title,code  from " + coinsTableName+ " where Active=1 and userid="+userid+
                    " order by CreateDate desc limit "+((page-1)*pagesize)+","+pagesize;
            String nickname = "";//用户昵称
            String avatar = "";//用户头像
            Integer sex = 0;//用户性别
            String level = "";//用户等级
            Integer coins = getCoins(userid);//用户总金币
            ResultSet userRs = tu.executeQuery(userinfoSql);
            if(userRs.next()){
                nickname=userRs.getString("Title");
                avatar=userRs.getString("avatar");
                sex =userRs.getInt("sex");
                level= userRs.getString("level") ;
            }else{
                throw new MessageException("用户信息不存在");
            }
            tu.closeRs(userRs);
            ResultSet coinsRs = tu.executeQuery(coinsSql);
            JSONArray array = new JSONArray();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            Long zero = calendar.getTime().getTime();
            while(coinsRs.next()){
                JSONObject obj = new JSONObject();
                String timeStr = "";
                obj.put("addcoins",coinsRs.getInt("coins"));
                obj.put("msg",coinsRs.getString("Title"));
				obj.put("code",coinsRs.getString("code"));
                Long ctime = coinsRs.getLong("CreateDate")*1000;
                Long ntime = new Date().getTime();
                Long second = (ntime-ctime)/1000;
                if(ctime<zero){
                    timeStr = sdf.format(new Date(ctime));
                }else{
                    if(second>60){
                        Long mins = second/60;
                        if(mins>60){
                            Long hours = mins/60;
                            timeStr= hours+"小时前";
                        }else{
                            timeStr= mins+"分钟前";
                        }
                    }else{
                        timeStr= second+"秒前";
                    }
                }
                obj.put("date",timeStr);
                array.put(obj);
            }
            tu.closeRs(coinsRs);
            rejson.put("coins",coins);
            rejson.put("username",nickname);
            rejson.put("userid",userid);
            rejson.put("gender",sex);
            rejson.put("level",level);
            rejson.put("avatar",avatar);
            rejson.put("list",array);

            json.put("result",rejson);
            json.put("status","1");
            json.put("message","成功");

            return json;
        }
        //获取总金币数
        public Integer getCoins(Integer userid) throws SQLException, MessageException {
			TableUtil tu2 = new TableUtil();
			String queryGoldSql = "select gold from "+cms_register+" where id = " + userid;
			ResultSet rs2 = tu2.executeQuery(queryGoldSql);
			int coins = 0;
			while(rs2.next()){
				coins = rs2.getInt("gold");
			}
			tu2.closeRs(rs2);

            return coins;
        }

        public boolean addCoinsCheck(String code ,int userid)throws SQLException, MessageException {
            TableUtil tu =new TableUtil();
            String sql = "select frequency,period from "+actionTableName+ " where active =1 and Status=1 and code ='"+code+"'";
            ResultSet rs = tu.executeQuery(sql);
            //时(0)
            //天(1)
            //周(2)
            //月(3)
            //无限(4)
            int frequency=0;
            int period=-1;
            if(rs.next()){
                frequency = rs.getInt("frequency");
                period = rs.getInt("period");
            }else {
                tu.closeRs(rs);
                throw new MessageException("操作类型无法对应金币方案");
            }
            tu.closeRs(rs);
            String whereSql = "";
            Calendar c = Calendar.getInstance();
            Date nowDate = new Date();
            long nowtime= nowDate.getTime();
            c.setTime(nowDate);
            if(period==0){
                //获取当前小时的初始时间：
                c.set(Calendar.MINUTE, 0);
                c.set(Calendar.SECOND, 0);
                long hourfirsttime=(c.getTime().getTime())/1000;//当前小时的起始时间
                c.set(Calendar.MINUTE, 59);
                c.set(Calendar.SECOND, 59);
                long hourlasttime=(c.getTime().getTime())/1000;//当前小时的最后一秒
                whereSql = "and createDate <= "+hourlasttime+" and createDate >= "+hourfirsttime;
            }else if(period==1){
                //获取当天0点
                c.set(Calendar.HOUR_OF_DAY, 0);
                c.set(Calendar.MINUTE, 0);
                c.set(Calendar.SECOND, 0);
                long dayfirsttime=(c.getTime().getTime())/1000;//当天时间的起始时间
                //获取当天最后一秒
                c.set(Calendar.HOUR_OF_DAY, 23);
                c.set(Calendar.MINUTE, 59);
                c.set(Calendar.SECOND, 59);
                long daylasttime=(c.getTime().getTime())/1000;//当天时间的最后一秒
                whereSql = " and createDate <= "+daylasttime+" and createDate >= "+dayfirsttime;
            }else if(period==2){
                c.set(Calendar.HOUR_OF_DAY, 0);
                c.set(Calendar.MINUTE, 0);
                c.set(Calendar.SECOND, 0);
                int d = 0;
                if (c.get(Calendar.DAY_OF_WEEK) == 1) {
                    d = -6;
                } else {
                    d = 2 - c.get(Calendar.DAY_OF_WEEK);
                }
                c.add(Calendar.DAY_OF_WEEK, d);
                // 所在周开始日期
                long weekfirsttime=(c.getTime().getTime())/1000;
                c.add(Calendar.DAY_OF_WEEK, 6);
                // 所在周结束日期
                c.set(Calendar.HOUR_OF_DAY, 23);
                c.set(Calendar.MINUTE, 59);
                c.set(Calendar.SECOND, 59);
                long weeklasttime = (c.getTime().getTime())/1000;
                whereSql = " and createDate <= "+weeklasttime+" and createDate >= "+weekfirsttime;
            }else if(period==3){
                //获取当前月第一天：
                c.add(Calendar.MONTH, 0);
                c.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天
                c.set(Calendar.HOUR_OF_DAY, 0);
                c.set(Calendar.MINUTE, 0);
                c.set(Calendar.SECOND, 0);
                long monthfirsttime=(c.getTime().getTime())/1000;//当前月份的第一天起始时间
                //获取当前月最后一天
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                c.set(Calendar.HOUR_OF_DAY, 23);
                c.set(Calendar.MINUTE, 59);
                c.set(Calendar.SECOND, 59);
                long monthlasttime=(c.getTime().getTime())/1000;//当前月份的最后一天的时间
                whereSql = " and createDate <= "+monthlasttime+" and createDate >= "+monthfirsttime;
            }
            String CountSql = "select count(id) from "+coinsTableName+" where code = '"+code+"' and userid='"+userid+"' "+whereSql;
            int count = tu.getNumber(CountSql);
            if(count>=frequency){
                return false;
            }else{
                return true;
            }
        }

        public String getTitle() {
            return Title;
        }

        public void setTitle(String title) {
            Title = title;
        }

        public Integer getUserid() {
            return userid;
        }

        public void setUserid(Integer userid) {
            this.userid = userid;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        public Integer getItemid() {
            return itemid;
        }

        public void setItemid(Integer itemid) {
            this.itemid = itemid;
        }

        public Integer getCoins() {
            return coins;
        }

        public void setCoins(Integer coins) {
            this.coins = coins;
        }

        public String getIp() {
            return ip;
        }

        public void setIp(String ip) {
            this.ip = ip;
        }
    }
