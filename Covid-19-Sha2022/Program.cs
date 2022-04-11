using Covid_19_Sha2022.Helper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;

namespace Covid_19_Sha2022
{
    internal class Program
    {
        static CookieContainer frmcookie = new CookieContainer();
        static HttpHelper httpHelper = new HttpHelper();
        static string strReferer = "";
        static string strHost = "https://wsjkw.sh.gov.cn";
        static string strSql = "";
        static string frmsessionid = string.Empty;
        static SQLHelper sqlserver = new SQLHelper();

        static void Main(string[] args)
        {
            string frmsessionid = string.Empty;
            SQLHelper sqlserver = new SQLHelper();

            string strUrl;
            bool isFirstRun = CheckIsFirstRun();
            if (isFirstRun)
            {
                strUrl = string.Format("https://wsjkw.sh.gov.cn/xwfb/index.html");
                ScanNews(strUrl);
                for (int i = 2; i <= 20; i++)
                {
                    strUrl = string.Format("https://wsjkw.sh.gov.cn/xwfb/index_{0}.html", i.ToString());
                    ScanNews(strUrl);
                }
            }
            else
            {
                strUrl = string.Format("https://wsjkw.sh.gov.cn/xwfb/index.html");
                ScanNews(strUrl);
            }


            //Scan News
            strSql = String.Format("select * from tNews t where Recorded=0 order by NewsID desc");
            DataSet ds = new DataSet();
            ds = sqlserver.ExecuteDataset(strSql);
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                string strURL = dr["Href"].ToString();
                string strTemp = string.Format(strURL);
                ScanNewsContent0319(strTemp);
            }

        }


        static bool CheckIsFirstRun()
        {
            //Scan News
            strSql = String.Format("select * from tNews");
            DataSet ds = new DataSet();
            ds = sqlserver.ExecuteDataset(strSql);
            if(ds.Tables[0].Rows.Count==0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// https://wsjkw.sh.gov.cn/xwfb/index_n.html
        /// </summary>
        /// <param name="strUrl"></param>
        static void ScanNews(string strUrl)
        {
            string strHtml = httpHelper.ReturnGetHtml(strUrl, false, ref frmcookie, strReferer, strHost, true);
            List<String> lstLI = strHtml.Split(new string[] { "<li>" }, StringSplitOptions.None).ToList();
            List<String> lstNews = new List<string>();
            string tempHref, tempTitle;

            var query = from s in lstLI
                .Where(s => (s.Contains("居住地信息")))
                        select s;
            foreach (var news in query)
            {
                tempHref = HtmlHelper.GetMidString(news, "<a href='", "'", false);
                if (!tempHref.Contains("http"))
                {
                    tempHref = strHost + tempHref;
                }
                tempTitle = HtmlHelper.GetMidString(news, " title='", "'", false);
                lstNews.Add(tempHref + "    " + tempTitle);

                strSql = String.Format("exec dbo.uspInsertNews N'{0}',N'{1}'", tempHref, tempTitle);
                sqlserver.ExecuteNonQuery(strSql);
            }
        }

        static void ScanNewsContent0319(string strUrl)
        {
            string strHtml = httpHelper.ReturnGetHtml(strUrl, false, ref frmcookie, strReferer, strHost, true);
            //use <strong> to split districts
            List<String> lstSTRONG = strHtml.Split(new string[] { "<strong" }, StringSplitOptions.None).ToList();
            List<String> lstStreet = new List<string>();
            string tempDistrict, tempDistrictInfo, tempStreet;

            var query = from s in lstSTRONG
                .Where(s => (s.Contains("</strong>")))
                        select s;

            foreach (var district in query)
            {
                tempDistrict = HtmlHelper.GetMidString(district, ">", "</strong>", false);
                tempDistrict = ClearHtml(tempDistrict);

                tempDistrictInfo = HtmlHelper.GetMidString(district, "居住于：", "", false);
                //use <p> to split streets
                List<String> lstSTREET = tempDistrictInfo.Split(new string[] { "<p" }, StringSplitOptions.None).ToList();
                foreach (string street in lstSTREET)
                {
                    tempStreet = HtmlHelper.GetMidString(street, ">", "</p>", false);
                    tempStreet = ClearHtml(tempStreet);
                    if (!string.IsNullOrEmpty(tempStreet))
                    {
                        if (tempStreet.EndsWith("。") || tempStreet.EndsWith("，") || tempStreet.EndsWith("、") || tempStreet.EndsWith(","))
                        {
                            tempStreet = tempStreet.Substring(0, tempStreet.Length - 1);
                        }

                        strSql = String.Format("exec dbo.uspInsertPositiveArea N'{0}',N'{1}',N'{2}'", strUrl, tempDistrict, tempStreet);
                        sqlserver.ExecuteNonQuery(strSql);
                    }
                }
            }
            strSql = String.Format("update t set Recorded = 1 from tNews t where Href = N'{0}'", strUrl);
            sqlserver.ExecuteNonQuery(strSql);
        }


        static string ClearHtml(string strHtml)
        {
            while (strHtml.Contains("<") && strHtml.Contains(">"))
            {
                string strRemove = HtmlHelper.GetMidString(strHtml, "<", ">", true);
                strHtml = strHtml.Replace(strRemove, "").Trim();
            }
            return strHtml.Replace("&nbsp;", "").Trim();
        }

    }
}
