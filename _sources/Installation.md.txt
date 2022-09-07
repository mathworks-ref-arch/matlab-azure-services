# Installation

## Clone this repository

```bash
git clone https://github.com/mathworks-ref-arch/matlab-azure-services.git
```

## Build MATLAB Azure SDK Jar

MATLAB Interface *for Azure Services* depends on the Azure® Java SDK which,
together with some helper code, first needs to be packaged into the MATLAB Azure
Utility Library. Building this utility requires both a Java 1.8 SDK and Apache
Maven.

The build process downloads a number of required 3rd party packages. The
specifics of which can be derived from the pom file.

To build the utility using Maven:

```bash
cd Software/Java
mvn clean package
```

The build should produce the file: `Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar`

## Configuring the MATLAB Java class path

Having built the SDK jar file, it must be included in the MATLAB Java class
path. The jar file must be added to the *static* class path. On Windows® the jar
file can be added at any position on the static class path, it can be added to
the start or at the end. On Linux the jar file must be added at the *start* of
the static java class path if `SharedTokenCacheCredential` and
`TokenCachePersistenceOptions` are used, if not, the jar file can be in any
position on the static java class path.

```{note}
When making use of MathWorks features which can automatically add
jar files to the static class path, these typically add them to then *end* of
the static class path. For example when working with a [packaged custom
toolbox](https://www.mathworks.com/help/matlab/matlab_prog/create-and-share-custom-matlab-toolboxes.html)
the included jar file is added to the *end* of the static path in the end user
MATLAB installation. Or if working with MATLAB Compiler (SDK) standalone
components the jar file which was packaged into the component are
automatically added to the *end* of the static class path at runtime. However
there may be situations in which this is not possible and then these features
may add the jar file to the dynamic class path.
```

In general the recommended approach to add the jar file to the static java class
path in a local MATLAB installation is to add an entry to the
`javaclasspath.txt` file in MATLAB's preferences directory. To create or open
this file in the MATLAB editor you can type the following command in the MATLAB
Command Window:

```matlab
edit(fullfile(prefdir,'javaclasspath.txt'));
```

Add the following content to the file, noting:

* Specific version numbers may change in future releases.
* Delimiters and path formats will change base on the operating system in use.
* Full absolute paths should be provided.
* Both the absolute full path of the JAR-file as well as the directory
  containing the JAR are listed. The directory is added to make Log4j
  configuration files available to MATLAB.
* The `<before>` tag as shown below is optional and can be used to add the jar
  file to the *start* of the path (see above for more details on when this is
  needed).

```xml
<before>
/myfiles/matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar
```

To verify that the change has made been successfully, restart MATLAB and run the
`javaclasspath` command, the entries should be found at either the beginning or
the end of the output.

To be able to use the interface, its directories need to be added to the
MATLAB path. To add the required directories run `startup.m` from the
`Software/MATLAB` directory.

The interface should now be ready to be configured and used, see
[Authentication](Authentication.md) and [Configuration](Configuration.md)
for further details.

[//]: #  (Copyright 2022 The MathWorks, Inc.)
