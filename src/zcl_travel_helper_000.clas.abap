 CLASS zcl_travel_helper_000 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: validate_customer IMPORTING iv_customer_id TYPE /dmo/customer_id RETURNING VALUE(rv_exists) TYPE abap_bool.
    METHODS: get_booking_status IMPORTING iv_status TYPE /dmo/booking_status_text RETURNING VALUE(rv_status) TYPE /dmo/booking_status.
    METHODS: get_sightseeing_tips IMPORTING iv_city TYPE /dmo/city RETURNING VALUE(rv_sightseeing_tips) TYPE /dmo/description.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TRAVEL_HELPER_000 IMPLEMENTATION.


  METHOD validate_customer.
     SELECT SINGLE
        FROM /dmo/customer
        FIELDS @abap_true AS line_exists
        WHERE customer_id = @iv_customer_id
        INTO @rv_exists.
  ENDMETHOD.


  METHOD get_booking_status.
    CASE iv_status.
      WHEN 'Booked'.
        rv_status = 'B'.
      WHEN 'New'.
        rv_status = 'N'.
      WHEN 'Cancelled'.
        rv_status = 'X'.
    ENDCASE.
  ENDMETHOD.


  METHOD get_sightseeing_tips.
    " We will call an LLM to generate the sightseeing tips for a given city using the ABAP AI SDK powered by ISLM

      DATA(system_prompt) = | You support by giving sightseeing tips for a given city. | &&
                            | Write a short summary of the 10 top most sightseeing tips | &&
                            | using a brief listing without a caption | &&
                            | It should be less 1000 characters. |.

      " User specific prompt, including the city selection from the UI
      DATA(user_prompt)   = |The city is { iv_city }.|.

      " create an instance of the ABAP AI SDK powered by ISLM
      TRY.
        FINAL(api) =  cl_aic_islm_compl_api_factory=>get( )->create_instance( islm_scenario = 'ZINTS_RAP120' ).
      CATCH cx_aic_api_factory INTO DATA(lx_api).
        rv_sightseeing_tips = ''.
      ENDTRY.

      TRY.
        FINAL(message_container) = api->create_message_container( ).
        message_container->set_system_role( system_prompt ).
        message_container->add_user_message( user_prompt ).
        rv_sightseeing_tips = api->execute_for_messages( message_container )->get_completion( ).
      CATCH cx_aic_completion_api INTO DATA(lx_completion).
        rv_sightseeing_tips = ''.
      ENDTRY.
  ENDMETHOD.
ENDCLASS.
