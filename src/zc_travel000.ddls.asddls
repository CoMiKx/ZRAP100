@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Travel'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZTravel000', 
  semanticKey: [ 'Travelid' ]
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_TRAVEL000
  provider contract transactional_query
  as projection on ZR_TRAVEL000
  association [1..1] to ZR_TRAVEL000 as _BaseEntity on $projection.UUID = _BaseEntity.UUID
{
  key UUID,
  TravelID,
  AgencyID,
  CustomerID,
  BeginDate,
  EndDate,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  BookingFeeCurr,
  @Semantics: {
    amount.currencyCode: 'BookingFeeCurr'
  }
  BookingFee,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  TotalPriceCurr,
  @Semantics: {
    amount.currencyCode: 'TotalPriceCurr'
  }
  TotalPrice,
  CurrencyCode,
  Description,
  Status,
  Destination,
  SightseeingsTips,
  @Semantics: {
    user.createdBy: true
  }
  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _Booking : redirected to composition child ZC_BOOKING000,
  _BaseEntity
}
