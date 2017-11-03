# aspnet-calendar

When I started learning the web, it was one of my studies, I might need new friends.  

This event calendar implements JQuery [FullCalendar](http://fullcalendar.io/) in ASP.NET.
It's work only mssql but it is quite simple to evolve into others.  
If you want work you just need to do  change [SqlOp.cs](https://github.com/baozdemir/aspnet-calendar/blob/master/FullCalendar/Class/SqlOp.cs).
Actually this is a [fork](https://github.com/esausilva/ASP.Net-EventCalendar) counted.

### Features

* Can runnable for all devices
* Responsive for all devices
* Fullsize option
* Create single day events
* Create multiple day events
* Create all day events
* Update existing events
* Drag & Drop events
* Rezise events
* Clone events
* Delete events

### Libraries

* [FullCalendar 3.1.0](https://fullcalendar.io/)

### Installation
To open the project sln and run.

### Requirements
* [MSSQL Express](https://www.microsoft.com/en-us/sql-server/sql-server-editions-express)

### Configuration
* [DB](https://github.com/baozdemir/aspnet-calendar/blob/master/FullCalendar/Web.config)

### Mssql database Table Format

|column_name|column_type|
|-----------|---------|
|id|int [identity]|
|project|varchar(255)|
|description|varchar(255)|
|startDate|DateTime|
|endDate|DateTime|
|isAllDay|Bit|

## Preview

### Web

1- Adding Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/1-web-adding-event.gif" height="480" width="840"><br><br>
2- Drag & Drop Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/2-web-moving-event.gif" height="480" width="840"><br><br>
3- Resize Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/3-web-moving-event(optional).gif" height="480" width="840"><br><br>
4- Cloning Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/4-web-cloning-event.gif" height="480" width="840"><br><br>
5- Deleting Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/5-web-deleteting-event.gif" height="480" width="840"><br><br>

### Mobile  
1 Adding Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/1-mobil-adding-event.gif" height="600" width="300"><br><br>
2- Editing Event Event <br><br>
<img src="https://github.com/baozdemir/aspnet-calendar/blob/master/guide_gif/2-mobil-editing-event.gif" height="600" width="300"><br><br>
