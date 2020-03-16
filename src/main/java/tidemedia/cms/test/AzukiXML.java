package tidemedia.cms.test;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;


/**
 * 与azuki对接的 Media对象类
 * @author liuwx
 *
 */
public class AzukiXML  {

	public static final String PRE_ID_STR = "m";
	
	private String id;
	private String name ="test";
	private String url = "http://localhost/a.mp4";
	//private String[] cdn_profiles = {"CDN_VOD_TEST"};
	
	//owner sanaobk
//	private String[] cdn_profiles = {"CDN_VOD_NEW"};
//	private String ingestion_profile = "cch_vod_stb_an_ms_apple_all_3_0";
	
	//owner azuki
	private String[] cdn_profiles = {"CDN_USR_VOD"};
    private String ingestion_profile = "cch_vod_stb_an_ms_apple_all_3_0";
	
	private String[] retranscode_formats;
	//private String format;
	private boolean all;
	
	private boolean live = false;
	private String live_rtmp_app;
	private String live_rtmp_media;
	private String live_rtmp_swf_url;
	private String live_rtmp_page_url;
	private String live_rtmp_tc_url;
	private String live_start_time;
	private String live_end_time;
	private int priority = 3;
	private String activate_date;
	private String deactivate_date;
	private String expire_date;
	private String publish_date;
	private boolean admin_disable;
	private boolean rights_callout_enabled;
	private int max_retries;
	private Map<String,String> metadata;
	private List<Marker> markers;
	
	
	
	public AzukiXML(String cdn_profiles,String ingestion_profile)
    {
	    this.cdn_profiles = cdn_profiles.split(",");
	    this.ingestion_profile = ingestion_profile;
    }
	
	public String convertToAxukiXml(){
		StringBuffer sb = new StringBuffer();
		sb.append("<media>\r\n");
		if(StringUtils.isNotEmpty(name)){
			sb.append("<name>").append(name).append("</name>\r\n");
		}
		
		if(StringUtils.isNotEmpty(url)){
			sb.append("<url>").append(url).append("</url>\r\n");
		}
		
		if(cdn_profiles != null && cdn_profiles.length  > 0){
			sb.append("<cdn_profiles>\r\n");
				for (int i = 0; i < cdn_profiles.length; i++) {
					if(StringUtils.isNotEmpty(cdn_profiles[i])){
						sb.append("<cdn_profile>").append(cdn_profiles[i]).append("</cdn_profile>\r\n");
					}
				}
			sb.append("</cdn_profiles>\r\n");
			
		}

		if(all){
			sb.append("<retranscode_formats>\r\n");
			sb.append("<all>true</all>");
			sb.append("</retranscode_formats>\r\n");
		}else if(retranscode_formats != null && retranscode_formats.length  > 0){
			sb.append("<retranscode_formats>\r\n");
				for (int i = 0; i < retranscode_formats.length; i++) {
					if(StringUtils.isNotEmpty(retranscode_formats[i])){
						sb.append("<format>").append(retranscode_formats[i]).append("</format>\r\n");
					}
				}
			sb.append("</retranscode_formats>\r\n");
			
		}
		
		if(StringUtils.isNotEmpty(ingestion_profile)){
			sb.append("<ingestion_profile>").append(ingestion_profile).append("</ingestion_profile>\r\n");
		}
		
		if(live != false){
			sb.append("<live>").append(live).append("</live>\r\n");
		}
		
		if(StringUtils.isNotEmpty(live_rtmp_app)){
			sb.append("<live_rtmp_app>").append(live_rtmp_app).append("</live_rtmp_app>\r\n");
		}

		if(StringUtils.isNotEmpty(live_rtmp_media)){
			sb.append("<live_rtmp_media>").append(live_rtmp_media).append("</live_rtmp_media>\r\n");
		}

		if(StringUtils.isNotEmpty(live_rtmp_swf_url)){
			sb.append("<live_rtmp_swf_url>").append(live_rtmp_swf_url).append("</live_rtmp_swf_url>\r\n");
		}		

		if(StringUtils.isNotEmpty(live_rtmp_page_url)){
			sb.append("<live_rtmp_page_url>").append(live_rtmp_page_url).append("</live_rtmp_page_url>\r\n");
		}	

		if(StringUtils.isNotEmpty(live_rtmp_tc_url)){
			sb.append("<live_rtmp_tc_url>").append(live_rtmp_tc_url).append("</live_rtmp_tc_url>\r\n");
		}	

		if(StringUtils.isNotEmpty(live_start_time)){
			sb.append("<live_start_time>").append(live_start_time).append("</live_start_time>\r\n");
		}	

		if(StringUtils.isNotEmpty(live_end_time)){
			sb.append("<live_end_time>").append(live_end_time).append("</live_end_time>\r\n");
		}	

		if(priority != 0){
			sb.append("<priority>").append(priority).append("</priority>\r\n");
		}	
		
		if(StringUtils.isNotEmpty(activate_date)){
			sb.append("<activate_date>").append(activate_date).append("</activate_date>\r\n");
		}	

		if(StringUtils.isNotEmpty(deactivate_date)){
			sb.append("<deactivate_date>").append(deactivate_date).append("</deactivate_date>\r\n");
		}	
		
		if(StringUtils.isNotEmpty(expire_date)){
			sb.append("<expire_date>").append(expire_date).append("</expire_date>\r\n");
		}	
		
		if(StringUtils.isNotEmpty(publish_date)){
			sb.append("<publish_date>").append(publish_date).append("</publish_date>\r\n");
		}	

		if(admin_disable){
			sb.append("<admin_disable>").append(admin_disable).append("</admin_disable>\r\n");
		}	
		
		if(rights_callout_enabled){
			sb.append("<rights_callout_enabled>").append(rights_callout_enabled).append("</rights_callout_enabled>\r\n");
		}		

		if(max_retries != 0){
			sb.append("<max_retries>").append(max_retries).append("</max_retries>\r\n");
		}
		
		if(metadata != null && !metadata.isEmpty()){
			sb.append("<metadata>\r\n");
		        Set<String> key = metadata.keySet();
		        String s;
		        for (Iterator it = key.iterator(); it.hasNext();) {
		        	s = (String) it.next();
		        	sb.append("<").append(s).append(">").append(metadata.get(s)).append("</").append(s).append(">\r\n");
		        }
			sb.append("</metadata>\r\n");
		}
		
		if(markers != null && !markers.isEmpty()){
			sb.append("<markers>\r\n");
				Marker marker;
				for (int i = 0; i < markers.size(); i++) {
					marker = markers.get(i);
					sb.append("<marker>\r\n");
						sb.append("<start_offset>").append(marker.getStart_offset()).append("</start_offset>");
						sb.append("<duration>").append(marker.getDuration()).append("</duration>");
						sb.append("<marker_type>").append(marker.getMarker_type()).append("</marker_type>");
						sb.append("<data>").append(marker.getData()).append("</data>");
					sb.append("</marker>\r\n");
				}
			
			sb.append("</markers>\r\n");
		}
		
		sb.append("</media>");
		
		return sb.toString();
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public boolean isAll() {
		return all;
	}
	public void setAll(boolean all) {
		this.all = all;
	}
	public String getIngestion_profile() {
		return ingestion_profile;
	}
	public void setIngestion_profile(String ingestion_profile) {
		this.ingestion_profile = ingestion_profile;
	}
	public String getLive_rtmp_app() {
		return live_rtmp_app;
	}
	public void setLive_rtmp_app(String live_rtmp_app) {
		this.live_rtmp_app = live_rtmp_app;
	}
	public String getLive_rtmp_media() {
		return live_rtmp_media;
	}
	public void setLive_rtmp_media(String live_rtmp_media) {
		this.live_rtmp_media = live_rtmp_media;
	}
	public String getLive_rtmp_swf_url() {
		return live_rtmp_swf_url;
	}
	public void setLive_rtmp_swf_url(String live_rtmp_swf_url) {
		this.live_rtmp_swf_url = live_rtmp_swf_url;
	}
	public String getLive_rtmp_page_url() {
		return live_rtmp_page_url;
	}
	public void setLive_rtmp_page_url(String live_rtmp_page_url) {
		this.live_rtmp_page_url = live_rtmp_page_url;
	}
	public String getLive_rtmp_tc_url() {
		return live_rtmp_tc_url;
	}
	public void setLive_rtmp_tc_url(String live_rtmp_tc_url) {
		this.live_rtmp_tc_url = live_rtmp_tc_url;
	}
	public String getLive_start_time() {
		return live_start_time;
	}
	public void setLive_start_time(String live_start_time) {
		this.live_start_time = live_start_time;
	}
	public String getLive_end_time() {
		return live_end_time;
	}
	public void setLive_end_time(String live_end_time) {
		this.live_end_time = live_end_time;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
	    if(priority < 1)
	        this.priority = 3;
	    else
	        this.priority = priority;
	}
	public String getActivate_date() {
		return activate_date;
	}
	public void setActivate_date(String activate_date) {
		this.activate_date = activate_date;
	}
	public String getDeactivate_date() {
		return deactivate_date;
	}
	public void setDeactivate_date(String deactivate_date) {
		this.deactivate_date = deactivate_date;
	}
	public String getExpire_date() {
		return expire_date;
	}
	public void setExpire_date(String expire_date) {
		this.expire_date = expire_date;
	}
	public String getPublish_date() {
		return publish_date;
	}
	public void setPublish_date(String publish_date) {
		this.publish_date = publish_date;
	}
	public boolean isAdmin_disable() {
		return admin_disable;
	}
	public void setAdmin_disable(boolean admin_disable) {
		this.admin_disable = admin_disable;
	}
	public boolean isRights_callout_enabled() {
		return rights_callout_enabled;
	}
	public void setRights_callout_enabled(boolean rights_callout_enabled) {
		this.rights_callout_enabled = rights_callout_enabled;
	}
	public int getMax_retries() {
		return max_retries;
	}
	public void setMax_retries(int max_retries) {
		this.max_retries = max_retries;
	}
	public List<Marker> getMarkers() {
		return markers;
	}
	public void setMarkers(List<Marker> markers) {
		this.markers = markers;
	}

	public String[] getCdn_profiles() {
		return cdn_profiles;
	}

	public void setCdn_profiles(String[] cdn_profiles) {
		this.cdn_profiles = cdn_profiles;
	}

	public String[] getRetranscode_formats() {
		return retranscode_formats;
	}

	public void setRetranscode_formats(String[] retranscode_formats) {
		this.retranscode_formats = retranscode_formats;
	}

	public Map<String, String> getMetadata() {
		return metadata;
	}

	public void setMetadata(Map<String, String> metadata) {
		this.metadata = metadata;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public boolean isLive() {
		return live;
	}

	public void setLive(boolean live) {
		this.live = live;
	}
}
