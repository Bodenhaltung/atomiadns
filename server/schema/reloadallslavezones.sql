CREATE OR REPLACE FUNCTION ReloadAllSlaveZones () RETURNS void AS $$
BEGIN
	INSERT INTO slavezone_change (nameserver_id, zone)
	SELECT nameserver.id, slavezone.name FROM nameserver, slavezone WHERE nameserver.nameserver_group_id = slavezone.nameserver_group_id;
	INSERT INTO tsigkey_change (nameserver_id, tsigkey_name)
	SELECT n.id, k.name FROM tsigkey k INNER JOIN nameserver n ON k.nameserver_group_id = n.nameserver_group_id;
END; $$ LANGUAGE plpgsql;
