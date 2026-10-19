#!/usr/bin/env python3
# vim:ts=4:sts=4:sw=4:tw=80:et

from datetime import datetime, date, time, timedelta

import argparse
import fcntl
import os
import sqlite3
import sys
import random

sqlite3.register_adapter(datetime, lambda value: value.isoformat(' '))
sqlite3.register_converter('timestamp',
                           lambda value: datetime.fromisoformat(value.decode()))

ACT_ARRIVE = 'arrive'
ACT_BREAK = 'break'
ACT_RESUME = 'resume'
ACT_LEAVE = 'leave'


MSG_ERR_NOT_WORKING = 1 << 0
MSG_ERR_HAVE_NOT_LEFT = 1 << 1
MSG_ERR_NOT_BREAKING = 1 << 2
MSG_SUCCESS_ARRIVAL = 1 << 3
MSG_SUCCESS_BREAK = 1 << 4
MSG_SUCCESS_RESUME = 1 << 5
MSG_SUCCESS_LEAVE = 1 << 6


WEEK_HOURS = 40


class ProgramAbortError(Exception):
    """
    Exception class that wraps a critical error and encapsules it for
    pretty-printing of the error message.
    """
    def __init__(self, message, cause):
        self.message = message
        self.cause = cause

    def __str__(self):
        if self.cause is not None:
            return "Error: {}\n       {}".format(self.message, self.cause)
        else:
            return "Error: {}".format(self.message)


def message(msg):
    """
    Print an informational message
    """
    print(msg)


def warning(msg):
    """
    Print a warning message
    """
    print("Warning: {}".format(msg), file=sys.stderr)


def error(msg, ex):
    """
    Print an error message and abort execution
    """
    raise ProgramAbortError(msg, ex)


def randomMessage(type, *args):
    messageList = []

    ###########
    # Arrival #
    ###########
    if type == MSG_SUCCESS_ARRIVAL:
        if len(args) > 0:
            arrivalTime = args[0]
            if arrivalTime.hour <= 7:
                messageList.append("The early bird catches the worm. Welcome"
                                   " and have a nice day!")
            elif arrivalTime.hour <= 9:
                messageList.append("Good morning.")
            elif arrivalTime.hour >= 10:
                messageList.append("Coming in late today? Have fun working"
                                   " anyway.")

            if arrivalTime.weekday() == 0:  # Monday
                messageList.append("Have a nice start into the fresh week!")
                messageList.append("New week, new luck!")
            elif arrivalTime.weekday() == 4:  # Friday
                messageList.append("Last day of the week! Almost done! Keep "
                                   " going!")
                messageList.append("Just a couple more hours until weekend."
                                   " Have fun!")
            elif arrivalTime.weekday() == 5:  # Saturday
                messageList.append("Oh, so they made you work on Saturday? I'm"
                                   " sorry :/")
                messageList.append("Saturday, meh. Hang in there, it'll be"
                                   " over soon.")

        messageList.append("Welcome and have a nice day!")

    #########
    # Break #
    #########
    elif type == MSG_SUCCESS_BREAK:
        breakTime = None
        workStartTime = None
        if len(args) > 0:
            breakTime = args[0]
        if len(args) > 1:
            workStartTime = args[1]

        if breakTime is not None and workStartTime is not None:
            duration = breakTime - workStartTime
            durationHours = int(duration.total_seconds() // 3600)
            durationMinutes = int(
                (duration.total_seconds() - (durationHours * 3600)) // 60)
            msgText = ""
            if durationHours > 1:
                msgText += "{:d} hours".format(durationHours)
            elif durationHours == 1:
                msgText += "{:d} hour".format(durationHours)

            # avoid 1 hour 2 minutes
            if durationHours > 0 and durationMinutes > 2: 
                msgText += " and "

            if durationHours == 0 or durationMinutes > 2:
                if durationMinutes > 1:
                    msgText += "{:02d} minutes".format(durationMinutes)
                else:
                    msgText += "{:02d} minutes".format(durationMinutes)

            msgText += " of work."

            # more than 4h, time for a break
            if duration.total_seconds() >= 4 * 60 * 60: 
                msgText += " Time for a well-deserved break."
            else:
                msgText += " I guess a coffee break wouldn't hurt, would it?"

            messageList.append(msgText)

        if breakTime is not None:
            if breakTime.hour >= 11 and breakTime.hour <= 13:
                messageList.append("{:%H:%M}. A good time for lunch.".format(
                    breakTime))
            if breakTime.hour < 11:
                messageList.append("{0.hour} o'clock. Breakfast time!".format(
                    breakTime))
            if breakTime.hour > 13:
                messageList.append("Coffee?")
                messageList.append("Good idea, take a break and relax a"
                                   " little.")

        messageList.append("Enjoy your break!")
        messageList.append("Relax a little and all your problems will have"
                           " gotten simpler once you're back :-)")
        messageList.append("Bye bye!")

    ################
    # End of break #
    ################
    elif type == MSG_SUCCESS_RESUME:
        resumeTime = None
        breakStartTime = None
        if len(args) > 0:
            resumeTime = args[0]
        if len(args) > 1:
            breakStartTime = args[1]

        if resumeTime is not None:
            if resumeTime.hour <= 12:
                messageList.append("With renewed vigour into the rest of the"
                                   " day! Welcome back.")
                messageList.append("The rest of the day right ahead, but with"
                                   " fresh strength.")
            elif resumeTime.hour >= 15:
                messageList.append("Just a few more hours. Hang in, closing"
                                   " time is near!")
                messageList.append("Almost there. Just a few more minutes.")

        if resumeTime is not None and breakStartTime is not None:
            duration = resumeTime - breakStartTime
            durationMinutes = int(duration.total_seconds() // 60)

            msgText = "{:d}".format(durationMinutes)
            if durationMinutes != 1:
                msgText += " minutes"
            else:
                msgText += " minute"
            msgText += " break. Welcome back and have fun with the rest of"
            msgText += " your day."
            messageList.append(msgText)

            if durationMinutes < 30:
                messageList.append("Quick coffee break finished? Back to work,"
                                   " getting things done!")
                messageList.append("That break certainly was a quick one!"
                                   " Welcome back!")
            elif durationMinutes >= 30 and durationMinutes < 45:
                messageList.append("Average size break, now back to work.")
            else:
                messageList.append("That was a pretty long break. You can pull"
                                   " off more then 9 hours today.")
                messageList.append("Pretty extensive {:d} minute break. Hope"
                                   " you're feeling refreshed now :)".format(
                                       durationMinutes))

        messageList.append("Welcome back at your desk. Your laptop has been"
                           " missing you.")
        messageList.append("Back into work! Enjoy!")
        messageList.append("Welcome back.")

    ###################
    # End of work day #
    ###################
    elif type == MSG_SUCCESS_LEAVE:
        endTime = None
        if len(args) > 0:
            endTime = args[0]

        if endTime is not None:
            if endTime.hour <= 14:
                messageList.append("Going home early today? Go ahead, I'm sure"
                                   " you earned it.")
                messageList.append("Short work day, enjoy your afternoon.")
            elif endTime.hour > 14 and endTime.hour < 18:
                messageList.append("Have a nice evening.")
                messageList.append("Bon appetit and enjoy your evening!")
            else:
                messageList.append("Leaving late today?")
                messageList.append("Did you just stay because the job was"
                                   " interesting or did something have to get"
                                   " done today?")
                messageList.append("Finally. Have a good night's sleep!")
            if endTime.weekday() == 4:  # Friday
                messageList.append("Friday! Have a nice weekend!")
                messageList.append("Finally, this week has come to an end.")
                messageList.append("Fuck this shit, it's Friday and I'm going"
                                   " home!")
            elif endTime.weekday() == 5:  # Saturday
                messageList.append("Ugh, somebody made you come in on"
                                   " Saturday. Enjoy your Sunday then.")
                messageList.append("About time the week was over, isn't it?")

        messageList.append("A good time to leave. Because it's always a good"
                           " time to do that. :)")
        messageList.append("You're right, go home. Tomorrow's yet another"
                           " day.")

    ######################################################################
    # Not currently working even though the requested action requires it #
    ######################################################################
    elif type == MSG_ERR_NOT_WORKING:
        msg = ("You can't leave or take a break if you're not here in the"
               " first place.")
        if len(args) > 0:
            if args[0] == ACT_BREAK:
                msg += " You are currently taking a break."
            elif args[0] == ACT_LEAVE:
                msg += " According to my data, you're still at home."
        messageList.append(msg)

    ####################################################################
    # Not currently taking a break even though you requested to resume #
    ####################################################################
    elif type == MSG_ERR_NOT_BREAKING:
        msg = ("You can't continue working if you're not currently taking"
               " a break.")
        if len(args) > 0:
            if args[0] in [ACT_ARRIVE, ACT_RESUME]:
                msg += " My data says you're here and working."
            elif args[0] == ACT_LEAVE:
                msg += " According to my data, you're still at home."
        messageList.append(msg)

    ################################################
    # Not at home, but requested to start your day #
    ################################################
    elif type == MSG_ERR_HAVE_NOT_LEFT:
        msg = "You cannot start your day when you're already (or still?) here."
        if len(args) > 0:
            if args[0] in [ACT_ARRIVE, ACT_RESUME]:
                msg += " My data says you're here and working."
            elif args[0] == ACT_BREAK:
                msg += " It seems you're taking a break."
        messageList.append(msg)

    return random.choice(messageList)


def databasePath():
    return os.path.expanduser(os.environ.get(
        'TIMETRACK_DB', '~/.local/share/timetrack/timetrack.db'))


def dbSetup():
    """
    Create a new SQLite database in the user's home, creating and initializing
    the database if it doesn't exist. Returns an sqlite3 connection object.
    """
    path = databasePath()
    os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
    con = sqlite3.connect(path, detect_types=sqlite3.PARSE_DECLTYPES)
    con.row_factory = sqlite3.Row

    dbVersion = con.execute("PRAGMA user_version").fetchone()['user_version']
    if dbVersion == 0:
        # database is uninitialized, create the tables we need
        con.execute("BEGIN EXCLUSIVE")
        if con.execute("PRAGMA user_version").fetchone()[0] == 0:
            con.execute("""
                CREATE TABLE times (
                      type TEXT NOT NULL CHECK (
                           type == "{}"
                        OR type == "{}"
                        OR type == "{}"
                        OR type == "{}")
                    , ts TIMESTAMP NOT NULL
                    , PRIMARY KEY (type, ts)
                )
            """.format(ACT_ARRIVE, ACT_BREAK, ACT_RESUME, ACT_LEAVE))
            con.execute("PRAGMA user_version = 1")
        con.commit()
    # database upgrade code would go here

    return con


def addEntry(con, type, ts):
    con.execute("INSERT INTO times (type, ts) VALUES (?, ?)", (type, ts))
    con.commit()


def getLastType(con):
    cur = con.execute("SELECT type FROM times ORDER BY ts DESC, rowid DESC LIMIT 1")
    row = cur.fetchone()
    if row is None:
        return None
    return row['type']


def getLastTime(con):
    cur = con.execute("SELECT ts FROM times ORDER BY ts DESC, rowid DESC LIMIT 1")
    row = cur.fetchone()
    if row is None:
        return None
    return row['ts']


def startTracking(con):
    """
    Start your day: Records your arrival time in the morning.
    """
    # Make sure you're not already at work.
    lastType = getLastType(con)
    if lastType is not None and lastType != ACT_LEAVE:
        error(randomMessage(MSG_ERR_HAVE_NOT_LEFT), None)

    arrivalTime = datetime.now()
    addEntry(con, ACT_ARRIVE, arrivalTime)
    message(randomMessage(MSG_SUCCESS_ARRIVAL, arrivalTime))


def suspendTracking(con):
    """
    Suspend tracking for today: Records the start of your break time. There can
    be an infinite number of breaks per day.
    """

    # Make sure you're currently working; can't suspend if you weren't even
    # working
    lastType = getLastType(con)
    lastTime = getLastTime(con)
    if lastType not in [ACT_ARRIVE, ACT_RESUME]:
        error(randomMessage(MSG_ERR_NOT_WORKING, lastType), None)

    breakTime = datetime.now()
    addEntry(con, ACT_BREAK, breakTime)
    message(randomMessage(MSG_SUCCESS_BREAK, breakTime, lastTime))


def resumeTracking(con):
    """
    Resume tracking after a break. Records the end time of your break. There
    can be an infinite number of breaks per day.
    """

    # Make sure you're currently taking a break; can't resume if you were not
    # taking a break
    lastType = getLastType(con)
    lastTime = getLastTime(con)
    if lastType != ACT_BREAK:
        error(randomMessage(MSG_ERR_NOT_BREAKING, lastType), None)

    resumeTime = datetime.now()
    addEntry(con, ACT_RESUME, resumeTime)
    message(randomMessage(MSG_SUCCESS_RESUME, resumeTime, lastTime))


def endTracking(con):
    """
    End tracking for the day. Records the time of your leave.
    """
    # Make sure you've actually been at work. Can't leave if you're not even
    # here!
    lastType = getLastType(con)
    if lastType not in [ACT_ARRIVE, ACT_RESUME, ACT_BREAK]:
        error(randomMessage(MSG_ERR_NOT_WORKING, lastType), None)

    leaveTime = datetime.now()
    addEntry(con, ACT_LEAVE, leaveTime)
    message(randomMessage(MSG_SUCCESS_LEAVE, leaveTime))


def getEntries(con, d):
    return con.execute("SELECT type, ts FROM times WHERE ts >= ? AND ts < ? "
                       "ORDER BY ts, rowid",
                       (datetime.combine(d, time()),
                        datetime.combine(d + timedelta(days=1), time())))


def getWorkIntervals(con, now=None):
    """Read work intervals, ending an unfinished interval at the current time."""
    now = now or datetime.now()
    intervals = []
    start = None
    for type, ts in con.execute("SELECT type, ts FROM times WHERE ts <= ? "
                                "ORDER BY ts, rowid", (now,)):
        if type in [ACT_ARRIVE, ACT_RESUME]:
            if start is None:
                start = ts
        elif start is not None:
            intervals.append((start, ts))
            start = None
    if start is not None:
        intervals.append((start, now))
    return intervals, start is not None


def workTime(intervals, start, end):
    """Count only the portions of work intervals inside [start, end)."""
    return sum((max(timedelta(0), min(b, end) - max(a, start))
                for a, b in intervals), timedelta(0))


def getWorkTimeForDay(con, d=None, now=None):
    now = now or datetime.now()
    d = d or now.date()
    start = datetime.combine(d, time())
    intervals, active = getWorkIntervals(con, now)
    total = workTime(intervals, start, start + timedelta(days=1))
    if not total and getEntries(con, d).fetchone() is None:
        error("There are no work entries on {:%d.%m.%Y}".format(d), None)
    return active and d == now.date(), total


def dayStatistics(con, offset=0):
    targetDay = date.today() + timedelta(days=offset)
    currentlyHere, totalTime = getWorkTimeForDay(con, targetDay)
    message("Time tracking entries for {:%d.%m.%Y}:".format(targetDay))
    for type, ts in getEntries(con, targetDay):
        message("  {:<10} {:%d.%m.%Y %H:%M}".format(type, ts))

    if currentlyHere:
        message("You are currently at work.")
    message("You have worked {} h {} min".format(
        int(totalTime.total_seconds() // (60 * 60)),
        int((totalTime.total_seconds() % 3600) // 60)))


def weekStatistics(con, offset=0):
    today = date.today()
    startOfWeek = (today - timedelta(days=today.weekday()) +
                   timedelta(weeks=offset))
    endOfWeek = min(today + timedelta(days=1),
                    startOfWeek + timedelta(weeks=1))
    message("Statistics for week {:>02d}:".format(
        startOfWeek.isocalendar()[1]))

    current = startOfWeek
    dailyHours = timedelta(hours=float(WEEK_HOURS) / 5.0)
    weekTotal = timedelta(seconds=0)
    extraHours = timedelta(seconds=0)
    daysSoFar = 0

    headerPrinted = False
    currentlyHere = False

    while current < endOfWeek:
        try:
            currentlyHere, timeForDay = getWorkTimeForDay(con, current)
            daysSoFar += 1
            totalHours = int(timeForDay.total_seconds() // (60 * 60))
            totalMinutes = int((timeForDay.total_seconds() % 3600) // 60)

            timedeltaForDay = timeForDay - dailyHours
            timedeltaHours = timedeltaForDay.total_seconds() / (60 * 60)

            weekTotal += timeForDay
            extraHours += timedeltaForDay

            if not headerPrinted:
                headerPrinted = True
                message("   date         hours         diff ")
                message("  ----------   -----------   ------")
            message("  {:%d.%m.%Y}   {:>2d} h {:>02d} min    {: =+1.2f}"
                    .format(current, totalHours, totalMinutes, timedeltaHours))
        except ProgramAbortError as pae:
            if current.weekday() < 5:
                # For non-weekend days, print a message
                if not headerPrinted:
                    headerPrinted = True
                    message("   date         hours         diff ")
                    message("  ----------   -----------   ------")
                message("  {:%d.%m.%Y}    -              -".format(current))

        current += timedelta(days=1)

    weekTotalHours = int(weekTotal.total_seconds() // (60 * 60))
    weekTotalMinutes = int((weekTotal.total_seconds() % 3600) // 60)
    weekExtraHours = extraHours.total_seconds() / (60 * 60)
    message("  ----------   -----------   ------")

    if daysSoFar < 5:
        # The week isn't over, compare your current state against the ideal
        # rate
        expectation = dailyHours * daysSoFar
        expectationHours = int(expectation.total_seconds() // (60 * 60))
        expectationMinutes = int((expectation.total_seconds() % 3600) // 60)
        message("   Expected:   {:>2d} h {:>02d} min"
                .format(expectationHours, expectationMinutes))
    message("    Week {:>02d}:   {:>2d} h {:>02d} min    {: =+2.2f}"
            .format(startOfWeek.isocalendar()[1], weekTotalHours,
                    weekTotalMinutes, weekExtraHours))
    if daysSoFar < 5 or (daysSoFar == 5 and currentlyHere):
        # Calculate avg. remaining work time per day
        totalExpectation = timedelta(hours=WEEK_HOURS)
        remaining = totalExpectation - weekTotal
        remainingHours = int(remaining.total_seconds() // (60 * 60))
        remainingMinutes = int((remaining.total_seconds() % 3600) // 60)
        message("  ----------   -----------   ------")
        message("  Remaining:   {:>2d} h {:>02d} min"
                .format(remainingHours, remainingMinutes))
        if daysSoFar < 4:
            # Remaining per day
            remainingPerDay = remaining / (5 - daysSoFar)
            remainingPerDayHours = int(
                remainingPerDay.total_seconds() // (60 * 60))
            remainingPerDayMinutes = int(
                (remainingPerDay.total_seconds() % 3600) // 60)
            message("      Daily:   {:>2d} h {:>02d} min"
                    .format(remainingPerDayHours, remainingPerDayMinutes))

def monthStart(d, offset=0):
    year, month = divmod(d.year * 12 + d.month - 1 + offset, 12)
    return datetime(year, month + 1, 1)


def periodStatistics(con, start, end, advance, dateFormat, label):
    now = datetime.now()
    intervals, active = getWorkIntervals(con, now)
    end = min(end, now) if end is not None else now
    message(label + ":")
    current = start
    total = timedelta(0)
    while current < end:
        following = advance(current)
        duration = workTime(intervals, current, min(following, end))
        total += duration
        hours, minutes = divmod(int(duration.total_seconds()) // 60, 60)
        message("  {}   {:>4d} h {:02d} min".format(
            current.strftime(dateFormat), hours, minutes))
        current = following
    hours, minutes = divmod(int(total.total_seconds()) // 60, 60)
    message("  Total: {} h {:02d} min".format(hours, minutes))
    if active and start <= now == end:
        message("You are currently at work; the total includes time so far.")


def monthStatistics(con, offset=0):
    start = monthStart(date.today(), offset)
    periodStatistics(con, start, monthStart(start, 1),
                     lambda d: d + timedelta(days=1), "%d.%m.%Y",
                     "Statistics for month {:%Y-%m}".format(start))


def yearStatistics(con, offset=0):
    start = datetime(date.today().year + offset, 1, 1)
    periodStatistics(con, start, datetime(start.year + 1, 1, 1),
                     lambda d: monthStart(d, 1), "%Y-%m",
                     "Statistics for year {}".format(start.year))


def allStatistics(con):
    first = con.execute("SELECT ts FROM times ORDER BY ts, rowid LIMIT 1").fetchone()
    start = datetime(first['ts'].year if first else date.today().year, 1, 1)
    periodStatistics(con, start, None,
                     lambda d: datetime(d.year + 1, 1, 1), "%Y",
                     "All-time statistics")


def main(argv=None):
    parser = argparse.ArgumentParser(description='Track your work time')
    commands = parser.add_subparsers(title='subcommands', dest='action',
                                    help='description', metavar='action')
    actions = {
        'morning': (startTracking, 'Start a new day', None, []),
        'break': (suspendTracking, 'Take a break from working', None, []),
        'resume': (resumeTracking, 'Resume working', None, ['continue']),
        'closing': (endTracking, 'End your work day', None, []),
        'day': (dayStatistics, 'Print daily statistics', 'days', []),
        'week': (weekStatistics, 'Print weekly statistics', 'weeks', []),
        'month': (monthStatistics, 'Print monthly statistics', 'months',
                  ['monthly']),
        'year': (yearStatistics, 'Print yearly statistics', 'years', ['yearly']),
        'all': (allStatistics, 'Print all-time statistics', None, ['all-time'])
    }
    for name, (handler, helpText, unit, aliases) in actions.items():
        sub = commands.add_parser(name, help=helpText, aliases=aliases)
        sub.set_defaults(handler=handler)
        if unit:
            sub.add_argument('offset', nargs='?', default=0, type=int,
                             help='Offset in {} from the current period '
                                  '(e.g. -1 for the previous one).'.format(unit))
    args = parser.parse_args(argv)
    if not hasattr(args, 'handler'):
        parser.print_help()
        return 1

    connection = None
    lock = None
    try:
        if args.handler in (startTracking, suspendTracking, resumeTracking,
                            endTracking):
            path = os.path.realpath(databasePath())
            os.makedirs(os.path.dirname(path), exist_ok=True)
            lock = open(path + '.lock', 'a')
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                error("Another timer or tracking command controls this "
                      "database. Stop it before changing the session.", None)
        connection = dbSetup()
        extraArgs = {'offset': args.offset} if hasattr(args, 'offset') else {}
        args.handler(connection, **extraArgs)
        return 0
    except (ProgramAbortError, sqlite3.Error, OSError, ValueError) as e:
        print(str(e), file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print(file=sys.stderr)
        return 255
    finally:
        if connection is not None:
            connection.close()
        if lock is not None:
            lock.close()


if __name__ == '__main__':
    sys.exit(main())
