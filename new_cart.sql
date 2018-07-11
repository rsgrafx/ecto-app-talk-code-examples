CREATE OR REPLACE FUNCTION notify_new_cart()
RETURNS trigger AS $$
DECLARE
  purchaser_name VARCHAR;
  email VARCHAR;
  current_row RECORD;
BEGIN

 IF (TG_OP = 'INSERT') THEN
    current_row := NEW;
 END IF;

 purchaser_name := street_name
 from fetch_cart_owner(NEW.user_id)
 as f(email varchar, street_name varchar);

 email := email
 from fetch_cart_owner(NEW.user_id)
 as f(email varchar, street_name varchar);

PERFORM pg_notify(
  'new_order_created',
  json_build_object(
    'table', TG_TABLE_NAME,
    'type', TG_OP,
    'order_id', current_row.id,
    'data', NEW.cart,
    'purchaser_name', purchaser_name,
    'email', email
  )::text
);
RETURN current_row;
END;
$$ language plpgsql;


-- Trigger
DROP TRIGGER IF EXISTS new_cart_notification_trg ON orders;

CREATE TRIGGER new_cart_notification_trg
AFTER INSERT
ON orders
FOR EACH ROW
EXECUTE PROCEDURE notify_new_cart();
