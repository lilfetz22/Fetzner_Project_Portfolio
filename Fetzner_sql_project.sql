/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
-- 5 facilities do:
SELECT COUNT( name )
FROM `Facilities`
WHERE `membercost` >0


-- In order to see which ones do: Tennis Courts 1 & 2, Massage Room 1&2, and the Squash Court
SELECT name, membercost
FROM `Facilities`
WHERE `membercost` >0

/* Q2: How many facilities do not charge a fee to members? */
-- 4 facilities do not
SELECT COUNT( name )
FROM `Facilities`
WHERE `membercost` =0


-- in order to see which do not: Badminton Court, Table Tennis, Snooker Table, and the Pool Table
SELECT name, membercost
FROM `Facilities`
WHERE `membercost` =0



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
-- All facilities that charge a fee charge less than 20% of the facililites monthly maintenance cost.
SELECT facid, name, membercost, monthlymaintenance
FROM `Facilities`
WHERE `membercost` >0
AND membercost < ( .2 * monthlymaintenance )
LIMIT 30 

-- To find out how much each charges in relation to how much the monthly cost is:
SELECT facid, 
name, 
membercost, 
monthlymaintenance, 
((membercost / monthlymaintenance) *100) AS percent_charged
FROM `Facilities`
WHERE `membercost` >0
AND membercost < ( .2 * monthlymaintenance ) 

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT *
FROM `Facilities`
WHERE name LIKE '%2'

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance >100
THEN 'expensive'
WHEN monthlymaintenance <100
THEN 'cheap'
ELSE NULL
END AS label
FROM `Facilities`
LIMIT 0 , 30

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
-- First I sorted the data with the joindate in descending order
SELECT firstname, surname, joindate
FROM `Members`
ORDER BY 3 DESC 

-- Then I used the Where operator to filter out just Darren Smith

SELECT firstname, surname
FROM `Members`
WHERE joindate LIKE '2012-09-26%'


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT concat( m.firstname, ' ', m.surname, ' ', f.name ) AS mem_fac_name
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
JOIN Members AS m ON b.memid = m.memid
WHERE f.name LIKE 'Tennis Court%'
GROUP BY 1


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name, concat( m.firstname, ' ', m.surname ) AS mem_full_name,
CASE WHEN m.memid =0 THEN b.slots * f.guestcost
     WHEN m.memid >0 THEN b.slots * f.membercost
     ELSE NULL END AS cost
FROM Bookings AS b
JOIN Facilities AS f ON b.facid = f.facid
JOIN Members AS m ON b.memid = m.memid
WHERE b.starttime LIKE '2012-09-14%'
HAVING cost >30
ORDER BY 3 DESC
LIMIT 0 , 30

/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT sub . *
FROM (
    SELECT f.name, concat( m.firstname, ' ', m.surname ) AS mem_full_name,
    CASE WHEN m.memid =0 THEN b.slots * f.guestcost
         WHEN m.memid >0 THEN b.slots * f.membercost
         ELSE NULL END AS cost
    FROM Bookings AS b
    JOIN Facilities AS f ON b.facid = f.facid
    JOIN Members AS m ON b.memid = m.memid
    WHERE b.starttime LIKE '2012-09-14%'
    ORDER BY 3 DESC) sub
WHERE sub.cost >30

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT s . *
FROM (

    SELECT sub.name, SUM( sub.revenue ) AS total_revenue
    FROM (

        SELECT f.name AS name,
        CASE WHEN m.memid =0 THEN b.slots * f.guestcost
             WHEN m.memid >0 THEN b.slots * f.membercost
             ELSE NULL END AS revenue
        FROM Bookings AS b
        JOIN Facilities AS f ON b.facid = f.facid
        JOIN Members AS m ON b.memid = m.memid
        ORDER BY 2 DESC)sub
    
    GROUP BY 1
    ORDER BY 2)s

WHERE s.total_revenue <1000













