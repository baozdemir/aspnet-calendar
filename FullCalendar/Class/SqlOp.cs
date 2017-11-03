﻿using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace FullCalendar
{
    public class SqlOp
    {
        private SqlConnection con;
        private SqlCommand cmd;

        public SqlOp(string ConnectionService)
        {
            con = new SqlConnection(ConfigurationManager.ConnectionStrings[ConnectionService].ConnectionString);
        }

        private void OpenConnection()
        {
            if (con.State == ConnectionState.Closed)
                con.Open();
        }

        private void CloseConnection()
        {
            if (con.State == ConnectionState.Open)
                con.Close();
        }

        public string sOperation(string CommandText, SqlParameter[] parameters = null)
        {
            cmd = new SqlCommand(CommandText, con);
            if (parameters != null)
                cmd.Parameters.AddRange(parameters);
            OpenConnection();
            string objName = Convert.ToString(cmd.ExecuteScalar());
            cmd.Parameters.Clear();
            CloseConnection();
            return objName;
        }

        public void iudOperation(string CommandText, SqlParameter[] parameters)
        {
            cmd = new SqlCommand(CommandText, con);
            cmd.Parameters.AddRange(parameters);
            OpenConnection();
            cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
            CloseConnection();
        }

        public List<Dictionary<string, string>> multiSOperation(string CommandText, List<string> tableRowNames, SqlParameter[] parameters = null)
        {
            List<Dictionary<string, string>> mainList = new List<Dictionary<string, string>>();
            Dictionary<string, string> subList = new Dictionary<string, string>();
            OpenConnection();
            cmd = new SqlCommand(CommandText, con);
            if (parameters != null)
                cmd.Parameters.AddRange(parameters);
            SqlDataReader sdr = cmd.ExecuteReader();
            while (sdr.Read())
            {
                subList = new Dictionary<string, string>();
                foreach (string listItem in tableRowNames)
                    subList.Add(listItem, sdr[listItem].ToString());
                mainList.Add(subList);
            }
            CloseConnection();
            cmd.Parameters.Clear();
            return mainList;
        }
    }
}