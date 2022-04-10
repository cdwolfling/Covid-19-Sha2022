using ICSharpCode.SharpZipLib.GZip;
using ICSharpCode.SharpZipLib.Zip.Compression.Streams;
using System.IO;
using System.Net;
using System.Text;
using System.Web;

namespace Covid_19_Sha2022.Helper
{
    public class HttpHelper
    {
        #region Member Fields
        private const string USERAGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36 Edg/100.0.1185.36";
        private const string ACCEPT = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9";
        private const string ACCEPTENCODING = "gzip, deflate";
        private const string ACCEPTLANGUAGE = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6";
        private const bool KEEPALIVE = true;
        private const string GET = "GET";
        public string Location = string.Empty;
        public bool HasProxy;
        public const string POSTCONTENTTYPE = "application/x-www-form-urlencoded";
        public const string GETCONTENTTYPE = "text/html;charset=UTF-8";
        public const string IMGCONTENTTYPE = "image/jpeg";
        private int refreshSecond = 200;
        #endregion

        #region 构造函数
        public HttpHelper()
        {
        }
        #endregion

        //解密
        private Stream Gzip(HttpWebResponse HWResp)
        {
            Stream stream1 = null;
            if (HWResp.ContentEncoding == "gzip")
            {
                stream1 = new GZipInputStream(HWResp.GetResponseStream());
            }
            else
            {
                if (HWResp.ContentEncoding == "deflate")
                {
                    stream1 = new InflaterInputStream(HWResp.GetResponseStream());
                }
            }
            if (stream1 == null)
            {
                return HWResp.GetResponseStream();
            }
            MemoryStream stream2 = new MemoryStream();
            int count = 0x800;
            byte[] buffer = new byte[0x800];
            goto A;
        A:
            count = stream1.Read(buffer, 0, count);
            if (count > 0)
            {
                stream2.Write(buffer, 0, count);
                goto A;
            }
            stream2.Seek((long)0, SeekOrigin.Begin);
            return stream2;
        }

        public string ReturnGetHtml(string strUrl, bool isAllowAutoRedirect,ref CookieContainer cookie, string referer,string host,bool isDelay)
        {
            if (isDelay)
            {
                System.Threading.Thread.Sleep(this.refreshSecond);
            }

            HttpWebRequest httpWebRequest = WebRequest.Create(strUrl) as HttpWebRequest;
            httpWebRequest.Accept = ACCEPT;
            httpWebRequest.Headers.Add("Accept-Encoding", ACCEPTENCODING);
            httpWebRequest.Headers.Add("Accept-Language", ACCEPTLANGUAGE);
            httpWebRequest.UserAgent = USERAGENT;

            httpWebRequest.Method = GET;
            httpWebRequest.KeepAlive = KEEPALIVE;
            httpWebRequest.Headers.Add("Accept-Language: zh-cn"); 
            httpWebRequest.CookieContainer = new CookieContainer();
            if (referer != string.Empty)
            {
                httpWebRequest.Referer = referer;
            }

            //httpWebRequest.ContentType = GETCONTENTTYPE;
            httpWebRequest.AllowAutoRedirect = isAllowAutoRedirect;

            HttpWebResponse httpWebResponse = httpWebRequest.GetResponse() as HttpWebResponse;

            Stream responseStream = Gzip(httpWebResponse);
            StreamReader streamReader = new StreamReader(responseStream, Encoding.GetEncoding("utf-8"));
            string returnHtml = streamReader.ReadToEnd();
            streamReader.Close();
            responseStream.Close();
            return returnHtml.Replace("\n", "").Replace("\r", "").Replace("\t", "").Replace("\"", "'").Replace("  ", "");
        }

    }
}

