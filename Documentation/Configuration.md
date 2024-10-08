# Configuration

The package offers a `loadConfigurationSettings` function which allows reading
configuration settings from a short JSON format file. This provides a convenient
way to configure various settings (like endpoint URLs) without having to
hardcode these into MATLAB® code. By convention settings are stored in the
`Software/MATLAB/config` directory. When calling `loadConfigurationSettings` the
name of the configuration file must be provided as input, e.g.:

```matlab
settings = loadConfigurationSettings('mysettings.json');
```

If only a filename is provided the function will search for the file on the
MATLAB path. Alternatively a full absolute path can be provided as well.

An example `mysettings.json` file could look something like the following:

```json
{
    "myURL": "https://www.mathworks.com"
}
```

And then in MATLAB this could be used as:

```matlab
settings = loadConfigurationSettings('mysettings.json');
homePage = webread(settings.myURL);
```

## Authentication

The `configureCredentials` function for creating Azure® Credentials objects
relies on `loadConfigurationSettings` as well, it uses this same function to
read its settings from a JSON configuration file. Typically both Authentication
and other settings are in fact kept in a single JSON file. See
[Authentication](Authentication.md) for more details on authentication specific
configuration options as used by `configureCredentials`.

## Service specific settings

Service specific functions may rely on other additional configuration settings
as well. And they typically work with a service specific default filename for
the JSON file. But in most cases alternative filenames can be provided as well.

See the service specific documentation pages for more information on service
specific settings, the default JSON filename and how to provide an alternative
configuration file name if needed:

* [Key Vault](KeyVault.md)
* [Data Lake Storage Gen2](DataLakeStorageGen2.md)
* [Azure Data Explorer](DataExplorer.md)

[//]: #  (Copyright 2022-2024 The MathWorks, Inc.)
