using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;

namespace Covid_19_Sha2022.Helper
{
    public static class HtmlHelper
    {
        //在str中截取，start开始，end结束的字符串(含start和end)
        public static string GetMidString(string str, string start, string end)
        {
            if (string.IsNullOrEmpty(str) || string.IsNullOrEmpty(start) || string.IsNullOrEmpty(end))
            {
                return string.Empty;
            }

            int startindex = str.IndexOf(start, StringComparison.CurrentCultureIgnoreCase);
            if (-1 == startindex)
            {
                return string.Empty;
            }
            int endindex = str.IndexOf(end, startindex + start.Length, StringComparison.CurrentCultureIgnoreCase);
            if (-1 == endindex)
            {
                return string.Empty;
            }
            return str.Substring(startindex, endindex + end.Length - startindex).Trim();
        }

        //old: 在str中截取，start开始，end结束的字符串(bool iscontain判断是否含start和end)
        public static string GetMidStringOld(string str, string start, string end, bool iscontain)
        {
            if (string.IsNullOrEmpty(str) || string.IsNullOrEmpty(start) || string.IsNullOrEmpty(end))
            {
                return string.Empty;
            }

            int startindex = str.IndexOf(start, StringComparison.CurrentCultureIgnoreCase);
            if (-1 == startindex)
            {
                return string.Empty;
            }
            int endindex = str.IndexOf(end, startindex + start.Length, StringComparison.CurrentCultureIgnoreCase);
            if (-1 == endindex)
            {
                return string.Empty;
            }
            if (iscontain)
            {
                return str.Substring(startindex, endindex + end.Length - startindex).Trim();
            }
            else
            {
                return str.Substring(startindex + start.Length, endindex - startindex - start.Length).Trim();
            }
        }

        //在str中截取，start开始，end结束的字符串(bool iscontain判断是否含start和end)
        public static string GetMidString(string str, string start, string end, bool iscontain)
        {
            if (string.IsNullOrEmpty(str))
            {
                return string.Empty;
            }

            int startindex;
            if (string.IsNullOrEmpty(start))
            {
                startindex = 0;
            }
            else
            {
                startindex = str.IndexOf(start, StringComparison.CurrentCultureIgnoreCase);
                if (-1 == startindex)
                {
                    return string.Empty;
                }
            }
            int endindex;
            if (string.IsNullOrEmpty(end))
            {
                endindex = str.Length;
            }
            else
            {
                endindex = str.IndexOf(end, startindex + start.Length, StringComparison.CurrentCultureIgnoreCase);
                if (-1 == endindex)
                {
                    return string.Empty;
                }
            }

            if (iscontain)
            {
                return str.Substring(startindex, endindex + end.Length - startindex).Trim();
            }
            else
            {
                return str.Substring(startindex + start.Length, endindex - startindex - start.Length).Trim();
            }
        }

        public static List<string> GetList(string context,string pattern,string gname)
        {
            List<string> list = new List<string>();
            MatchCollection matchs = Regex.Matches(context, pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase);
            foreach (Match match in matchs)
            {
                if (match.Success == true)
                {
                    list.Add(match.Groups[gname].Value);
                }
            }
            return list;
        }

        public static string GetString(string context, string pattern, string gname)
        {
            string s = string.Empty;
            Match match = Regex.Match(context, pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase);
            if (match.Success == true)
            {
                s = match.Groups[gname].Value;
            }
            return s;
        }

        public static Hashtable GetHashtable(string context, string pattern, string gkey,string gvalue)
        {
            Hashtable hashtable = new Hashtable();
            MatchCollection matchs = Regex.Matches(context, pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase);
            foreach (Match match in matchs)
            {
                if (match.Success == true)
                {
                    hashtable.Add(match.Groups[gkey].Value, match.Groups[gvalue].Value);
                }
            }
            return hashtable;
        }

        public static DataTable GetDataTable(string context, string pattern, string[] gkey)
        {
            int length = gkey.Length;
            DataTable dt = new DataTable();
            for (int i = 0; i < length;i++)
            {
                dt.Columns.Add(gkey[i], Type.GetType("System.String"));
            }
            MatchCollection matchs = Regex.Matches(context, pattern, RegexOptions.Singleline | RegexOptions.IgnoreCase);
            foreach (Match match in matchs)
            {
                if (match.Success == true)
                {
                    DataRow dr = dt.NewRow();
                    for (int i = 0; i < length; i++)
                    {                        
                        dr[i] = match.Groups[gkey[i]].Value;                        
                    }
                    dt.Rows.Add(dr);
                }
            }
            return dt;
        }
    }
}
