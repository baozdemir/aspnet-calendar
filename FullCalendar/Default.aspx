<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="FullCalendar._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/themes/cupertino/jquery-ui.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.1.0/fullcalendar.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.min.css" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
    <style type="text/css">
        .ui-selectmenu-button.ui-button
        {
            text-align: center;
            width: 18em;
            height: 34px;
        }
        .ui-selectmenu-text
        {
            line-height: 220%;
        }
        .ui-selectmenu-icon.ui-icon
        {
            margin-top: 2.5px;
        }
        th, td
        {
            padding: 5px;
            text-align: left;
        }
        @media (max-width: 414px) {
            #calendar .fc-right {float:left;padding-top:20px;margin-bottom:30px;}
            #calendar .fc-center {font-size:7.5px;}
            #calendar .fc-title {font-size:7.5px;}
            #calendar .fc-toolbar h2 {font-size:24px;}
            #calendar .fc-day-header span{font-size:12px;}
        }
        @media (min-width: 415px) and (max-width: 768px) 
        {
            #calendar .fc-toolbar h2 {padding-top:20px;font-size:25px;}
            #calendar .fc-day-header span{font-size:11px;}
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </asp:ScriptManager>
    <div class="row" style="width:99.5%;margin-left:0.25%; margin-bottom:5%">
        <br />
        <br />
        <div class="col-md-10 col-md-offset-1">
            <div id="calendar">
            </div>
        </div>
    </div>
    <div id="updateDeleteModal" style="font: 70% 'Trebuchet MS', sans-serif; margin: 10px;
        display: none;">
        <table>
            <tr>
                <td>
                    Option:
                </td>
                <td style="line-height: 50%">
                    <select id="eventName">
                        <option>Option 1</option>
                        <option>Option 2</option>
                        <option>Option 3</option>
                    </select><br />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    Start:
                </td>
                <td>
                    <input name="dtpUpdateStartTime" id="dtpUpdateStartTime" type="text" class="tp form-control"
                        style="text-align: center; cursor: pointer;" placeholder="Select Date" />
                </td>
            </tr>
            <tr>
                <td>
                    End:
                </td>
                <td>
                    <input type="text" name="dtpUpdateEndTime" id="dtpUpdateEndTime" class="tp form-control"
                        style="text-align: center; cursor: pointer;" placeholder="Select Date" />
                </td>
            </tr>
        </table>
        <input type="hidden" id="eventId" />
    </div>
    <div id="addModal" style="font: 70% 'Trebuchet MS', sans-serif; margin: 10px;">
        <table>
            <tr>
                <td>
                    Option:
                </td>
                <td style="line-height: 50%">
                    <select id="addEventName">
                        <option>Option 1</option>
                        <option>Option 2</option>
                        <option>Option 3</option>
                    </select>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    Start
                </td>
                <td>
                    <input type="text" name="addEventStartDatePicker" id="addEventStartDatePicker" class="tp form-control"
                        style="text-align: center; cursor: pointer; height: 34px;" placeholder="Select Date" />
                </td>
            </tr>
            <tr>
                <td>
                    End
                </td>
                <td>
                    <input type="text" name="addEventEndDatePicker" id="addEventEndDatePicker" class="tp form-control"
                        style="text-align: center; cursor: pointer;" placeholder="Select Date" />
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.17.1/moment.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-ui-timepicker-addon/1.6.3/jquery-ui-timepicker-addon.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.1.0/fullcalendar.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
    <script type="text/javascript" src="/Assets/isMobile.js"></script>
    <script type="text/javascript">

        $('.tp').datetimepicker({
            timezone: 0,
            dateFormat: "yy-mm-dd",
            controlType: 'select',
            oneLine: true,
            text: false
        });

        var copyKey = false;
        $(document).keydown(function (e) {
            copyKey = e.shiftKey;
        }).keyup(function () {
            copyKey = false;
        });

        //for Update, click event (n:eventClick) =>  set function (n:eventToAdd) (using for to transfer values ​​between functions)
        var currentUpdateEvent;

        //page methods returns function, retVal -1 means error on code behind
        function RetFunc(retVal) {
            if (retVal == -1)
                alert("operations failed id..: " + retVal);
            if (retVal != -1) {
                //alert(" operations success id..: " + retVal);
                $('#calendar').fullCalendar('refetchEvents');
            }
        }

        function CtrlAllDay(startDate, endDate) {
            var dateStart = new Date(startDate);
            var dateStop = new Date(endDate);
            var allDay;
            if (dateStart.getHours() == "0" && dateStart.getMinutes() == "0" && dateStop.getHours() == "0" && dateStop.getMinutes() == "0") {
                allDay = true;
            }
            else {
                allDay = false;
            }
            return allDay;
        }

        function OnSelect_AddEvent(start, end, allDay) {
            $("#addEventName").selectmenu();
            $('#addModal').dialog('open');
            $('#addEventStartDatePicker').datetimepicker('setDate', new Date(start));
            $('#addEventEndDatePicker').datetimepicker('setDate', new Date(end));
        }

        function OnClick_UpdateEvent(event, element) {
            currentUpdateEvent = event;
            $('#updateDeleteModal').dialog('open');
            $("#eventName").val(event.title);
            $("#eventName").selectmenu().selectmenu('refresh', true);
            $("#eventId").val(event.id);
            $('#dtpUpdateStartTime').datetimepicker('setDate', new Date(event.start));

            if (event.end === null) {
                $("#dtpUpdateEndTime").text("");
            }
            else {
                $('#dtpUpdateEndTime').datetimepicker('setDate', new Date(event.end));
            }
        }

        function EventDropped(event, dayDelta, minuteDelta, allDay, revertFunc) {
            UpdateEventOnDropAndResize(event);
        }

        function EventResized(event, dayDelta, minuteDelta, revertFunc) {
            UpdateEventOnDropAndResize(event);
        }

        var eClone=null;
        function UpdateEventOnDropAndResize(event) {

            var eventToUpdate = {
                id: event.id,
                start: event.start,
                end: event.end,
                allDay: event.allDay
            };

            if (event.end == null) {
                if (eventToUpdate.allDay) {
                    var date = new Date(eventToUpdate.start.toJSON());
                    date.setDate(date.getDate() + 1);
                    eventToUpdate.end = date;
                }
                else {
                    var date = new Date(eventToUpdate.start.toJSON());
                    date.setHours(date.getHours() + 2)
                    eventToUpdate.end = date;
                }

            }

            eventToUpdate.start = eventToUpdate.start.toJSON();
            eventToUpdate.end = eventToUpdate.end.toJSON(); //endDate;
            eventToUpdate.allDay = event.allDay;

            PageMethods.UpdateEvent(eventToUpdate, RetFunc);
            if(eClone != null)
                PageMethods.AddEvent(eClone, RetFunc);
            eClone = null;
        }

        function SetEClone (event, jsEvent, ui, view) {
            if (copyKey) { //shift
                eClone = {
                    title: event.title,
                    start: event.start.toJSON(),
                    end: event.end.toJSON(),
                    allDay: event.allDay
                };
            }
        }

        function MobileDraggable(event, element, view) {
            if (isMobile(navigator.userAgent || navigator.vendor || window.opera)) {
                element.draggable();
            }
        }

        $(document).ready(function () {
            $('#updateDeleteModal').dialog({
                autoOpen: false,
                width: 300,
                buttons: {
                    "update": function () {
                        var eventToUpdate = {
                            id: currentUpdateEvent.id,
                            title: $("#eventName").val(),
                            start: $('#dtpUpdateStartTime').val(),
                            end: $('#dtpUpdateEndTime').val(),
                            allDay: CtrlAllDay($('#dtpUpdateStartTime').val(), $('#dtpUpdateEndTime').val())
                        };
                        $(this).dialog("close");
                        //$('#calendar').fullCalendar('removeEvents', currentUpdateEvent.id);
                        //$("#calendar").fullCalendar('renderEvent', eventToUpdate);
                        PageMethods.UpdateEvent(eventToUpdate, RetFunc);

                    },
                    "delete": function () {
                        if (confirm("Are you sure for deleting ?")) {
                            $(this).dialog("close");
                            //$('#calendar').fullCalendar('removeEvents', $("#eventId").val());
                            PageMethods.DeleteEvent($("#eventId").val(), RetFunc);
                        }
                    }
                }
            });

            $('#addModal').dialog({
                autoOpen: false,
                width: 300,
                modal: true,
                buttons: {
                    "Add": function () {
                        var eventToAdd = {
                            //id: Math.floor((Math.random() * 100) + 1), // Because the deletion is done by the ID (not safe, used for illustrative purposes)
                            title: $("#addEventName").val(),
                            start: $('#addEventStartDatePicker').val(),
                            end: $('#addEventEndDatePicker').val(),
                            allDay: CtrlAllDay($('#addEventStartDatePicker').val(), $('#addEventEndDatePicker').val())
                        };
                        //$("#calendar").fullCalendar('renderEvent', eventToAdd, true);
                        PageMethods.AddEvent(eventToAdd, RetFunc);
                        $(this).dialog("close");
                    }
                }
            });

            $('.fc-view tbody').draggable();
            $('#calendar').fullCalendar({
                theme: true,
                header: {
                    left: 'prev,next today, addEventButton',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay, redirectToAdmin'
                },
                customButtons: {
                    addEventButton: {
                        text: 'Add Event',
                        click: function () {
                            $("#addEventName").selectmenu();
                            $('#addModal').dialog('open');
                        }
                    },
                    redirectToAdmin: {
                        text: 'Admin Panel',
                        click: function () {
                        }
                    }
                },
                defaultView: 'agendaWeek',
                eventClick: OnClick_UpdateEvent,
                selectable: true,
                selectHelper: true,
                editable: true,
                select: OnSelect_AddEvent,
                editable: true,
                events: 'Handler/EventResponser.ashx',
                eventDrop: EventDropped,
                eventResize: EventResized,
                eventAfterRender: MobileDraggable,
                eventDragStart: SetEClone
            });
        });
    </script>
</asp:Content>
