window.onload = function () {
  window.ui = SwaggerUIBundle({
    url: "../../st-spec-v1.json",
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout",
    serverVariablesEditable: true
  });
};
