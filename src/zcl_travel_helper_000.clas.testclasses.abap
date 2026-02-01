 CLASS ltcl_travel_helper_000 DEFINITION FINAL FOR TESTING
   DURATION SHORT RISK LEVEL HARMLESS.

   PRIVATE SECTION.
     "! ABAP SQL test environment
     CLASS-DATA environment TYPE REF TO if_osql_test_environment.
     CLASS-METHODS:
       "setup test double framework
       class_setup,
       "stop test doubles
       class_teardown.
 METHODS:
   "rollback test doubles
   setup,

   "! Test helper method
   configure_db_testdoubles,

   validate_customer_success for testing,
   validate_customer_failure for testing.
 ENDCLASS.

 CLASS ltcl_travel_helper_000 IMPLEMENTATION.

   METHOD class_setup.
     "setup test double framework
     environment = cl_osql_test_environment=>create(
       i_dependency_list = VALUE #( ( '/DMO/CUSTOMER' ) ) ).
   ENDMETHOD.

   METHOD class_teardown.
     "stop the test doubles
     environment->destroy( ).
   ENDMETHOD.

   METHOD setup.
     "clear the content of the test doubles per test
     environment->clear_doubles( ).
     configure_db_testdoubles( ).
   ENDMETHOD.

   METHOD configure_db_testdoubles.
     DATA customer_stub_data TYPE STANDARD TABLE OF /dmo/customer.
 customer_stub_data = VALUE #(
   ( client = '080' customer_id = '000001' )
   ( client = '080' customer_id = '000002' )
   ( client = '080' customer_id = '000003' )
 ).
 environment->insert_test_data( customer_stub_data ).
   ENDMETHOD.

   METHOD validate_customer_success.
     DATA(cut) = NEW zcl_travel_helper_000( ).
     DATA(result) = cut->validate_customer( '000001' ).
     cl_abap_unit_assert=>assert_equals( exp = abap_true act = result ).
   ENDMETHOD.

   METHOD validate_customer_failure.
     DATA(cut) = NEW zcl_travel_helper_000( ).
     DATA(result) = cut->validate_customer( '000004' ).
     cl_abap_unit_assert=>assert_equals( exp = abap_false act = result ).
   ENDMETHOD.

ENDCLASS.
