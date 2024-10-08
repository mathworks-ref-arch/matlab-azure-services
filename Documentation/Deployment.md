# MATLAB Compiler (SDK) Deployment

When compiling MATLAB™ code, in general, [MATLAB Compiler™](https://www.mathworks.com/products/compiler.html) will do a dependency analysis of the code and automatically include all the necessary files. However in the case of this package, because Java components are used [which need to be loaded on the static Java class path](Installation.md#configuring-the-matlab-java-class-path), additional steps are required.

Three options are discussed below for making the correct JAR-files available to the deployed component.

* The [first option](#option-one-compile-the-jar-file-into-the-standalone-component) is the easiest but will add the JAR-file to the *end* of the static class path; see the [installation documentation](Installation.md#configuring-the-matlab-java-class-path) to learn more about what limitations this may introduce depending on the platform.

* The [second option](#option-two-modified-javaclasspathtxt-and-distribute-jar-file-next-to-component) can add the JAR-file to the *front* of the static Java class path but is more involved.

* The [last option](#option-three-make-jar-file-available-in-matlab-runtime) adds the JAR-file to the MATLAB Runtime installation rather than include it with the component, making it available to all standalone components using that MATLAB Runtime installation.

```{hint}
Contact us at [mwlab@mathworks.com](mailto:mwlab@mathworks.com) if you require additional advice on your specific use-case of deploying MATLAB Code which makes use of the "MATLAB Interface *for Azure Services*". 
```

## Option One: Compile the JAR-file *into* the standalone component

Any JAR-file which is compiled into a MATLAB Compiler (SDK) standalone component will automatically be added to the Java static<sup>[1](#option-three-make-jar-file-available-in-matlab-runtime)</sup> class path at runtime of the component. This will add the JAR-file to the *end* of the Java class path though, which on Windows should not be a problem but may introduce [limitations on Linux](Installation.md#configuring-the-matlab-java-class-path).

To compile the JAR-files into the component, in the Application- or Library Compiler App under "Files required for your application to run" (or when working with `mcc`, using the `-a` argument), explicitly add the following files to the component, they will not be added by automatic dependency analysis:

* `matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar`
* `matlab-azure-services/Software/MATLAB/lib/jar/log4j.properties`
* `matlab-azure-services/Software/MATLAB/lib/jar/log4j2.xml`
* `$MATLABROOT/java/jarext/slf4j/slf4j-api.jar`
* `$MATLABROOT/java/jarext/slf4j/slf4j-log4j12.jar`

Where `$MATLABROOT` stands for the MATLAB installation directory as returned by running the `matlabroot` function in the MATLAB Command Window.

## Option Two: Modified `javaclasspath.txt` and distribute JAR-file *next to* component

During the [installation](Installation.md) of the package, a [`javaclasspath.txt` will have been created](Installation.md#configuring-the-matlab-java-class-path) in the MATLAB preferences directory, with the following content:

```xml
<before>
/myfiles/matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar
```

This `javaclasspath.txt` from the preferences directory *can* be included in MATLAB Compiler (SDK) standalone components and *will* then actually be used at runtime of the component. The problem however is that this typically refers to an absolute path which exists on the development machine but which will likely *not* exist on target machines to which the standalone component is deployed.

However, the `javaclasspath.txt` file can be updated to the following before compiling the standalone component:

```{code-block} xml
---
emphasize-lines: 3
---
<before>
/myfiles/matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar
./azure-common-sdk-0.2.0.jar
```

Where the line which added at the bottom basically says: load `azure-common-sdk-0.2.0.jar` from `./` which stands for "the current directory".

Now when compiling a standalone component with this updated `javaclasspath.txt`, that component can load the JAR-file from either the specified absolute location *or* "the current directory at runtime of the standalone component". Where "the current directory at runtime" is typically quite simply equal to the directory where the main executable is located.

Further, for this workflow, in the Application- or Library Compiler App under "Files required for your application to run" (or when working with `mcc`, using the `-a` argument), explicitly add the following files to the component:

* `matlab-azure-services/Software/MATLAB/lib/jar/log4j.properties`
* `matlab-azure-services/Software/MATLAB/lib/jar/log4j2.xml`
* `$MATLABROOT/java/jarext/slf4j/slf4j-api.jar`
* `$MATLABROOT/java/jarext/slf4j/slf4j-log4j12.jar`
* `$PREFDIR/javaclasspath.txt`

Where `$PREFDIR` stands for the MATLAB preferences directory as returned by running the `prefdir` function in the MATLAB Command Windows. Depending on the exact MATLAB Compiler version, *some* versions may already include `$PREFDIR/javaclasspath.txt` *automatically*; by adding it *explicitly* though, this approach should work in *all* supported releases.

And then, if working with [MATLAB Compiler (SDK) packaged installers](https://www.mathworks.com/help/compiler/files-generated-after-packaging-application-compiler.html), under "Files installed for your end user", add:

* `matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar`

The packaged installer will then place the JAR-file next to the standalone component during installation. Alternatively, if not working with the packaged installers, simply manually distribute `azure-common-sdk-0.2.0.jar` next to the standalone component itself, in the same directory.

## Option Three: Make JAR-file available in MATLAB Runtime

JAR-files can only be added to the *static* class path upon initialization of the MATLAB Runtime. In use cases where multiple standalone components are used in a single application, there will be only *one* MATLAB Runtime instance which is instantiated upon first interaction with the first component. If a component is loaded after initial initialization of the MATLAB Runtime, its JAR-files are added to the *dynamic* class path rather than the static class path. Unfortunately `azure-common-sdk-0.2.0.jar` *must* be loaded on the *static* class path though.

In some situation, for example when working with multiple MATLAB Compiler Java/.NET/Python modules in a single Java/.NET/Python application, this is simply something to "keep in mind" and it may be possible to ensure that the right component is loaded first. However, this can not always be *guaranteed*, especially in [MATLAB Production Server](https://www.mathworks.com/products/matlab-production-server.html) workflows, where it is not possible to predict which component will be called first inside which worker process. In such situations an option could be to add the JAR-file to the MATLAB Runtime such that it is *always* loaded, regardless of which exact component instantiated this runtime first.

First, at compile time, again add the following two files to the "Files required for your application to run" (or using `mcc`'s `-a` flag):

* `matlab-azure-services/Software/MATLAB/lib/jar/log4j.properties`
* `matlab-azure-services/Software/MATLAB/lib/jar/log4j2.xml`

Then, manually copy the following three files to the target machine onto which the component will be deployed:

* `matlab-azure-services/Software/MATLAB/lib/jar/azure-common-sdk-0.2.0.jar`
* `$MATLABROOT/java/jarext/slf4j/slf4j-api.jar`
* `$MATLABROOT/java/jarext/slf4j/slf4j-log4j12.jar`

The files can basically be placed anywhere on this machine as long as they are accessible by the runtime. Lastly, also on the target machine where the MATLAB Runtime has been installed, open `$MCRROOT/toolbox/local/classpath.txt` (where `$MCRROOT` stands for the installation directory of the MATLAB Runtime) in a text editor and add the full absolute locations of the three files to the *front* of the list of JAR-files and directories in the text file.

````{note}
The `toolbox/local/classpath.txt` file contains a notification:

```
#DO NOT MODIFY THIS FILE.  IT IS AN AUTOGENERATED FILE.
```

For this particular use-case, this can partly be ignored, the file *may* be edited but do indeed keep in mind that it may be changed or overwritten when reinstalling the MATLAB Runtime or installing an Update to the runtime. The modification may have to be reapplied afterwards.
````

[//]: #  (Copyright 2022-2024 The MathWorks, Inc.)
