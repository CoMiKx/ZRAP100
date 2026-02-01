@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZTravel000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.semanticKey: [ 'Travelid' ]
define root view entity ZR_TRAVEL000
  as select from ZTRAVEL000 as Travel
  composition [1..*] of ZR_BOOKING000 as _Booking
{
  key uuid as UUID,
  travel_id as TravelID,
  agency_id as AgencyID,
  customer_id as CustomerID,
  begin_date as BeginDate,
  end_date as EndDate,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  booking_fee_curr as BookingFeeCurr,
  @Semantics.amount.currencyCode: 'BookingFeeCurr'
  booking_fee as BookingFee,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  total_price_curr as TotalPriceCurr,
  @Semantics.amount.currencyCode: 'TotalPriceCurr'
  total_price as TotalPrice,
  currency_code as CurrencyCode,
  description as Description,
  status as Status,
  destination as Destination,
  sightseeings_tips as SightseeingsTips,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _Booking
}
