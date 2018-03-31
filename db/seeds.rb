connection = ActiveRecord::Base.connection()

# Applications
connection.execute("TRUNCATE application_tbl CASCADE")
connection.execute <<-SQL
INSERT INTO application_tbl (name) VALUES
  ('Cloud Application'),
  ('Configuration Application'),
  ('Identity Management Application')
SQL

# User Types
connection.execute("TRUNCATE user_type_tbl CASCADE")
connection.execute <<-SQL
    INSERT INTO user_type_tbl (name) VALUES
      ('Customer User'),
      ('Distributor User')
SQL

# Feature Types
connection.execute("TRUNCATE feature_type_tbl CASCADE")
connection.execute <<-SQL
    INSERT INTO feature_type_tbl (name) VALUES
      ('Page Feature'),
      ('Configuration Feature')
SQL

# Features
connection.execute("TRUNCATE feature_tbl CASCADE")
connection.execute <<-SQL
    INSERT INTO feature_tbl (feature_type_id, application_id, name, default_enabled_status, user_assignable, icon) VALUES
        (1, 1, 'Custom Insights', FALSE, FALSE, 'fa-area-chart'),
        (1, 1, 'Building Insights', TRUE, TRUE, 'fa-home'),
        (1, 1, 'Alarms', TRUE, TRUE, 'fa-bell'),
        (1, 1, 'Analytics', TRUE, FALSE, 'fa-list-alt'),
        (1, 1, 'Meters', FALSE, TRUE, 'fa-tachometer'),
        (1, 1, 'Savings Strategies', FALSE, TRUE, 'fa-tasks'),
        (1, 1, 'Schedules', TRUE, TRUE, 'fa-calendar'),
        (1, 1, 'Overview', TRUE, TRUE, 'fa-signal'),
        (1, 1, 'Export Data', FALSE, FALSE, 'fa-table'),
        (1, 1, 'Reports', TRUE, TRUE, 'fa-file-text-o'),
        (2, 1, 'Weather Normalized Charts', TRUE, FALSE, ''),
        (2, 1, 'Area Normalized Charts', TRUE, FALSE, ''),
        (2, 1, 'Dashboard KPIs', TRUE, FALSE, ''),
        (2, 1, 'Walkthrough KPIs', TRUE, FALSE, '')
SQL

# Roles
connection.execute("TRUNCATE role_tbl CASCADE")
connection.execute <<-SQL
    INSERT INTO role_tbl (application_id, name) VALUES
      (1, 'Super Admin'),
      (1, 'Portfolio Manager'),
      (1, 'Facility Manager'),
      (1, 'Limited User'),
      (2, 'Distributor Admin'),
      (2, 'Distributor User')
SQL

# Node Types
connection.execute("TRUNCATE node_types CASCADE")
connection.execute <<-SQL
  INSERT INTO node_types (id, name) VALUES
    (1, 'Portfolio'),
    (2, 'Site'),
    (3, 'Building'),
    (4, 'Sub-building'),
    (5, 'Floor'),
    (6, 'Zone'),
    (7, 'Meter'),
    (8, 'Equipment'),
    (9, 'Point'),
    (10, 'Area of Interest')
SQL

# Tag Groups
connection.execute("TRUNCATE tag_groups CASCADE")
connection.execute <<-SQL
  INSERT INTO tag_groups (id, name) VALUES
    (1, 'Tag'),
    (2, 'Group'),
    (3, 'Area of Interest'),
    (4, 'Equipment Type')
SQL

# Tag Types
connection.execute("TRUNCATE tag_types CASCADE")
connection.execute <<-SQL
  INSERT INTO tag_types (id, name) VALUES
    (1, 'Marker'),
    (2, 'Key-Value')
SQL


# Tag Group Tag Types
connection.execute("TRUNCATE tag_group_tag_types CASCADE")
connection.execute <<-SQL
  INSERT INTO tag_group_tag_types (tag_group_id, tag_type_id) VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2),
    (3, 1),
    (4, 1)
SQL

# Tag Group Node Types
connection.execute("TRUNCATE tag_group_node_types CASCADE")
connection.execute <<-SQL
  INSERT INTO tag_group_node_types (tag_group_id, node_type_id) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (2, 2),
    (2, 3),
    (3, 10),
    (4, 8)
SQL

#Tags
connection.execute("TRUNCATE tags CASCADE")
connection.execute <<-SQL
  INSERT INTO tags (tag_group_id, tag_type_id, name) VALUES
    (2, 2, 'region'),
    (2, 2, 'building_type'),
    (3, 1, 'operating_room'),
    (4, 1, 'hvac')
SQL

#Applications
connection.execute("TRUNCATE application_tbl CASCADE")
connection.execute <<-SQL
  INSERT INTO application_tbl (id, name) VALUES
    (1, 'cloud_app'),
    (2, 'config_app')
SQL

