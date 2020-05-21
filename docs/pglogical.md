## Postgresql 9

SELECT * FROM pglogical.show_subscription_status();


select set_reloid,set_att_list from pglogical.replication_set_table; 

select pglogical.replication_set_remove_table('set2', 'accounts')

select pglogical.replication_set_add_table(set_name := 'set2'::name, relation :='public.accounts'::regclass, synchronize_data := true, columns := '{id,name,enabled,created_at,updated_at,deleted_at,owner_id,balance,company_name,inn_code,kpp,owner_phone,tariff_id,trial_ended_at,partner_balance,partner_id,phone,phone_confirmed_at,phone_await_confirmation,blocked_at,type,remote_id,common_number,phone_confirmation_id,aon_number_kind,allow_team,business,comment,trial_balance_depleted,leads_count,users_count,scenarios_count,trial_balance,reports_settings,nauphone_domain,allow_automation,team_size_range,lead_sms_chunks_count,allow_sms,uuid,trial_calls_left,flags,phone_bus_uri,additional_info,credit,first_payment_at,last_sign_in_at,admin_last_sign_in_at,payments_count,calls_count,closed_at,lead_sms_chunks_monthly_count}' );

## Postgresql 10+

CREATE PUBLICATION percpub FOR ALL TABLES;
CREATE PUBLICATION percpub FOR TABLE scott.employee scott.departments;
ALTER PUBLICATION

CREATE SUBSCRIPTION percsub CONNECTION 'host=publisher_server_ip dbname=percona user=postgres password=secret port=5432' PUBLICATION percpub;

select * from pg_publication;
select * from pg_stat_replication;
select * from pg_subscription;
select * from pg_stat_subscription;