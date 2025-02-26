EXEC rdsadmin.rdsadmin_master_util.create_archivelog_dir;
EXEC rdsadmin.rdsadmin_master_util.create_onlinelog_dir;

/* Grant read access ONLINELOG_DIR and ARCHIVELOG_DIR if dmsuser is not master user */
SELECT directory_name, directory_path FROM all_directories WHERE directory_name LIKE ('ARCHIVELOG_DIR%') OR directory_name LIKE ('ONLINELOG_DIR%');
GRANT READ ON DIRECTORY ONLINELOG_DIR TO DMS_USER;
GRANT READ ON DIRECTORY ARCHIVELOG_DIR TO DMS_USER;

/* Configure adequate retention for archived redo log*/
exec rdsadmin.rdsadmin_util.set_configuration('archivelog retention hours',24);
commit;
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD');
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD','PRIMARY KEY');