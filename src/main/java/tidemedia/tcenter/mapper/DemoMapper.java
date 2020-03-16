package tidemedia.tcenter.mapper;

import java.util.List;

import org.apache.ibatis.annotations.*;
import tidemedia.tcenter.entity.DemoEntity;

//@Mapper 这里可以使用@Mapper注解，但是每个mapper都加注解比较麻烦，所以统一配置@MapperScan在扫描路径在application类中
//mapper类参考
public interface DemoMapper {

    /**
     * 获取所有的xx对象
     * @return 
     */
    @Select("SELECT * FROM site")
    List<DemoEntity> getAll();

    @Insert("insert into xx (name,sex,age) values(#{name},#{sex},#{age})")
    @Options(useGeneratedKeys=true,keyProperty="id")
    int add(DemoEntity d);

    @Update("UPDATE xx SET name=#{name}, passwd=#{passwd} WHERE id=#{id}")
    int update(DemoEntity d);

    @Delete("delete from xx where id=#{id}")
    int delete(@Param("id") int id);

    @Select("select * from xx where id=#{id}")
    DemoEntity get(int id);


}