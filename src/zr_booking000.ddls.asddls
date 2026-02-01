@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'Bookingid' ]
define view entity ZR_BOOKING000
  as select from zbooking000 as Booking
  association to parent ZR_TRAVEL000 as _Travel on $projection.ParentUUID = _Travel.UUID
{
  key uuid as UUID,
  parent_uuid as ParentUUID,
  booking_id as BookingID,
  booking_date as BookingDate,
  customer_id as CustomerID,
  carrier_id as CarrierID,
  connection_id as ConnectionID,
  flight_date as FlightDate,
//  @Consumption.valueHelpDefinition: [ {
//    entity.name: 'I_CurrencyStdVH', 
//    entity.element: 'Currency', 
//    useForValidation: true
//  } ]
//  flight_price_curr as FlightPriceCurr,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  flight_price as FlightPrice,
  currency_code as CurrencyCode,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  @Semantics.amount.currencyCode: 'CurrencyCode'
  case
     when carrier_id = 'LH' then cast(flight_price as abap.dec(16,2)) * cast('0.90' as abap.dec(5,2))
     when carrier_id = 'AF' then cast(flight_price as abap.dec(16,2)) * cast('0.85' as abap.dec(5,2))
     else cast(flight_price as abap.dec(16,2))
  end as DiscountedFlightPrice,

  _Travel
}
