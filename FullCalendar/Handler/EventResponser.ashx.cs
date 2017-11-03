using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace FullCalendar
{
    public class EventResponser : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {            
            DateTime start, end;
            if (!DateTime.TryParse(context.Request.QueryString["start"], out start) || !DateTime.TryParse(context.Request.QueryString["end"], out end))
                return;

            List<int> idList = new List<int>();
            List<JavascriptObject> eventList = new List<JavascriptObject>();

            foreach (DatabaseObject dbObj in FullCalendarCRUD.Get(start, end))
            {
                eventList.Add(new JavascriptObject
                {
                    id = dbObj.id,
                    title = dbObj.project,
                    start = String.Format("{0:s}", dbObj.startDate),
                    end = String.Format("{0:s}", dbObj.endDate),
                    allDay = dbObj.isAllDay,
                    color = "#C2189B"
                });
                idList.Add(dbObj.id);
            }

            context.Session["idList"] = idList;

            JavaScriptSerializer oSerializer = new JavaScriptSerializer();
            context.Response.Write(oSerializer.Serialize(eventList));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}