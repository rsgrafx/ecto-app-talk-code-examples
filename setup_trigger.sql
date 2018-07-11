\c core_orders;

CREATE OR REPLACE FUNCTION notify_new_order()
RETURNS trigger AS $$
DECLARE
  purchaser VARCHAR;
  current_row RECORD;
BEGIN

 IF (TG_OP = 'INSERT') THEN
    current_row := NEW;
 END IF;

 purchaser := user_name
 from fetch_purchaser(NEW.purchaser_id)
 as f(id integer, user_name varchar);

PERFORM pg_notify(
  'new_order_created',
  json_build_object(
    'table', TG_TABLE_NAME,
    'type', TG_OP,
    'order_id', current_row.id,
    'data', row_to_json(NEW),
    'purchaser', purchaser
  )::text
);
RETURN current_row;
END;
$$ language plpgsql;

DROP TRIGGER IF EXISTS new_order_notification_trg ON orders;

CREATE TRIGGER new_order_notification_trg
AFTER INSERT
ON orders
FOR EACH ROW
EXECUTE PROCEDURE notify_new_order();
