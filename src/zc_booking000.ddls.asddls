@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Booking'
}
@ObjectModel: {
  semanticKey: [ 'Bookingid' ]
}
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZC_BOOKING000
  as projection on ZR_BOOKING000
  association [1..1] to ZR_BOOKING000 as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  ParentUUID,
  BookingID,
  BookingDate,
  CustomerID,
  CarrierID,
  ConnectionID,
  FlightDate,
//  @Consumption: {
//    Valuehelpdefinition: [ {
//      Entity.Element: 'Currency', 
//      Entity.Name: 'I_CurrencyStdVH', 
//      Useforvalidation: true
//    } ]
//  }
//  FlightPriceCurr,
  @Semantics: {
    amount.currencyCode: 'CurrencyCode'
  }
  FlightPrice,
  CurrencyCode,
//  @Consumption: {
//    valueHelpDefinition: [ {
//      entity.element: 'Currency', 
//      entity.name: 'I_CurrencyStdVH', 
//      useForValidation: true
//    } ]
//  }
//  DiscountedFlightPriceCurr,
  @Semantics: {
    amount.currencyCode: 'CurrencyCode'
  }
  DiscountedFlightPrice,
  _Travel : redirected to parent ZC_TRAVEL000,
  _BaseEntity
}
