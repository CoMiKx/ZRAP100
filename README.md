# ZRAP120_AI_000 — RAP Travel & Booking Application

A managed RAP (RESTful ABAP Programming) business object built on SAP BTP ABAP Environment, implementing a Travel and Booking scenario with draft handling, OData V4 exposure, and AI-powered sightseeing tips.

## Architecture

```
Service Binding (OData V4)
  └── ZUI_TRAVEL_O4000
Service Definition
  └── ZUI_TRAVEL_O4000
Projection Layer (C-Views)
  ├── ZC_TRAVEL000  (root)
  └── ZC_BOOKING000 (child)
Interface Layer (R-Views)
  ├── ZR_TRAVEL000  (root)
  └── ZR_BOOKING000 (child)
Database Tables
  ├── ZTRAVEL000  / ZTRAVEL_D000  (draft)
  └── ZBOOKING000 / ZBOOKING_D000 (draft)
```

## Features

- **Managed BO with Draft**: Full create, update, delete with draft support via `Activate`, `Discard`, `Edit`, `Resume`, and `Prepare` actions.
- **Validations**: `validateCustomer` ensures `CustomerID` exists in `/DMO/CUSTOMER`.
- **Determinations**:
  - `calcTotalTravelPrice` (on save) — recalculates total price from booking fees and flight prices.
  - `editTotalTravelPrice` (on save, Booking) — propagates booking price changes to the parent Travel entity.
  - `setSightseeingTips` (on modify) — generates AI-powered sightseeing tips for a destination using the ABAP AI SDK (ISLM scenario `ZINTS_RAP120`).
- **CDS Calculated Field**: `DiscountedFlightPrice` in `ZR_BOOKING000` applies carrier-based discounts (LH: 10% off, AF: 15% off).
- **Access Control**: DCL roles defined for all CDS views.
- **Unit Tests**:
  - `zcl_travel_helper_000` — tests customer validation with OSQL test doubles.
  - `zcl_test_cds_booking_000` — tests CDS discount calculation with CDS test environment.

## Objects

| Object | Type | Description |
|---|---|---|
| `ZTRAVEL000` | Table | Travel persistent table |
| `ZBOOKING000` | Table | Booking persistent table |
| `ZTRAVEL_D000` | Table | Travel draft table |
| `ZBOOKING_D000` | Table | Booking draft table |
| `ZR_TRAVEL000` | CDS View Entity | Travel interface view |
| `ZR_BOOKING000` | CDS View Entity | Booking interface view (with discount calc) |
| `ZC_TRAVEL000` | CDS Projection | Travel projection view |
| `ZC_BOOKING000` | CDS Projection | Booking projection view |
| `ZBP_R_TRAVEL000` | Class | Behavior implementation (validations, determinations) |
| `ZBP_C_TRAVEL000` | Class | Projection behavior implementation |
| `ZCL_TRAVEL_HELPER_000` | Class | Helper class (customer validation, booking status, AI tips) |
| `ZUI_TRAVEL_O4000` | Service Binding | OData V4 UI service |

## Discount Logic (CDS)

Defined in `ZR_BOOKING000`:

```sql
case
  when carrier_id = 'LH' then flight_price * 0.90
  when carrier_id = 'AF' then flight_price * 0.85
  else flight_price
end as DiscountedFlightPrice
```

## Setup

1. Import via **abapGit** into your SAP BTP ABAP Environment.
2. Activate all objects in the package `ZRAP120_AI_000`.
3. Publish the service binding `ZUI_TRAVEL_O4000`.
4. (Optional) Configure ISLM scenario `ZINTS_RAP120` for AI-powered sightseeing tips.

## License

MIT — see [LICENSE](LICENSE) for details.
