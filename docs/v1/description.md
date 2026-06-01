The Suntransfers Supplier API Specification (`ST SPEC v1`) defines an API for managing Bookings in real time: creation, amendment, and cancellation. Booking Quotes and Booking/Driver Events are optional capabilities you can add on top.

# How the integration works

## You build the API, we are the client

This specification describes an API that you implement and host. Suntransfers is the client: we send the requests, your API receives them. We call your API to create, amend, and cancel bookings as those events occur on our side.

Each endpoint in this document is one you expose. Behind it you implement your own logic: create the booking in your system, apply an amendment, process a cancellation. You generate the endpoint skeletons from this specification (see "Scaffold your server in seconds" below) and fill in that logic.

## A push model, not polling

Two patterns can keep two systems in sync, polling and push:

- Polling: your system repeatedly asks ours "do you have any bookings for me yet?" on a fixed schedule, for example every minute, whether or not anything has changed.
- Push: our system contacts yours the moment we have something for you, and stays quiet otherwise. This is the same idea as a webhook.

ST SPEC is a push model. We push bookings to you as they happen, and you never poll us for them.

# Why we push instead of you polling

Both models can be made to work, but they are not equal. The difference is easiest to see with a concrete example. Suppose you receive 1,000 bookings from us in a month.

## With polling

You call our API every minute to check for new bookings.

- That is 60 calls an hour, 24 hours a day, 30 days a month: about 43,200 requests in the month.
- Only 1,000 of those requests find a new booking. The other ~42,200 find nothing.
- Roughly ~98% of your requests are wasted; only ~2% are useful.
- Both sides pay for every one of those empty requests, in traffic and compute, around the clock.

It also gets worse as you grow. The empty requests stay constant, or rise if you poll more often to cut the delay, while the useful ones remain a small fraction. And you inherit a built-in lag: a booking can sit unseen for up to a full polling interval before you notice it.

## With push

We call your API once for each thing that actually happens.

- About 1,000 requests in the month, one per booking, plus a few more for amendments and cancellations.
- Every request carries a real event, so none are wasted.
- 100% of the traffic is necessary, and nothing is spent checking for changes that have not occurred.
- Bookings reach you the instant we have them, with no polling delay.

The push model delivers the same 1,000 bookings while making only ~2% as many requests, so it costs both sides roughly 2% of what polling would in compute and network. It also scales with booking volume rather than with the polling clock, and delivers bookings in real time.

# Where are the "get bookings" endpoints?

There is no Suntransfers-hosted API for you to poll for upcoming bookings, because you never need to ask us for them. Under the push model the bookings come to you: we call your `POST /v1/bookings` endpoint when there is a new one, your `PUT` endpoint when one is amended, and your `DELETE` endpoint when one is cancelled. Your job is to host those endpoints and react when we call them, not to poll us for data.

This specification does define a `GET /v1/bookings/{bookingReference}` endpoint, but it is one you host as well: it lets Suntransfers read back the current state of a single, known booking. It is not a way to list or discover upcoming bookings.

# How you acknowledge a booking

You do not need a separate call to confirm that you received or processed a booking. The HTTP response to our request is your acknowledgement.

- If you accept the request, return a success status: `201 Created` when the booking is created, or `202 Accepted` when the request is validated and queued for processing. Include your own `supplierReferences` in the response so the booking is linked on both sides.
- If you return an error status, we treat the request as not processed. A client error (`4xx`, such as `400` or `401`) means the request must be corrected; a server error (`5xx`, such as `500`) is one we may retry.

The same applies to amendments and cancellations: a 2xx response is your confirmation that you handled it, and an error response tells us you did not. Because the exchange is synchronous, the answer travels back on the same request, so there is nothing extra to call.

# Scaffold your server in seconds

You can scaffold in less than a minute all the code necessary for creating an API that follows this spec by leveraging OpenAPI Generators.

1. Install: On MacOS `brew install openapi-generator` or `npm install -g @openapitools/openapi-generator-cli` elsewhere
2. Find the server generator for your stack at [OpenAPI Server Generators](https://openapi-generator.tech/docs/generators#server-generators)
3. Run `openapi-generator` (or `openapi-generator-cli`) `config-help -g <generator-name>` to see configuration options for your chosen generator
4. Generate your API server: `openapi-generator` (or `openapi-generator-cli`) `generate -g <generator-name> -i ./st-spec-v1.json -o ./output`
5. Implement your business logic in the generated code, working with the request and response models defined in the spec and generated automatically in the step above.

# Test your implementation

You can test your implementation by using our [Try it out](../try-it-out/) Swagger UI utility.

# Only sending driver events?

If you're interested only in sending `Driver Events` to Suntransfers (webhook), check our [Booking Events](../../booking-events/docs/) docs.
