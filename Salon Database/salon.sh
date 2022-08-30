#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ Hair Salon ~~\n"

MAIN_MENU(){
  # print services
echo "$($PSQL "SELECT service_id, name FROM services")" | while read SERVICE_ID BAR NAME 
do
 echo -e "\n$SERVICE_ID) $NAME"
done

# get service
read SERVICE_ID_SELECTED

# if input does not match a service 
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
then
  # show list of services
  MAIN_MENU
else
  # get phone number
  echo "Please enter your phone number."
  read CUSTOMER_PHONE
  
  #check phone number
  CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE ]]
  then
    # get name  
    echo "Please enter your name."
    read CUSTOMER_NAME
    CUSTOMER_INFO_INSERT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # get apt time
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "Hello $CUSTOMER_NAME, Please choose a service time."
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  APPOINTMENT_INFO_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo "I have put you down for a$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") at$($PSQL "SELECT time FROM appointments WHERE time='$SERVICE_TIME'"),$CUSTOMER_NAME."
fi

}

MAIN_MENU
