#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon . How may I help You?\n"

SERVICE_SELECTOR(){
#Displaying services :
SERVICES_OFFERED=$($PSQL "select service_id , name from services")

echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done

#Selecting a service :
read SERVICE_ID_SELECTED
IF_SERVICE_AVAILABLE=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")

#if incorrect service selected :
if [[ -z $IF_SERVICE_AVAILABLE ]]
then
  SERVICE_SELECTOR

else
  #Check Customer Exists :
  echo -e "Enter Phone Number : "
  read CUSTOMER_PHONE 
  CHECK_PHONE_EXISTS=$($PSQL "select * from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE_EXISTS ]]
  then
    echo -e "\nEnter Customer Name : "
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

  echo -e "\nEnter Service Time : "
  read SERVICE_TIME
  #echo $SERVICE_ID_SELECTED
  #insert into appointments :
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENTS=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")

  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
fi

}

SERVICE_SELECTOR



