"!@testing ZR_BOOKING000
CLASS ltc_zr_booking000 DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_zbooking000 TYPE STANDARD TABLE OF zbooking000 WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zr_booking000 WITH EMPTY KEY.
    DATA exp_results TYPE STANDARD TABLE OF zr_booking000 WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.

    "! In this method test data is inserted into the generated double(s) for test case
    "! "Calculate DISCOUNTEDFLIGHTPRICE field"
    METHODS td_calc_discounted_flight_prc.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "When carrier_id = 'AF'"
    METHODS td_when_carrier_af.
    "! In this method test data is inserted into the generated double(s) for test case
    "! "When carrier_id = 'LH'"
    METHODS td_when_carrier_eq_lh.

    "! <strong>Test Case:</strong> Calculate DISCOUNTEDFLIGHTPRICE field <br><br>
    "! Test calculation of DISCOUNTEDFLIGHTPRICE field.
    "! <br><br> The results should be asserted with the actuals.
    METHODS calc_discounted_flight_prc FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> When carrier_id = 'AF' <br><br>
    "! Test a CDS View when the CASE condition When carrier_id = 'AF' is satisfied.
    "! <br><br> The results should be asserted with the actuals.
    METHODS when_carrier_af FOR TESTING RAISING cx_static_check.
    "! <strong>Test Case:</strong> When carrier_id = 'LH' <br><br>
    "! Test a CDS View when the CASE condition When carrier_id = 'LH' is satisfied.
    "! <br><br> The results should be asserted with the actuals.
    METHODS when_carrier_eq_lh FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ZR_BOOKING000 IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZR_BOOKING000' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD calc_discounted_flight_prc.
    td_calc_discounted_flight_prc( ).
    SELECT * FROM zr_booking000 INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-discountedflightprice act = act_results[ sy-tabix ]-discountedflightprice
      msg = 'Test Generated using AI: Expected result for field DISCOUNTEDFLIGHTPRICE is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_calc_discounted_flight_prc.
    " Prepare test data for 'ZBOOKING000'
    td_zbooking000 = VALUE #(
      (
        client = '080'
        uuid = '1234567890ABCDEF'
        parent_uuid = 'FEDCBA0987654321'
        carrier_id = 'LH'
        flight_price = '1000.00'
      ) ).
    environment->insert_test_data( i_data = td_zbooking000 ).

    " Prepare test data for 'zr_booking000'
    exp_results = VALUE #(
      (
           uuid = '1234567890ABCDEF'
           parentuuid = 'FEDCBA0987654321'
           carrierid = 'LH'
           flightprice = '1000.00'
           discountedflightprice = '900.00'
      ) ).
  ENDMETHOD.

  METHOD when_carrier_af.
    td_when_carrier_af( ).
    SELECT * FROM zr_booking000 INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-DiscountedFlightPrice act = act_results[ sy-tabix ]-DiscountedFlightPrice
      msg = 'Test Generated using AI: Expected result for field DiscountedFlightPrice is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_when_carrier_af.
    " Prepare test data for 'ZBOOKING000'
    td_zbooking000 = VALUE #(
      (
        client = '080'
        uuid = '1234567890ABCDEF'
        parent_uuid = 'FEDCBA0987654321'
        carrier_id = 'AF'
        flight_price = '2000'
      ) ).
    environment->insert_test_data( i_data = td_zbooking000 ).

    " Prepare test data for 'zr_booking000'
    exp_results = VALUE #(
      (
           uuid = '1234567890ABCDEF'
           parentuuid = 'FEDCBA0987654321'
           carrierid = 'AF'
           flightprice = '2000'
           discountedflightprice = '1700.00'
      ) ).
  ENDMETHOD.

  METHOD when_carrier_eq_lh.
    td_when_carrier_eq_lh( ).
    SELECT * FROM zr_booking000 INTO TABLE @act_results.

    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-DiscountedFlightPrice act = act_results[ sy-tabix ]-DiscountedFlightPrice
      msg = 'Test Generated using AI: Expected result for field DiscountedFlightPrice is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_when_carrier_eq_lh.
    " Prepare test data for 'ZBOOKING000'
    td_zbooking000 = VALUE #(
      (
        client = '080'
        uuid = '1234567890ABCDEF'
        parent_uuid = 'FEDCBA0987654321'
        carrier_id = 'LH'
        flight_price = '1000.00'
      ) ).
    environment->insert_test_data( i_data = td_zbooking000 ).

    " Prepare test data for 'zr_booking000'
    exp_results = VALUE #(
      (
           uuid = '1234567890ABCDEF'
           parentuuid = 'FEDCBA0987654321'
           carrierid = 'LH'
           flightprice = '1000.00'
           discountedflightprice = '900.00'
      ) ).
  ENDMETHOD.

ENDCLASS.
