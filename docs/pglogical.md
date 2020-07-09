## Postgresql 9

SELECT * FROM pglogical.show_subscription_status();

## replication sets 
pglogical.create_replication_set(set_name name, replicate_insert bool, replicate_update bool, replicate_delete bool, replicate_truncate bool)
pglogical.alter_replication_set(set_name name, replicate_inserts bool, replicate_updates bool, replicate_deletes bool, replicate_truncate bool)


select set_reloid,set_att_list from pglogical.replication_set_table where set_reloid = 'accounts'::regclass;
select pglogical.replication_set_remove_table('set2', 'accounts')

select pglogical.replication_set_add_table(set_name := 'set2'::name, relation :='public.accounts'::regclass, synchronize_data := true, columns := '{id,name,enabled,created_at,updated_at,deleted_at,owner_id,balance,company_name,inn_code,kpp,owner_phone,tariff_id,trial_ended_at,partner_balance,partner_id,phone,phone_confirmed_at,phone_await_confirmation,blocked_at,type,remote_id,common_number,phone_confirmation_id,aon_number_kind,allow_team,business,comment,trial_balance_depleted,leads_count,users_count,scenarios_count,trial_balance,reports_settings,nauphone_domain,allow_automation,team_size_range,lead_sms_chunks_count,allow_sms,uuid,trial_calls_left,flags,phone_bus_uri,additional_info,credit,first_payment_at,last_sign_in_at,admin_last_sign_in_at,payments_count,calls_count,closed_at,lead_sms_chunks_monthly_count}' );

select set_reloid,set_att_list from pglogical.replication_set_table where set_reloid = 'traffic_packages'::regclass;
select pglogical.replication_set_add_table(
  set_name := 'set1'::name,
  relation := 'public.traffic_packages'::regclass,
  synchronize_data := true,
  columns := '{id,account_id,country_code,active_until,seconds,notification_threshold,created_at,updated_at,initial_seconds}'
);

select pglogical.replication_set_add_table(
  set_name := 'indi_archive_str'::name,
  relation := 'public.traffic_packages'::regclass,
  synchronize_data := true,
  columns := '{id,account_id,country_code,active_until,seconds,notification_threshold,created_at,updated_at,initial_seconds}'
);

## Postgresql 10+

CREATE PUBLICATION percpub FOR ALL TABLES;
CREATE PUBLICATION percpub FOR TABLE scott.employee scott.departments;
ALTER PUBLICATION

CREATE SUBSCRIPTION percsub CONNECTION 'host=publisher_server_ip dbname=percona user=postgres password=secret port=5432' PUBLICATION percpub;

select * from pg_publication;
select * from pg_stat_replication;
select * from pg_subscription;
select * from pg_stat_subscription;

### Examples
CREATE SUBSCRIPTION indi_archive_str
  CONNECTION 'dbname=indicrm host=127.0.0.1 user=postgres port=5432'
  PUBLICATION indi_archive,indi_archive_insert
  WITH (copy_data=false);
