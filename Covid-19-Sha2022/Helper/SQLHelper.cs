using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace Covid_19_Sha2022.Helper
{
    public class SQLHelper
    {
        string strSqlConn = @"server=.\sql2017;database=Covid19_SHA;Trusted_Connection=SSPI";
        public SQLHelper()
        {
        }

        public int ExecuteNonQuery(string strSql)
        {
            using SqlConnection conn = new SqlConnection(strSqlConn);
            using (SqlCommand comm = conn.CreateCommand())
            {
                conn.Open();
                comm.CommandText = strSql;
                int no = 0;
                no = comm.ExecuteNonQuery();
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
                return no;
            }
        }

        public DataSet ExecuteDataset(string strSql)
        {
            using (SqlConnection conn = new SqlConnection(strSqlConn))
            {
                using (SqlCommand comm = conn.CreateCommand())
                {
                    conn.Open();
                    comm.CommandText = strSql;
                    DataSet ds = new DataSet();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(comm))
                    {
                        adapter.Fill(ds);
                    }
                    if (conn.State == ConnectionState.Open)
                    {
                        conn.Close();
                    }
                    return ds;
                }
            }
        }
    }
}
