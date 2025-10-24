# Booking Events API Integration Guide

## Overview

The Booking Events API allows suppliers to send real-time driver and booking event updates to Suntransfers. This enables
tracking of transfer progress and improves customer experience.

## Endpoint Details

**Base URL (Staging):** `https://supplierhub-api.suntransfers.biz`  
**Endpoint:** `POST /api/v1/suppliers/{supplierCode}/bookings/{bookingReference}/events`  
**Authentication:** Basic Authentication (credentials provided separately)

### URL Parameters

- **supplierCode** (1-10 chars): Your unique supplier code provided by Suntransfers
- **bookingReference** (1-32 chars): The Suntransfers booking reference (e.g., SUNTR_AB1234)

## Request Body

| Field      | Type     | Required | Description                           | Validation                                                                                                                                                                              | Example                                                  |
|------------|----------|----------|---------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| eventType  | string   | Yes      | Type of event (see Event Types below) | One of: `DRIVER_DEPARTED_TO_PICKUP`, `DRIVER_ARRIVED_AT_PICKUP`, `DRIVER_SUBMITTED_CUSTOMER_NO_SHOW`, `DRIVER_DEPARTED_TO_DROPOFF`, `DRIVER_ARRIVED_AT_DROPOFF`, `DRIVER_LIVE_LOCATION` | `DRIVER_ARRIVED_AT_PICKUP`                               |
| occurredAt | datetime | Yes      | When the event occurred               | ISO 8601 format                                                                                                                                                                         | `2025-12-24T14:30:00Z` or<br>`2025-12-24T16:30:00+02:00` |
| latitude   | number   | No*      | Event location latitude               | Range: -90 to 90                                                                                                                                                                        | `41.3851`                                                |
| longitude  | number   | No*      | Event location longitude              | Range: -180 to 180                                                                                                                                                                      | `2.1734`                                                 |

*Both `latitude` and `longitude` must be provided together or both omitted. We strongly encourage you to always provide
it. Always required for the `DRIVER_LIVE_LOCATION` event.

### Event Types

- `DRIVER_DEPARTED_TO_PICKUP` - Driver has left to pick up the customer
- `DRIVER_ARRIVED_AT_PICKUP` - Driver has arrived at pickup location
- `DRIVER_SUBMITTED_CUSTOMER_NO_SHOW` - Customer was not at pickup location
- `DRIVER_DEPARTED_TO_DROPOFF` - Driver has left pickup with customer
- `DRIVER_ARRIVED_AT_DROPOFF` - Driver has arrived at destination
- `DRIVER_LIVE_LOCATION` - Real-time driver location update

## Sample Request

### CURL Example

This call will execute silently with no response.

```bash
curl -X POST https://supplierhub-api.suntransfers.biz/api/v1/suppliers/YOUR_CODE/bookings/SUNTR_AB1234/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $(echo -n 'username:password' | base64)" \
  -d '{
    "eventType": "DRIVER_DEPARTED_TO_PICKUP",
    "occurredAt": "2025-12-24T14:30:00Z",
    "latitude": 41.3851,
    "longitude": 2.1734
  }'
```

## Response Codes

- **201 Created** - Event successfully recorded (empty response body)
- **400 Bad Request** - Invalid request data or validation failure (returns JSON Problem Details - RFC 7807 with trace
  ID)
- **401 Unauthorized** - Invalid or missing credentials (returns JSON Problem Details - RFC 7807 with trace ID)
- **500 Internal Server Error** - Server error, please retry (returns JSON Problem Details - RFC 7807 with trace ID)

**Note:** When an error occurs, the response will include a trace ID that you can provide to our support team for
troubleshooting.

## Testing & Implementation

1. Use the provided credentials and staging URL to test your integration
2. Test all event types relevant to your operations
3. Once testing is complete, request production credentials and URL

## Custom Driver Events

We understand that every integration is unique. Contact us if you:

- Have driver events not covered by our standard event types
- Use a completely different API structure or event format
- Need us to pull events from YOUR API instead of pushing to ours
- Have any other integration requirements

We'll implement a custom solution with minimal effort on your side.

## Included Resources

- **Postman Collection:** [Import to quickly test the endpoint](./files/Suntransfers-Supplier-Hub.postman_collection.json)
- **Postman Environment:** [Pre-configured with Staging URL (add your credentials)](./files/Suntransfers-Staging.postman_environment.json)
- **Swagger Document:** [https://supplierhub-api.suntransfers.biz/swagger/v1/swagger.json](https://supplierhub-api.suntransfers.biz/swagger/v1/swagger.json)
- **Credentials:** Provided separately for security

## Complete Integration

If you're looking to implement the full Suntransfers Supplier API (Bookings, Amendments, Cancellations, Quotes, and Booking Events), refer to our [Full Integration](../../full-integration/docs/) docs.

## Questions?

Contact [The Supplier Hub Team](mailto:lucas.dasilva@suntransfers.com).