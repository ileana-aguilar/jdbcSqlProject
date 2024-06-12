package org.example;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class CreateTable {
    public static DefaultTableModel createTableModelFromResultSet(ResultSet rs) throws SQLException {
        DefaultTableModel tableModel = new DefaultTableModel();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        // Add columns
        for (int column = 1; column <= columnCount; column++) {
            tableModel.addColumn(metaData.getColumnName(column));
        }

        // Add rows
        while (rs.next()) {
            Object[] row = new Object[columnCount];
            for (int column = 1; column <= columnCount; column++) {
                row[column - 1] = rs.getObject(column);
            }
            tableModel.addRow(row);
        }
        return tableModel;
    }

    public static void setColumnWidthsBasedOnContent(JTable table) {
        for (int column = 0; column < table.getColumnCount(); column++) {
            TableColumn tableColumn = table.getColumnModel().getColumn(column);
            int preferredWidth = 200; // Minimum width
            for (int row = 0; row < table.getRowCount(); row++) {
                Object value = table.getValueAt(row, column);
                if (value != null) {
                    int cellWidth = table.getCellRenderer(row, column).getTableCellRendererComponent(table, value, false, false, row, column).getPreferredSize().width;
                    preferredWidth = Math.max(preferredWidth, cellWidth);
                }
            }
            tableColumn.setPreferredWidth(preferredWidth);
        }
    }
}
