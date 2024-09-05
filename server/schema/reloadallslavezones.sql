CREATE OR REPLACE FUNCTION ReloadAllSlaveZones () RETURNS void AS $$
BEGIN
	INSERT INTO slavezone_change (nameserver_id, zone)
	SELECT nameserver.id, slavezone.name FROM nameserver, slavezone WHERE nameserver.nameserver_group_id = slavezone.nameserver_group_id;

	INSERT INTO tsigkey_change (nameserver_id, tsigkey_name)
	SELECT n.id, k.name FROM tsigkey k INNER JOIN nameserver n ON k.nameserver_group_id = n.nameserver_group_id;

	INSERT INTO domainmetadata_change (nameserver_id, domain_id)
	SELECT ns.id, md.id || ',' || COALESCE(z.name, sz.name) FROM nameserver ns INNER JOIN domainmetadata md ON ns.nameserver_group_id = md.nameserver_group_id LEFT JOIN zone z ON z.id = md.domain_id AND md.kind = 'TSIG-ALLOW-AXFR' LEFT JOIN slavezone sz ON sz.id = md.domain_id AND md.kind <> 'TSIG-ALLOW-AXFR';

END; $$ LANGUAGE plpgsql;
