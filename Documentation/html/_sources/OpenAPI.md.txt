# Azure Data Explorer OpenAPI Spec

This file documents the process of building the control plane OpenAPI based client.
*It is not expected that end users should need to use or be familiar with this workflow.*

## Spec download

See: [https://github.com/microsoft/azure-rest-api-specs/tree/kusto-demo/specification/azure-kusto/resource-manager](https://github.com/microsoft/azure-rest-api-specs/tree/kusto-demo/specification/azure-kusto/resource-manager)

```bash
git clone https://github.com/Azure/azure-rest-api-specs.git
```

## AutoRest

AutoRest is required to convert the spec from 2.0 to 3

### Install AutoRest

See: [https://github.com/Azure/autorest/blob/main/docs/install/readme.md](https://github.com/Azure/autorest/blob/main/docs/install/readme.md)

```bash
npm install -g autorest
```

### Convert Spec

Use AutoRest to generate a spec. in v3.0 format

```bash
cd azure-rest-api-specs/specification/azure-kusto/resource-manager
npx autorest --output-converted-oai3
```

Creates a spec in: `azure-rest-api-specs/specification/azure-kusto/resource-manager/generated/azure-kusto/resource-manager/Microsoft.Kusto/stable/<2022-11-11>`
where the data is the latest release folder

## Generate a client using a MATLAB client

```matlab
% Assuming the Java files have been built using maven
% In the openAPI Code generator package's directory
% cd Software/Java
% !mvn clean package

% Run startup to configure the package's MATLAB paths
cd <ADX package directory>Software/MATLAB
startup

buildControlPlaneClient
```

## Generate a client with npx

Generally this approach is not required or preferred.

Check openapitools version are at version 6.2.1 or greater.

```bash
npx @openapitools/openapi-generator-cli version
```

```bash
# Change to OpenAPI client generation package directory
# Call the client generator
npx @openapitools/openapi-generator-cli --custom-generator ./Java/target/classes \
 generate -g MATLAB \
 -i /home/<username>/git/azure-rest-api-specs/specification/azure-kusto/resource-manager/generated/azure-kusto/resource-manager/Microsoft.Kusto/stable/<release date>/kusto.json \
 -o KustoClient --package-name kusto | tee gen.log
 ```

## Customize the Client

* For now use find and replace across the generated files to get rid of apiVersion and subscriptionId such that they are no longer inputs and object properties instead.
* Remove "object" as a type in SkuDescription.
* Add auth to `presend()`.

[//]: #  (Copyright 2023-2024 The MathWorks, Inc.)
