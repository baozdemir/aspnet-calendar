using System;
using System.Web;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace FullCalendar
{
    public class FullCalendarCRUD
    {
        private static SqlOp op = new SqlOp("ApplicationServices");
        private static SqlParameter[] prm;
        private static string query;

        public static List<DatabaseObject> Get(DateTime eventStart, DateTime eventEnd)
        {
            List<DatabaseObject> events = new List<DatabaseObject>();
            List<string> tableRowNames = new List<string>() { "event_id", "event_project", "event_start", "event_end", "event_isAllDay" };
            query = "SELECT event_id, event_project, event_start, event_end, event_isAllDay FROM tblEvents where event_start>=@event_start AND event_end<=@event_end";
            prm = new SqlParameter[2];
            prm[0] = new SqlParameter("@event_start", eventStart);
            prm[1] = new SqlParameter("@event_end", eventEnd);

            foreach (var subList in op.multiSOperation(query, tableRowNames, prm))
            {
                events.Add(new DatabaseObject()
                {
                    id = Convert.ToInt32(subList["event_id"]),
                    project = Convert.ToString(subList["event_project"]),
                    startDate = Convert.ToDateTime(subList["event_start"]),
                    endDate = Convert.ToDateTime(subList["event_end"]),
                    isAllDay = Convert.ToBoolean(subList["event_isAllDay"])
                });
            }
            return events;
        }

        public static int Add(DatabaseObject dbObject)
        {
            query = "INSERT INTO tblEvents(event_project, event_start, event_end, event_isAllDay) VALUES(@event_project, @event_start, @event_end, @event_isAllDay)";
            prm = new SqlParameter[4];
            prm[0] = new SqlParameter("@event_project", dbObject.project);
            prm[1] = new SqlParameter("@event_start", dbObject.startDate);
            prm[2] = new SqlParameter("@event_end", dbObject.endDate);
            prm[3] = new SqlParameter("@event_isAllDay", dbObject.isAllDay);
            op.iudOperation(query, prm);

            query = "SELECT max(event_id) FROM tblEvents where event_project=@event_project AND event_start=@event_start AND event_end=@event_end AND event_isAllDay=@event_isAllDay";
            return Convert.ToInt32(op.sOperation(query, prm));
        }

        public static void Update(DatabaseObject dbObject)
        {
            query = "UPDATE tblEvents SET event_start=@event_start, event_end=@event_end, event_isAllDay=@event_isAllDay ";
            if (!string.IsNullOrEmpty(dbObject.project))
            { 
                query += ", event_project=@event_project ";
                prm = new SqlParameter[5];
                prm[4] = new SqlParameter("@event_project", dbObject.project);
            }
            else
                prm = new SqlParameter[4];
            query += " WHERE event_id=@event_id";

            prm[0] = new SqlParameter("@event_id", dbObject.id);
            prm[1] = new SqlParameter("@event_start", dbObject.startDate);
            prm[2] = new SqlParameter("@event_end", dbObject.endDate);
            prm[3] = new SqlParameter("@event_isAllDay", dbObject.isAllDay);
            op.iudOperation(query, prm);
        }

        public static void Delete(int id)
        {
            query = "DELETE FROM tblEvents WHERE (event_id = @event_id)";
            prm = new SqlParameter[1] { new SqlParameter("@event_id", id) };
            op.iudOperation(query, prm);
        }
    }
}