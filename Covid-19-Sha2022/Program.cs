using Covid_19_Sha2022.Helper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;

namespace Covid_19_Sha2022
{
    internal class Program
    {
        static string Wechat_Site = "https://mp.weixin.qq.com/";
        static string WSJKW_Site = "https://wsjkw.sh.gov.cn";
        static string PositiveArea_Homepage = "https://wsjkw.sh.gov.cn/xwfb/index.html";

        static HttpHelper httpHelper = new HttpHelper();
        static CookieContainer frmcookie = new CookieContainer();
        static SQLHelper sqlserver = new SQLHelper();
        static string strSql = "";


        static void Main(string[] args)
        {

            IConfigurationBuilder builder = new ConfigurationBuilder().AddJsonFile("appsettings.json", false, true);
            IConfigurationRoot root = builder.Build();
            sqlserver.strSqlConn = root["SQLConn"];
            string strUrl = "";
            //strUrl = string.Format("https://mp.weixin.qq.com/s/72SXJPIJmO0Go5ZOARuv6A");
            //strUrl = string.Format("https://mp.weixin.qq.com/s/CVeBcXgkuPA8HKslTO3u5A");
            //Scan3Zones(strUrl);
            //return;

            int iMaxPageID = 3;  //default: scan 3 pages
            //If it's first run: scan 30 pages
            if (CheckIsFirstRun())
            {
                iMaxPageID = 10;
            }
            //Scan news pages in reverse order
            for (int i = iMaxPageID; i >= 1; i--)
            {
                if (i == 1)
                    strUrl = string.Format(PositiveArea_Homepage);
                else
                    strUrl = PositiveArea_Homepage.Replace("index.html", string.Format("index_{0}.html", i.ToString()));
                ScanNews(strUrl);
            }

            //Scan News info
            strSql = String.Format("select * from tNews t where Recorded=0 order by NewsContentDate");
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
            if (ds.Tables[0].Rows.Count == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }


        /// <summary>
        /// https://mp.weixin.qq.com/s/72SXJPIJmO0Go5ZOARuv6A
        /// </summary>
        /// <param name="strUrl"></param>
        static void Scan3Zones(string strUrl)
        {
            string FilterKey = "三区";
            string strHtml = httpHelper.ReturnGetHtml(strUrl, false, ref frmcookie, "", Wechat_Site, true);
            List<String> lstLI = strHtml.Split(new string[] { "<a target='_blank'" }, StringSplitOptions.None).ToList();
            string tempHref, tempTitle;

            var query = from s in lstLI
                .Where(s => (s.Contains(FilterKey)))
                        select s;
            foreach (var tempItem in query)
            {
                tempHref = HtmlHelper.GetMidString(tempItem, " href='", "'", false);
                if (!tempHref.Contains("http"))
                {
                    tempHref = WSJKW_Site + tempHref;
                }
                tempTitle = HtmlHelper.GetMidString(tempItem, " textvalue='", "'", false);

                if (tempTitle.Contains(FilterKey))
                {
                    strSql = String.Format("exec dbo.uspInsert3Zones N'{0}',N'{1}'", tempHref, tempTitle.Replace("'", "''"));
                    sqlserver.ExecuteNonQuery(strSql);
                }
            }
        }

        /// <summary>
        /// https://wsjkw.sh.gov.cn/xwfb/index_n.html
        /// </summary>
        /// <param name="strUrl"></param>
        static void ScanNews(string strUrl)
        {
            string FilterKey = "居住地信息";
            string strHtml = httpHelper.ReturnGetHtml(strUrl, false, ref frmcookie, "", WSJKW_Site, true);
            List<String> lstLI = strHtml.Split(new string[] { "<li>" }, StringSplitOptions.None).ToList();
            List<News> lstNews = new List<News>();
            string tempHref, tempTitle;

            var query = from s in lstLI
                .Where(s => (s.Contains(FilterKey)))
                        select s;
            foreach (var tempItem in query)
            {
                tempHref = HtmlHelper.GetMidString(tempItem, "<a href='", "'", false);
                if (!tempHref.Contains("http"))
                {
                    tempHref = WSJKW_Site + tempHref;
                }
                tempTitle = HtmlHelper.GetMidString(tempItem, " title='", "'", false);
                if (tempTitle.Contains(FilterKey))
                {
                    lstNews.Add(new News(tempHref, tempTitle));
                }
            }

            //Insert news items in reverse order
            for (int i = lstNews.Count-1; i >= 0; i--)
            {
                strSql = String.Format("exec dbo.uspInsertNews N'{0}',N'{1}'", lstNews[i].Href, lstNews[i].Title);
                sqlserver.ExecuteNonQuery(strSql);
            }
        }

        static void ScanNewsContent0319(string strUrl)
        {
            string strHtml = httpHelper.ReturnGetHtml(strUrl, false, ref frmcookie, "", WSJKW_Site, true);
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

    class News
    {
        public string Href { get; set; }
        public string Title { get; set; }
        public News(string href, string title)
        {
            Href = href;
            Title = title;
        }
    }

}
