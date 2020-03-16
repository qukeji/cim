package tidemedia.tcenter.entity;

import java.io.Serializable;

//实体类参考
public class DemoEntity implements Serializable {

    private static final long serialVersionUID = 1L;
    private int id = 0;// id
    private String name = "";// 姓名
    private int age = 0;// 年龄

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }


    public void setAge(int age) {
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "User [id=" + id + ", name=" + name + ", age=" + age + "]";
    }
}