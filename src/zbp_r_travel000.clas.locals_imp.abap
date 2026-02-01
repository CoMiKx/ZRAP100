CLASS LHC_ZR_TRAVEL000 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Travel
        RESULT result,
      validateCustomer FOR VALIDATE ON SAVE
            IMPORTING keys FOR Travel~validateCustomer,
      calcTotalTravelPrice FOR DETERMINE ON SAVE
            IMPORTING keys FOR Travel~calcTotalTravelPrice,
      editTotalTravelPrice FOR DETERMINE ON SAVE
            IMPORTING keys FOR Booking~editTotalTravelPrice,
      setSightseeingTips FOR DETERMINE ON MODIFY
            IMPORTING keys FOR Travel~setSightseeingTips.
ENDCLASS.

CLASS LHC_ZR_TRAVEL000 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD validateCustomer.

    DATA(lo_travel_helper) = NEW zcl_travel_helper_000( ).

    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Travel
        FIELDS ( CustomerID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-CustomerID IS INITIAL OR NOT lo_travel_helper->validate_customer( ls_travel-CustomerID ).
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-Travel.
        APPEND VALUE #(
            %tky        = ls_travel-%tky
            %state_area = 'Validation'
            %msg        = NEW_MESSAGE_WITH_TEXT(
              text     = 'CustomerID is missing or invalid'
              severity = if_abap_behv_message=>severity-error
            )
        ) TO reported-Travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD calcTotalTravelPrice.
    "1) Read Travel and Booking entities
    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Travel
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Travel BY \_Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_booking).

      "Let's add this
      DATA(current_total_price) = VALUE #( lt_travel[ 1 ]-TotalPrice OPTIONAL ).
      DATA(booking_fee) = VALUE #( lt_travel[ 1 ]-BookingFee OPTIONAL ).
      DATA(currency_code) = VALUE #( lt_booking[ 1 ]-CurrencyCode OPTIONAL ).

    "2) Calculate the total flight price of the bookings using reduce operator in calculated_total_price variable
    DATA(calculated_total_price) = REDUCE i( INIT price = 0 FOR booking IN lt_booking NEXT price = price + booking-FlightPrice ).

      "Let's add this
      calculated_total_price += booking_fee.

    "3) Modify the total flight price of the travels
    IF current_total_price NE calculated_total_price.
      MODIFY ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
        ENTITY Travel
          UPDATE FIELDS ( TotalPrice CurrencyCode )
            WITH VALUE #( FOR key IN keys ( %tky         = key-%tky
                                            TotalPrice   = calculated_total_price
                                            CurrencyCode = currency_code ) )
                                            REPORTED DATA(reported_modify).
    ENDIF.
  ENDMETHOD.

  METHOD editTotalTravelPrice.
    "1) Read root entities
    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Booking BY \_Travel
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    "2) Read Booking entities
    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_booking).

    "3) Calculate the total flight price of the bookings using reduce operator in calculated_total_price variable
    DATA(current_total_price) = VALUE #( lt_travel[ 1 ]-TotalPrice OPTIONAL ).
    DATA(booking_fee) = VALUE #( lt_travel[ 1 ]-BookingFee OPTIONAL ).
    DATA(currency_code) = VALUE #( lt_travel[ 1 ]-CurrencyCode OPTIONAL ).
    DATA(uuid) = VALUE #( lt_travel[ 1 ]-uuid OPTIONAL ).

    "Let's add this
    DATA(calculated_total_price) = REDUCE i( INIT price = 0 FOR booking IN lt_booking NEXT price = price + booking-FlightPrice ).
    calculated_total_price += booking_fee.

    "4) Modify the total flight price of the root entities
    IF current_total_price NE calculated_total_price.
      MODIFY ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
        ENTITY Travel
          UPDATE FIELDS ( TotalPrice CurrencyCode )
            WITH VALUE #( ( %tky-UUID    = uuid
                            TotalPrice   = calculated_total_price
                            CurrencyCode = currency_code ) )
                            REPORTED DATA(reported_modify).
    ENDIF.
  ENDMETHOD.

  METHOD setSightseeingTips.

    DATA(lo_travel_helper) = NEW zcl_travel_helper_000( ).

    READ ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
      ENTITY Travel
        FIELDS ( SightseeingsTips Destination )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-SightseeingsTips IS INITIAL.
*        DATA(sightseeing_tips) = lo_travel_helper->get_sightseeing_tips( ls_travel-Destination ).
*        MODIFY ENTITIES OF ZR_TRAVEL000 IN LOCAL MODE
*          ENTITY Travel
*            UPDATE FIELDS ( SightseeingsTips )
*            WITH VALUE #( ( %tky = ls_travel-%tky
*                            SightseeingsTips = sightseeing_tips ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
