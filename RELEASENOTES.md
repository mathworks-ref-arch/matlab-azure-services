# MATLAB Interface *for Azure Services*

## Release Notes

## Release 1.0.1 September 10th 2024

* Jar shading fix
* Removed internal, experimental & partial ADX JDBC support

## Release 1.0.0 July 21st 2024

* Added Azure Data Explorer support
* Increased Azure SDK BOM version to 1.2.24
* Added azure.storage.queue.QueueClient.receiveMessages
* Added azure.storage.blob.models.BlobProperties.getBlobSize
* Moved compareAuthEnvVars to azure.mathworks.internal.compareAuthEnvVars *Breaking change*
* Moved datetime2OffsetDateTime to azure.mathworks.internal.datetime2OffsetDateTime *Breaking change*

## Release 0.3.2 April 14th 2023

* Typo fix in `configureCredentials`.

## Release 0.3.1 April 11th 2023

* Fixes issue with client certificate authentication

## Release 0.3.0 March 27th 2023

* Added EndPoint setting support
* Documentation updates
* Added Managed Identity Resource ID support
* Increase Azure SDK bom version to 1.2.11
* Standardized ClientId settings field name
* Standardized PemCertificate settings field name

## Release 0.2.0 March 13th 2023

* Added additional blob listing support
* Increase Azure SDK bom version to 1.2.10
* Documentation updates

## Release 0.1.1 September 7th 2022

* Published documentation to GitHub pages.
* Fixed relative path issues with `uploadFromFile` and `downloadToFile`.
* Documented deployment workflows.

## Release 0.1.0 May 18th 2022

* Initial release to GitHub.com
* Added File API support
* Documentation update

## Release 0.0.8 April 11th 2022

* Added support for generating user delegation SAS
* Documentation improvements
* Improved log4j handling
* Updated to Azure® SDK bom v1.2.0

## Release 0.0.7 March 17th 2022

* Added support for listing, getting, recovering and purging deleted keys and
  secrets (for Key Vaults with soft-delete enabled)

## Release 0.0.6 February 18th 2022

* Added Blob Lease support
* Added createStorageClient and createKeyVaultClient convenience functions
* Support for loading Java package at the end of the static Java class path (in
  most cases)
* Internal refactor of class inheritance

## Release 0.0.5 January 21st 2022

* Added Device Code Authentication support
* Added Shared Token Cache support

## Release 0.0.4 December 9th 2021

* Added authenticated proxy support
* Minor fixes & documentation updates

## Release Notes 0.0.3 November 14th 2021

* Added Documentation
* Improved Blob support
* Added Key Vault support

## Release 0.0.2 December 2020

* Initial release
* Added Queue Support

## Release 0.0.1 December 2020

* Initial internal release with support for Blob Storage


[//]: #  (Copyright 2020-2022, The MathWorks, Inc.)
