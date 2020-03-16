package tidemedia.tcenter.base;

public class ResultJson<T> {
    private int code = 0;//200 成功 500 发生错误 403 没有权限
    private String msg = "";
    private String showMsg = "";//用于展示到界面的信息
    private T data;

    public ResultJson()
    {
        setData((T)"");
    }

    public ResultJson(int c, String m, Object object)
    {
        code = c;
        msg = m;
        setData((T) object);
    }

    //正常返回使用，数据放在data里面
    public static ResultJson success(Object object) {
        ResultJson result = new ResultJson();
        result.setCode(200);
        result.setMsg("成功");
        result.setData(object);
        return result;
    }

    //程序发生错误使用
    public static ResultJson error(String msg1) {
        ResultJson result = new ResultJson();
        result.setCode(500);
        result.setMsg(msg1);
        result.setShowMsg(msg1);
        return result;
    }

    //程序发生错误使用
    public static ResultJson error(String msg1,String msg2) {
        ResultJson result = new ResultJson();
        result.setCode(500);
        result.setMsg(msg1);
        result.setShowMsg(msg2);
        return result;
    }

    //没有权限访问使用
    public static ResultJson noAccess(String msg) {
        ResultJson result = new ResultJson();
        result.setCode(403);
        if(msg.length()==0) msg = "没有权限";
        result.setMsg(msg);
        return result;
    }

    public String getShowMsg() {
        return showMsg;
    }

    public void setShowMsg(String showMsg) {
        this.showMsg = showMsg;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
