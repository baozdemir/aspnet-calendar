using System;

namespace FullCalendar
{
    public class DatabaseObject
    {
        public int id { get; set; }
        public string project { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public bool isAllDay { get; set; }
    }
}