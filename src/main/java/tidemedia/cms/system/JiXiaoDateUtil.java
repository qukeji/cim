package tidemedia.cms.system;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class JiXiaoDateUtil {

    private final static SimpleDateFormat shortSdf = new SimpleDateFormat("yyyy-MM-dd");

    private final static SimpleDateFormat longSdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    //是否是周一
    public static boolean isWeekStart() {
        Calendar calendar = Calendar.getInstance();
        int week = calendar.get(Calendar.DAY_OF_WEEK);//2代表周一
        if (week == 2) {
            return true;
        }
        return false;
    }

    //是否是月初
    public static boolean isMonthStart() {
        Calendar calendar = Calendar.getInstance();
        if (calendar.get(Calendar.DAY_OF_MONTH) == 1) {
            return true;
        } else {
            return false;
        }
    }

    //返回当前季度第一天
    public static String thisSeasonStart() {
        Calendar calendar = Calendar.getInstance();
        String dateString = "";
        int x = calendar.get(Calendar.YEAR);
        int y = calendar.get(Calendar.MONTH) + 1;
        if (y >= 1 && y <= 3) {
            dateString = x + "-" + "01" + "-" + "01";
        }
        if (y >= 4 && y <= 6) {
            dateString = x + "-" + "04" + "-" + "01";
        }
        if (y >= 7 && y <= 9) {
            dateString = x + "-" + "07" + "-" + "01";
        }
        if (y >= 10 && y <= 12) {
            dateString = x + "-" + "10" + "-" + "01";
        }
        return dateString;
    }

    //返回年初日期
    public static String thisYearStart() {
        Calendar calendar = Calendar.getInstance();
        String thisYearEnd = "";
        int i = calendar.get(Calendar.YEAR);
        thisYearEnd = i + "-01-01";
        return thisYearEnd;
    }

    //返回给定日期的yyyy--MM-dd格式
    public static String getDateTime(int num) {
        Calendar calendar = Calendar.getInstance();
        String dateTime = "";
        calendar.add(Calendar.DATE, num);
        int y = calendar.get(Calendar.YEAR);
        int m = calendar.get(Calendar.MONTH) + 1;
        int d = calendar.get(Calendar.DAY_OF_MONTH);
        String day = d + "";
        if (d < 10) {
            day = "0" + d;
        }
        dateTime = y + "-" + m + "-" + day;
        return dateTime;
    }

    //获取指定日期零点时间戳
    public static long getOneDayTimestamp(int num) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, num);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        long date = calendar.getTimeInMillis() / 1000;
        return date;
    }

    //获取 年初/月初/季度初 零点时间戳
    public static long getYearStartTimestamp(int year, boolean b) {
        Calendar calendar = Calendar.getInstance();
        if (b) {//获取上个季度初时间戳
            int i = calendar.get(Calendar.MONTH);
            if (i < 3) {
                calendar.add(Calendar.YEAR, -1);
                calendar.set(Calendar.MONTH, 9);
            } else if (i < 6) {
                calendar.set(Calendar.MONTH, 0);
            } else if (i < 9) {
                calendar.set(Calendar.MONTH, 3);
            } else {
                calendar.set(Calendar.MONTH, 6);
            }
        } else {
            if (year != 0) {//获取去年年初的时间戳
                calendar.add(Calendar.YEAR, -1);
                calendar.set(Calendar.MONTH, 0);
            }
        }
        if(!b&&year==0){
            calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH)-1);//上个月
        }
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        long date = calendar.getTimeInMillis() / 1000;
        return date;
    }

    //获取指定日期时间时间戳
    public static long getTimestamp(int day, int hour, int MINUTE) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, day);
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, MINUTE);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        long date = calendar.getTime().getTime() / 1000;
        return date;
    }
}
