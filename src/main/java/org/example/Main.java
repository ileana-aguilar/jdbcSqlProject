package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;

public class Main {
    public static void main(String[] args) {
        String[] queries = {
                "SELECT * FROM [Process].[WorkflowSteps]",
                "SELECT AI.InstructorId, AI.LastName, AI.FirstName, COUNT(DISTINCT AD.DepartmentId) AS DepartmentsTaught " +
                        "FROM Academic.Instructor AI " +
                        "INNER JOIN Academic.Class AC ON AI.InstructorId = AC.InstructorId " +
                        "INNER JOIN Academic.Course C ON AC.CourseId = C.CourseId " +
                        "INNER JOIN Academic.Department AD ON LEFT(C.CourseName, CHARINDEX(' ', C.CourseName) - 1) = AD.DepartmentName " +
                        "GROUP BY AI.InstructorId, AI.LastName, AI.FirstName " +
                        "HAVING COUNT(DISTINCT AD.DepartmentId) > 1;",
                "SELECT DepartmentName, COUNT(DISTINCT InstructorFullName) AS NumberOfInstructors " +
                        "FROM InstructorDepartmentTeaching " +
                        "GROUP BY DepartmentName;",
                "SELECT C.CourseName, COUNT(Cl.ClassId) AS NumberOfClasses, " +
                        "SUM(Cl.Enrolled) AS TotalEnrollment, SUM(Cl.MaxEnrollment) AS TotalClassLimit, " +
                        "CAST(SUM(Cl.Enrolled) AS FLOAT) / SUM(Cl.MaxEnrollment) * 100 AS PercentageOfEnrollment " +
                        "FROM [Academic].[Class] Cl " +
                        "JOIN [Academic].[Course] C ON Cl.CourseId = C.CourseId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY C.CourseName " +
                        "ORDER BY C.CourseName;",
                "SELECT CourseId, CourseName, ClassId, Semester, DateAdded " +
                        "FROM ( " +
                        "SELECT C.CourseId, C.CourseName, Cl.ClassId, Cl.Semester, Cl.DateAdded, " +
                        "ROW_NUMBER() OVER (PARTITION BY C.CourseId ORDER BY Cl.DateAdded DESC) AS RowNum " +
                        "FROM [Academic].[Class] AS Cl " +
                        "JOIN [Academic].[Course] AS C ON Cl.CourseId = C.CourseId " +
                        "WHERE Cl.Semester LIKE 'Current Semester' " +
                        ") AS LatestClasses " +
                        "WHERE RowNum = 1;",
                "SELECT BL.BuildingName, SUM(Cl.Enrolled) AS TotalEnrolled " +
                        "FROM [Academic].[Class] AS Cl " +
                        "JOIN [Facilities].[RoomLocation] AS RL ON Cl.RoomLocationId = RL.RoomLocationId " +
                        "JOIN [Facilities].[BuildingLocation] AS BL ON RL.BuildingId = BL.BuildingId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY BL.BuildingName " +
                        "ORDER BY TotalEnrolled DESC;",
                "SELECT I.FullName, COUNT(Cl.ClassId) AS NumberOfClassesTaught " +
                        "FROM [Academic].[Instructor] AS I " +
                        "JOIN [Academic].[Class] AS Cl ON I.InstructorId = Cl.InstructorId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY I.FullName " +
                        "HAVING COUNT(Cl.ClassId) > ( " +
                        "SELECT AVG(ClassCount) " +
                        "FROM ( " +
                        "SELECT COUNT(Cl.ClassId) AS ClassCount " +
                        "FROM [Academic].[Instructor] AS I " +
                        "JOIN [Academic].[Class] AS Cl ON I.InstructorId = Cl.InstructorId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY I.InstructorId " +
                        ") AS AverageClasses " +
                        ") " +
                        "ORDER BY NumberOfClassesTaught DESC;",
                "SELECT C.CourseName, AVG(CAST(Cl.Enrolled AS FLOAT)) AS AverageClassSize " +
                        "FROM [Academic].[Class] Cl " +
                        "JOIN [Academic].[Course] C ON Cl.CourseId = C.CourseId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY C.CourseName " +
                        "ORDER BY AverageClassSize DESC;",
                "SELECT ClassId, SUM(Enrolled) AS TotalEnrolled " +
                        "FROM Academic.Class " +
                        "GROUP BY ClassId " +
                        "HAVING SUM(Enrolled) = 25;",
                "SELECT b.BuildingName, COUNT(*) AS NumberOfClasses " +
                        "FROM Facilities.BuildingLocation b " +
                        "INNER JOIN Academic.Class c ON b.BuildingId = c.RoomLocationId " +
                        "GROUP BY b.BuildingName;",
                "SELECT BL.BuildingName, AVG(CAST(Cl.Enrolled AS INT)) AS AverageEnrollmentPerRoom " +
                        "FROM [Facilities].[RoomLocation] RL " +
                        "JOIN [Facilities].[BuildingLocation] BL ON RL.BuildingId = BL.BuildingId " +
                        "JOIN [Academic].[Class] Cl ON RL.RoomLocationId = Cl.RoomLocationId " +
                        "WHERE Cl.Semester = 'Current Semester' " +
                        "GROUP BY BL.BuildingName " +
                        "ORDER BY AverageEnrollmentPerRoom DESC;",
                "SELECT I.InstructorId, CONCAT(I.LastName, ', ', I.FirstName) AS InstructorName, " +
                        "C.ClassId, C.Enrolled, " +
                        "AVG(C.Enrolled) OVER (PARTITION BY I.InstructorId) AS AvgEnrolledStudents " +
                        "FROM Academic.Class AS C " +
                        "INNER JOIN Academic.Instructor AS I ON C.InstructorId = I.InstructorId " +
                        "ORDER BY I.InstructorId;",
                "WITH ClassRoomInfo AS ( " +
                        "SELECT C.ClassId, C.CourseId, C.RoomLocationId, RL.BuildingId, RL.RoomNumber " +
                        "FROM Academic.Class AS C " +
                        "INNER JOIN Facilities.RoomLocation AS RL ON C.RoomLocationId = RL.RoomLocationId " +
                        ") " +
                        "SELECT * FROM ClassRoomInfo;",
                "SELECT C.CourseName, SUM(Cl.Enrolled) AS TotalEnrollment, " +
                        "SUM(Cl.MaxEnrollment) AS TotalCapacity, " +
                        "CASE " +
                        "WHEN SUM(Cl.MaxEnrollment) > 0 THEN (SUM(Cl.Enrolled) * 100.0 / SUM(Cl.MaxEnrollment)) " +
                        "ELSE 0 " +
                        "END AS PercentageOfCapacity " +
                        "FROM Academic.Class AS Cl " +
                        "JOIN Academic.Course AS C ON Cl.CourseId = C.CourseId " +
                        "GROUP BY C.CourseName " +
                        "HAVING " +
                        "CASE " +
                        "WHEN SUM(Cl.MaxEnrollment) > 0 THEN (SUM(Cl.Enrolled) * 100.0 / SUM(Cl.MaxEnrollment)) " +
                        "ELSE 0 " +
                        "END >= 90 " +
                        "ORDER BY PercentageOfCapacity DESC;"
        };

        try {

            JPanel panel = new JPanel();
            panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));

            for (String query : queries) {
                ResultSet rs = DatabaseManager.executeQuery(query);
                DefaultTableModel tableModel = CreateTable.createTableModelFromResultSet(rs);
                JTable table = new JTable(tableModel);
                table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
                CreateTable.setColumnWidthsBasedOnContent(table);

                // Preferred size of the table
                table.setPreferredScrollableViewportSize(new Dimension(1200, 250));

                JScrollPane scrollPane = new JScrollPane(table);
                panel.add(scrollPane);
            }

            JScrollPane frameScrollPane = new JScrollPane(panel);

            JFrame frame = new JFrame("Our Query Results");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add(frameScrollPane);
            frame.setSize(1280, 720);
            frame.setVisible(true);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
