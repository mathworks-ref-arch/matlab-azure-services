# Frequently Asked Questions

## How to change the underlying library logging level

The Azure® interfaces rely on an number of underlying libraries which are
included in the `Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar` Jar file.
Many of these libraries use slf4j as a logging mechanism. Further, MATLAB itself
also includes slf4j and MATLAB configures it to use log4j as backend. So when
used in MATLAB, these libraries end up using sl4j with log4j as backend. Which
exact log4j version is used, depends on the MATLAB release. MATLAB releases up
to MATLAB R2021b Update 2 use log4j versions 1.x, MATLAB R2021b Update 2 and
newer use log4j versions 2.x.

The logging level and destination of log4j versions 1.x can be controlled using
`Software/MATLAB/lib/jar/log4j.properties` and for log4j versions 2.x using
`Software/MATLAB/lib/jar/log4j2.xml`. By default they log at the `ERROR` level.
To change this to `INFO` for example use the following in `log4j.properties`:

```
log4j.rootLogger=INFO, stdout
```

or the following in `log4j2.xml`:

```
<Root level="info" additivity="false">
```

[//]: #  (Copyright 2020-2022 The MathWorks, Inc.)
