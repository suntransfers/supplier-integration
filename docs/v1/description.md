The Suntransfers Supplier API Specification (`ST SPEC v1`) is an OpenAPI-based standard definition to be implemented by Suntransfers' suppliers that wish a seamless integration capable of providing Booking creation, amendment, and cancellation in realtime.
Optional capabilities include providing Booking Quotes and Booking Events (Driver Events).

You can scaffold in less than a minute all the code necessary for creating an API that follows this spec by leveraging OpenAPI Generators.

1. Install: On MacOS `brew install openapi-generator` or `npm install -g @openapitools/openapi-generator-cli` elsewhere
2. Find the server generator for your stack at [OpenAPI Server Generators](https://openapi-generator.tech/docs/generators#server-generators)
3. Run `openapi-generator` (or `openapi-generator-cli`) `config-help -g <generator-name>` to see configuration options for your chosen generator
4. Generate your API server: `openapi-generator` (or `openapi-generator-cli`) `generate -g <generator-name> -i ./st-spec-v1.json -o ./output`
5. Implement your business logic in the generated code, working with the request and response models defined in the spec and generated automatically in the step above.

You can test your implementation by using our [Try it out](../try-it-out/) Swagger UI utility.

If you're interested only in sending `Driver Events` to Suntransfers (webhook), check our [Booking Events](../../booking-events/docs/) docs.