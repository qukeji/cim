package tidemedia.cms.backup;

import java.io.File;
import java.util.*;
import java.util.zip.ZipException;

import org.apache.tools.zip.ZipOutputStream;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ZipFiles {
	public ZipFiles() {
	}


// 全部打包
	public void zip(String inputFileName, String zipFileName) throws Exception {
		// String zipFileName="f:\\CMS.zip";
		zip(zipFileName, new File(inputFileName));

	}

	private void zip(String zipFileName, File inputFile) throws Exception {
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
				zipFileName));
		zip(out, inputFile, "");
		out.close();
	}

	private void zip(ZipOutputStream out, File f, String base) throws Exception {
		if (f.isDirectory()) {
			File[] fl = f.listFiles();
			out.putNextEntry(new org.apache.tools.zip.ZipEntry(base + "/"));
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < fl.length; i++) {
				zip(out, fl[i], base + fl[i].getName());
			}
		} else {
			out.putNextEntry(new org.apache.tools.zip.ZipEntry(base));
			FileInputStream in = new FileInputStream(f);
			int b;
			while ((b = in.read()) != -1) {
				out.write(b);
			}
			in.close();
		}
	}

	
// 文件命名
	public String getFileName(String bkName) throws MessageException,
			SQLException {

		GregorianCalendar time = new GregorianCalendar();
		String year = String.valueOf(time.get(GregorianCalendar.YEAR));
		String month = String.valueOf(time.get(GregorianCalendar.MONTH) + 1);
		String date = String.valueOf(time.get(GregorianCalendar.DATE));
		String backup_name = bkName + "_" + year + "_" + month + "_" + date
				+ ".zip";
		String backup1 = bkName + "_" + year + "_" + month + "_" + date;

		for (int i = 1; i < 10; i++) {
			TableUtil smt = new TableUtil();
			String sql = "select backup_name from backup_file where backup_name='"
					+ backup_name + "'";
			ResultSet rs = smt.executeQuery(sql);

			if (rs.next()) {
				backup_name = backup1 + "_" + (i + 1) + ".zip";
			} else {
				break;
			}
			smt.closeRs(rs);
		}

		return backup_name;

	}

	
// 增量打包
	public void zipUpdate(File folder, File zipFileName, long lastZipTime)
			throws Exception {
		// byte[] buf = new byte[1024];
		int folderlen = folder.getPath().length();
		FileOutputStream out1 = new FileOutputStream(zipFileName);
		ZipOutputStream out = new ZipOutputStream(out1);
		_zipUpdate(folder, out, folderlen, zipFileName, lastZipTime);
		try {
			out.close();
		} catch (ZipException e) {
			out1.close();
		}
	}

	public void _zipUpdate(File folder, ZipOutputStream out, int folderlen,
			File zipFileName, long lastZipTime) throws Exception {
		byte[] buf = new byte[1024];
		File[] files = folder.listFiles();
		if (files != null && files.length != 0) {
			for (int i = 0; i < files.length; i++) {
				if (files[i].isDirectory()) {
					_zipUpdate(files[i], out, folderlen, zipFileName,
							lastZipTime);
				} else {
					if (!files[i].getPath().equals(zipFileName.getPath())) {
						long fileTime = files[i].lastModified();

						if (fileTime >= lastZipTime) {
							FileInputStream in = new FileInputStream(files[i]);
							out.putNextEntry(new org.apache.tools.zip.ZipEntry(
									files[i].getPath().substring(folderlen)));
							int len;
							while ((len = in.read(buf)) > 0) {
								out.write(buf, 0, len);
							}
							out.closeEntry();
							in.close();
						}
					}
				}
			}
		}
	}
}
