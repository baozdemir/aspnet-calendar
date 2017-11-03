using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace FullCalendar
{
    public partial class _Default : System.Web.UI.Page
    {
        [System.Web.Services.WebMethod]
        public static int AddEvent(JavascriptObject jsObj)
        {
            DateTime ctrlDate;

            if (jsObj.id == null 
                || jsObj.id < 0 
                || string.IsNullOrEmpty(jsObj.start) 
                || string.IsNullOrEmpty(jsObj.end) 
                || string.IsNullOrEmpty(jsObj.title)
                || !DateTime.TryParse(jsObj.start, out ctrlDate)
                || !DateTime.TryParse(jsObj.end, out ctrlDate)
                ) return -1;

            DatabaseObject dbObj = new DatabaseObject()
            {
                project = jsObj.title,
                startDate = Convert.ToDateTime(jsObj.start),
                endDate = Convert.ToDateTime(jsObj.end),
                isAllDay = jsObj.allDay
            };

                int key = FullCalendarCRUD.Add(dbObj);
                List<int> idList = (List<int>)HttpContext.Current.Session["idList"];
                if (idList != null)
                {
                    idList.Add(key);
                    HttpContext.Current.Session["idList"] = idList;
                }

                return key;
        }

        [System.Web.Services.WebMethod(true)]
        public static int UpdateEvent(JavascriptObject jsObj)
        {
            DateTime ctrlDate;

            if (jsObj.id == null
                || jsObj.id < 0
                || string.IsNullOrEmpty(jsObj.start)
                || string.IsNullOrEmpty(jsObj.end)
                || !DateTime.TryParse(jsObj.start, out ctrlDate)
                || !DateTime.TryParse(jsObj.end, out ctrlDate)
                ) return -1;

            DatabaseObject dbObj = new DatabaseObject()
            {
                id = jsObj.id,
                project = jsObj.title,
                startDate = Convert.ToDateTime(jsObj.start),
                endDate = Convert.ToDateTime(jsObj.end),
                isAllDay = jsObj.allDay
            };

            List<int> idList = (List<int>)HttpContext.Current.Session["idList"];
            if (idList != null && idList.Contains(jsObj.id))
            {
                FullCalendarCRUD.Update(dbObj);
                return jsObj.id;
            }

            return -1;
        }

        [System.Web.Services.WebMethod(true)]
        public static int DeleteEvent(int id)
        {
            if (id == null || id < 0)
                return -1;

            List<int> idList = (List<int>)HttpContext.Current.Session["idList"];
            if (idList != null && idList.Contains(id))
            {
                FullCalendarCRUD.Delete(id);
                return id;
            }

            return -1;
        }
    }
}
